<?php
require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/utils/logger.php';
require_once __DIR__ . '/utils/fila.php';
require_once __DIR__ . '/utils/lead_status.php';
require_once __DIR__ . '/utils/zapi.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(403);
    exit('Acesso negado.');
}

// Recebe e decodifica JSON
$json = file_get_contents('php://input');
$dados = json_decode($json, true);
gravar_log('lead', "📥 Lead recebido: " . substr($json, 0, 300) . "...");

// Validação mínima
$camposObrigatorios = ['form_id'];
foreach ($camposObrigatorios as $campo) {
    if (empty($dados[$campo])) {
        gravar_log('lead', "❌ Campo obrigatório ausente: {$campo}");
        http_response_code(200);
        echo json_encode(['status' => 'erro', 'mensagem' => "Campo obrigatório ausente: {$campo}"]);
        exit;
    }
}

// Buscar empresa pelo form_id
$empresa_id = 2;
if (!empty($dados['form_id'])) {
    $stmt = $pdo->prepare("SELECT empresa_id FROM formularios_origem WHERE form_id = ?");
    $stmt->execute([$dados['form_id']]);
    $empresa_id = $stmt->fetchColumn();
}

// Buscar conjunto
$stmt = $pdo->prepare("SELECT id, campanha_id FROM conjuntos_anuncio WHERE nome = ?");
$stmt->execute([$dados['adset_nome']]);
$conjunto = $stmt->fetch(PDO::FETCH_ASSOC);
$conjunto_id = $conjunto['id'] ?? null;
$campanha_id = $conjunto['campanha_id'] ?? null;

// Buscar corretor da fila
$corretor_id = null;
$telefone_corretor = null;

if ($conjunto_id && $empresa_id) {
    $stmtFila = $pdo->prepare("
        SELECT c.id, c.telefone_whatsapp
        FROM elegibilidade_corretores ec
        JOIN corretores c ON c.id = ec.corretor_id
        WHERE ec.conjunto_id = ? AND ec.empresa_id = ? AND ec.ativo = 1 AND c.ativo = 1
        ORDER BY ec.ordem_fila ASC
        LIMIT 1
    ");
    $stmtFila->execute([$conjunto_id, $empresa_id]);
    $corretor = $stmtFila->fetch(PDO::FETCH_ASSOC);
    if ($corretor) {
        $corretor_id = $corretor['id'];
        $telefone_corretor = $corretor['telefone_whatsapp'];
    }
}

// Corretor padrão se nenhum disponível
if (!$corretor_id) {
    $stmt = $pdo->query("SELECT valor FROM configuracoes_sistema WHERE chave = 'corretor_padrao_id'");
    $corretor_id = $stmt->fetchColumn();
    $stmt = $pdo->prepare("SELECT telefone_whatsapp FROM corretores WHERE id = ?");
    $stmt->execute([$corretor_id]);
    $telefone_corretor = $stmt->fetchColumn();
}

// Inserção no banco
$stmt = $pdo->prepare("
    INSERT INTO leads_recebidos (
        nome_cliente, telefone_cliente, email_cliente,
        conjunto_id, campanha_id, corretor_id,
        lead_id, form_id, pagina_id, anuncio_nome,
        plataforma, veiculo, campanha_nome,
        data_recebido, status, empresa_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), 0, ?)
");
$stmt->execute([
    $dados['nome'] ?? '',
    $dados['telefone'] ?? '',
    $dados['email'] ?? '',
    $conjunto_id,
    $campanha_id,
    $corretor_id,
    $dados['lead_id'] ?? '',
    $dados['form_id'] ?? '',
    $dados['pagina_id'] ?? '',
    $dados['anuncio_nome'] ?? '',
    $dados['plataforma'] ?? '',
    $dados['veiculo'] ?? '',
    $dados['campanha_nome'] ?? '',
    $empresa_id
]);

$lead_id = $pdo->lastInsertId();
gravar_log('lead', "✅ Lead #{$lead_id} gravado no banco");

// Enviar WhatsApp
$mensagem = "*📞 Novo Lead Recebido!*\n";
$mensagem .= "*Cliente:* {$dados['nome']}\n";
$mensagem .= "*Telefone:* {$dados['telefone']}\n";
$mensagem .= "*Anúncio:* {$dados['anuncio_nome']}\n";
$mensagem .= "*Conjunto:* " . ($dados['adset_nome'] ?? '-');

$opcoes = [
    'whatsapp' => 'Contato via WhatsApp',
    'telefone' => 'Contato por Telefone',
    'nao-contatado' => 'Não consegui contato',
    'desqualificado' => 'Lead Desqualificado'
];

$resposta = enviar_mensagem_com_opcoes($telefone_corretor, $mensagem, $opcoes, $empresa_id);
$message_id = $resposta['messageId'] ?? null;

if (isset($resposta['erro'])) {
    gravar_log('processo', "❌ Envio falhou para lead #{$lead_id}: {$resposta['erro']}");
    $pdo->prepare("INSERT INTO leads_pendentes (lead_id, corretor_id, telefone, json_recebido)
        VALUES (?, ?, ?, ?)")->execute([$lead_id, $corretor_id, $dados['telefone'], $json]);

    echo json_encode(['status' => 'erro', 'mensagem' => 'Lead gravado, mas envio falhou']);
    exit;
}

// Atualizar lead como enviado
$stmt = $pdo->prepare("
    UPDATE leads_recebidos
    SET status = 1,
        message_id_enviado = ?,
        data_envio_whatsapp = NOW()
    WHERE id = ?
");
$stmt->execute([$message_id, $lead_id]);

// Fila Round Robin
if ($conjunto_id) {
    atualizar_fila_round_robin($pdo, $conjunto_id, $corretor_id);
}

gravar_log('processo', "📨 Lead #{$lead_id} enviado com sucesso via WhatsApp");

echo json_encode(['status' => 'sucesso', 'mensagem' => 'Lead recebido e enviado com sucesso.']);
