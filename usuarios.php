<?php
// usuarios.php

require_once __DIR__ . '/config/config.php';
require_once __DIR__ . '/config/niveis.php';
definirNiveisGlobais($pdo);
verificar_acesso(NIVEL_GERENTE); // Apenas gerente ou superiores

require_once __DIR__ . '/includes/header.php';
?>

<h1 class="h3 text-gray-800 mb-4"><i class="fas fa-users-cog"></i> Gestão de Usuários</h1>

<div class="accordion mb-4" id="accordionUsuarios">
  <div class="accordion-item">
    <h2 class="accordion-header" id="headingCadastro">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCadastro" aria-expanded="false" aria-controls="collapseCadastro">
        <i class="fas fa-plus me-2"></i> Cadastrar Novo Usuário
      </button>
    </h2>
    <div id="collapseCadastro" class="accordion-collapse collapse" aria-labelledby="headingCadastro" data-bs-parent="#accordionUsuarios">
      <div class="accordion-body">
        <form id="formUsuario">
          <div class="row">
            <div class="col-md-4 mb-3">
              <label>Nome</label>
              <input type="text" class="form-control" name="nome" required>
            </div>
            <div class="col-md-4 mb-3">
              <label>Email</label>
              <input type="email" class="form-control" name="email" required>
            </div>
            <div class="col-md-4 mb-3">
              <label>Senha</label>
              <input type="password" class="form-control" name="senha" required>
            </div>
            <div class="col-md-4 mb-3">
              <label>Cargo</label>
              <select name="cargo_id" class="form-select" required>
                <option value="">Selecione</option>
                <?php
                $cargos = $pdo->query("SELECT id, nome FROM cargos ORDER BY nome")->fetchAll();
                foreach ($cargos as $cargo) {
                  echo "<option value='{$cargo['id']}'>{$cargo['nome']}</option>";
                }
                ?>
              </select>
            </div>
            <div class="col-md-4 mb-3">
              <label>Empresa</label>
              <select name="empresa_id" class="form-select" required>
                <?php
                $empresas = $pdo->query("SELECT id, nome FROM empresas ORDER BY nome")->fetchAll();
                foreach ($empresas as $empresa) {
                  echo "<option value='{$empresa['id']}'>{$empresa['nome']}</option>";
                }
                ?>
              </select>
            </div>
          </div>
          <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i> Salvar</button>
        </form>
      </div>
    </div>
  </div>
</div>

<table class="table table-bordered table-hover" id="tabelaUsuarios">
  <thead class="table-light">
    <tr>
      <th>ID</th>
      <th>Nome</th>
      <th>Email</th>
      <th>Cargo</th>
      <th>Empresa</th>
      <th>Ações</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/toastr/build/toastr.min.js"></script>

<script>
$(document).ready(function() {
  const tabela = $('#tabelaUsuarios').DataTable({
    ajax: 'ajax/usuarios.php?action=listar',
    columns: [
      { data: 'id' },
      { data: 'nome', render: function(data, type, row) {
          return `<input class="form-control form-control-sm editar" data-id="${row.id}" data-campo="nome" value="${data}">`;
      }},
      { data: 'email', render: function(data, type, row) {
          return `<input class="form-control form-control-sm editar" data-id="${row.id}" data-campo="email" value="${data}">`;
      }},
      { data: 'cargo_nome' },
      { data: 'empresa_nome' },
      { data: 'id', render: function(data) {
          return `<button class="btn btn-sm btn-danger excluir" data-id="${data}"><i class="fas fa-trash"></i></button>`;
      }}
    ]
  });

  $('#formUsuario').on('submit', function(e) {
    e.preventDefault();
    $.post('ajax/usuarios.php?action=criar', $(this).serialize(), function(res) {
      if (res.status === 'ok') {
        toastr.success(res.mensagem);
        tabela.ajax.reload();
        $('#formUsuario')[0].reset();
        $('#collapseCadastro').collapse('hide');
      } else {
        toastr.error(res.mensagem);
      }
    }, 'json');
  });

  $('#tabelaUsuarios tbody').on('blur', '.editar', function() {
    const id = $(this).data('id');
    const campo = $(this).data('campo');
    const valor = $(this).val();

    $.post('ajax/usuarios.php?action=atualizar', { id, campo, valor }, function(res) {
      if (res.status === 'ok') {
        toastr.success(res.mensagem);
      } else {
        toastr.error(res.mensagem);
      }
    }, 'json');
  });

  $('#tabelaUsuarios tbody').on('click', '.excluir', function() {
    if (!confirm('Tem certeza que deseja excluir este usuário?')) return;
    const id = $(this).data('id');
    $.post('ajax/usuarios.php?action=excluir', { id }, function(res) {
      if (res.status === 'ok') {
        toastr.success(res.mensagem);
        tabela.ajax.reload();
      } else {
        toastr.error(res.mensagem);
      }
    }, 'json');
  });
});
</script>
