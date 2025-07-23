<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/niveis.php';
verificar_acesso(NIVEL_SOCIO); // Apenas sócio pode editar permissões

$acao = $_POST['acao'] ?? '';

if ($acao === 'carregar') {
    // Lista todos os cargos e permissões existentes
    $dados = [];

    $cargos = $pdo->query("SELECT id, nome FROM cargos ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
    $paginas = $pdo->query("SELECT DISTINCT pagina FROM permissoes_cargos ORDER BY pagina")->fetchAll(PDO::FETCH_COLUMN);

    foreach ($cargos as $cargo) {
        $permissoes = $pdo->prepare("SELECT pagina, acao FROM permissoes_cargos WHERE cargo_id = ?");
        $permissoes->execute([$cargo['id']]);
        $mapa = [];
        foreach ($permissoes->fetchAll(PDO::FETCH_ASSOC) as $p) {
            $mapa[$p['pagina']][$p['acao']] = true;
        }

        $dados[] = [
            'id'         => $cargo['id'],
            'nome'       => $cargo['nome'],
            'permissoes' => $mapa
        ];
    }

    echo json_encode([
        'status'  => 'ok',
        'cargos'  => $dados,
        'paginas' => $paginas
    ]);
    exit;
}

if ($acao === 'atualizar') {
    $cargo_id = $_POST['cargo_id'] ?? null;
    $pagina   = $_POST['pagina'] ?? '';
    $acaoPerm = $_POST['acaoPerm'] ?? '';
    $checked  = $_POST['checked'] === 'true';

    if (!$cargo_id || !$pagina || !$acaoPerm) {
        echo json_encode(['status' => 'erro', 'mensagem' => 'Dados incompletos']);
        exit;
    }

    try {
        if ($checked) {
            // INSERIR se não existir
            $stmt = $pdo->prepare("INSERT IGNORE INTO permissoes_cargos (cargo_id, pagina, acao) VALUES (?, ?, ?)");
            $stmt->execute([$cargo_id, $pagina, $acaoPerm]);
        } else {
            // REMOVER
            $stmt = $pdo->prepare("DELETE FROM permissoes_cargos WHERE cargo_id = ? AND pagina = ? AND acao = ?");
            $stmt->execute([$cargo_id, $pagina, $acaoPerm]);
        }

        echo json_encode(['status' => 'ok']);
    } catch (PDOException $e) {
        echo json_encode(['status' => 'erro', 'mensagem' => $e->getMessage()]);
    }

    exit;
}

echo json_encode(['status' => 'erro', 'mensagem' => 'Ação inválida']);
exit;
