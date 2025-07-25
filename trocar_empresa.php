<?php
session_start();

// Apenas usuários da empresa NoCRM (empresa_id = 1) podem trocar a empresa visualizada
if (!isset($_SESSION['empresa_id']) || $_SESSION['empresa_id'] != 1) {
    http_response_code(403);
    echo json_encode(['erro' => 'Acesso negado.']);
    exit;
}

// Verifica se foi enviada uma nova empresa
if (!isset($_POST['nova_empresa_id']) || !is_numeric($_POST['nova_empresa_id'])) {
    http_response_code(400);
    echo json_encode(['erro' => 'ID de empresa inválido.']);
    exit;
}

$nova_empresa_id = (int)$_POST['nova_empresa_id'];

// Atualiza a sessão com a nova empresa visualizada
$_SESSION['empresa_visualizada_id'] = $nova_empresa_id;

echo json_encode(['status' => 'ok', 'nova_empresa_id' => $nova_empresa_id]);
