<?php
require_once '../config/config.php';
require_once '../includes/auth.php';

if ($_SESSION['empresa_id'] != 1) {
  http_response_code(403);
  echo json_encode(['erro' => 'Acesso negado.']);
  exit;
}

$action = $_GET['action'] ?? ($_POST['action'] ?? '');

if ($action === 'listar') {
  $stmt = $pdo->query("SELECT * FROM empresas ORDER BY id DESC");
  echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
  exit;
}

if ($action === 'salvar') {
  $id = $_POST['id'] ?? null;
  $nome = trim($_POST['nome'] ?? '');
  $dominio = trim($_POST['dominio'] ?? '');
  $telefone = $_POST['telefone_contato'] ?? null;
  $cnpj = $_POST['cnpj'] ?? null;

  if (!$nome || !$dominio) {
    echo json_encode(['erro' => 'Campos obrigatórios.']);
    exit;
  }

  if ($id) {
    $stmt = $pdo->prepare("UPDATE empresas SET nome=?, dominio=?, telefone_contato=?, cnpj=? WHERE id=?");
    $stmt->execute([$nome, $dominio, $telefone, $cnpj, $id]);
  } else {
    $stmt = $pdo->prepare("INSERT INTO empresas (nome, dominio, telefone_contato, cnpj) VALUES (?, ?, ?, ?)");
    $stmt->execute([$nome, $dominio, $telefone, $cnpj]);
  }

  echo json_encode(['status' => 'ok']);
  exit;
}

if ($action === 'deletar') {
  $id = $_POST['id'] ?? null;
  if (!$id) {
    echo json_encode(['erro' => 'ID não informado.']);
    exit;
  }
  $stmt = $pdo->prepare("DELETE FROM empresas WHERE id = ?");
  $stmt->execute([$id]);
  echo json_encode(['status' => 'ok']);
  exit;
}

echo json_encode(['erro' => 'Ação inválida.']);
