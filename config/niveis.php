<?php
// config/niveis.php

function definirNiveisGlobais($pdo, $empresa_id) {
    try {
        $stmt = $pdo->prepare("SELECT id, nome, nivel_acesso FROM cargos WHERE empresa_id = ?");
        $stmt->execute([$empresa_id]);
        $cargos = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $_SESSION['niveis_disponiveis'] = [];

        foreach ($cargos as $cargo) {
            $constante = 'NIVEL_' . strtoupper(preg_replace('/[^A-Za-z0-9]/', '_', $cargo['nome']));
            if (!defined($constante)) {
                define($constante, (int)$cargo['nivel_acesso']);
            }
            // Mapeia cargo para uso em sessão se necessário
            $_SESSION['niveis_disponiveis'][$cargo['id']] = [
                'nome' => $cargo['nome'],
                'nivel' => $cargo['nivel_acesso']
            ];
        }
    } catch (PDOException $e) {
        die("Erro ao carregar níveis de acesso: " . $e->getMessage());
    }
}

function verificar_acesso() {
    if (!isset($_SESSION['usuario_id'])) {
        header('Location: login.php?erro=nao-logado');
        exit;
    }

    if (!isset($_SESSION['nivel_acesso'])) {
        header('Location: login.php?erro=sem-nivel');
        exit;
    }
}

function usuario_eh_admin_nocrm() {
    return isset($_SESSION['empresa_id']) && $_SESSION['empresa_id'] == 1 && $_SESSION['nivel_acesso'] >= 5;
}

function usuario_eh_dono() {
    return isset($_SESSION['nivel_acesso']) && $_SESSION['nivel_acesso'] >= 4;
}

function usuario_eh_regional() {
    return isset($_SESSION['nivel_acesso']) && $_SESSION['nivel_acesso'] >= 3;
}

function usuario_eh_gerente() {
    return isset($_SESSION['nivel_acesso']) && $_SESSION['nivel_acesso'] >= 2;
}

function usuario_eh_corretor() {
    return isset($_SESSION['nivel_acesso']) && $_SESSION['nivel_acesso'] == 1;
}

function obterNivelPorCargo($cargo_nome) {
    $constante = 'NIVEL_' . strtoupper(str_replace(' ', '_', $cargo_nome));
    return defined($constante) ? constant($constante) : null;
}
    
