<?php require_once 'includes/header.php'; ?>

<div class="container mt-4">
  <h1 class="h3 text-gray-800 mb-4">🧪 Simulador de Leads</h1>

  <div class="row">
    <!-- Formulário -->
    <div class="col-md-6">
      <form id="leadForm" class="card shadow p-3" onsubmit="event.preventDefault(); enviarLead();">
        <div class="mb-2">
          <label class="form-label">Nome do Cliente</label>
          <input type="text" class="form-control" id="nome" required>
        </div>
        <div class="mb-2">
          <label class="form-label">Telefone</label>
          <input type="text" class="form-control" id="telefone" required>
        </div>
        <div class="mb-2">
          <label class="form-label">Email</label>
          <input type="email" class="form-control" id="email">
        </div>
        <div class="mb-2">
          <label class="form-label">Anúncio</label>
          <input type="text" class="form-control" id="anuncio_nome" value="Anúncio Teste">
        </div>
        <div class="mb-2">
          <label class="form-label">Lead ID</label>
          <input type="text" class="form-control" id="lead_id" readonly>
        </div>

        <!-- Campos ocultos -->
        <input type="hidden" id="form_id" value="form_simulador">
        <input type="hidden" id="pagina_id" value="pagina_simulador">
        <input type="hidden" id="conjunto_id" value="10">
        <input type="hidden" id="adset_nome" value="Simular Lead">
        <input type="hidden" id="plataforma" value="fb">
        <input type="hidden" id="veiculo" value="">
        <input type="hidden" id="campanha_id" value="1">
        <input type="hidden" id="campanha_nome" value="Campanha Simulada">
        <input type="hidden" id="corretor_id" value="6">
        <input type="hidden" id="status_envio" value="pendente">
        <input type="hidden" id="whatsapp_enviado" value="0">
        <input type="hidden" id="enviado_whatsapp" value="">
        <input type="hidden" id="resposta_contato" value="">
        <input type="hidden" id="data_contato" value="">
        <input type="hidden" id="message_id_enviado" value="">

        <div class="d-flex justify-content-between mt-3">
          <button type="button" class="btn btn-secondary" onclick="gerarLead()">🔁 Gerar Lead Aleatório</button>
          <button type="submit" class="btn btn-success">🚀 Enviar Lead</button>
        </div>
      </form>
    </div>

    <!-- Coluna JSON -->
    <div class="col-md-6">
      <div class="bg-dark text-light p-3 rounded shadow-sm">
        <h6 class="text-info">📦 JSON Enviado</h6>
        <pre id="jsonPreview" style="font-size: 14px; white-space: pre-wrap;"></pre>
      </div>
    </div>
  </div>
</div>

<!-- Toast -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 9999">
  <div id="toast" class="toast align-items-center text-white bg-primary border-0" role="alert">
    <div class="d-flex">
      <div class="toast-body" id="toast-message">Mensagem</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
  </div>
</div>

<script>
function gerarLead() {
  const nomes = ["João", "Maria", "Carlos", "Ana", "Paulo", "Fernanda"];
  const sobrenomes = ["Silva", "Souza", "Oliveira", "Lima"];
  const nome = `${nomes[Math.floor(Math.random() * nomes.length)]} ${sobrenomes[Math.floor(Math.random() * sobrenomes.length)]}`;
  const telefone = "+55319" + Math.floor(10000000 + Math.random() * 89999999);
  const email = nome.toLowerCase().replace(/ /g, ".") + "@teste.com";
  const id = "SIMULADO_" + Math.floor(Math.random() * 9999999999);

  document.getElementById("nome").value = nome;
  document.getElementById("telefone").value = telefone;
  document.getElementById("email").value = email;
  document.getElementById("lead_id").value = id;

  atualizarJson();
}

function atualizarJson() {
  const now = new Date().toISOString();

  const json = {
    nome: document.getElementById("nome").value,
    telefone: document.getElementById("telefone").value,
    email: document.getElementById("email").value,
    anuncio_nome: document.getElementById("anuncio_nome").value,
    lead_id: document.getElementById("lead_id").value,
    form_id: document.getElementById("form_id").value,
    pagina_id: document.getElementById("pagina_id").value,
    conjunto_id: document.getElementById("conjunto_id").value,
    adset_nome: document.getElementById("adset_nome").value,
    plataforma: document.getElementById("plataforma").value,
    veiculo: document.getElementById("veiculo").value,
    campanha_id: document.getElementById("campanha_id").value,
    campanha_nome: document.getElementById("campanha_nome").value,
    corretor_id: document.getElementById("corretor_id").value,
    status_envio: document.getElementById("status_envio").value,
    whatsapp_enviado: document.getElementById("whatsapp_enviado").value,
    enviado_whatsapp: now,
    resposta_contato: document.getElementById("resposta_contato").value,
    data_contato: document.getElementById("data_contato").value,
    message_id_enviado: document.getElementById("message_id_enviado").value,
    created_at: now,
    updated_at: now,
    data_recebido: now
  };

  document.getElementById("jsonPreview").textContent = JSON.stringify(json, null, 2);
  return json;
}

function mostrarToast(msg, cor = 'bg-primary') {
  const el = document.getElementById('toast');
  document.getElementById('toast-message').textContent = msg;
  el.className = `toast align-items-center text-white ${cor} border-0`;
  new bootstrap.Toast(el).show();
}

function enviarLead() {
  const json = atualizarJson();
  fetch('receber_lead.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(json)
  })
  .then(async res => {
    const tipo = res.headers.get("content-type");
    if (tipo.includes("json")) {
      const resposta = await res.json();
      if (resposta.status === "sucesso" || resposta.status === "ok") {
        mostrarToast("✅ " + (resposta.mensagem || "Lead enviado!"), 'bg-success');
      } else {
        mostrarToast("⚠️ " + (resposta.mensagem || "Erro ao enviar"), 'bg-warning');
      }
    } else {
      mostrarToast("⚠️ Resposta inválida do servidor", 'bg-danger');
    }
  })
  .catch(err => {
    console.error(err);
    mostrarToast("❌ Erro ao enviar: " + err.message, 'bg-danger');
  });
}

document.querySelectorAll('input').forEach(el => {
  el.addEventListener('input', atualizarJson);
});
</script>

<?php require_once 'includes/footer.php'; ?>
