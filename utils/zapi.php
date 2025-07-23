<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/logger.php';

function getCredenciaisZAPI(?int $empresa_id = 2): ?array {
    global $pdo;

    if (!$empresa_id) {
        $empresa_id = $_SESSION['empresa_id'] ?? null;
    }

    if (!$empresa_id) {
        gravar_log('log_zapi.txt', '❌ Empresa não definida (nem via sessão, nem via argumento).');
        return null;
    }

    $sql = "SELECT instance_id, token, secret_key 
            FROM configuracoes_zapi 
            WHERE empresa_id = :empresa_id AND ativo = 1 
            LIMIT 1";

    $stmt = $pdo->prepare($sql);
    $stmt->execute(['empresa_id' => $empresa_id]);

    $dados = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($dados) {
        return $dados;
    } else {
        gravar_log('log_zapi.txt', "❌ Credenciais Z-API não encontradas para empresa_id $empresa_id");
        return null;
    }
}

function enviar_mensagem_whatsapp(string $telefone, string $mensagem): array {
    gravar_log('log_zapi.txt', "📤 [enviar_mensagem_whatsapp] Início - Telefone: $telefone | Msg: $mensagem");

    $credenciais = getCredenciaisZAPI();
    if (!$credenciais) {
        gravar_log('log_zapi.txt', "❌ Credenciais ausentes no envio padrão.");
        return ['erro' => 'Credenciais Z-API ausentes'];
    }

    $payload = ['phone' => $telefone, 'message' => $mensagem];
    $resposta = fazer_requisicao_zapi('/send-text', $payload, $credenciais);

    gravar_log('log_zapi.txt', "📥 Resposta [enviar_mensagem_whatsapp]: " . json_encode($resposta));
    return $resposta;
}

function enviar_mensagem_whatsapp_empresa(int $empresa_id, string $telefone, string $mensagem): array {
    gravar_log('log_zapi.txt', "📤 [enviar_mensagem_whatsapp_empresa] Empresa $empresa_id | Tel: $telefone");

    $credenciais = getCredenciaisZAPI($empresa_id);
    if (!$credenciais) {
        gravar_log('log_zapi.txt', "❌ Credenciais ausentes para empresa_id $empresa_id");
        return ['erro' => 'Credenciais Z-API ausentes'];
    }

    $payload = ['phone' => $telefone, 'message' => $mensagem];
    $resposta = fazer_requisicao_zapi('/send-text', $payload, $credenciais);

    gravar_log('log_zapi.txt', "📥 Resposta [empresa_id=$empresa_id]: " . json_encode($resposta));
    return $resposta;
}

function enviar_mensagem_com_opcoes(string $numero, string $mensagem, array $opcoes): array {
    gravar_log('log_zapi.txt', "📤 [enviar_mensagem_com_opcoes] Número: $numero | Msg: $mensagem");

    $credenciais = getCredenciaisZAPI();
    if (!$credenciais) {
        gravar_log('log_zapi.txt', "❌ Credenciais ausentes para envio com opções");
        return ['erro' => 'Credenciais Z-API ausentes'];
    }

    $lista = [];
    foreach ($opcoes as $id => $titulo) {
        $lista[] = ['id' => $id, 'title' => $titulo, 'description' => ''];
    }

    $payload = [
        'phone' => $numero,
        'message' => $mensagem,
        'optionList' => [
            'title' => 'Escolha uma opção',
            'buttonLabel' => 'Abrir opções',
            'options' => $lista
        ]
    ];

    $resposta = fazer_requisicao_zapi('/send-option-list', $payload, $credenciais);
    gravar_log('log_zapi.txt', "📥 Resposta com opções: " . json_encode($resposta));
    return $resposta;
}

function enviar_mensagem_com_opcoes_empresa(int $empresa_id, string $numero, string $mensagem, array $opcoes): array {
    gravar_log('log_zapi.txt', "📤 [enviar_mensagem_com_opcoes_empresa] Empresa $empresa_id | Número: $numero");

    $credenciais = getCredenciaisZAPI($empresa_id);
    if (!$credenciais) {
        gravar_log('log_zapi.txt', "❌ Credenciais ausentes para empresa_id $empresa_id");
        return ['erro' => 'Credenciais Z-API ausentes'];
    }

    $lista = [];
    foreach ($opcoes as $id => $titulo) {
        $lista[] = ['id' => $id, 'title' => $titulo, 'description' => ''];
    }

    $payload = [
        'phone' => $numero,
        'message' => $mensagem,
        'optionList' => [
            'title' => 'Escolha uma opção',
            'buttonLabel' => 'Abrir opções',
            'options' => $lista
        ]
    ];

    $resposta = fazer_requisicao_zapi('/send-option-list', $payload, $credenciais);
    gravar_log('log_zapi.txt', "📥 Resposta com opções (empresa $empresa_id): " . json_encode($resposta));
    return $resposta;
}

function fazer_requisicao_zapi(string $endpoint, array $payload, array $credenciais): array {
    $url = "https://api.z-api.io/instances/{$credenciais['instance_id']}/token/{$credenciais['token']}{$endpoint}";

    $headers = [
        'Content-Type: application/json',
        'Client-Token: ' . $credenciais['secret_key']
    ];

    gravar_log('log_zapi.txt', "🌐 Requisição para Z-API: $url | Payload: " . json_encode($payload));

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $resposta = curl_exec($ch);
    $erro = curl_error($ch);
    $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($erro || !$resposta || $status !== 200) {
        gravar_log('log_zapi.txt', "❌ Erro cURL [$status]: $erro | Resposta: $resposta");
        return ['erro' => "Erro cURL/Z-API: {$erro} [HTTP {$status}]"];
    }

    $decoded = json_decode($resposta, true);
    if (!$decoded) {
        gravar_log('log_zapi.txt', "❌ Erro ao decodificar resposta JSON: $resposta");
        return ['erro' => 'Resposta inválida da API'];
    }

    return $decoded;
}
