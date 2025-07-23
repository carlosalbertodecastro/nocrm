<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

// Inserir nova campanha
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['nova_campanha'])) {
  $nome = trim($_POST['nome']);
  if ($nome) {
    $stmt = $pdo->prepare("INSERT INTO campanhas (nome, ativo) VALUES (?, 1)");
    $stmt->execute([$nome]);
    header("Location: campanhas.php");
    exit;
  }
}

// Atualizar campanha
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['editar_campanha'])) {
  $id = $_POST['campanha_id'];
  $nome = trim($_POST['nome']);
  $ativo = isset($_POST['ativo']) ? 1 : 0;
  $stmt = $pdo->prepare("UPDATE campanhas SET nome = ?, ativo = ? WHERE id = ?");
  $stmt->execute([$nome, $ativo, $id]);
  header("Location: campanhas.php");
  exit;
}

// Excluir campanha
if (isset($_GET['excluir'])) {
  $id = $_GET['excluir'];
  $pdo->prepare("DELETE FROM campanhas WHERE id = ?")->execute([$id]);
  header("Location: campanhas.php");
  exit;
}

// Buscar todas campanhas
$campanhas = $pdo->query("SELECT * FROM campanhas ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
  <h3 class="mb-4">📣 Campanhas</h3>

  <!-- Formulário Nova Campanha -->
  <div class="card mb-4">
    <div class="card-header fw-bold">Nova Campanha</div>
    <div class="card-body">
      <form method="post" class="row g-2">
        <div class="col-md-6">
          <input type="text" name="nome" class="form-control" placeholder="Nome da Campanha" required>
        </div>
        <div class="col-md-2">
          <button class="btn btn-success w-100" name="nova_campanha"><i class="fas fa-plus"></i> Adicionar</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Tabela de campanhas -->
  <div class="card">
    <div class="card-header fw-bold">📋 Campanhas Cadastradas</div>
    <div class="card-body table-responsive">
      <table class="table table-bordered table-sm datatable">
        <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Status</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($campanhas as $camp): ?>
            <tr>
              <td><?= $camp['id'] ?></td>
              <td><?= htmlspecialchars($camp['nome']) ?></td>
              <td><?= $camp['ativo'] ? 'Ativo' : 'Inativo' ?></td>
              <td>
                <!-- Botão Editar -->
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editarModal<?= $camp['id'] ?>">
                  <i class="fas fa-edit"></i>
                </button>

                <!-- Botão Excluir -->
                <a href="?excluir=<?= $camp['id'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Excluir esta campanha?')">
                  <i class="fas fa-trash"></i>
                </a>

                <!-- Modal de edição -->
                <div class="modal fade" id="editarModal<?= $camp['id'] ?>" tabindex="-1">
                  <div class="modal-dialog">
                    <form method="post" class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title">Editar Campanha</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                      </div>
                      <div class="modal-body">
                        <input type="hidden" name="campanha_id" value="<?= $camp['id'] ?>">
                        <div class="mb-3">
                          <label class="form-label">Nome</label>
                          <input type="text" name="nome" class="form-control" value="<?= htmlspecialchars($camp['nome']) ?>" required>
                        </div>
                        <div class="form-check">
                          <input class="form-check-input" type="checkbox" name="ativo" <?= $camp['ativo'] ? 'checked' : '' ?>>
                          <label class="form-check-label">Ativo</label>
                        </div>
                      </div>
                      <div class="modal-footer">
                        <button type="submit" name="editar_campanha" class="btn btn-success">Salvar</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                      </div>
                    </form>
                  </div>
                </div>

              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Scripts do DataTables e Bootstrap -->
<script src="assets/js/datatables.js"></script>

<?php include 'includes/footer.php'; ?>