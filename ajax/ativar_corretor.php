<?php
require_once '../config/config.php';
header('Content-Type: application/json');

$dados = json_decode(file_get_contents("php://input"), true);
$corretor_id = $dados['id'] ?? null;

if (!$corretor_id) {
  echo json_encode(['erro' => 'ID do corretor não informado']);
  exit;
}

$stmt = $pdo->prepare("SELECT nome, ativo FROM corretores WHERE id = ?");
$stmt->execute([$corretor_id]);
$corretor = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$corretor) {
  echo json_encode(['erro' => 'Corretor não encontrado']);
  exit;
}

$novoStatus = $corretor['ativo'] ? 0 : 1;
$stmt = $pdo->prepare("UPDATE corretores SET ativo = ? WHERE id = ?");
$stmt->execute([$novoStatus, $corretor_id]);

echo json_encode([
  'sucesso' => true,
  'mensagem' => "Corretor " . htmlspecialchars($corretor['nome']) .
                ($novoStatus ? " ativado" : " desativado") . " com sucesso."
]);
