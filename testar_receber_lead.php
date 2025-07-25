<?php
require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/utils/logger.php';
require_once __DIR__ . '/utils/fila.php';
require_once __DIR__ . '/utils/lead_status.php';
require_once __DIR__ . '/utils/zapi.php';

echo "<pre>";
echo "📍 Simulação de envio de lead via interface visual...\n";

// Gerar dados aleatórios
$nome = "Simulado " . rand(100, 999);
$telefone = "+553199" . rand(1000000, 9999999);
$email = strtolower(str_replace(" ", ".", $nome)) . "@teste.com";
$lead_id = "SIMULADO_" . rand(1000000, 9999999);

$dados = [
    "nome" => $nome,
    "telefone" => $telefone,
    "email" => $email,
    "lead_id" => $lead_id,
    "form_id" => "form_simulador",
    "pagina_id" => "pagina_simulador",
    "adset_nome" => "Simular Lead",
    "anuncio_nome" => "Anúncio Teste",
    "plataforma" => "fb",
    "veiculo" => "",
    "campanha_id" => "1",
    "campanha_nome" => "Campanha Simulada"
];

// Validar campos
$camposObrigatorios = ['nome', 'telefone', 'anuncio_nome', 'adset_nome'];
foreach ($camposObrigatorios as $campo) {
    if (empty($dados[$campo])) {
        echo "❌ Campo obrigatório ausente: {$campo}\n";
        exit;
    }
}

// Buscar conjunto
$stmt = $pdo->prepare("SELECT id, campanha_id FROM conjuntos_anuncio WHERE nome = ?");
$stmt->execute([$dados['adset_nome']]);
$conjunto = $stmt->fetch(PDO::FETCH_ASSOC);

$conjunto_id = $conjunto['id'] ?? null;
$campanha_id = $conjunto['campanha_id'] ?? null;

echo "✔️ Conjunto: {$conjunto_id} | Campanha: {$campanha_id}\n";

// Buscar corretor da fila
$corretor_id = null;
$telefone_corretor = null;

if ($conjunto_id) {
    $stmtFila = $pdo->prepare("
        SELECT c.id, c.telefone_whatsapp
        FROM elegibilidade_corretores ec
        JOIN corretores c ON c.id = ec.corretor_id
        WHERE ec.conjunto_id = ? AND ec.ativo = 1 AND c.ativo = 1
        ORDER BY ec.ordem_fila ASC
        LIMIT 1
    ");
    $stmtFila->execute([$conjunto_id]);
    $corretor = $stmtFila->fetch(PDO::FETCH_ASSOC);

    if ($corretor) {
        $corretor_id = $corretor['id'];
        $telefone_corretor = $corretor['telefone_whatsapp'];
        echo "👤 Corretor encontrado: {$corretor_id} - {$telefone_corretor}\n";
    }
}

if (!$corretor_id) {
    echo "⚠️ Nenhum corretor na fila. Usando corretor padrão...\n";
    $stmt = $pdo->query("SELECT valor FROM configuracoes_sistema WHERE chave = 'corretor_padrao_id'");
    $corretor_id = $stmt->fetchColumn();
    $stmt = $pdo->prepare("SELECT telefone_whatsapp FROM corretores WHERE id = ?");
    $stmt->execute([$corretor_id]);
    $telefone_corretor = $stmt->fetchColumn();
}

// Inserir lead
$stmt = $pdo->prepare("
    INSERT INTO leads_recebidos (
        nome_cliente, telefone_cliente, email_cliente,
        conjunto_id, campanha_id, corretor_id,
        lead_id, form_id, pagina_id, anuncio_nome, plataforma, veiculo, campanha_nome,
        data_recebido, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), 0)
");

$stmt->execute([
    $dados['nome'], $dados['telefone'], $dados['email'],
    $conjunto_id, $campanha_id, $corretor_id,
    $dados['lead_id'], $dados['form_id'], $dados['pagina_id'],
    $dados['anuncio_nome'], $dados['plataforma'], $dados['veiculo'],
    $dados['campanha_nome']
]);

$lead_id = $pdo->lastInsertId();
echo "✅ Lead #{$lead_id} inserido com sucesso\n";

// Enviar via WhatsApp
$mensagem = "*📞 Novo Lead Recebido!*\n";
$mensagem .= "*Cliente:* {$dados['nome']}\n";
$mensagem .= "*Telefone:* {$dados['telefone']}\n";
$mensagem .= "*Anúncio:* {$dados['anuncio_nome']}\n";
$mensagem .= "*Conjunto:* {$dados['adset_nome']}";

$opcoes = [
    'whatsapp' => 'Contato via WhatsApp',
    'telefone' => 'Contato por Telefone',
    'nao-contatado' => 'Não consegui contato',
    'desqualificado' => 'Lead Desqualificado'
];

$resposta = enviar_mensagem_com_opcoes($telefone_corretor, $mensagem, $opcoes);

if (isset($resposta['erro'])) {
    echo "❌ Erro ao enviar via Z-API: {$resposta['erro']}\n";
    exit;
}

$message_id = $resposta['messageId'] ?? null;
echo "📨 Enviado com sucesso. messageId: {$message_id}\n";

// Atualizar lead
atualizar_lead_recebido($pdo, $lead_id, $message_id, 'enviado', $corretor_id);

// Atualizar fila
if ($conjunto_id) {
    atualizar_fila_round_robin($pdo, $conjunto_id, $corretor_id);
    echo "🔁 Fila atualizada\n";
}

echo "🎯 Processo concluído com sucesso!\n</pre>";
