<?php
// gestao-de-leads/ajax/permissoes_cargos.php

require_once 'config/config.php';

header('Content-Type: application/json');

try {
    // Recebe dados via POST
    $cargo_id   = (int) ($_POST['cargo_id'] ?? 0);
    $pagina     = trim($_POST['pagina'] ?? '');
    $acao       = trim($_POST['acao'] ?? '');
    $permitido  = isset($_POST['permitido']) ? (int) $_POST['permitido'] : 0;

    // Validações básicas
    if ($cargo_id <= 0 || !$pagina || !$acao) {
        throw new Exception('Dados inválidos');
    }

    // Verifica se já existe a permissão
    $stmt = $pdo->prepare("SELECT id FROM permissoes_cargos WHERE cargo_id = ? AND pagina = ? AND acao = ?");
    $stmt->execute([$cargo_id, $pagina, $acao]);
    $permissao = $stmt->fetch();

    if ($permissao) {
        // Atualiza
        $update = $pdo->prepare("UPDATE permissoes_cargos SET permitido = ?, atualizado_em = NOW() WHERE id = ?");
        $update->execute([$permitido, $permissao['id']]);
    } else {
        // Insere nova permissão
        $insert = $pdo->prepare("INSERT INTO permissoes_cargos (cargo_id, pagina, acao, permitido) VALUES (?, ?, ?, ?)");
        $insert->execute([$cargo_id, $pagina, $acao, $permitido]);
    }

    echo json_encode(['status' => 'ok', 'message' => 'Permissão salva com sucesso']);
} catch (Exception $e) {
    echo json_encode(['status' => 'erro', 'message' => $e->getMessage()]);
}
