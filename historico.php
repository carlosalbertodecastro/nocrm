<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$inicio = $_GET['inicio'] ?? date('Y-m-01');
$fim = $_GET['fim'] ?? date('Y-m-d');
$corretor_id = $_GET['corretor_id'] ?? '';

$where = "WHERE DATE(il.data_interacao) BETWEEN ? AND ?";
$params = [$inicio, $fim];

if ($corretor_id !== '') {
  $where .= " AND il.corretor_id = ?";
  $params[] = $corretor_id;
}

$stmt = $pdo->prepare("  
  SELECT il.*, c.nome AS corretor_nome, c.foto_perfil, lr.nome_cliente
  FROM interacoes_leads il
  LEFT JOIN leads_recebidos lr ON lr.id = il.lead_id
  LEFT JOIN corretores c ON c.id = il.corretor_id
  $where
  ORDER BY il.data_interacao DESC
");
$stmt->execute($params);
$interacoes = $stmt->fetchAll(PDO::FETCH_ASSOC);

$corretores = $pdo->query("SELECT id, nome, foto_perfil FROM corretores ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container-fluid py-4">
  <h1 class="h3 text-gray-800">Histórico de Interações</h1>
  <div class="row">
    <!-- Corretores -->
    <div class="col-md-3">
      <div class="card shadow-sm mb-4">
        <div class="card-header fw-bold">Corretores</div>
        <div class="list-group list-group-flush">
          <?php foreach ($corretores as $c): ?>
            <a href="?corretor_id=<?= $c['id'] ?>&inicio=<?= $inicio ?>&fim=<?= $fim ?>" class="list-group-item list-group-item-action <?= $corretor_id == $c['id'] ? 'active' : '' ?>">
              <?php if (!empty($c['foto_perfil'])): ?>
                <img src="<?= $c['foto_perfil'] ?>" alt="Foto" class="rounded-circle me-2" width="30" height="30">
              <?php else: ?>
                <i class="fas fa-user-circle me-2 text-secondary"></i>
              <?php endif; ?>
              <?= htmlspecialchars($c['nome']) ?>
            </a>
          <?php endforeach; ?>
        </div>
      </div>
    </div>

    <!-- Histórico -->
    <div class="col-md-9">
      <form method="get" class="row g-2 align-items-end mb-3">
        <input type="hidden" name="corretor_id" value="<?= $corretor_id ?>">
        <div class="col-md-3">
          <label for="inicio" class="form-label small">Início</label>
          <input type="date" name="inicio" id="inicio" class="form-control" value="<?= $inicio ?>">
        </div>
        <div class="col-md-3">
          <label for="fim" class="form-label small">Fim</label>
          <input type="date" name="fim" id="fim" class="form-control" value="<?= $fim ?>">
        </div>
        <div class="col-md-2">
          <button class="btn btn-dark w-100">Filtrar</button>
        </div>
      </form>

      <div class="card shadow-sm">
        <div class="card-header fw-bold">Interações recentes</div>
        <div class="card-body table-responsive">
          <table class="table table-sm table-hover datatables">
            <thead>
              <tr>
                <th>Data</th>
                <th>Lead</th>
                <th>Tipo</th>
                <th>Mensagem</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              <?php foreach ($interacoes as $i): ?>
                <tr>
                  <td><?= date('d/m/Y H:i', strtotime($i['data_interacao'])) ?></td>
                  <td><?= htmlspecialchars($i['nome_cliente']) ?></td>
                  <td>
                    <?php if ($i['opcao_escolhida']): ?>
                      <span class="badge bg-secondary"><?= $i['opcao_escolhida'] ?></span>
                    <?php endif; ?>
                  </td>
                  <td><?= htmlspecialchars($i['texto_exibido']) ?></td>
                  <td>
                    <a href="historico_lead.php?lead_id=<?= $i['lead_id'] ?>" class="btn btn-outline-primary btn-sm">
                      <i class="fas fa-comments"></i> Ver histórico
                    </a>
                  </td>
                </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
