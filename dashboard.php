<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
require_once 'config/niveis.php';
include 'includes/header.php';

$empresa_id = $_SESSION['empresa_visualizada_id'];
$nivel_acesso = $_SESSION['nivel_acesso'] ?? 0;
$usuario_id = $_SESSION['usuario_id'];
$hoje = date('Y-m-d');
$inicio = $_GET['inicio'] ?? date('Y-m-d', strtotime('-30 days'));
$fim    = $_GET['fim'] ?? $hoje;

// Mapeia status_lead
$status_map = [];
$status_ids = [];

$status_rows = $pdo->query("SELECT id, LOWER(REPLACE(nome, ' ', '-')) AS slug, nome FROM status_lead")->fetchAll(PDO::FETCH_ASSOC);
foreach ($status_rows as $row) {
    $slug = $row['slug'];

    switch ($slug) {
        case 'pendente':
            $classe = 'warning';
            $descricao = 'Leads que não foram distribuídos';
            $icone = 'fa-clock';
            break;
        case 'entregue':
            $classe = 'success';
            $descricao = 'Leads enviados aos corretores por WhatsApp';
            $icone = 'fa-check-circle';
            break;
        case 'contatado':
            $classe = 'info';
            $descricao = 'Leads com resposta de contato';
            $icone = 'fa-headset';
            break;
        case 'desqualificado':
            $classe = 'danger';
            $descricao = 'Leads desqualificados';
            $icone = 'fa-times-circle';
            break;
        default:
            $classe = 'secondary';
            $descricao = 'Leads com outro status';
            $icone = 'fa-question-circle';
            break;
    }

    $status_map[$slug] = [
        'id' => $row['id'],
        'label' => ucwords(str_replace('-', ' ', $slug)),
        'classe' => $classe,
        'descricao' => $descricao,
        'icone' => $icone,
        'slug' => $slug
    ];
    $status_ids[$slug] = $row['id'];
}

$contagem = array_fill_keys(array_keys($status_map), 0);

$query = $pdo->prepare("SELECT status, COUNT(*) as total FROM leads_recebidos WHERE empresa_id = ? AND DATE(data_recebido) BETWEEN ? AND ? GROUP BY status");
$query->execute([$empresa_id, $inicio, $fim]);
$rows = $query->fetchAll(PDO::FETCH_KEY_PAIR);

$total_entregue = 0;
foreach ($rows as $status_id => $total) {
    $slug_encontrado = array_search($status_id, $status_ids);
    if ($slug_encontrado !== false) {
        $contagem[$slug_encontrado] = $total;
    }
    if ($status_id == ($status_ids['entregue'] ?? null)) {
        $total_entregue = $total;
    }
}

$total_respondidos = 0;
foreach (['contatado', 'desqualificado'] as $slug) {
    $total_respondidos += $contagem[$slug] ?? 0;
}
$contagem['sem-resposta'] = max($total_entregue - $total_respondidos, 0);
$status_map['sem-resposta'] = [
    'id' => '',
    'label' => 'Sem Resposta',
    'classe' => 'secondary',
    'descricao' => 'Leads entregues sem retorno ou atualização',
    'icone' => 'fa-question-circle',
    'slug' => 'sem-resposta'
];

if (isset($status_map['pendente'])) {
    $pendente = $status_map['pendente'];
    $count_pendente = $contagem['pendente'] ?? 0;
    unset($status_map['pendente'], $contagem['pendente']);
    $status_map['pendente'] = $pendente;
    $contagem['pendente'] = $count_pendente;
}

$corretores = $pdo->prepare("SELECT id, nome, ativo, foto_perfil FROM corretores WHERE empresa_id = ? ORDER BY nome");
$corretores->execute([$empresa_id]);
$corretores = $corretores->fetchAll(PDO::FETCH_ASSOC);

$conjuntoChart = $pdo->prepare("SELECT ca.nome AS conjunto, COUNT(*) as total FROM leads_recebidos lr JOIN conjuntos_anuncio ca ON ca.id = lr.conjunto_id WHERE lr.empresa_id = ? AND DATE(lr.data_recebido) BETWEEN ? AND ? GROUP BY ca.nome");
$conjuntoChart->execute([$empresa_id, $inicio, $fim]);
$conjuntoChart = $conjuntoChart->fetchAll(PDO::FETCH_ASSOC);

$corretorChart = $pdo->prepare("SELECT c.nome AS corretor, COUNT(*) as total FROM leads_recebidos lr JOIN corretores c ON c.id = lr.corretor_id WHERE lr.empresa_id = ? AND DATE(lr.data_recebido) BETWEEN ? AND ? GROUP BY c.nome");
$corretorChart->execute([$empresa_id, $inicio, $fim]);
$corretorChart = $corretorChart->fetchAll(PDO::FETCH_ASSOC);

$ultimos = $pdo->prepare("SELECT lr.*, c.nome AS corretor_nome FROM leads_recebidos lr LEFT JOIN corretores c ON lr.corretor_id = c.id WHERE lr.empresa_id = ? ORDER BY lr.data_recebido DESC LIMIT 10");
$ultimos->execute([$empresa_id]);
$ultimos = $ultimos->fetchAll(PDO::FETCH_ASSOC);

$indicadores = $pdo->prepare("SELECT c.id, c.nome, c.foto_perfil,
  COUNT(lr.id) as total,
  SUM(CASE WHEN lr.resposta_contato IN ('whatsapp','telefone') THEN 1 ELSE 0 END) as em_atendimento,
  SUM(CASE WHEN lr.resposta_contato = 'nao-contatado' THEN 1 ELSE 0 END) as sem_resposta,
  SUM(CASE WHEN lr.status = {$status_ids['pendente']} THEN 1 ELSE 0 END) as pendente,
  SUM(CASE WHEN lr.resposta_contato = 'desqualificado' THEN 1 ELSE 0 END) as desqualificado,
  c.ativo
FROM corretores c
LEFT JOIN leads_recebidos lr ON c.id = lr.corretor_id AND DATE(lr.data_recebido) BETWEEN ? AND ? AND lr.empresa_id = ?
WHERE c.empresa_id = ?
GROUP BY c.id, c.nome, c.foto_perfil, c.ativo
ORDER BY c.nome");
$indicadores->execute([$inicio, $fim, $empresa_id, $empresa_id]);
$indicadores = $indicadores->fetchAll(PDO::FETCH_ASSOC);
?>

<!-- MANTIDO O HTML ORIGINAL ABAIXO -->
<div class="container-fluid py-4">
  <h1 class="h3 text-gray-800">Dashboard</h1>

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
    <?php foreach ($status_map as $slug => $info): ?>
      <div class="col-xl-3 col-md-3 col-12 mb-3">
        <div class="card border-left-<?= $info['classe'] ?> shadow h-100 py-2">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-<?= $info['classe'] ?> text-uppercase mb-1"><?= $info['label'] ?></div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">
                  <a href="leads.php?status=<?= $info['id'] ?>&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-<?= $info['classe'] ?>">
                    <?= $contagem[$slug] ?? 0 ?>
                  </a>
                </div>
                <div class="small text-muted"><?= $info['descricao'] ?></div>
              </div>
              <div class="col-auto">
                <i class="fas <?= $info['icone'] ?> fa-2x text-gray-300"></i>
              </div>
            </div>
          </div>
        </div>
      </div>
    <?php endforeach; ?>
  </div>

    <!-- Controle de Corretores -->
<?php
// ... [todo o código anterior permanece inalterado]

// Atualiza a consulta de indicadores para respeitar intervalo de datas
$indicadores = $pdo->query("SELECT c.id, c.nome, c.foto_perfil,
  COUNT(lr.id) as total,
  SUM(CASE WHEN lr.resposta_contato IN ('whatsapp','telefone') THEN 1 ELSE 0 END) as em_atendimento,
  SUM(CASE WHEN lr.resposta_contato = 'nao-contatado' THEN 1 ELSE 0 END) as sem_resposta,
  SUM(CASE WHEN lr.status = {$status_ids['pendente']} THEN 1 ELSE 0 END) as pendente,
  SUM(CASE WHEN lr.resposta_contato = 'desqualificado' THEN 1 ELSE 0 END) as desqualificado,
  c.ativo
FROM corretores c
LEFT JOIN leads_recebidos lr ON c.id = lr.corretor_id AND DATE(lr.data_recebido) BETWEEN '{$inicio}' AND '{$fim}'
where lr.empresa_id = '{$empresa_id}'
GROUP BY c.id, c.nome, c.foto_perfil, c.ativo
ORDER BY c.nome")->fetchAll(PDO::FETCH_ASSOC);
?>

    <!-- Painel de Indicadores por Corretor -->
    <div class="card mb-5">
      <div class="card-header fw-bold">Performance dos Corretores</div>
      <div class="card-body">
        <div class="row">
          <?php foreach ($indicadores as $i): ?>
            <div class="col-md-4 mb-4">
              <div class="card shadow-sm h-100 p-3">
                <div class="d-flex justify-content-between align-items-center">
    
                  <!-- Coluna 1: Foto e Nome -->
                  <div class="text-center" style="width: 30%;">
                    <img src="<?= $i['foto_perfil'] ?? 'img/user.png' ?>" class="rounded-circle mb-2" alt="Foto" width="60" height="60">
                    <h6 class="fw-bold mb-0 text-dark"><?= htmlspecialchars($i['nome']) ?></h6>
                  </div>
    
                  <!-- Coluna 2: Indicadores -->
                  <div style="width: 50%;">
                    <div class="small text-dark">
                      <i class="fas fa-users me-1 text-primary"></i>
                      <a href="leads.php?corretor_id=<?= $i['id'] ?>&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-dark">
                        Total: <?= $i['total'] ?>
                      </a><br>
    
                      <i class="fas fa-comments me-1 text-info"></i>
                      <a href="leads.php?corretor_id=<?= $i['id'] ?>&resposta_contato=whatsapp&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-dark">
                        Em Atendimento: <?= $i['em_atendimento'] ?>
                      </a><br>
    
                      <i class="fas fa-question-circle me-1 text-secondary"></i>
                      <a href="leads.php?corretor_id=<?= $i['id'] ?>&resposta_contato=nao-contatado&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-dark">
                        Sem Resposta: <?= $i['sem_resposta'] ?>
                      </a><br>
    
                      <i class="fas fa-clock me-1 text-warning"></i>
                      <a href="leads.php?corretor_id=<?= $i['id'] ?>&status=<?= $status_ids['pendente'] ?>&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-dark">
                        Pendente: <?= $i['pendente'] ?>
                      </a><br>
    
                      <i class="fas fa-times-circle me-1 text-danger"></i>
                      <a href="leads.php?corretor_id=<?= $i['id'] ?>&resposta_contato=desqualificado&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="text-decoration-none text-dark">
                        Desqualificado: <?= $i['desqualificado'] ?>
                      </a>
                    </div>
                  </div>
    
                  <!-- Coluna 3: Ativação -->
                  <div class="text-end" style="width: 20%;">
                    <div class="form-check form-switch">
                      <input class="form-check-input toggle-corretor" type="checkbox" <?= $i['ativo'] ? 'checked' : '' ?> data-id="<?= $i['id'] ?>">
                    </div>
                  </div>
    
                </div>
              </div>
            </div>
          <?php endforeach; ?>
        </div>
      </div>
    </div>
    
    
    <!-- Gráficos -->
    <div class="row mb-4">
      <div class="col-md-6 col-12">
        <div class="mb-5">
          <div class="card-header fw-bold">Leads por Conjunto</div>
        </div>
        <canvas id="graficoConjuntos" height="300"></canvas>
      </div>
      <div class="col-md-6 col-12">
        <div class="mb-5">
          <div class="card-header fw-bold">Leads por Corretor</div>
        </div>
        <canvas id="graficoCorretores" height="300"></canvas>
      </div>
    </div>
    
    <!-- Últimos Leads -->
    <div class="card mb-5">
      <div class="card-header fw-bold">Últimos Leads Recebidos</div>
      <div class="card-body table-responsive">
        <table class="table table-bordered table-sm nowrap datatables" id="tabelaLeads">
          <thead>
            <tr>
              <th>Data</th>
              <th>Corretor</th>
              <th>Cliente</th>
              <th>Telefone</th>
              <th>Anúncio</th>
              <th>Contato</th>
              <th>Resposta</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($ultimos as $l): ?>
              <tr>
                <td><?= date('d/m H:i', strtotime($l['data_recebido'])) ?></td>
                <td><?= $l['corretor_nome'] ?? '-' ?></td>
                <td><?= htmlspecialchars($l['nome_cliente'] ?? '') ?></td>
                <td><?= htmlspecialchars($l['telefone_cliente'] ?? '') ?></td>
                <td><?= htmlspecialchars($l['anuncio_nome'] ?? '') ?></td>
                <td><?= $l['resposta_contato'] ?? '-' ?></td>
                <td><?= $l['data_contato'] ? date('d/m H:i', strtotime($l['data_contato'])) : '-' ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- Gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    new Chart(document.getElementById("graficoConjuntos"), {
      type: 'doughnut',
      data: {
        labels: <?= json_encode(array_column($conjuntoChart, 'conjunto')) ?>,
        datasets: [{
          data: <?= json_encode(array_column($conjuntoChart, 'total')) ?>,
          backgroundColor: ['#007bff', '#66b3ff', '#17a2b8', '#6c757d', '#ffc107']
        }]
      },
      options: {
        plugins: {
          legend: { position: 'bottom' },
          tooltip: { callbacks: { label: ctx => `${ctx.label}: ${ctx.raw}` } }
        }
      }
    });
    
    new Chart(document.getElementById("graficoCorretores"), {
      type: 'bar',
      data: {
        labels: <?= json_encode(array_column($corretorChart, 'corretor')) ?>,
        datasets: [{
          label: 'Leads',
          data: <?= json_encode(array_column($corretorChart, 'total')) ?>,
          backgroundColor: '#0d6efd'
        }]
      },
      options: {
        indexAxis: 'y',
        plugins: {
          tooltip: {
            callbacks: {
              label: ctx => `${ctx.label}: ${ctx.raw} leads`
            }
          }
        },
        scales: {
          x: { beginAtZero: true }
        }
      }
    });
    
    // AJAX ativar/desativar corretor
    document.querySelectorAll('.toggle-corretor').forEach(input => {
      input.addEventListener('change', () => {
        fetch('ajax/ativar_corretor.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ id: input.dataset.id })
        })
        .then(res => res.json())
        .then(res => {
          toastr[res.sucesso ? 'success' : 'error'](res.mensagem || res.erro || 'Erro');
        })
        .catch(() => toastr.error('Erro na requisição'));
      });
    });
    </script>

<?php include_once ('includes/footer.php'); ?>