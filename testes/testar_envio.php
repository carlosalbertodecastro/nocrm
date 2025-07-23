<?php
require_once '../includes/auth.php';
require_once '../config/config.php';
require_once '../utils/zapi.php';
include '../includes/header.php';

// Buscar leads não enviados
$leads = $pdo->query("
    SELECT lr.*, ca.nome AS conjunto_nome, c.nome AS corretor_nome, c.telefone_whatsapp
    FROM leads_recebidos lr
    JOIN conjuntos_anuncio ca ON ca.id = lr.conjunto_id
    JOIN corretores c ON c.id = lr.corretor_id
    WHERE (lr.enviado_whatsapp IS NULL OR lr.enviado_whatsapp = 0)
    AND c.ativo = 1
    ORDER BY lr.id DESC
")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container py-4">
    <h3 class="mb-4">🧪 Testes de Envio WhatsApp (Z-API)</h3>
    <table class="table table-bordered table-sm">
        <thead>
            <tr>
                <th>Data</th>
                <th>Corretor</th>
                <th>Cliente</th>
                <th>Telefone</th>
                <th>Anúncio</th>
                <th>Ação</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($leads as $lead): ?>
                <tr>
                    <td><?= date('d/m/Y H:i', strtotime($lead['data_recebido'])) ?></td>
                    <td><?= htmlspecialchars($lead['corretor_nome']) ?></td>
                    <td><?= htmlspecialchars($lead['nome_cliente']) ?></td>
                    <td><?= htmlspecialchars($lead['telefone_cliente']) ?></td>
                    <td><?= htmlspecialchars($lead['anuncio_nome']) ?></td>
                    <td>
                        <button class="btn btn-outline-success btn-sm enviar-whatsapp" data-id="<?= $lead['id'] ?>">
                            <i class="fa fa-paper-plane"></i> Enviar
                        </button>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

<!-- Toastr + FontAwesome + jQuery -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

<script>
document.querySelectorAll('.enviar-whatsapp').forEach(button => {
    button.addEventListener('click', () => {
        const id = button.dataset.id;
        const payload = { id: id };

        console.log('🟨 Enviando POST para: ../ajax/zapi_envio_manual.php');
        console.log('📤 JSON Enviado:', payload);

        fetch('../ajax/zapi_envio_manual.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(res => {
            console.log('📥 Resposta bruta:', res);
            return res.json();
        })
        .then(res => {
            console.log('📊 Resposta JSON:', res);

            if (res.sucesso) {
                toastr.success('✅ Mensagem enviada com sucesso!');
                button.closest('tr').remove();
            } else {
                toastr.error('❌ Erro: ' + (res.mensagem || 'Erro desconhecido'));
            }
        })
        .catch(err => {
            console.error('❌ Erro de rede ou resposta inválida:', err);
            toastr.error('Erro na requisição AJAX');
        });
    });
});
</script>

<?php include '../includes/footer.php'; ?>
