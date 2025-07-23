<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';
?>

<div class="container-fluid">
    <h1 class="h3 text-gray-800">Conjuntos de Anúncio</h1>

    <button class="btn btn-success mb-3" onclick="abrirModalAdicionar()">
        <i class="fas fa-plus"></i> Novo Conjunto
    </button>

    <table id="tabelaConjuntos" class="table table-striped table-bordered">
        <thead>
            <tr>
                <th>Nome</th>
                <th>Campanha</th>
                <th>Código Facebook</th>
                <th>Ativo</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
</div>

<!-- Modal -->
<div class="modal fade" id="modalConjunto" tabindex="-1">
    <div class="modal-dialog">
        <form id="formConjunto">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Conjunto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="id" id="id">
                    <input type="hidden" name="acao" id="acao">

                    <div class="mb-3">
                        <label>Nome</label>
                        <input type="text" name="nome" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Campanha ID</label>
                        <input type="number" name="campanha_id" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label>Código Facebook</label>
                        <input type="text" name="codigo_facebook" class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" type="submit"><i class="fas fa-save"></i> Salvar</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Cancelar</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toast" class="toast align-items-center text-white bg-success border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body" id="toast-mensagem">Sucesso</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<script>
const tabela = $('#tabelaConjuntos').DataTable({
    ajax: { url: 'ajax/conjuntos.php?acao=listar', dataSrc: 'data' },
    columns: [
        { data: 'nome' },
        { data: 'campanha_id' },
        { data: 'codigo_facebook' },
        {
            data: 'ativo',
            render: val => val == 1 ? 'Sim' : 'Não'
        },
        {
            data: null,
            render: data => `
                <button class="btn btn-sm btn-primary" onclick='editar(${JSON.stringify(data)})'><i class="fas fa-edit"></i></button>
                <button class="btn btn-sm btn-danger" onclick='deletar(${data.id})'><i class="fas fa-trash"></i></button>
                <button class="btn btn-sm btn-${data.ativo == 1 ? 'warning' : 'success'}" onclick='toggleAtivo(${data.id}, ${data.ativo})'>
                    <i class="fas fa-${data.ativo == 1 ? 'ban' : 'check'}"></i>
                </button>
            `
        }
    ]
});

function abrirModalAdicionar() {
    $('#formConjunto')[0].reset();
    $('#acao').val('adicionar');
    $('#id').val('');
    $('#modalConjunto').modal('show');
}

function editar(dado) {
    $('#acao').val('editar');
    $('#id').val(dado.id);
    $('[name="nome"]').val(dado.nome);
    $('[name="campanha_id"]').val(dado.campanha_id);
    $('[name="codigo_facebook"]').val(dado.codigo_facebook);
    $('#modalConjunto').modal('show');
}

$('#formConjunto').submit(e => {
    e.preventDefault();
    const formData = new FormData(e.target);
    fetch('ajax/conjuntos.php', { method: 'POST', body: formData })
        .then(r => r.json())
        .then(r => {
            showToast(r.mensagem, r.status == 'sucesso');
            if (r.status == 'sucesso') {
                $('#modalConjunto').modal('hide');
                tabela.ajax.reload();
            }
        });
});

function deletar(id) {
    if (confirm('Deseja realmente excluir?')) {
        fetch('ajax/conjuntos.php', {
            method: 'POST',
            body: new URLSearchParams({ acao: 'deletar', id })
        })
        .then(r => r.json())
        .then(r => {
            showToast(r.mensagem, r.status == 'sucesso');
            if (r.status == 'sucesso') tabela.ajax.reload();
        });
    }
}

function toggleAtivo(id, statusAtual) {
    const acao = statusAtual == 1 ? 'desativar' : 'ativar';
    fetch('ajax/conjuntos.php', {
        method: 'POST',
        body: new URLSearchParams({ acao, id })
    })
    .then(r => r.json())
    .then(r => {
        showToast(r.mensagem, r.status == 'sucesso');
        if (r.status == 'sucesso') tabela.ajax.reload();
    });
}

function showToast(mensagem, sucesso = true) {
    $('#toast-mensagem').text(mensagem);
    $('#toast').removeClass('bg-success bg-danger').addClass(sucesso ? 'bg-success' : 'bg-danger');
    const toast = new bootstrap.Toast(document.getElementById('toast'));
    toast.show();
}
</script>

<?php require_once 'includes/footer.php'; ?>
