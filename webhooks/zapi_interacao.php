<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../utils/logger.php';
require_once __DIR__ . '/../utils/lead_status.php';

header('Content-Type: application/json');

try {
    $entrada = file_get_contents('php://input');
    $dados = json_decode($entrada, true);
    gravar_log('interacao', '📨 Webhook recebido: ' . print_r($dados, true));

    if (!$dados || empty($dados['referenceMessageId'])) {
        gravar_log('interacao', '❌ referenceMessageId ausente no webhook');
        throw new Exception('referenceMessageId ausente');
    }

    $referenceMessageId = $dados['referenceMessageId'];
    $opcao = $dados['listResponseMessage']['selectedRowId'] ?? $dados['optionId'] ?? null;
    $texto = $dados['listResponseMessage']['title'] ?? $dados['text'] ?? null;
    $telefone = preg_replace('/\D/', '', $dados['phone'] ?? '');

    // Buscar lead e corretor pelo referenceMessageId
    $stmt = $pdo->prepare("
        SELECT lr.id AS lead_id, lr.nome_cliente, lr.corretor_id, c.nome AS corretor_nome
        FROM leads_recebidos lr
        LEFT JOIN corretores c ON c.id = lr.corretor_id
        WHERE lr.zapi_message_id = ?
    ");
    $stmt->execute([$referenceMessageId]);
    $lead = $stmt->fetch(PDO::FETCH_ASSOC);

    gravar_log('interacao', "Lead encontrado pela messageId: {$referenceMessageId} " . print_r($lead, true));

    if (!$lead) {
        gravar_log('interacao', "❌ Lead não encontrado para messageId: {$referenceMessageId}");
        throw new Exception('Lead não encontrado');
    }

    $lead_id = $lead['lead_id'];
    $nome_cliente = $lead['nome_cliente'];
    $corretor_id = $lead['corretor_id'];
    $corretor_nome = $lead['corretor_nome'];

    // Mapear status numérico conforme estrutura do banco
    $statusMap = [
        'whatsapp'        => 2, // Em atendimento
        'telefone'        => 2,
        'nao-contatado'   => 1, // Entregue, mas sem resposta
        'desqualificado'  => 3
    ];

    $status = $statusMap[$opcao] ?? null;

    // Atualizar leads_recebidos
    try {
        if ($status !== null) {
            $stmt = $pdo->prepare("UPDATE leads_recebidos SET status = ?, resposta_contato = ?, data_contato = NOW() WHERE id = ?");
            $stmt->execute([$status, $opcao, $lead_id]);
            gravar_log('interacao', "✅ Lead #{$lead_id} atualizado com status numérico {$status} e resposta '{$opcao}'");
        } else {
            $stmt = $pdo->prepare("UPDATE leads_recebidos SET resposta_contato = ?, data_contato = NOW() WHERE id = ?");
            $stmt->execute([$opcao, $lead_id]);
            gravar_log('interacao', "⚠️ Lead #{$lead_id} atualizado apenas com resposta '{$opcao}' (sem status definido)");
        }
    } catch (Exception $e) {
        gravar_log('interacao', "❌ Erro ao atualizar leads_recebidos (Lead #{$lead_id}): " . $e->getMessage());
    }

    // Inserir na interacoes_leads
    try {
        $stmt = $pdo->prepare("
            INSERT INTO interacoes_leads 
            (lead_id, corretor_id, telefone, message_id, opcao_escolhida, texto_exibido, tipo_contato, data_interacao, data_resposta)
            VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?)
        ");
        $stmt->execute([
            $lead_id,
            $corretor_id,
            $telefone ?: null,
            $referenceMessageId,
            $opcao,
            $texto,
            'whatsapp',
            $opcao ? date('Y-m-d H:i:s') : null
        ]);
        gravar_log('interacao', "✅ Interação inserida em interacoes_leads (Lead #{$lead_id}, Corretor #{$corretor_id})");
    } catch (Exception $e) {
        gravar_log('interacao', "❌ Erro ao inserir em interacoes_leads (Lead #{$lead_id}, Corretor #{$corretor_id}): " . $e->getMessage());
    }

} catch (Exception $e) {
    // Fallback: grava erro como lead pendente
    $stmt = $pdo->prepare("
        INSERT INTO leads_pendentes 
        (lead_id, corretor_id, telefone, json_recebido, motivo, data_registro)
        VALUES (NULL, ?, ?, ?, ?, NOW())
    ");
    $stmt->execute([
        $corretor_id ?? null,
        $telefone ?? null,
        $entrada,
        $e->getMessage()
    ]);

    gravar_log('interacao', '⚠️ Erro capturado e enviado para leads_pendentes: ' . $e->getMessage());
}

// Sempre responde sucesso
echo json_encode(['status' => 'ok']);
