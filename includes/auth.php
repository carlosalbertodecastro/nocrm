<?php
// includes/auth.php

session_start();

require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/niveis.php';

// ⚙️ Define níveis dinamicamente a partir da tabela cargos
if (isset($_SESSION['empresa_id'])) {
    definirNiveisGlobais($pdo, $_SESSION['empresa_id']);
}


// 🔒 Redireciona se não estiver logado
if (!isset($_SESSION['usuario_id'])) {
    header('Location: /gestao-de-leads/login.php');
    exit;
}

// 🔐 Define variáveis de sessão seguras
$usuario_id = $_SESSION['usuario_id'];
$empresa_id = $_SESSION['empresa_id'];
$nivel_acesso = $_SESSION['nivel_acesso'];
$cargo_nome = $_SESSION['cargo_nome'] ?? '';

// 🔍 Função: verifica se o usuário pode ver tudo
function usuarioPodeVerTudo(): bool {
    return $_SESSION['empresa_id'] == 1 || $_SESSION['nivel_acesso'] >= NIVEL_ADMINISTRADOR;
}

// 🔍 Função: define se o usuário é da empresa NoCRM
function usuarioEhDaNoCRM(): bool {
    return $_SESSION['empresa_id'] == 1;
}

// 🔍 Função: define se o usuário é administrador da própria empresa
function usuarioEhAdministrador(): bool {
    return $_SESSION['nivel_acesso'] >= NIVEL_ADMINISTRADOR;
}
