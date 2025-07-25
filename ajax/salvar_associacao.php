<?php
require_once '../config/config.php';

$conjunto_id = $_POST['conjunto_id'] ?? null;
$corretor_id = $_POST['corretor_id'] ?? null;

if (!$conjunto_id || !$corretor_id) {
    header('Location: ../associar_corretores.php?erro=1');
    exit;
}

// Verifica se já existe associação
$verifica = $pdo->prepare("
    SELECT COUNT(*) FROM elegibilidade_corretores
    WHERE conjunto_id = ? AND corretor_id = ?
");
$verifica->execute([$conjunto_id, $corretor_id]);

if ($verifica->fetchColumn() > 0) {
    header("Location: ../associar_corretores.php?conjunto_id=$conjunto_id&erro=2");
    exit;
}

// Busca o maior número de ordem atual para o conjunto
$maxOrdem = $pdo->prepare("
    SELECT MAX(ordem_fila) FROM elegibilidade_corretores
    WHERE conjunto_id = ?
");
$maxOrdem->execute([$conjunto_id]);
$novaOrdem = (int) $maxOrdem->fetchColumn() + 1;

// Faz a associação
$insert = $pdo->prepare("
    INSERT INTO elegibilidade_corretores (conjunto_id, corretor_id, ordem_fila, ativo)
    VALUES (?, ?, ?, 1)
");
$insert->execute([$conjunto_id, $corretor_id, $novaOrdem]);

header("Location: ../associar_corretores.php?conjunto_id=$conjunto_id&ok=1");
exit;