<?php
require_once('../config/config.php');

session_start();
header('Content-Type: application/json');

$empresa_id = $_SESSION['empresa_visualizada_id'] ?? 1;

$acao = $_POST['acao'] ?? $_GET['acao'] ?? '';

function json_response($status, $mensagem = '') {
    echo json_encode(['status' => $status, 'mensagem' => $mensagem]);
    exit;
}

switch ($acao) {
    case 'listar':
        $res = $pdo->prepare("SELECT * FROM conjuntos_anuncio WHERE empresa_id = ?");
        $res->execute([$empresa_id]);
        $dados = $res->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['data' => $dados]);
        break;

    case 'adicionar':
        $nome = $_POST['nome'] ?? '';
        $campanha_id = $_POST['campanha_id'] ?? null;
        $codigo_facebook = $_POST['codigo_facebook'] ?? '';
        if ($nome == '') json_response('erro', 'Nome é obrigatório');

        $stmt = $pdo->prepare("INSERT INTO conjuntos_anuncio (nome, campanha_id, codigo_facebook, empresa_id, ativo, created_at) VALUES (?, ?, ?, ?, 1, NOW())");
        $stmt->execute([$nome, $campanha_id, $codigo_facebook, $empresa_id]);
        json_response('sucesso', 'Conjunto adicionado');
        break;

    case 'editar':
        $id = $_POST['id'] ?? null;
        $nome = $_POST['nome'] ?? '';
        $campanha_id = $_POST['campanha_id'] ?? null;
        $codigo_facebook = $_POST['codigo_facebook'] ?? '';
        if (!$id || $nome == '') json_response('erro', 'Dados incompletos');

        $stmt = $pdo->prepare("UPDATE conjuntos_anuncio SET nome = ?, campanha_id = ?, codigo_facebook = ?, updated_at = NOW() WHERE id = ? AND empresa_id = ?");
        $stmt->execute([$nome, $campanha_id, $codigo_facebook, $id, $empresa_id]);
        json_response('sucesso', 'Conjunto atualizado');
        break;

    case 'deletar':
        $id = $_POST['id'] ?? null;
        if (!$id) json_response('erro', 'ID inválido');
        $stmt = $pdo->prepare("DELETE FROM conjuntos_anuncio WHERE id = ? AND empresa_id = ?");
        $stmt->execute([$id, $empresa_id]);
        json_response('sucesso', 'Conjunto excluído');
        break;

    case 'ativar':
        $id = $_POST['id'] ?? null;
        if (!$id) json_response('erro', 'ID inválido');
        $stmt = $pdo->prepare("UPDATE conjuntos_anuncio SET ativo = 1 WHERE id = ? AND empresa_id = ?");
        $stmt->execute([$id, $empresa_id]);
        json_response('sucesso', 'Conjunto ativado');
        break;

    case 'desativar':
        $id = $_POST['id'] ?? null;
        if (!$id) json_response('erro', 'ID inválido');
        $stmt = $pdo->prepare("UPDATE conjuntos_anuncio SET ativo = 0 WHERE id = ? AND empresa_id = ?");
        $stmt->execute([$id, $empresa_id]);
        json_response('sucesso', 'Conjunto desativado');
        break;

    default:
        json_response('erro', 'Ação inválida');
}
