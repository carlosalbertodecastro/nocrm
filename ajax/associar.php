<?php
require_once __DIR__ . '/../config/config.php';
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $conjunto_id = $_GET['conjunto_id'] ?? null;

    if (!$conjunto_id) {
        http_response_code(400);
        echo json_encode(['erro' => 'Conjunto ID ausente']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("
            SELECT c.id, c.nome
            FROM elegibilidade_corretores ec
            JOIN corretores c ON c.id = ec.corretor_id
            WHERE ec.conjunto_id = ? AND ec.ativo = 1
            ORDER BY ec.ordem_fila ASC
        ");
        $stmt->execute([$conjunto_id]);
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['erro' => 'Erro ao buscar associados']);
    }

} elseif ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    $corretor_id = $data['corretor_id'] ?? null;
    $conjunto_id = $data['conjunto_id'] ?? null;

    if (!$corretor_id || !$conjunto_id) {
        http_response_code(400);
        echo json_encode(['erro' => 'Dados ausentes']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT COUNT(*) FROM elegibilidade_corretores WHERE corretor_id = ? AND conjunto_id = ?");
    $stmt->execute([$corretor_id, $conjunto_id]);

    if ($stmt->fetchColumn() == 0) {
        $stmt = $pdo->prepare("INSERT INTO elegibilidade_corretores (corretor_id, conjunto_id, ativo) VALUES (?, ?, 1)");
        $stmt->execute([$corretor_id, $conjunto_id]);
    }

    echo json_encode(['sucesso' => true]);

} elseif ($method === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    $corretor_id = $data['corretor_id'] ?? null;
    $conjunto_id = $data['conjunto_id'] ?? null;

    if (!$corretor_id || !$conjunto_id) {
        http_response_code(400);
        echo json_encode(['erro' => 'Dados ausentes']);
        exit;
    }

    $stmt = $pdo->prepare("DELETE FROM elegibilidade_corretores WHERE corretor_id = ? AND conjunto_id = ?");
    $stmt->execute([$corretor_id, $conjunto_id]);

    echo json_encode(['removido' => true]);

} else {
    http_response_code(405);
    echo json_encode(['erro' => 'Método não permitido']);
}
