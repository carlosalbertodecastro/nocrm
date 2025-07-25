<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

// Buscar interações
$interacoes = $pdo->query("
    SELECT il.*, c.nome AS corretor_nome
    FROM interacoes_leads il
    LEFT JOIN corretores c ON c.id = il.corretor_id
    ORDER BY il.data_interacao DESC
    LIMIT 100
")->fetchAll();
?>

<div class="container py-4">
  <h2 class="mb-4">📨 Interações Recebidas via WhatsApp</h2>

  <div class="table-responsive">
    <table class="table table-bordered table-hover table-sm datatable">
      <thead class="table-dark">
        <tr>
          <th>Data</th>
          <th>Corretor</th>
          <th>Telefone</th>
          <th>Tipo Contato</th>
          <th>Mensagem</th>
          <th>Mensagem ID</th>
          <th>Resposta ID</th>
          <th>Lead ID</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($interacoes as $i): ?>
          <tr>
            <td><?= date('d/m/Y H:i', strtotime($i['data_interacao'])) ?></td>
            <td><?= $i['corretor_nome'] ?? '-' ?></td>
            <td><?= htmlspecialchars($i['telefone'] ?? '-') ?></td>
            <td><?= ucfirst(str_replace('-', ' ', $i['tipo_contato'] ?? '-')) ?></td>
            <td><?= htmlspecialchars($i['texto_exibido'] ?? '-') ?></td>
            <td><small><?= htmlspecialchars($i['mensagem_id'] ?? '-') ?></small></td>
            <td><small><?= htmlspecialchars($i['resposta_id'] ?? '-') ?></small></td>
            <td><small><?= htmlspecialchars($i['lead_id'] ?? '-') ?></small></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>

<!-- Scripts do DataTables -->
<script src="assets/js/datatables.js"></script>

<?php include 'includes/footer.php'; ?>