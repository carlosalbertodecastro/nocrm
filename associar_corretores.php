<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$conjuntos = $pdo->query("SELECT id, nome FROM conjuntos_anuncio ORDER BY nome")->fetchAll();
$corretores = $pdo->query("SELECT id, nome FROM corretores WHERE ativo = 1 ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
$fila = $pdo->query("
  SELECT conjunto_id, corretor_id, ordem_fila
  FROM elegibilidade_corretores
  WHERE ativo = 1
")->fetchAll(PDO::FETCH_GROUP | PDO::FETCH_ASSOC);
?>

<div class="container-fluid py-4">
  <h3 class="mb-4">🔁 Associação de Corretores aos Conjuntos</h3>
  <div class="row">
    <!-- Corretores disponíveis (Desktop) -->
    <div class="col-md-3 d-none d-md-block">
      <h5 class="mb-3">👥 Corretores Disponíveis</h5>
      <ul id="corretores" class="list-group position-sticky top-0 z-1 bg-white">
        <?php foreach ($corretores as $c): ?>
          <li class="list-group-item draggable" draggable="true" data-id="<?= $c['id'] ?>">
            <?= htmlspecialchars($c['nome']) ?>
          </li>
        <?php endforeach; ?>
      </ul>
    </div>

    <!-- Conjuntos -->
    <div class="col-md-9">
      <div class="row">
        <?php foreach ($conjuntos as $cj): ?>
          <div class="col-12 col-md-6 mb-4">
            <div class="card shadow-sm border">
              <div class="card-header bg-dark text-white fw-bold"><?= htmlspecialchars($cj['nome']) ?></div>

              <!-- Select para mobile -->
              <div class="d-block d-md-none p-2">
                <select class="form-select select-corretor" data-conjunto="<?= $cj['id'] ?>">
                  <option value="">Adicionar corretor...</option>
                  <?php foreach ($corretores as $c): ?>
                    <option value="<?= $c['id'] ?>"><?= htmlspecialchars($c['nome']) ?></option>
                  <?php endforeach; ?>
                </select>
              </div>

              <!-- Área de corretores associados -->
              <ul class="list-group list-group-flush dropzone px-2" data-conjunto="<?= $cj['id'] ?>" style="min-height: 120px;">
                <?php if (!empty($fila[$cj['id']])): ?>
                  <?php usort($fila[$cj['id']], fn($a, $b) => $a['ordem_fila'] <=> $b['ordem_fila']); ?>
                  <?php foreach ($fila[$cj['id']] as $i => $item):
                      $corretorNome = $corretores[array_search($item['corretor_id'], array_column($corretores, 'id'))]['nome'] ?? 'Desconhecido';
                  ?>
                    <li class="list-group-item d-flex justify-content-between align-items-center dropitem" data-id="<?= $item['corretor_id'] ?>">
                      <span><strong><?= $item['ordem_fila'] ?>.</strong> <?= htmlspecialchars($corretorNome) ?></span>
                      <div>
                        <button class="btn btn-sm btn-light me-1 btn-subir" title="Subir"><i class="fas fa-arrow-up"></i></button>
                        <button class="btn btn-sm btn-light me-1 btn-descer" title="Descer"><i class="fas fa-arrow-down"></i></button>
                        <button class="btn btn-sm btn-outline-danger btn-remover" title="Remover"><i class="fas fa-times"></i></button>
                      </div>
                    </li>
                  <?php endforeach; ?>
                <?php endif; ?>
              </ul>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script>
document.querySelectorAll('.draggable').forEach(item => {
  item.addEventListener('dragstart', ev => {
    ev.dataTransfer.setData('corretor_id', ev.target.dataset.id);
  });
});

document.querySelectorAll('.dropzone').forEach(zone => {
  zone.addEventListener('dragover', e => e.preventDefault());
  zone.addEventListener('drop', e => {
    e.preventDefault();
    const corretor_id = e.dataTransfer.getData('corretor_id');
    const conjunto_id = zone.dataset.conjunto;

    if ([...zone.children].some(li => li.dataset.id === corretor_id)) {
      toastr.warning("Corretor já está na fila!");
      return;
    }

    const posicao = zone.children.length + 1;
    const nome = document.querySelector(`.draggable[data-id='${corretor_id}']`).innerText;

    const li = criarCorretorNaFila(corretor_id, nome, posicao);
    zone.appendChild(li);
    salvar('adicionar', conjunto_id, corretor_id, posicao);
  });
});

document.querySelectorAll('.select-corretor').forEach(select => {
  select.addEventListener('change', () => {
    const corretor_id = select.value;
    const conjunto_id = select.dataset.conjunto;
    if (!corretor_id) return;

    const zona = select.closest('.card').querySelector('.dropzone');

    if ([...zona.children].some(li => li.dataset.id === corretor_id)) {
      toastr.warning("Corretor já está na fila!");
      return;
    }

    const nome = select.options[select.selectedIndex].text;
    const posicao = zona.children.length + 1;

    const li = criarCorretorNaFila(corretor_id, nome, posicao);
    zona.appendChild(li);
    salvar('adicionar', conjunto_id, corretor_id, posicao);
    select.value = "";
  });
});

function criarCorretorNaFila(id, nome, posicao) {
  const li = document.createElement('li');
  li.className = 'list-group-item d-flex justify-content-between align-items-center dropitem';
  li.dataset.id = id;
  li.innerHTML = `
    <span><strong>${posicao}.</strong> ${nome}</span>
    <div>
      <button class="btn btn-sm btn-light me-1 btn-subir" title="Subir"><i class="fas fa-arrow-up"></i></button>
      <button class="btn btn-sm btn-light me-1 btn-descer" title="Descer"><i class="fas fa-arrow-down"></i></button>
      <button class="btn btn-sm btn-outline-danger btn-remover" title="Remover"><i class="fas fa-times"></i></button>
    </div>
  `;
  return li;
}

document.addEventListener('click', e => {
  if (e.target.closest('.btn-remover')) {
    const li = e.target.closest('li');
    const conjunto_id = li.closest('.dropzone').dataset.conjunto;
    const corretor_id = li.dataset.id;
    li.remove();
    salvar('remover', conjunto_id, corretor_id);
    renumerar(li.closest('.dropzone'));
  }

  if (e.target.closest('.btn-subir') || e.target.closest('.btn-descer')) {
    const li = e.target.closest('li');
    const ul = li.closest('.dropzone');
    const anterior = li.previousElementSibling;
    const proximo = li.nextElementSibling;

    if (e.target.closest('.btn-subir') && anterior) {
      ul.insertBefore(li, anterior);
    } else if (e.target.closest('.btn-descer') && proximo) {
      ul.insertBefore(proximo, li);
    }

    renumerar(ul);
  }
});

function renumerar(lista) {
  [...lista.children].forEach((li, i) => {
    const conjunto = lista.dataset.conjunto;
    const corretor = li.dataset.id;
    const nome = li.querySelector('span').textContent.replace(/^\d+\.\s*/, '');
    li.querySelector('span').innerHTML = `<strong>${i + 1}.</strong> ${nome}`;
    salvar('atualizar', conjunto, corretor, i + 1);
  });
}

function salvar(acao, conjunto_id, corretor_id, ordem = 1) {
  fetch('ajax/salvar_fila.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ acao, conjunto_id, corretor_id, ordem })
  })
  .then(res => res.json())
  .then(res => {
    if (res.sucesso) {
      toastr.success(res.mensagem);
    } else {
      toastr.error('Erro: ' + res.mensagem);
    }
  })
  .catch(err => {
    console.error('❌ Erro ao salvar:', err);
    toastr.error('Erro na requisição');
  });
}
</script>

<?php include 'includes/footer.php'; ?>