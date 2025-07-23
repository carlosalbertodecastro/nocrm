<?php
require_once __DIR__ . '/config/config.php';
session_start();

$email = $_POST['email'] ?? '';
$senha = $_POST['senha'] ?? '';

$stmt = $pdo->prepare("SELECT * FROM usuarios WHERE email = :email AND ativo = 1 LIMIT 1");
$stmt->execute(['email' => $email]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if ($usuario && password_verify($senha, $usuario['senha'])) {
    $_SESSION['usuario'] = $usuario;
    header("Location: dashboard.php");
    exit;
} else {
    $_SESSION['erro'] = "E-mail ou senha inválidos.";
    header("Location: login.php");
    exit;
}
