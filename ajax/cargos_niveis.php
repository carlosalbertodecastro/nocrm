<?php
// ajax/cargos_niveis.php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/niveis.php';
header('Content-Type: application/json');

// Apenas usuários com nível de Sócio ou superior podem fazer isso
session_start();
definirNiveisGlobais($pdo);

if (!isset($_SESSION['usuario_id'])) {
  echo json_encode(['status' => 'erro', 'mensagem' => 'Acesso negado']);
  exit;
}

$usuario_id = $_SESSION['usuario_id'];
$empresa_id = $_SESSION['empresa_id'] ?? 0;
$nivel_usuario = $_SESSION['nivel_acesso'] ?? 0;

if ($nivel_usuario < NIVEL_SOCIO) {
  echo json_encode(['status' => 'erro', 'mensagem' => 'Permissão insuficiente']);
  exit;
}

// Lê os dados JSON do POST
$dados = json_decode(file_get_contents('php://input'), true);

$cargo_id = (int)($dados['cargo_id'] ?? 0);
$novo_nivel_id = (int)($dados['novo_nivel_id'] ?? 0);

if (!$cargo_id || !$novo_nivel_id) {
  echo json_encode(['status' => 'erro', 'mensagem' => 'Dados inválidos']);
  exit;
}

// Verifica se o cargo pertence à empresa visualizada
$stmt = $pdo->prepare("SELECT * FROM cargos WHERE id = ? AND empresa_id = ?");
$stmt->execute([$cargo_id, $_SESSION['empresa_visualizada_id']]);
$cargo = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$cargo) {
  echo json_encode(['status' => 'erro', 'mensagem' => 'Cargo não encontrado']);
  exit;
}

// Atualiza o cargo com o novo nível de acesso
$update = $pdo->prepare("UPDATE cargos SET nivel_acesso_id = ? WHERE id = ?");
if ($update->execute([$novo_nivel_id, $cargo_id])) {
  echo json_encode(['status' => 'sucesso']);
} else {
  echo json_encode(['status' => 'erro', 'mensagem' => 'Falha ao atualizar']);
}
