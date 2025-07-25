<?php
// ajax/usuarios.php

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/niveis.php';
definirNiveisGlobais($pdo);
verificar_acesso(NIVEL_GERENTE);

header('Content-Type: application/json');

$acao = $_GET['action'] ?? '';

try {
    if ($acao === 'listar') {
        $stmt = $pdo->query("
            SELECT u.id, u.nome, u.email, u.empresa_id, e.nome AS empresa_nome,
                   c.nome AS cargo_nome
            FROM usuarios u
            LEFT JOIN empresas e ON u.empresa_id = e.id
            LEFT JOIN cargos c ON u.cargo_id = c.id
        ");
        echo json_encode(['data' => $stmt->fetchAll()]);
        exit;
    }

    if ($acao === 'criar') {
        $nome       = $_POST['nome'] ?? '';
        $email      = $_POST['email'] ?? '';
        $senha      = $_POST['senha'] ?? '';
        $cargo_id   = $_POST['cargo_id'] ?? null;
        $empresa_id = $_POST['empresa_id'] ?? null;

        if (!$nome || !$email || !$senha || !$cargo_id || !$empresa_id) {
            echo json_encode(['status' => 'erro', 'mensagem' => 'Todos os campos são obrigatórios.']);
            exit;
        }

        $senhaHash = password_hash($senha, PASSWORD_DEFAULT);

        $stmt = $pdo->prepare("INSERT INTO usuarios (nome, email, senha, empresa_id, cargo_id) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$nome, $email, $senhaHash, $empresa_id, $cargo_id]);

        echo json_encode(['status' => 'ok', 'mensagem' => 'Usuário criado com sucesso!']);
        exit;
    }

    if ($acao === 'atualizar') {
        $id     = $_POST['id'] ?? null;
        $campo  = $_POST['campo'] ?? '';
        $valor  = $_POST['valor'] ?? '';

        if (!$id || !$campo || $valor === '') {
            echo json_encode(['status' => 'erro', 'mensagem' => 'Dados incompletos para atualização.']);
            exit;
        }

        // Campos permitidos para edição inline
        $permitidos = ['nome', 'email'];
        if (!in_array($campo, $permitidos)) {
            echo json_encode(['status' => 'erro', 'mensagem' => 'Campo não permitido para edição.']);
            exit;
        }

        $sql = "UPDATE usuarios SET {$campo} = :valor WHERE id = :id";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(['valor' => $valor, 'id' => $id]);

        echo json_encode(['status' => 'ok', 'mensagem' => 'Usuário atualizado.']);
        exit;
    }

    if ($acao === 'excluir') {
        $id = $_POST['id'] ?? null;

        if (!$id) {
            echo json_encode(['status' => 'erro', 'mensagem' => 'ID não fornecido.']);
            exit;
        }

        $stmt = $pdo->prepare("DELETE FROM usuarios WHERE id = ?");
        $stmt->execute([$id]);

        echo json_encode(['status' => 'ok', 'mensagem' => 'Usuário excluído.']);
        exit;
    }

    // Ação inválida
    echo json_encode(['status' => 'erro', 'mensagem' => 'Ação inválida.']);
} catch (PDOException $e) {
    echo json_encode(['status' => 'erro', 'mensagem' => 'Erro: ' . $e->getMessage()]);
}
