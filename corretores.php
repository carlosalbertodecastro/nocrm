<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';
?>
<!-- Font Awesome já deve estar incluído no header.php -->
<link rel="stylesheet" href="assets/css/datatables.css">
<script src="assets/js/datatables.js"></script>

<?php
// Atualizar ou deletar corretor
if (isset($_GET['delete'])) {
    $id = $_GET['delete'];
    $pdo->prepare("DELETE FROM corretores WHERE id = ?")->execute([$id]);
    echo '<div class="alert alert-warning">Corretor removido.</div>';
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['editar_id'])) {
    $id = $_POST['editar_id'];
    $stmt = $pdo->prepare("UPDATE corretores SET nome = ?, telefone_whatsapp = ?, instagram = ?, cargo_id = ?, ativo = ? WHERE id = ?");
    $stmt->execute([
        $_POST['nome'],
        preg_replace('/[^0-9]/', '', $_POST['telefone']),
        $_POST['instagram'],
        $_POST['cargo_id'],
        isset($_POST['ativo']) ? 1 : 0,
        $id
    ]);
    echo '<div class="alert alert-info">Corretor atualizado com sucesso!</div>';
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['nome'])) {
    $nome = $_POST['nome'];
    $telefone = preg_replace('/[^0-9]/', '', $_POST['telefone']);
    $instagram = $_POST['instagram'];
    $cargo_id = $_POST['cargo_id'];
    $ativo = isset($_POST['ativo']) ? 1 : 0;

    $stmt = $pdo->prepare("INSERT INTO corretores (nome, telefone_whatsapp, instagram, cargo_id, ativo) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$nome, $telefone, $instagram, $cargo_id, $ativo]);
    echo '<div class="alert alert-success">Corretor cadastrado com sucesso!</div>';
}

$cargos = $pdo->query("SELECT id, nome FROM cargos ORDER BY nome")->fetchAll();
$corretores = $pdo->query("SELECT co.*, ca.nome as cargo_nome FROM corretores co LEFT JOIN cargos ca ON ca.id = co.cargo_id ORDER BY co.nome")->fetchAll();
?>

<div class="container mt-4">
    <h1 class="h3 text-gray-800">Cadastrar Novo Corretor</h1>
    <form method="POST" class="mb-4">
        <div class="row g-2">
            <div class="col-md-4">
                <input type="text" name="nome" class="form-control" placeholder="Nome completo" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="telefone" class="form-control" placeholder="WhatsApp com DDD" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="instagram" class="form-control" placeholder="Link do Instagram">
            </div>
            <div class="col-md-2">
                <select name="cargo_id" class="form-select" required>
                    <option value="">Cargo</option>
                    <?php foreach ($cargos as $cargo): ?>
                        <option value="<?= $cargo['id'] ?>" <?= $cargo['nome'] === 'Corretor' ? 'selected' : '' ?>><?= $cargo['nome'] ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
        </div>
        <div class="form-check mt-2">
            <input class="form-check-input" type="checkbox" name="ativo" id="ativo" checked>
            <label class="form-check-label" for="ativo">Ativo</label>
        </div>
        <button class="btn btn-primary mt-3">Cadastrar Corretor</button>
    </form>

    <h3>Corretores Cadastrados</h3>
    <table class="table table-bordered table-sm datatable">
        <thead class="table-light">
            <tr>
                <th>Nome</th>
                <th>WhatsApp</th>
                <th>Instagram</th>
                <th>Cargo</th>
                <th>Status</th>
                <th class="text-center">Ações</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($corretores as $c): ?>
                <tr>
                    <form method="POST">
                        <td><input type="text" name="nome" value="<?= $c['nome'] ?>" class="form-control form-control-sm" required></td>
                        <td><input type="text" name="telefone" value="<?= $c['telefone_whatsapp'] ?>" class="form-control form-control-sm" required></td>
                        <td><input type="text" name="instagram" value="<?= $c['instagram'] ?>" class="form-control form-control-sm"></td>
                        <td>
                            <select name="cargo_id" class="form-select form-select-sm">
                                <?php foreach ($cargos as $cargo): ?>
                                    <option value="<?= $cargo['id'] ?>" <?= $cargo['id'] == $c['cargo_id'] ? 'selected' : '' ?>><?= $cargo['nome'] ?></option>
                                <?php endforeach; ?>
                            </select>
                        </td>
                        <td class="text-center">
                            <input type="checkbox" name="ativo" <?= $c['ativo'] ? 'checked' : '' ?>>
                            <input type="hidden" name="editar_id" value="<?= $c['id'] ?>">
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-primary" title="Salvar">
                                <i class="fas fa-save"></i>
                            </button>
                            <a href="?delete=<?= $c['id'] ?>" onclick="return confirm('Tem certeza que deseja remover este corretor?')" class="btn btn-sm btn-outline-danger" title="Excluir">
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </td>
                    </form>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const tables = document.querySelectorAll('.datatable');
        tables.forEach(table => new DataTable(table));
    });
</script>

<?php include 'includes/footer.php'; ?>
