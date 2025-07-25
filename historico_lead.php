<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$lead_id = $_GET['lead_id'] ?? null;
if (!$lead_id) {
  echo "<div class='alert alert-danger'>ID do lead não informado.</div>";
  exit;
}

// Buscar dados principais do lead
$stmt = $pdo->prepare("
  SELECT lr.*, c.nome AS corretor_nome, c.foto_perfil, c.id AS corretor_id, ca.nome AS conjunto_nome
  FROM leads_recebidos lr
  LEFT JOIN corretores c ON c.id = lr.corretor_id
  LEFT JOIN conjuntos_anuncio ca ON ca.id = lr.conjunto_id
  WHERE lr.id = ?
");
$stmt->execute([$lead_id]);
$lead = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$lead) {
  echo "<div class='alert alert-warning'>Lead não encontrado.</div>";
  exit;
}

// Buscar histórico de interações
$interacoes = $pdo->prepare("
  SELECT * FROM interacoes_leads 
  WHERE lead_id = ? 
  ORDER BY data_interacao ASC
");
$interacoes->execute([$lead_id]);
$interacoes = $interacoes->fetchAll(PDO::FETCH_ASSOC);

// Calcular tempo desde última interação
$ultima = end($interacoes);
$ultima_data = $ultima['data_interacao'] ?? $lead['data_recebido'];
$agora = new DateTime();
$ultima_dt = new DateTime($ultima_data);
$intervalo = $agora->diff($ultima_dt);
$tempo_ultimo = $intervalo->days ? "{$intervalo->days}d {$intervalo->h}h {$intervalo->i}min atrás" : "{$intervalo->h}h {$intervalo->i}min atrás";
?>

<div class="container-fluid py-4">
  <h1 class="h3 text-gray-800">Histórico do Lead</h1>

  <!-- Blocos -->
  <div class="row mb-4">
    <!-- Lead -->
    <div class="col-md-4">
      <div class="card shadow-sm p-3">
        <h6 class="text-muted mb-1">Lead</h6>
        <div><strong><?= htmlspecialchars($lead['nome_cliente']) ?></strong></div>
        <div class="text-muted small"><?= $lead['telefone_cliente'] ?></div>
        <div class="text-muted small"><?= $lead['email_cliente'] ?></div>
        <div class="text-muted small mt-2">📅 Cadastrado: <?= date('d/m/Y H:i', strtotime($lead['data_recebido'])) ?></div>
        <div class="text-muted small">⏱ Última interação: <?= $tempo_ultimo ?></div>
      </div>
    </div>

    <!-- Corretor -->
    <div class="col-md-4">
      <div class="card shadow-sm p-3">
        
        <div class="d-flex align-items-center">
          <img src="<?= $lead['foto_perfil'] ?? 'https://via.placeholder.com/40' ?>" class="rounded-circle me-2" width="40" height="40">
          <strong><?= htmlspecialchars($lead['corretor_nome']) ?></strong>
          
        </div>
        <div class="text-muted small mt-2">Tempo médio de resposta: —</div>
        <div class="text-muted small">Participa de: —</div>
        <div class="text-muted small">Leads: Enviados: — | Sem resposta: — | Em atendimento: — | Desqualificados: —</div>
      </div>
    </div>

    <!-- Anúncio -->
    <div class="col-md-4">
      <div class="card shadow-sm p-3 text-center">
        <h6 class="text-muted mb-2">Anúncio</h6>
        <div class="mb-2 text-muted small"><?= htmlspecialchars($lead['conjunto_nome'] ?? '—') ?></div>
        <div style="width: 100%; height: 120px; background-color: #f1f1f1; border: 1px dashed #ccc;">
          <span class="text-muted">📸 Imagem do anúncio (futuramente)</span>
        </div>
      </div>
    </div>
  </div>

  <!-- Histórico de conversas -->
  <div class="card shadow-sm">
    <div class="card-header fw-bold">🗂️ Histórico de Conversas</div>
    <div class="card-body" style="max-height: 500px; overflow-y: auto;">
      <?php if (empty($interacoes)): ?>
        <div class="text-muted">Nenhuma interação registrada ainda.</div>
      <?php else: ?>
        <?php foreach ($interacoes as $i): ?>
          <div class="mb-3">
            <div class="small text-muted">
              <?= date('d/m/Y H:i', strtotime($i['data_interacao'])) ?> 
              • <?= ucfirst($i['tipo_contato']) ?> 
              • <?= $i['opcao_escolhida'] ?>
            </div>
            <div class="bg-light border rounded p-2">
              <?= nl2br(htmlspecialchars($i['texto_exibido'])) ?>
            </div>
          </div>
        <?php endforeach; ?>
      <?php endif; ?>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
