<?php
require_once 'includes/auth.php';
require_once 'config/config.php';

// Verifica se o usuário logado é da empresa NoCRM (ID 1)
if ($_SESSION['empresa_id'] != 1) {
  header('Location: dashboard.php');
  exit;
}
?>

<?php include 'includes/header.php'; ?>

<h1 class="h3 text-gray-800">Cadastro de Nova Empresa</h1>

<div class="card shadow mb-4">
  <div class="card-body">
    <form id="formEmpresa">
      <ul class="nav nav-tabs" id="tabEmpresa" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" id="empresa-tab" data-bs-toggle="tab" data-bs-target="#empresa" type="button" role="tab">Empresa</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="admin-tab" data-bs-toggle="tab" data-bs-target="#admin" type="button" role="tab">Administrador</button>
        </li>
      </ul>

      <div class="tab-content p-3" id="tabEmpresaContent">
        <!-- Aba Empresa -->
        <div class="tab-pane fade show active" id="empresa" role="tabpanel">
          <div class="mb-3">
            <label for="nome" class="form-label">Nome da Empresa</label>
            <input type="text" class="form-control" id="nome" name="nome" required>
          </div>
          <div class="mb-3">
            <label for="cnpj" class="form-label">CNPJ</label>
            <input type="text" class="form-control" id="cnpj" name="cnpj">
          </div>
          <div class="mb-3">
            <label for="telefone_contato" class="form-label">Telefone de Contato</label>
            <input type="text" class="form-control" id="telefone_contato" name="telefone_contato">
          </div>
          <div class="mb-3">
            <label for="dominio" class="form-label">Domínio (sem https://)</label>
            <input type="text" class="form-control" id="dominio" name="dominio" required>
          </div>
        </div>

        <!-- Aba Administrador -->
        <div class="tab-pane fade" id="admin" role="tabpanel">
          <div class="mb-3">
            <label for="admin_nome" class="form-label">Nome do Administrador</label>
            <input type="text" class="form-control" id="admin_nome" name="admin_nome" required>
          </div>
          <div class="mb-3">
            <label for="admin_email" class="form-label">Email</label>
            <input type="email" class="form-control" id="admin_email" name="admin_email" required>
          </div>
          <div class="mb-3">
            <label for="admin_telefone" class="form-label">Telefone</label>
            <input type="text" class="form-control" id="admin_telefone" name="admin_telefone">
          </div>
          <div class="mb-3">
            <label for="admin_senha" class="form-label">Senha</label>
            <input type="password" class="form-control" id="admin_senha" name="admin_senha" required>
          </div>
        </div>
      </div>

      <div class="text-end mt-3">
        <button type="submit" class="btn btn-success">Salvar Empresa</button>
      </div>
    </form>
  </div>
</div>

<h1 class="h3 text-gray-800 mt-5">Empresas Cadastradas</h1>
<div class="card shadow">
  <div class="card-body">
    <table class="table table-striped" id="tabelaEmpresas">
      <thead>
        <tr>
          <th>Nome</th>
          <th>Domínio</th>
          <th>Telefone</th>
          <th>Ações</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>
</div>

<script>
function carregarEmpresas() {
  fetch('ajax/empresas.php?action=listar')
    .then(resp => resp.json())
    .then(dados => {
      const tbody = document.querySelector('#tabelaEmpresas tbody');
      tbody.innerHTML = '';

      dados.forEach(emp => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td><input class="form-control form-control-sm" value="${emp.nome}" data-id="${emp.id}" data-campo="nome"></td>
          <td><input class="form-control form-control-sm" value="${emp.dominio}" data-id="${emp.id}" data-campo="dominio"></td>
          <td><input class="form-control form-control-sm" value="${emp.telefone_contato || ''}" data-id="${emp.id}" data-campo="telefone_contato"></td>
          <td>
            <button class="btn btn-sm btn-success salvar" data-id="${emp.id}"><i class="fas fa-save"></i></button>
            <button class="btn btn-sm btn-danger excluir" data-id="${emp.id}"><i class="fas fa-trash"></i></button>
          </td>
        `;
        tbody.appendChild(tr);
      });

      // Inicializa DataTables com idioma em português
      $('#tabelaEmpresas').DataTable({
        destroy: true,
        language: {
          url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/pt-BR.json'
        }
      });
    });
}

// Evento de cadastro
document.getElementById('formEmpresa').addEventListener('submit', function (e) {
  e.preventDefault();
  const form = e.target;
  const formData = new FormData(form);

  fetch('ajax/empresas.php', {
    method: 'POST',
    body: formData
  })
  .then(resp => resp.json())
  .then(json => {
    if (json.status === 'ok') {
      toastr.success('Empresa cadastrada com sucesso!');
      form.reset();
      carregarEmpresas();
    } else {
      toastr.error(json.erro || 'Erro ao cadastrar empresa.');
    }
  })
  .catch(() => toastr.error('Erro na requisição.'));
});

// Eventos de editar/excluir
document.addEventListener('click', function (e) {
  const btn = e.target.closest('button');
  if (!btn) return;

  const id = btn.dataset.id;
  if (btn.classList.contains('salvar')) {
    const campos = document.querySelectorAll(`input[data-id="${id}"]`);
    const dados = {};
    campos.forEach(input => {
      dados[input.dataset.campo] = input.value;
    });

    fetch('ajax/empresas.php?action=atualizar&id=' + id, {
      method: 'POST',
      body: new URLSearchParams(dados)
    })
    .then(resp => resp.json())
    .then(json => {
      if (json.status === 'ok') {
        toastr.success('Empresa atualizada.');
      } else {
        toastr.error(json.erro || 'Erro ao atualizar.');
      }
    });
  }

  if (btn.classList.contains('excluir')) {
    if (!confirm('Tem certeza que deseja excluir esta empresa?')) return;

    fetch('ajax/empresas.php?action=excluir&id=' + id, { method: 'POST' })
      .then(resp => resp.json())
      .then(json => {
        if (json.status === 'ok') {
          toastr.success('Empresa excluída.');
          carregarEmpresas();
        } else {
          toastr.error(json.erro || 'Erro ao excluir.');
        }
      });
  }
});

document.addEventListener('DOMContentLoaded', carregarEmpresas);
</script>

<?php include 'includes/footer.php'; ?>
