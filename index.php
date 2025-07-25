<?php
header("Location: dashboard.php");
exit;
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$periodo = $_GET['periodo'] ?? 'dia';
$hoje = date('Y-m-d');

if ($periodo === 'semana') {
  $inicio = date('Y-m-d', strtotime('-7 days'));
} elseif ($periodo === 'mes') {
  $inicio = date('Y-m-d', strtotime('-30 days'));
} else {
  $inicio = $hoje;
}

// Gráficos
$stmt = $pdo->prepare("
  SELECT ca.nome AS conjunto, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN conjuntos_anuncio ca ON lr.conjunto_id = ca.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY ca.nome
");
$stmt->execute([$inicio, $hoje]);
$conjuntos = $stmt->fetchAll(PDO::FETCH_ASSOC);

$stmt = $pdo->prepare("
  SELECT c.nome AS corretor, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN corretores c ON lr.corretor_id = c.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY c.nome
");
$stmt->execute([$inicio, $hoje]);
$corretores = $stmt->fetchAll(PDO::FETCH_ASSOC);

$stmt = $pdo->prepare("
  SELECT ca.nome AS conjunto, anuncio_nome, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN conjuntos_anuncio ca ON lr.conjunto_id = ca.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY ca.nome, anuncio_nome
");
$stmt->execute([$inicio, $hoje]);
$anuncios = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Últimos leads (com nome do corretor)
$ultimos = $pdo->query("
  SELECT lr.nome_cliente, lr.telefone_cliente, lr.email_cliente, lr.anuncio_nome,
         DATE_FORMAT(lr.data_recebido, '%d/%m %H:%i') as data,
         c.nome AS corretor
  FROM leads_recebidos lr
  JOIN corretores c ON lr.corretor_id = c.id
  ORDER BY lr.data_recebido DESC
  LIMIT 10
")->fetchAll(PDO::FETCH_ASSOC);

// Corretores ativos
$ativos = $pdo->query("SELECT id, nome, ativo FROM corretores ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);

// Fila de atendimento por conjunto
$filas = $pdo->query("
  SELECT ca.nome AS conjunto, ec.ordem_fila, c.nome AS corretor
  FROM elegibilidade_corretores ec
  JOIN conjuntos_anuncio ca ON ca.id = ec.conjunto_id
  JOIN corretores c ON c.id = ec.corretor_id
  WHERE ca.ativo = 1 AND ec.ativo = 1 AND c.ativo = 1
  ORDER BY ca.nome, ec.ordem_fila ASC
")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
  <h2 class="mb-4 text-primary">📊 Dashboard de Leads</h2>

  <!-- Período -->
  <form class="mb-4">
    <div class="btn-group" role="group">
      <a href="?periodo=dia" class="btn btn-outline-primary <?= $periodo === 'dia' ? 'active' : '' ?>">Hoje</a>
      <a href="?periodo=semana" class="btn btn-outline-primary <?= $periodo === 'semana' ? 'active' : '' ?>">Semana</a>
      <a href="?periodo=mes" class="btn btn-outline-primary <?= $periodo === 'mes' ? 'active' : '' ?>">Mês</a>
    </div>
  </form>

  <!-- Gráficos -->
  <div class="row">
    <div class="col-md-6 mb-4">
      <div class="card shadow">
        <div class="card-header bg-primary text-white fw-bold">🎯 Leads por Conjunto</div>
        <div class="card-body"><canvas id="graficoConjuntos"></canvas></div>
      </div>
    </div>
    <div class="col-md-6 mb-4">
      <div class="card shadow">
        <div class="card-header bg-primary text-white fw-bold">👥 Leads por Corretor</div>
        <div class="card-body"><canvas id="graficoCorretores"></canvas></div>
      </div>
    </div>
    <div class="col-12 mb-4">
      <div class="card shadow">
        <div class="card-header bg-primary text-white fw-bold">📢 Anúncios por Conjunto</div>
        <div class="card-body"><canvas id="graficoAnuncios"></canvas></div>
      </div>
    </div>
  </div>

  <!-- Últimos Leads -->
  <div class="card mb-4 bg-primary text-white">
    <div class="card-header fw-bold">🕓 Últimos Leads</div>
    <div class="card-body bg-white text-dark">
      <div class="table-responsive">
        <table class="table table-sm table-bordered">
          <thead class="table-primary"><tr>
            <th>Corretor</th><th>Cliente</th><th>Telefone</th><th>Email</th><th>Anúncio</th><th>Data</th>
          </tr></thead>
          <tbody>
            <?php foreach ($ultimos as $l): ?>
              <tr>
                <td><?= htmlspecialchars($l['corretor']) ?></td>
                <td><?= htmlspecialchars($l['nome_cliente']) ?></td>
                <td><?= htmlspecialchars($l['telefone_cliente']) ?></td>
                <td><?= htmlspecialchars($l['email_cliente']) ?></td>
                <td><?= htmlspecialchars($l['anuncio_nome']) ?></td>
                <td><?= $l['data'] ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Corretores Ativos -->
  <div class="card mb-4 bg-primary text-white">
    <div class="card-header fw-bold">🧑‍💼 Corretores Ativos</div>
    <div class="card-body bg-white text-dark">
      <table class="table table-sm table-bordered">
        <thead class="table-primary"><tr><th>Nome</th><th>Status</th><th>Ação</th></tr></thead>
        <tbody>
          <?php foreach ($ativos as $c): ?>
          <tr>
            <td><?= htmlspecialchars($c['nome']) ?></td>
            <td><?= $c['ativo'] ? '✅ Ativo' : '⛔ Inativo' ?></td>
            <td>
              <button class="btn btn-sm btn-outline-<?= $c['ativo'] ? 'danger' : 'success' ?>"
                      onclick="toggleCorretor(<?= $c['id'] ?>, <?= $c['ativo'] ? 0 : 1 ?>)">
                <i class="fa fa-toggle-<?= $c['ativo'] ? 'off' : 'on' ?>"></i>
              </button>
            </td>
          </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Fila de Atendimento -->
  <div class="card mb-5 bg-primary text-white">
    <div class="card-header fw-bold">⏳ Fila de Atendimento de Leads</div>
    <div class="card-body bg-white text-dark">
      <table class="table table-sm table-bordered">
        <thead class="table-primary"><tr><th>Conjunto</th><th>Corretor</th><th>Posição</th></tr></thead>
        <tbody>
          <?php foreach ($filas as $f): ?>
            <tr>
              <td><?= htmlspecialchars($f['conjunto']) ?></td>
              <td><?= htmlspecialchars($f['corretor']) ?></td>
              <td><?= $f['ordem_fila'] ?></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
function toggleCorretor(id, ativo) {
  fetch('ajax/toggle_corretor.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id, ativo })
  }).then(() => location.reload());
}

document.addEventListener('DOMContentLoaded', function () {
  new Chart(document.getElementById("graficoConjuntos"), {
    type: 'pie',
    data: {
      labels: <?= json_encode(array_column($conjuntos, 'conjunto')) ?>,
      datasets: [{
        data: <?= json_encode(array_map('intval', array_column($conjuntos, 'total'))) ?>,
        backgroundColor: ['#007bff', '#3399ff', '#66b3ff', '#5dade2', '#2980b9']
      }]
    }
  });

  new Chart(document.getElementById("graficoCorretores"), {
    type: 'bar',
    data: {
      labels: <?= json_encode(array_column($corretores, 'corretor')) ?>,
      datasets: [{
        label: 'Leads',
        data: <?= json_encode(array_map('intval', array_column($corretores, 'total'))) ?>,
        backgroundColor: '#007bff'
      }]
    }
  });

  const dados = <?= json_encode($anuncios) ?>;
  const conjuntos = [...new Set(dados.map(i => i.conjunto))];
  const nomesAnuncios = [...new Set(dados.map(i => i.anuncio_nome))];

  const datasets = nomesAnuncios.map((anuncio, idx) => ({
    label: anuncio,
    data: conjuntos.map(c => {
      const r = dados.find(d => d.anuncio_nome === anuncio && d.conjunto === c);
      return r ? parseInt(r.total) : 0;
    }),
    backgroundColor: `hsl(${(idx * 50) % 360}, 60%, 60%)`
  }));

  new Chart(document.getElementById("graficoAnuncios"), {
    type: 'bar',
    data: { labels: conjuntos, datasets },
    options: {
      responsive: true,
      plugins: { legend: { position: 'bottom' } }
    }
  });
});
</script>

<?php include 'includes/footer.php'; ?>
