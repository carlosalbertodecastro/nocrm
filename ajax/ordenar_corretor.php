<?php
require_once '../config/config.php';

$conjunto_id = $_POST['conjunto_id'] ?? null;
$corretor_id = $_POST['corretor_id'] ?? null;
$acao = $_POST['acao'] ?? null;

if (!$conjunto_id || !$corretor_id || !$acao) {
    exit('Requisição inválida');
}

// Obter todos os corretores associados à fila ordenados
$stmt = $pdo->prepare("
    SELECT * FROM elegibilidade_corretores
    WHERE conjunto_id = ?
    ORDER BY ordem_fila
");
$stmt->execute([$conjunto_id]);
$lista = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Localizar o índice do corretor na fila
$indexAtual = array_search($corretor_id, array_column($lista, 'corretor_id'));

if ($indexAtual === false) {
    exit('Corretor não encontrado na fila');
}

// Definir o novo índice
$novoIndex = $acao === 'subir' ? $indexAtual - 1 : $indexAtual + 1;

// Validar o índice
if ($novoIndex < 0 || $novoIndex >= count($lista)) {
    header("Location: ../associar_corretores.php?conjunto_id=$conjunto_id");
    exit;
}

// Trocar as posições
$temp = $lista[$indexAtual]['ordem_fila'];
$lista[$indexAtual]['ordem_fila'] = $lista[$novoIndex]['ordem_fila'];
$lista[$novoIndex]['ordem_fila'] = $temp;

// Atualizar no banco
$update = $pdo->prepare("
    UPDATE elegibilidade_corretores
    SET ordem_fila = :ordem
    WHERE conjunto_id = :conjunto AND corretor_id = :corretor
");

$update->execute([
    'ordem' => $lista[$indexAtual]['ordem_fila'],
    'conjunto' => $conjunto_id,
    'corretor' => $lista[$indexAtual]['corretor_id']
]);

$update->execute([
    'ordem' => $lista[$novoIndex]['ordem_fila'],
    'conjunto' => $conjunto_id,
    'corretor' => $lista[$novoIndex]['corretor_id']
]);

// Redirecionar de volta à tela
header("Location: ../associar_corretores.php?conjunto_id=$conjunto_id");
exit;