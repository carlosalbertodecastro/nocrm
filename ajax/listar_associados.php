<?php
require_once '../config/config.php';
header('Content-Type: application/json');

try {
    if (!isset($_GET['conjunto_id']) || !is_numeric($_GET['conjunto_id'])) {
        http_response_code(400);
        echo json_encode(['erro' => 'Parâmetro inválido.']);
        exit;
    }

    $conjunto_id = (int) $_GET['conjunto_id'];

    $stmt = $pdo->prepare("
        SELECT c.id, c.nome
        FROM elegibilidade_corretores ec
        INNER JOIN corretores c ON ec.corretor_id = c.id
        WHERE ec.conjunto_id = ? AND ec.ativo = 1
        ORDER BY ec.ordem_fila
    ");
    $stmt->execute([$conjunto_id]);
    $dados = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($dados);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['erro' => 'Erro no servidor.', 'detalhe' => $e->getMessage()]);
}
