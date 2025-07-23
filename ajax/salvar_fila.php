<?php
require_once '../config/config.php';

header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
$acao = $input['acao'] ?? '';
$conjunto_id = (int) ($input['conjunto_id'] ?? 0);
$corretor_id = (int) ($input['corretor_id'] ?? 0);
$ordem = (int) ($input['ordem'] ?? 1);

if (!$acao || !$conjunto_id || !$corretor_id) {
  echo json_encode(['sucesso' => false, 'mensagem' => 'Dados incompletos']);
  exit;
}

try {
  if ($acao === 'adicionar') {
    $stmt = $pdo->prepare("
      INSERT INTO elegibilidade_corretores (conjunto_id, corretor_id, ordem_fila, ativo)
      VALUES (?, ?, ?, 1)
      ON DUPLICATE KEY UPDATE ordem_fila = VALUES(ordem_fila), ativo = 1
    ");
    $stmt->execute([$conjunto_id, $corretor_id, $ordem]);

    echo json_encode(['sucesso' => true, 'mensagem' => "✅ Corretor adicionado à fila"]);
  } elseif ($acao === 'remover') {
    $stmt = $pdo->prepare("
      DELETE FROM elegibilidade_corretores WHERE conjunto_id = ? AND corretor_id = ?
    ");
    $stmt->execute([$conjunto_id, $corretor_id]);

    echo json_encode(['sucesso' => true, 'mensagem' => "🗑️ Corretor removido da fila"]);
  } elseif ($acao === 'atualizar') {
    $stmt = $pdo->prepare("
      UPDATE elegibilidade_corretores SET ordem_fila = ? WHERE conjunto_id = ? AND corretor_id = ?
    ");
    $stmt->execute([$ordem, $conjunto_id, $corretor_id]);

    echo json_encode(['sucesso' => true, 'mensagem' => "🔁 Ordem da fila atualizada"]);
  } else {
    echo json_encode(['sucesso' => false, 'mensagem' => '❌ Ação inválida']);
  }
} catch (Exception $e) {
  echo json_encode(['sucesso' => false, 'mensagem' => 'Erro: ' . $e->getMessage()]);
}