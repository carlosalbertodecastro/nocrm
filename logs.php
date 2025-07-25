<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

$dirLogs = __DIR__ . '/logs/';
$arquivos = array_diff(scandir($dirLogs), ['.', '..']);
?>

<div class="container-fluid py-4">
  <h3 class="mb-4">📂 Visualizador de Logs</h3>

  <div class="row">
    <!-- 📁 Lista de arquivos -->
    <div class="col-md-3 mb-4">
      <div class="border rounded p-2 bg-white shadow-sm" style="height: 75vh; overflow-y: auto;">
        <h6 class="fw-bold mb-3">🗂 Arquivos de Log</h6>
        <ul class="list-group small">
          <?php foreach ($arquivos as $arquivo): ?>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <?= htmlspecialchars($arquivo) ?>
              <button class="btn btn-sm btn-outline-primary abrir-log" data-arquivo="<?= urlencode($arquivo) ?>">
                <i class="fa fa-eye"></i>
              </button>
            </li>
          <?php endforeach; ?>
        </ul>
      </div>
    </div>

    <!-- 📝 Exibição de conteúdo -->
    <div class="col-md-9">
      <div class="d-flex justify-content-between align-items-center mb-2">
        <h6 class="mb-0 fw-bold">📄 Conteúdo do Log</h6>
        <div>
          <button id="copiarBtn" class="btn btn-outline-secondary btn-sm me-2" disabled>
            <i class="fa fa-copy"></i> Copiar
          </button>
          <button id="alternarModoBtn" class="btn btn-outline-secondary btn-sm" disabled>
            <i class="fa fa-exchange-alt"></i> Alternar Exibição
          </button>
        </div>
      </div>

      <div id="conteudo-log" class="border bg-light rounded p-3 shadow-sm"
           style="height: 75vh; overflow-y: auto; overflow-x: auto; white-space: pre-wrap; font-family: monospace; font-size: 14px;">
        <em class="text-muted">Clique em um log à esquerda para visualizar seu conteúdo aqui.</em>
      </div>
    </div>
  </div>
</div>

<script>
const logContainer = document.getElementById('conteudo-log');
const copiarBtn = document.getElementById('copiarBtn');
const alternarModoBtn = document.getElementById('alternarModoBtn');
let quebraAtivada = true;

document.querySelectorAll('.abrir-log').forEach(btn => {
  btn.addEventListener('click', () => {
    const arquivo = btn.dataset.arquivo;
    fetch(`ajax/abrir_log.php?arquivo=${arquivo}`)
      .then(res => res.ok ? res.text() : Promise.reject('Erro ao carregar log'))
      .then(texto => {
        logContainer.textContent = texto;
        copiarBtn.disabled = false;
        alternarModoBtn.disabled = false;
        logContainer.scrollTop = 0;
        logContainer.scrollLeft = 0;
      })
      .catch(err => {
        logContainer.textContent = '❌ ' + err;
        copiarBtn.disabled = true;
        alternarModoBtn.disabled = true;
      });
  });
});

copiarBtn.addEventListener('click', () => {
  const text = logContainer.textContent;
  navigator.clipboard.writeText(text).then(() => {
    copiarBtn.innerHTML = '✅ Copiado!';
    setTimeout(() => copiarBtn.innerHTML = '<i class="fa fa-copy"></i> Copiar', 2000);
  });
});

alternarModoBtn.addEventListener('click', () => {
  quebraAtivada = !quebraAtivada;
  logContainer.style.whiteSpace = quebraAtivada ? 'pre-wrap' : 'pre';
});
</script>

<?php include 'includes/footer.php'; ?>