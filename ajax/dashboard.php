<?php
require_once '../config/config.php';
$periodo = $_GET['periodo'] ?? 'dia';

$hoje = date('Y-m-d');
if ($periodo === 'semana') {
  $inicio = date('Y-m-d', strtotime('-7 days'));
} elseif ($periodo === 'mes') {
  $inicio = date('Y-m-d', strtotime('-30 days'));
} else {
  $inicio = $hoje;
}

// Leads por conjunto
$stmt = $pdo->prepare("
  SELECT ca.nome AS conjunto, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN conjuntos_anuncio ca ON lr.conjunto_id = ca.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY ca.nome
");
$stmt->execute([$inicio, $hoje]);
$conjuntos = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Leads por corretor
$stmt = $pdo->prepare("
  SELECT c.nome AS corretor, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN corretores c ON lr.corretor_id = c.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY c.nome
");
$stmt->execute([$inicio, $hoje]);
$corretores = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Leads por anúncio
$stmt = $pdo->prepare("
  SELECT ca.nome AS conjunto, anuncio_nome, COUNT(*) as total
  FROM leads_recebidos lr
  JOIN conjuntos_anuncio ca ON lr.conjunto_id = ca.id
  WHERE DATE(data_recebido) BETWEEN ? AND ?
  GROUP BY ca.nome, anuncio_nome
");
$stmt->execute([$inicio, $hoje]);
$anuncios = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Últimos leads
$ultimos = $pdo->query("
  SELECT nome_cliente, telefone_cliente, email_cliente, anuncio_nome, DATE_FORMAT(data_recebido, '%d/%m %H:%i') as data
  FROM leads_recebidos
  ORDER BY data_recebido DESC
  LIMIT 10
")->fetchAll(PDO::FETCH_ASSOC);

// Corretores ativos
$ativos = $pdo->query("SELECT id, nome, ativo FROM corretores ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);

// Funções para o JS
function toJSArray($arr, $campo) {
  return json_encode(array_column($arr, $campo));
}
function toJSValues($arr, $campo) {
  return json_encode(array_map('intval', array_column($arr, $campo)));
}
?>

<!-- Leads por Conjunto -->
<div class="card mb-4 bg-primary text-white">
  <div class="card-header fw-bold">🎯 Leads por Conjunto</div>
  <div class="card-body bg-white text-dark">
    <canvas id="graficoConjuntos"></canvas>
  </div>
</div>

<!-- Leads por Corretor -->
<div class="card mb-4 bg-primary text-white">
  <div class="card-header fw-bold">👥 Leads por Corretor</div>
  <div class="card-body bg-white text-dark">
    <canvas id="graficoCorretores"></canvas>
  </div>
</div>

<!-- Comparativo por Anúncio -->
<div class="card mb-4 bg-primary text-white">
  <div class="card-header fw-bold">📢 Anúncios por Conjunto</div>
  <div class="card-body bg-white text-dark">
    <canvas id="graficoAnuncios"></canvas>
  </div>
</div>

<!-- Últimos Leads -->
<div class="card mb-4 bg-primary text-white">
  <div class="card-header fw-bold">🕓 Últimos Leads Recebidos</div>
  <div class="card-body bg-white text-dark">
    <table class="table table-sm table-bordered table-striped">
      <thead class="table-primary">
        <tr><th>Nome</th><th>Telefone</th><th>Email</th><th>Anúncio</th><th>Data</th></tr>
      </thead>
      <tbody>
        <?php foreach ($ultimos as $l): ?>
          <tr>
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

<!-- Corretores Ativos -->
<div class="card mb-4 bg-primary text-white">
  <div class="card-header fw-bold">🧑‍💼 Corretores Ativos</div>
  <div class="card-body bg-white text-dark">
    <table class="table table-bordered table-sm">
      <thead class="table-primary">
        <tr><th>Nome</th><th>Status</th><th>Ação</th></tr>
      </thead>
      <tbody>
        <?php foreach ($ativos as $c): ?>
          <tr>
            <td><?= htmlspecialchars($c['nome']) ?></td>
            <td><?= $c['ativo'] ? 'Ativo' : 'Inativo' ?></td>
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

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
const conj = document.getElementById("graficoConjuntos");
if (conj) {
  new Chart(conj, {
    type: 'pie',
    data: {
      labels: <?= toJSArray($conjuntos, 'conjunto') ?>,
      datasets: [{
        data: <?= toJSValues($conjuntos, 'total') ?>,
        backgroundColor: ['#007bff', '#3399ff', '#66b3ff', '#5dade2', '#2980b9']
      }]
    }
  });
}

const cor = document.getElementById("graficoCorretores");
if (cor) {
  new Chart(cor, {
    type: 'bar',
    data: {
      labels: <?= toJSArray($corretores, 'corretor') ?>,
      datasets: [{
        label: 'Leads',
        data: <?= toJSValues($corretores, 'total') ?>,
        backgroundColor: '#007bff'
      }]
    },
    options: {
      responsive: true,
      scales: { y: { beginAtZero: true } }
    }
  });
}

const anuncios = <?= json_encode($anuncios) ?>;
const labels = [...new Set(anuncios.map(a => a.conjunto))];
const datasets = [...new Set(anuncios.map(a => a.anuncio_nome))].map(nome => ({
  label: nome,
  data: labels.map(c => {
    const x = anuncios.find(a => a.conjunto === c && a.anuncio_nome === nome);
    return x ? x.total : 0;
  }),
  backgroundColor: `#${Math.floor(Math.random()*16777215).toString(16)}`
}));

new Chart(document.getElementById("graficoAnuncios"), {
  type: 'bar',
  data: { labels, datasets },
  options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
});

function toggleCorretor(id, ativo) {
  fetch('ajax/toggle_corretor.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id, ativo })
  }).then(() => location.reload());
}
</script>
