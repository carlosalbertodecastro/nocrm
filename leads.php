<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$hoje = date('Y-m-d');
$inicio = $_GET['inicio'] ?? date('Y-m-d', strtotime('-30 days'));
$fim = $_GET['fim'] ?? $hoje;
$corretor_id = $_GET['corretor_id'] ?? '';
$conjunto_id = $_GET['conjunto_id'] ?? '';
$status = $_GET['status'] ?? '';

$where = '1 = 1';

if ($inicio && $fim) {
  $where .= " AND DATE(lr.data_recebido) BETWEEN '$inicio' AND '$fim'";
}
if (!empty($corretor_id)) {
  $where .= " AND lr.corretor_id = " . intval($corretor_id);
}
if (!empty($conjunto_id)) {
  $where .= " AND lr.conjunto_id = " . intval($conjunto_id);
}
if (!empty($status)) {
  $where .= " AND lr.status = " . intval($status);
}

$query = $pdo->prepare("
  SELECT lr.*, c.nome AS corretor_nome, ca.nome AS conjunto_nome
  FROM leads_recebidos lr
  LEFT JOIN corretores c ON lr.corretor_id = c.id
  LEFT JOIN conjuntos_anuncio ca ON lr.conjunto_id = ca.id
  WHERE $where
  ORDER BY lr.data_recebido DESC
");
$query->execute();
$leads = $query->fetchAll(PDO::FETCH_ASSOC);

$corretores = $pdo->query("SELECT id, nome FROM corretores ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
$conjuntos = $pdo->query("SELECT id, nome FROM conjuntos_anuncio ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container-fluid py-4">
  <h1 class="h3 text-gray-800">Leads Recebidos</h1>

  <form method="get" class="row g-2 align-items-end mb-4">
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= $hoje ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Hoje</a>
      <small class="d-block text-muted"><?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-d', strtotime('last sunday')) ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Semana</a>
      <small class="d-block text-muted"><?= date('d/m/Y', strtotime('last sunday')) ?> a <?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-01') ?>&fim=<?= date('Y-m-t') ?>" class="btn btn-outline-primary w-100">Mês</a>
      <small class="d-block text-muted"><?= date('d/m/Y', strtotime(date('Y-m-01'))) ?> a <?= date('d/m/Y', strtotime(date('Y-m-t'))) ?></small>
    </div>

    <div class="col-md-2">
      <label for="inicio" class="form-label">Data Inicial</label>
      <input type="date" name="inicio" id="inicio" class="form-control" value="<?= $inicio ?>">
    </div>
    <div class="col-md-2">
      <label for="fim" class="form-label">Data Final</label>
      <input type="date" name="fim" id="fim" class="form-control" value="<?= $fim ?>">
    </div>

    <div class="col-md-3">
      <label class="form-label">Corretor</label>
      <select name="corretor_id" class="form-select">
        <option value="">Todos</option>
        <?php foreach ($corretores as $c): ?>
          <option value="<?= $c['id'] ?>" <?= $corretor_id == $c['id'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($c['nome']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </div>

    <div class="col-md-3">
      <label class="form-label">Conjunto</label>
      <select name="conjunto_id" class="form-select">
        <option value="">Todos</option>
        <?php foreach ($conjuntos as $cj): ?>
          <option value="<?= $cj['id'] ?>" <?= $conjunto_id == $cj['id'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($cj['nome']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </div>

    <div class="col-md-2">
      <button class="btn btn-dark w-100 mt-2"><i class="fas fa-filter"></i> Filtrar</button>
    </div>
  </form>

  <div class="card">
    <div class="card-header fw-bold">📋 Lista de Leads</div>
    <div class="card-body table-responsive">
      <table class="table table-bordered table-striped table-sm nowrap datatables">
        <thead>
          <tr>
            <th>Data</th>
            <th>Corretor</th>
            <th>Cliente</th>
            <th>Telefone</th>
            <th>Anúncio</th>
            <th>Conjunto</th>
            <th>Status</th>
            <th>Resposta</th>
            <th class="text-center">🔍</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($leads as $l): ?>
            <tr>
              <td><?= date('d/m H:i', strtotime($l['data_recebido'])) ?></td>
              <td><?= htmlspecialchars($l['corretor_nome'] ?? '-') ?></td>
              <td><?= htmlspecialchars($l['nome_cliente']) ?></td>
              <td><?= htmlspecialchars($l['telefone_cliente']) ?></td>
              <td><?= htmlspecialchars($l['anuncio_nome']) ?></td>
              <td><?= htmlspecialchars($l['conjunto_nome'] ?? '-') ?></td>
              <td><?= $l['status'] ?></td>
              <td><?= $l['resposta_contato'] ?? '-' ?></td>
              <td class="text-center">
                <a href="historico_lead.php?lead_id=<?= $l['id'] ?>" class="text-secondary" title="Ver histórico do lead">
                  <i class="fas fa-history"></i>
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
