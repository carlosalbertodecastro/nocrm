<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

// Buscar leads ainda não enviados
$pendentes = $pdo->query("
  SELECT lr.id, lr.nome_cliente, lr.telefone_cliente, lr.anuncio_nome, lr.data_recebido
  FROM leads_recebidos lr
  WHERE lr.whatsapp_enviado = 0 OR lr.whatsapp_enviado IS NULL
  ORDER BY lr.data_recebido DESC
")->fetchAll(PDO::FETCH_ASSOC);

// Corretores ativos
$corretores = $pdo->query("SELECT id, nome FROM corretores WHERE ativo = 1 ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
  <h1 class="h3 text-gray-800">Leads Pendentes<br><small>Selecione o corretor e envie para o WhatsApp</small></h1>

  <?php if (count($pendentes) === 0): ?>
    <div class="alert alert-success">🎉 Nenhum lead pendente!</div>
  <?php else: ?>
    <div class="table-responsive">
      <table class="table table-bordered table-hover align-middle datatables">
        <thead>
          <tr>
            <th>Data</th>
            <th>Cliente</th>
            <th>Telefone</th>
            <th>Anúncio</th>
            <th>Corretor</th>
            <th>Ação</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($pendentes as $lead): ?>
            <tr data-lead-id="<?= $lead['id'] ?>">
              <td><?= date('d/m H:i', strtotime($lead['data_recebido'])) ?></td>
              <td><?= htmlspecialchars($lead['nome_cliente']) ?></td>
              <td><?= htmlspecialchars($lead['telefone_cliente']) ?></td>
              <td><?= htmlspecialchars($lead['anuncio_nome']) ?></td>
              <td>
                <select class="form-select form-select-sm corretor-select" data-lead-id="<?= $lead['id'] ?>">
                  <option value="">Selecionar</option>
                  <?php foreach ($corretores as $c): ?>
                    <option value="<?= $c['id'] ?>"><?= htmlspecialchars($c['nome']) ?></option>
                  <?php endforeach; ?>
                </select>
              </td>
              <td>
                <button class="btn btn-sm btn-outline-success enviar-lead" data-lead-id="<?= $lead['id'] ?>" title="Enviar Lead">
                  <i class="fab fa-whatsapp"></i>
                </button>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  <?php endif; ?>
</div>

<!-- Toastr -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
document.querySelectorAll('.enviar-lead').forEach(botao => {
  botao.addEventListener('click', () => {
    const leadId = botao.dataset.leadId;
    const select = document.querySelector(`.corretor-select[data-lead-id='${leadId}']`);
    const corretorId = select.value;

    if (!corretorId) {
      toastr.warning('Selecione um corretor para enviar o lead.');
      return;
    }

    fetch('ajax/zapi_envio_manual.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ lead_id: leadId, corretor_id: corretorId })
    })
    .then(res => res.json())
    .then(res => {
      if (res.sucesso) {
        toastr.success(res.mensagem || '✅ Lead enviado com sucesso!');

        // Remove a linha da tabela
        const linha = botao.closest('tr');
        linha.remove();

        // Se a tabela ficar vazia, exibe a mensagem "Nenhum lead pendente"
        const linhasRestantes = document.querySelectorAll('tbody tr');
        if (linhasRestantes.length === 0) {
          const tabela = document.querySelector('table');
          tabela.remove();

          const alerta = document.createElement('div');
          alerta.className = 'alert alert-success mt-4';
          alerta.innerHTML = '🎉 Nenhum lead pendente!';
          document.querySelector('.container').appendChild(alerta);
        }

      } else {
        toastr.error(res.erro || '❌ Erro ao enviar lead');
        console.error('Erro:', res);
      }
    })
    .catch(err => {
      toastr.error('❌ Erro na requisição');
      console.error(err);
    });
  });
});
</script>

<?php include 'includes/footer.php'; ?>
