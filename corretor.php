<<<<<<< HEAD
<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
require_once 'config/niveis.php';
include 'includes/header.php';

$usuario_id = $_SESSION['usuario_id'];
$corretor_id = $_SESSION['cargo_id']; // ou $_SESSION['usuario_id'] se for id do corretor
$nome_corretor = $_SESSION['nome'];
$empresa_id = $_SESSION['empresa_visualizada_id'];
$hoje = date('Y-m-d');
$inicio = $_GET['inicio'] ?? date('Y-m-d', strtotime('-30 days'));
$fim    = $_GET['fim'] ?? $hoje;

// Mapeia status_lead
$status_map = [];
$status_ids = [];
$status_rows = $pdo->query("SELECT id, LOWER(REPLACE(nome, ' ', '-')) AS slug, nome FROM status_lead")->fetchAll(PDO::FETCH_ASSOC);
foreach ($status_rows as $row) {
    $slug = $row['slug'];
    $status_map[$slug] = [
        'id' => $row['id'],
        'label' => ucwords(str_replace('-', ' ', $slug)),
        'slug' => $slug
    ];
    $status_ids[$slug] = $row['id'];
}

// Contadores
$query = $pdo->prepare("SELECT status, resposta_contato, COUNT(*) as total FROM leads_recebidos WHERE corretor_id = ? AND empresa_id = ? AND DATE(data_recebido) BETWEEN ? AND ? GROUP BY status, resposta_contato");
$query->execute([$corretor_id, $empresa_id, $inicio, $fim]);
$leads = $query->fetchAll(PDO::FETCH_ASSOC);

$total_leads = 0;
$total_contato = 0;
$total_pendentes = 0;
$total_desqualificados = 0;
foreach ($leads as $lead) {
    $total_leads += $lead['total'];
    if ($lead['resposta_contato'] === 'whatsapp' || $lead['resposta_contato'] === 'telefone') {
        $total_contato += $lead['total'];
    }
    if ($lead['resposta_contato'] === 'nao-contatado') {
        $total_pendentes += $lead['total'];
    }
    if ($lead['resposta_contato'] === 'desqualificado') {
        $total_desqualificados += $lead['total'];
    }
}

// Tabela de leads
$tabela = $pdo->prepare("SELECT * FROM leads_recebidos WHERE corretor_id = ? AND empresa_id = ? AND DATE(data_recebido) BETWEEN ? AND ? ORDER BY data_recebido DESC");
$tabela->execute([$corretor_id, $empresa_id, $inicio, $fim]);
$lista_leads = $tabela->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
  <h1 class="h3 text-primary mb-4"><?= htmlspecialchars($nome_corretor) ?></h1>

  <form method="get" class="row g-2 align-items-end mb-4">
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= $hoje ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Hoje</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-d', strtotime('last sunday')) ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Semana</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y', strtotime('last sunday')) ?> a <?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-01') ?>&fim=<?= date('Y-m-t') ?>" class="btn btn-outline-primary w-100">Mês</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y', strtotime(date('Y-m-01'))) ?> a <?= date('d/m/Y', strtotime(date('Y-m-t'))) ?></small>
    </div>
    <div class="col-md-2">
      <label for="inicio" class="form-label small text-muted">Data Inicial</label>
      <input type="date" name="inicio" id="inicio" class="form-control" value="<?= $inicio ?>">
    </div>
    <div class="col-md-2">
      <label for="fim" class="form-label small text-muted">Data Final</label>
      <input type="date" name="fim" id="fim" class="form-control" value="<?= $fim ?>">
    </div>
    <div class="col-md-2">
      <button class="btn btn-dark w-100">Filtrar</button>
    </div>
  </form>

  <div class="row mb-4">
    <div class="col-md-3 mb-3">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Total de Leads: <?= $total_leads ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Em Contato: <?= $total_contato ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Pendentes: <?= $total_pendentes ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Desqualificados: <?= $total_desqualificados ?></div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-5">
    <div class="card-header fw-bold">Lista de Leads</div>
    <div class="card-body table-responsive">
      <table class="table table-bordered table-sm nowrap datatables" id="tabelaLeads">
        <thead>
          <tr>
            <th>Data</th>
            <th>Cliente</th>
            <th>Telefone</th>
            <th>Anúncio</th>
            <th>Status</th>
            <th>Contato</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($lista_leads as $l): ?>
            <tr>
              <td><?= date('d/m H:i', strtotime($l['data_recebido'])) ?></td>
              <td><?= htmlspecialchars($l['nome_cliente'] ?? '') ?></td>
              <td><?= htmlspecialchars($l['telefone_cliente'] ?? '') ?></td>
              <td><?= htmlspecialchars($l['anuncio_nome'] ?? '') ?></td>
              <td><?= $l['status'] ?></td>
              <td><?= $l['resposta_contato'] ?? '-' ?></td>
              <td><a href="lead_status.php?id=<?= $l['id'] ?>" class="btn btn-sm btn-primary">Visualizar</a></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
=======
<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
require_once 'config/niveis.php';
include 'includes/header.php';

$usuario_id = $_SESSION['usuario_id'];
$corretor_id = $_SESSION['cargo_id']; // ou $_SESSION['usuario_id'] se for id do corretor
$nome_corretor = $_SESSION['nome'];
$empresa_id = $_SESSION['empresa_visualizada_id'];
$hoje = date('Y-m-d');
$inicio = $_GET['inicio'] ?? date('Y-m-d', strtotime('-30 days'));
$fim    = $_GET['fim'] ?? $hoje;

// Mapeia status_lead
$status_map = [];
$status_ids = [];
$status_rows = $pdo->query("SELECT id, LOWER(REPLACE(nome, ' ', '-')) AS slug, nome FROM status_lead")->fetchAll(PDO::FETCH_ASSOC);
foreach ($status_rows as $row) {
  
    $slug = $row['slug'];
    $status_map[$slug] = [
        'id' => $row['id'],
        'label' => ucwords(str_replace('-', ' ', $slug)),
        'slug' => $slug
    ];
    $status_ids[$slug] = $row['id'];
}

// Contadores
$query = $pdo->prepare("SELECT status, resposta_contato, COUNT(*) as total FROM leads_recebidos WHERE corretor_id = ? AND empresa_id = ? AND DATE(data_recebido) BETWEEN ? AND ? GROUP BY status, resposta_contato");
$query->execute([$corretor_id, $empresa_id, $inicio, $fim]);
$leads = $query->fetchAll(PDO::FETCH_ASSOC);

$total_leads = 0;
$total_contato = 0;
$total_pendentes = 0;
$total_desqualificados = 0;
foreach ($leads as $lead) {
    $total_leads += $lead['total'];
    if ($lead['resposta_contato'] === 'whatsapp' || $lead['resposta_contato'] === 'telefone') {
        $total_contato += $lead['total'];
    }
    if ($lead['resposta_contato'] === 'nao-contatado') {
        $total_pendentes += $lead['total'];
    }
    if ($lead['resposta_contato'] === 'desqualificado') {
        $total_desqualificados += $lead['total'];
    }
}

// Tabela de leads
$tabela = $pdo->prepare("SELECT * FROM leads_recebidos WHERE corretor_id = ? AND empresa_id = ? AND DATE(data_recebido) BETWEEN ? AND ? ORDER BY data_recebido DESC");
$tabela->execute([$corretor_id, $empresa_id, $inicio, $fim]);
$lista_leads = $tabela->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
  <h1 class="h3 text-primary mb-4"><?= htmlspecialchars($nome_corretor) ?></h1>

  <form method="get" class="row g-2 align-items-end mb-4">
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= $hoje ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Hoje</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-d', strtotime('last sunday')) ?>&fim=<?= $hoje ?>" class="btn btn-outline-primary w-100">Semana</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y', strtotime('last sunday')) ?> a <?= date('d/m/Y') ?></small>
    </div>
    <div class="col-md-2 text-center">
      <a href="?inicio=<?= date('Y-m-01') ?>&fim=<?= date('Y-m-t') ?>" class="btn btn-outline-primary w-100">Mês</a>
      <small class="d-block text-muted fw-light mt-1"><?= date('d/m/Y', strtotime(date('Y-m-01'))) ?> a <?= date('d/m/Y', strtotime(date('Y-m-t'))) ?></small>
    </div>
    <div class="col-md-2">
      <label for="inicio" class="form-label small text-muted">Data Inicial</label>
      <input type="date" name="inicio" id="inicio" class="form-control" value="<?= $inicio ?>">
    </div>
    <div class="col-md-2">
      <label for="fim" class="form-label small text-muted">Data Final</label>
      <input type="date" name="fim" id="fim" class="form-control" value="<?= $fim ?>">
    </div>
    <div class="col-md-2">
      <button class="btn btn-dark w-100">Filtrar</button>
    </div>
  </form>

  <div class="row mb-4">
    <div class="col-md-3 mb-3">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Total de Leads: <?= $total_leads ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Em Contato: <?= $total_contato ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Pendentes: <?= $total_pendentes ?></div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body">
          <div class="h5 mb-0 font-weight-bold text-gray-800">Desqualificados: <?= $total_desqualificados ?></div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-5">
    <div class="card-header fw-bold">Lista de Leads</div>
    <div class="card-body table-responsive">
      <table class="table table-bordered table-sm nowrap datatables" id="tabelaLeads">
        <thead>
          <tr>
            <th>Data</th>
            <th>Cliente</th>
            <th>Telefone</th>
            <th>Anúncio</th>
            <th>Status</th>
            <th>Contato</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($lista_leads as $l): ?>
            <tr>
              <td><?= date('d/m H:i', strtotime($l['data_recebido'])) ?></td>
              <td><?= htmlspecialchars($l['nome_cliente'] ?? '') ?></td>
              <td><?= htmlspecialchars($l['telefone_cliente'] ?? '') ?></td>
              <td><?= htmlspecialchars($l['anuncio_nome'] ?? '') ?></td>
              <td><?= $l['status'] ?></td>
              <td><?= $l['resposta_contato'] ?? '-' ?></td>
              <td><a href="lead_status.php?id=<?= $l['id'] ?>" class="btn btn-sm btn-primary">Visualizar</a></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
>>>>>>> 6c2fbeaafb0caf8a3337125370993ce78f69acf6
