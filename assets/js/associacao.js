document.addEventListener('DOMContentLoaded', () => {
  console.log('📦 DOM carregado!');

  // Ativar draggable nos corretores disponíveis
  document.querySelectorAll('.corretor-item').forEach(corretor => {
    corretor.setAttribute('draggable', true);
    corretor.addEventListener('dragstart', e => {
      e.dataTransfer.setData('corretor_id', corretor.dataset.id);
      e.dataTransfer.setData('corretor_nome', corretor.innerText.trim());
    });
  });

  // Tornar cada card dropzone
  document.querySelectorAll('.conjunto-card').forEach(card => {
    const conjuntoId = card.dataset.conjuntoId;
    const dropzone = card.querySelector('.dropzone-area');

    card.addEventListener('dragover', e => {
      e.preventDefault();
      card.classList.add('hover');
    });

    card.addEventListener('dragleave', () => {
      card.classList.remove('hover');
    });

    card.addEventListener('drop', e => {
      e.preventDefault();
      card.classList.remove('hover');

      const corretorId = e.dataTransfer.getData('corretor_id');
      const nome = e.dataTransfer.getData('corretor_nome');

      if (dropzone.querySelector(`[data-id="${corretorId}"]`)) return;

      const badge = criarBadge(corretorId, nome, conjuntoId);
      dropzone.appendChild(badge);

      fetch('/gestao-de-leads/ajax/associar.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ corretor_id: corretorId, conjunto_id: conjuntoId })
      })
        .then(() => showToast(`✅ ${nome} associado`, 'success'))
        .catch(() => showToast(`❌ Erro ao associar ${nome}`, 'danger'));
    });
  });

  function criarBadge(corretorId, nome, conjuntoId) {
    const div = document.createElement('div');
    div.className = 'corretor-item btn btn-outline-primary btn-sm d-inline-flex align-items-center m-1';
    div.dataset.id = corretorId;
    div.innerHTML = `
      <span class="me-2">⠿ ${nome}</span>
      <i class="fa fa-trash remove-corretor text-danger" style="cursor:pointer;"></i>
    `;

    div.querySelector('.remove-corretor').addEventListener('click', () => {
      div.remove();

      fetch('/gestao-de-leads/ajax/associar.php', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ corretor_id: corretorId, conjunto_id: conjuntoId })
      })
        .then(() => showToast(`🗑️ ${nome} removido`, 'warning'))
        .catch(() => showToast(`❌ Erro ao remover ${nome}`, 'danger'));
    });

    return div;
  }

  function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0 show position-fixed bottom-0 end-0 m-3`;
    toast.innerHTML = `
      <div class="d-flex">
        <div class="toast-body">${message}</div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
      </div>
    `;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 4000);
  }

  // Ativa lixeira nos corretores carregados via PHP
  document.querySelectorAll('.remove-corretor').forEach(icon => {
    icon.addEventListener('click', () => {
      const div = icon.closest('.corretor-item');
      const corretorId = div.dataset.id;
      const conjuntoId = div.closest('.dropzone-area').dataset.conjuntoId;
      const nome = div.innerText.trim();

      div.remove();

      fetch('/gestao-de-leads/ajax/associar.php', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ corretor_id: corretorId, conjunto_id: conjuntoId })
      })
        .then(() => showToast(`🗑️ ${nome} removido`, 'warning'))
        .catch(() => showToast(`❌ Erro ao remover ${nome}`, 'danger'));
    });
  });
});
