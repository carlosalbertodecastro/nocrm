<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../utils/logger.php';
require_once __DIR__ . '/../utils/zapi.php';

gravar_log('cron', '✅ CRON iniciado para verificação de leads SEM RESPOSTA');

try {
    $agora = new DateTime();
    $horaAtual = (int) $agora->format('H');
    $diaSemana = strtolower($agora->format('l'));

    $horaInicio = in_array($diaSemana, ['saturday', 'sunday']) ? 9 : 8;
    $horaFim = in_array($diaSemana, ['saturday', 'sunday']) ? 12 : 20;

    if ($horaAtual < $horaInicio || $horaAtual >= $horaFim) {
        gravar_log('cron', "⏰ Fora do horário de atendimento ({$horaInicio}h às {$horaFim}h)");
        exit;
    }

    $stmt = $pdo->prepare("
        SELECT lr.*, c.nome AS corretor_nome, c.telefone_whatsapp
        FROM leads_recebidos lr
        JOIN corretores c ON c.id = lr.corretor_id
        WHERE lr.status = 1
          AND lr.whatsapp_enviado = 1
          AND (lr.resposta_contato IS NULL OR lr.resposta_contato = '')
          AND DATE(lr.data_recebido) >= DATE_SUB(CURDATE(), INTERVAL 3 DAY)
        ORDER BY lr.data_recebido DESC
    ");
    $stmt->execute();
    $leads = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$leads) {
        gravar_log('cron', '📭 Nenhum lead com status ENVIADO e sem resposta encontrado.');
        exit;
    }

    foreach ($leads as $lead) {
        $leadId = $lead['id'];
        $nomeCliente = $lead['nome_cliente'];
        $corretor = $lead['corretor_nome'];
        $telefoneCorretor = preg_replace('/\D/', '', $lead['telefone_whatsapp'] ?? '');
        $tentativas = (int) $lead['tentativas_contato'];

        if (!$telefoneCorretor || strlen($telefoneCorretor) < 11) {
            gravar_log('cron', "⚠️ Telefone inválido para lead #$leadId ($nomeCliente): {$telefoneCorretor}");
            continue;
        }

        $stmtUltima = $pdo->prepare("
            SELECT data_interacao 
            FROM interacoes_leads 
            WHERE lead_id = ? AND tipo_contato = 'lembrete'
            ORDER BY data_interacao DESC LIMIT 1
        ");
        $stmtUltima->execute([$leadId]);
        $ultima = $stmtUltima->fetchColumn();

        if ($ultima) {
            $ultimaTentativa = new DateTime($ultima);
            $intervalo = $agora->getTimestamp() - $ultimaTentativa->getTimestamp();
            $horas = $intervalo / 3600;

            if ($tentativas >= 5) {
                gravar_log('cron', "🚫 Limite diário atingido para lead #$leadId ($nomeCliente)");
                continue;
            }

            $proxTentativa = clone $ultimaTentativa;
            $proxTentativa->modify($horas < 3 ? '+1 hour' : '+2 hours');

            if ($agora < $proxTentativa) {
                $proximaStr = $proxTentativa->format('H:i');
                $decorridoStr = gmdate("H\hi", $intervalo);
                gravar_log('cron', "⏳ Lead #$leadId ($nomeCliente) - Corretor: $corretor | Última tentativa: {$ultimaTentativa->format('d/m H:i')} | Tempo decorrido: {$decorridoStr} | Próxima tentativa: $proximaStr");
                continue;
            }
        }

        $mensagem = "📣 Lembrete: O lead *{$nomeCliente}* ainda não teve retorno.\n\n" .
            "📆 Recebido em: " . date('d/m/Y H:i', strtotime($lead['data_recebido'])) . "\n" .
            "📞 Telefone: {$lead['telefone_cliente']}\n" .
            "📣 Anúncio: {$lead['anuncio_nome']}\n\n" .
            "Por favor, selecione uma opção para atualizar o status:";

        $opcoes = [
            'whatsapp'       => 'Contato via WhatsApp',
            'telefone'       => 'Contato via Telefone',
            'nao-contatado'  => 'Não consegui contato',
            'desqualificado' => 'Lead desqualificado',
        ];

        gravar_log('cron', "📤 Enviando para $telefoneCorretor (Corretor: $corretor) | Lead: $nomeCliente");

        $resposta = enviar_mensagem_com_opcoes($telefoneCorretor, $mensagem, $opcoes);

        if ($resposta && isset($resposta['messageId'])) {
            $stmtUpdate = $pdo->prepare("
                UPDATE leads_recebidos 
                SET tentativas_contato = tentativas_contato + 1, zapi_message_id = ?, data_envio_whatsapp = NOW() 
                WHERE id = ?
            ");
            $stmtUpdate->execute([$resposta['messageId'], $leadId]);

            $stmtLog = $pdo->prepare("
                INSERT INTO interacoes_leads 
                (lead_id, corretor_id, telefone, message_id, opcao_escolhida, texto_exibido, tipo_contato, data_interacao)
                VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
            ");
            $stmtLog->execute([
                $leadId,
                $lead['corretor_id'],
                $telefoneCorretor,
                $resposta['messageId'],
                null,
                'Lembrete enviado automaticamente',
                'lembrete'
            ]);

            gravar_log('cron', "✅ Enviado para corretor $corretor - Lead #$leadId ($nomeCliente) | MsgID: {$resposta['messageId']}");
        } else {
            gravar_log('cron', "❌ Falha ao enviar para lead #$leadId ($nomeCliente) - Resposta: " . print_r($resposta, true));
        }
    }

    gravar_log('cron', '🏁 CRON finalizado com sucesso');
} catch (Exception $e) {
    gravar_log('cron', '❌ Erro geral: ' . $e->getMessage());
}
