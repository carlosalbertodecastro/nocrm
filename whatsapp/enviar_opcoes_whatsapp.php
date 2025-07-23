<?php
require_once '../config/config.php';
require_once '../utils/logger.php';
require_once '../utils/fila.php';
require_once '../utils/lead_status.php';
require_once '../utils/zapi.php';

header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
$lead_id = $input['lead_id'] ?? null;
$corretor_id = $input['corretor_id'] ?? null;

if (!$lead_id || !$corretor_id) {
    echo json_encode(['erro' => 'Lead ou corretor não informado']);
    exit;
}

// Buscar lead
$stmt = $pdo->prepare("SELECT * FROM leads_recebidos WHERE id = ?");
$stmt->execute([$lead_id]);
$lead = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$lead) {
    echo json_encode(['erro' => 'Lead não encontrado']);
    exit;
}

// Buscar corretor
$stmt = $pdo->prepare("SELECT nome, telefone_whatsapp FROM corretores WHERE id = ?");
$stmt->execute([$corretor_id]);
$corretor = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$corretor || empty($corretor['telefone_whatsapp'])) {
    echo json_encode(['erro' => 'Corretor inválido ou sem WhatsApp cadastrado']);
    exit;
}

// Criar mensagem
$mensagem = "*📞 Novo Lead Recebido!*\n";
$mensagem .= "*Cliente:* {$lead['nome_cliente']}\n";
$mensagem .= "*Telefone:* {$lead['telefone_cliente']}\n";
$mensagem .= "*Anúncio:* {$lead['anuncio_nome']}\n";
$mensagem .= "*Conjunto:* " . ($lead['adset_nome'] ?? '');

$opcoes = [
    'whatsapp' => 'Contato via WhatsApp',
    'telefone' => 'Contato por Telefone',
    'nao-contatado' => 'Não consegui contato',
    'desqualificado' => 'Lead Desqualificado'
];

// Envio via ZAPI
$resposta = enviar_mensagem_com_opcoes($corretor['telefone_whatsapp'], $mensagem, $opcoes);

if (isset($resposta['erro'])) {
    gravar_log('processo', "❌ Erro ao enviar lead #{$lead_id} para corretor {$corretor_id}: {$resposta['erro']}");
    echo json_encode(['erro' => 'Erro ao enviar via WhatsApp: ' . $resposta['erro']]);
    exit;
}

// Atualiza status do lead
$message_id = $resposta['messageId'] ?? null;
atualizar_lead_recebido($pdo, $lead_id, $message_id, 'enviado', $corretor_id);

// Atualiza fila
if (!empty($lead['conjunto_id'])) {
    atualizar_fila_round_robin($pdo, (int)$lead['conjunto_id'], $corretor_id);
}

echo json_encode([
    'sucesso' => true,
    'mensagem' => '✅ Lead enviado com sucesso para o WhatsApp!',
    'message_id' => $message_id
]);
