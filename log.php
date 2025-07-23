<?php
require_once __DIR__ . '/config/config.php';
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8">
  <title>Logs do Webhook</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
  <h2>📄 Logs de Webhook</h2>
  <hr>

  <h4 class="mt-4">✅ Últimos 50 registros processados</h4>
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th>ID</th>
        <th>Status</th>
        <th>Mensagem</th>
        <th>IP</th>
        <th>Data</th>
      </tr>
    </thead>
    <tbody>
      <?php
      $stmt = $pdo->query("SELECT id, status, mensagem, ip_origem, data_registro FROM logs_webhook ORDER BY id DESC LIMIT 50");
      foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $log):
      ?>
        <tr>
          <td><?= $log['id'] ?></td>
          <td><?= strtoupper($log['status']) ?></td>
          <td><?= htmlspecialchars($log['mensagem']) ?></td>
          <td><?= $log['ip_origem'] ?></td>
          <td><?= date('d/m/Y H:i', strtotime($log['data_registro'])) ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>

  <h4 class="mt-5">⚠️ Leads pendentes</h4>
  <table class="table table-bordered table-sm">
    <thead>
      <tr>
        <th>ID</th>
        <th>Motivo</th>
        <th>Data</th>
        <th>JSON recebido</th>
      </tr>
    </thead>
    <tbody>
      <?php
      $stmt = $pdo->query("SELECT id, motivo, json_recebido, data_registro FROM leads_pendentes ORDER BY id DESC LIMIT 20");
      foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $pendente):
      ?>
        <tr>
          <td><?= $pendente['id'] ?></td>
          <td><?= htmlspecialchars($pendente['motivo']) ?></td>
          <td><?= date('d/m/Y H:i', strtotime($pendente['data_registro'])) ?></td>
          <td><pre style="white-space: pre-wrap;"><?= htmlspecialchars($pendente['json_recebido']) ?></pre></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</body>
</html>
