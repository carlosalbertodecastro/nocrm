<?php
require_once '../config/config.php';
header('Content-Type: application/json');

// Receber dados do fetch
$input = json_decode(file_get_contents("php://input"), true);
$id = $input['id'] ?? null;
$ativo = $input['ativo'] ?? null;

if (!$id || !is_numeric($ativo)) {
    echo json_encode(['sucesso' => false, 'mensagem' => 'Dados inválidos.']);
    exit;
}

try {
    $stmt = $pdo->prepare("UPDATE corretores SET ativo = ? WHERE id = ?");
    $stmt->execute([$ativo, $id]);

    echo json_encode(['sucesso' => true, 'mensagem' => 'Status atualizado com sucesso.']);
} catch (PDOException $e) {
    echo json_encode(['sucesso' => false, 'mensagem' => 'Erro ao atualizar status.']);
}
