<?php
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/config/niveis.php';
verificar_acesso(NIVEL_SOCIO); // Apenas sócios podem alterar a hierarquia
?>

<h1 class="h3 text-gray-800">Hierarquia de Cargos</h1>

<div class="row" id="niveisContainer">
  <?php
  // Busca os níveis
  $niveis = $pdo->query("SELECT * FROM niveis_acesso ORDER BY valor ASC")->fetchAll(PDO::FETCH_ASSOC);
  $cargos = $pdo->query("SELECT * FROM cargos WHERE empresa_id = {$empresa_visualizada_id}")->fetchAll(PDO::FETCH_ASSOC);
  $cargosPorNivel = [];

  foreach ($niveis as $nivel) {
    $cargosPorNivel[$nivel['id']] = array_filter($cargos, fn($c) => $c['nivel_acesso_id'] == $nivel['id']);
  }

  foreach ($niveis as $nivel):
  ?>
    <div class="col-md-3 mb-4">
      <div class="card shadow border-left-primary">
        <div class="card-header bg-primary text-white text-center fw-bold">
          <?= htmlspecialchars($nivel['nome']) ?>
        </div>
        <div class="card-body p-2">
          <ul class="list-group cargo-list" data-nivel-id="<?= $nivel['id'] ?>">
            <?php foreach ($cargosPorNivel[$nivel['id']] as $cargo): ?>
              <li class="list-group-item d-flex justify-content-between align-items-center" data-cargo-id="<?= $cargo['id'] ?>">
                <?= htmlspecialchars($cargo['nome']) ?>
                <i class="fas fa-arrows-alt fa-sm text-secondary"></i>
              </li>
            <?php endforeach; ?>
          </ul>
        </div>
      </div>
    </div>
  <?php endforeach; ?>
</div>

<!-- Toastr -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<!-- SortableJS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.15.0/Sortable.min.js"></script>

<script>
document.querySelectorAll('.cargo-list').forEach(list => {
  new Sortable(list, {
    group: 'cargos',
    animation: 150,
    onAdd: function (evt) {
      const cargoId = evt.item.getAttribute('data-cargo-id');
      const novoNivelId = evt.to.getAttribute('data-nivel-id');

      fetch('ajax/cargos_niveis.php', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ cargo_id: cargoId, novo_nivel_id: novoNivelId })
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'sucesso') {
          toastr.success('Cargo atualizado com sucesso!');
        } else {
          toastr.error('Erro ao atualizar cargo');
        }
      })
      .catch(err => toastr.error('Erro na requisição'));
    }
  });
});
</script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
