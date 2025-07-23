<?php
require_once 'includes/auth.php';
require_once 'config/config.php';
include 'includes/header.php';

// Função auxiliar para obter configuração
function get_config($chave, $default = null) {
  global $pdo;
  $stmt = $pdo->prepare("SELECT valor FROM configuracoes_sistema WHERE chave = ?");
  $stmt->execute([$chave]);
  $row = $stmt->fetch(PDO::FETCH_ASSOC);
  return $row ? json_decode($row['valor'], true) : $default;
}

// Salvar configurações
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $config_padrao = [
    'corretor_padrao_id' => $_POST['corretor_padrao'] ?? null,
    'tempo_reenvio' => $_POST['tempo_reenvio'] ?? 2,
    'mensagem_padrao' => $_POST['mensagem_padrao'] ?? ''
  ];

  $stmt = $pdo->prepare("INSERT INTO configuracoes_sistema (chave, valor, atualizado_em)
      VALUES ('whatsapp_envio', ?, NOW())
      ON DUPLICATE KEY UPDATE valor = VALUES(valor), atualizado_em = NOW()");
  $stmt->execute([json_encode($config_padrao)]);

  echo '<div class="alert alert-success text-center mt-3">✅ Configurações salvas com sucesso!</div>';
}

// Obter valores atuais
$config = get_config('whatsapp_envio', [
  'corretor_padrao_id' => '',
  'tempo_reenvio' => 2,
  'mensagem_padrao' => ''
]);

$corretores = $pdo->query("SELECT id, nome FROM corretores WHERE ativo = 1 ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
?>

<div class="container mt-4">
  <h1 class="h3 text-gray-800">Configurações do Sistema</h1>

  <!-- Nav tabs -->
  <ul class="nav nav-tabs mb-3" id="configTabs" role="tablist">
    <li class="nav-item">
      <button class="nav-link active" id="whatsapp-tab" data-bs-toggle="tab" data-bs-target="#whatsapp" type="button" role="tab">
        Envio de WhatsApp
      </button>
    </li>
    <!-- Novas abas futuras podem ser adicionadas aqui -->
  </ul>

  <div class="tab-content" id="configTabsContent">
    <!-- Aba: Envio WhatsApp -->
    <div class="tab-pane fade show active" id="whatsapp" role="tabpanel">
      <form method="POST" class="row g-3 border rounded p-3 bg-light shadow-sm">
        <!-- Corretor padrão -->
        <div class="col-md-6">
          <label class="form-label">Corretor padrão para leads pendentes</label>
          <select name="corretor_padrao" class="form-select" required>
            <option value="">Selecione um corretor...</option>
            <?php foreach ($corretores as $c): ?>
              <option value="<?= $c['id'] ?>" <?= $config['corretor_padrao_id'] == $c['id'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($c['nome']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        </div>

        <!-- Tempo reenvio WhatsApp -->
        <div class="col-md-3">
          <label class="form-label">Tempo de reenvio WhatsApp (em horas)</label>
          <input type="number" name="tempo_reenvio" class="form-control" min="1" value="<?= htmlspecialchars($config['tempo_reenvio']) ?>" required>
        </div>

        <!-- Mensagem padrão -->
        <div class="col-12">
          <label class="form-label">Mensagem padrão para WhatsApp</label>
          <textarea name="mensagem_padrao" rows="4" class="form-control"><?= htmlspecialchars($config['mensagem_padrao']) ?></textarea>
        </div>

        <div class="col-12 text-end">
          <button class="btn btn-primary"><i class="fa fa-save"></i> Salvar Configurações</button>
        </div>
      </form>
    </div>
  </div>
</div>

<?php include 'includes/footer.php'; ?>
