<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../utils/logger.php';
require_once __DIR__ . '/../utils/zapi.php';

gravar_log('cron', '✅ CRON iniciado para lembrete de leads sem resposta');

try {
    // Buscar leads com status = 1 (enviados), whatsapp_enviado = 1, sem resposta
    $stmt = $pdo->prepare("
        SELECT lr.*, c.nome AS corretor_nome, c.telefone_whatsapp
        FROM leads_recebidos lr
        JOIN corretores c ON c.id = lr.corretor_id
        WHERE lr.status = 1 
          AND lr.whatsapp_enviado = 1 
          AND (lr.resposta_contato IS NULL OR lr.resposta_contato = '')
        ORDER BY lr.data_recebido DESC
    ");
    $stmt->execute();
    $leads = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($leads)) {
        gravar_log('cron', '📭 Nenhum lead pendente de lembrete');
        exit;
    }

    foreach ($leads as $lead) {
        $telefone = preg_replace('/\D/', '', $lead['telefone_whatsapp'] ?? '');
        if (strlen($telefone) < 11) {
            gravar_log('cron', "⚠️ Número inválido para lead #{$lead['id']} ({$lead['nome_cliente']}): {$telefone}");
            continue;
        }

        $mensagem = "📣 Lembrete: O lead *{$lead['nome_cliente']}* ainda não teve retorno.\n\n" .
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

        // Grava o payload para depuração
        gravar_log('cron', "📤 Enviando para {$telefone}: " . json_encode([
            'mensagem' => $mensagem,
            'opcoes' => $opcoes
        ]));

        // Enviar via Z-API
        $resposta = enviar_mensagem_com_opcoes($telefone, $mensagem, $opcoes);

        if ($resposta && isset($resposta['messageId'])) {
            // Atualizar a tabela leads_recebidos com novo envio
            $stmtUpdate = $pdo->prepare("
                UPDATE leads_recebidos 
                SET zapi_message_id = ?, data_envio_whatsapp = NOW(), tentativas_contato = tentativas_contato + 1 
                WHERE id = ?
            ");
            $stmtUpdate->execute([$resposta['messageId'], $lead['id']]);

            gravar_log('cron', "✅ Lembrete enviado para corretor {$lead['corretor_nome']} - Lead #{$lead['id']} ({$lead['nome_cliente']}) | MsgID: {$resposta['messageId']}");
        } else {
            gravar_log('cron', "❌ Falha ao enviar para lead #{$lead['id']} ({$lead['nome_cliente']}) - Resposta da Z-API: " . print_r($resposta, true));
        }
    }

    gravar_log('cron', '🏁 CRON finalizado com sucesso');
} catch (Exception $e) {
    gravar_log('cron', '❌ Erro durante execução do CRON: ' . $e->getMessage());
}
