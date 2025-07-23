<?php
require_once '../config/config.php';
require_once '../utils/zapi.php';

header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
$lead_id = $input['id'] ?? null;

if (!$lead_id) {
    echo json_encode(['status' => 'erro', 'mensagem' => 'ID do lead não informado.']);
    exit;
}

// Buscar dados do lead
$stmt = $pdo->prepare("SELECT lr.*, ca.nome AS conjunto_nome, co.nome AS corretor_nome, co.telefone_whatsapp 
    FROM leads_recebidos lr
    LEFT JOIN conjuntos_anuncio ca ON ca.id = lr.conjunto_id
    LEFT JOIN corretores co ON co.id = lr.corretor_id
    WHERE lr.id = ?
");
$stmt->execute([$lead_id]);
$lead = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$lead) {
    echo json_encode(['status' => 'erro', 'mensagem' => 'Lead não encontrado.']);
    exit;
}

// Verifica se o corretor está ativo
if (!$lead['telefone_whatsapp'] || $lead['telefone_whatsapp'] === '' || $lead['corretor_id'] == 0) {
    echo json_encode(['status' => 'erro', 'mensagem' => 'Corretor sem telefone válido.']);
    exit;
}

$telefone = preg_replace('/[^0-9]/', '', $lead['telefone_whatsapp']);
if (strlen($telefone) < 10) {
    echo json_encode(['status' => 'erro', 'mensagem' => 'Telefone do corretor inválido.']);
    exit;
}

$mensagem = "📩 *Novo Lead Recebido!*

*Anúncio:* {$lead['anuncio_nome']}
*Conjunto:* {$lead['conjunto_nome']}

👤 *Cliente:* {$lead['nome_cliente']}
📞 *Telefone:* {$lead['telefone_cliente']}
📧 *Email:* {$lead['email_cliente']}";

$resposta = enviar_mensagem_whatsapp($telefone, $mensagem);

// Se enviou com sucesso, atualiza o banco
if (isset($resposta['messageId']) || isset($resposta['zaapId'])) {
    $stmt = $pdo->prepare("UPDATE leads_recebidos SET enviado_whatsapp = 1 WHERE id = ?");
    $stmt->execute([$lead_id]);

    echo json_encode(['status' => 'sucesso', 'mensagem' => 'Mensagem enviada com sucesso.']);
} else {
    echo json_encode(['status' => 'erro', 'mensagem' => 'Falha ao enviar pelo WhatsApp.', 'debug' => $resposta]);
}
