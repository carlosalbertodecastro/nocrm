<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$leads = $pdo->query("SELECT lr.*, co.nome AS corretor_nome 
    FROM leads_recebidos lr 
    LEFT JOIN corretores co ON co.id = lr.corretor_id 
    WHERE lr.enviado_whatsapp = 0 
    ORDER BY lr.data_recebido DESC
")->fetchAll();
?>

<div class="container mt-4">
  <h2 class="mb-4">📨 Leads Pendentes de Envio via WhatsApp</h2>

  <?php if (count($leads) === 0): ?>
    <div class="alert alert-success">Todos os leads já foram enviados pelo WhatsApp. 👏</div>
  <?php else: ?>
    <div class="table-responsive">
      <table class="table table-bordered table-hover align-middle">
        <thead class="table-primary text-center">
          <tr>
            <th>Data</th>
            <th>Corretor</th>
            <th>Nome</th>
            <th>Telefone</th>
            <th>Anúncio</th>
            <th>Conjunto</th>
            <th>Ação</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($leads as $lead): ?>
            <tr>
              <td><?= date('d/m/Y H:i', strtotime($lead['data_recebido'])) ?></td>
              <td><?= htmlspecialchars($lead['corretor_nome'] ?? '---') ?></td>
              <td><?= htmlspecialchars($lead['nome_cliente']) ?></td>
              <td><?= htmlspecialchars($lead['telefone_cliente']) ?></td>
              <td><?= htmlspecialchars($lead['anuncio_nome']) ?></td>
              <td><?= htmlspecialchars($lead['adset_nome']) ?></td>
              <td class="text-center">
                <button class="btn btn-outline-success btn-sm enviar-lead" 
                  data-id="<?= $lead['id'] ?>" 
                  title="Enviar via WhatsApp">
                  <i class="fa fa-paper-plane"></i>
                </button>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  <?php endif; ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.enviar-lead').forEach(btn => {
    btn.addEventListener('click', () => {
      const id = btn.dataset.id;

      fetch('ajax/enviar_lead_manual.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'sucesso') {
          alert('✅ Lead enviado com sucesso!');
          location.reload();
        } else {
          alert('❌ Erro ao enviar: ' + data.mensagem);
        }
      })
      .catch(err => {
        alert('Erro na requisição: ' + err);
      });
    });
  });
});
</script>

<?php include 'includes/footer.php'; ?>
