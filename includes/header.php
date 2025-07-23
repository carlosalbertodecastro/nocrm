<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../config/niveis.php';

if (!isset($_SESSION)) session_start();
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>NoCRM - Gestão de Leads</title>


  <!-- Fonts and Icons -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

  <!-- DataTables -->
  <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">

  <!-- Toastr -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet">

  <!-- Custom styles -->
  <link href="assets/css/style.css" rel="stylesheet">
    <!-- SB Admin 2 - Bootstrap core -->
  <link href="https://cdn.jsdelivr.net/gh/BlackrockDigital/startbootstrap-sb-admin-2@master/css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body id="page-top">
  <!-- Page Wrapper -->
  <div id="wrapper">

    <!-- Sidebar -->
    <?php include 'menu_lateral.php'; ?>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <!-- Topbar -->
        <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

          <!-- Logo / Nome do sistema -->
          <div class="d-flex align-items-center">
            <i class="fas fa-chart-line fa-lg text-primary me-2"></i>
            <strong class="text-dark">NoCRM</strong>
          </div>

          <!-- Empresa visualizada (somente NoCRM master) -->
          <?php if ($_SESSION['empresa_id'] == 1): ?>
            <form class="ms-4">
              <select id="empresaSelect" class="form-select form-select-sm">
                <?php
                $empresas = $pdo->query("SELECT id, nome FROM empresas ORDER BY nome")->fetchAll(PDO::FETCH_ASSOC);
                foreach ($empresas as $e):
                ?>
                  <option value="<?= $e['id'] ?>" <?= ($_SESSION['empresa_visualizada_id'] == $e['id']) ? 'selected' : '' ?>>
                    <?= htmlspecialchars($e['nome']) ?>
                  </option>
                <?php endforeach; ?>
              </select>
            </form>
          <?php endif; ?>

          <!-- Topbar Navbar -->
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <span class="nav-link text-dark small">
                <?= htmlspecialchars($_SESSION['usuario_nome'] ?? 'Usuário') ?>
              </span>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="logout.php">
                <i class="fas fa-sign-out-alt"></i> Sair
              </a>
            </li>
          </ul>
        </nav>
        <!-- End of Topbar -->

        <!-- JS: troca de empresa -->
        <script>
          document.addEventListener('DOMContentLoaded', () => {
            const select = document.getElementById('empresaSelect');
            if (select) {
              select.addEventListener('change', () => {
                const novaEmpresa = select.value;
                fetch('ajax/trocar_empresa.php', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                  body: 'nova_empresa_id=' + encodeURIComponent(novaEmpresa)
                })
                .then(resp => resp.json())
                .then(json => {
                  if (json.status === 'ok') {
                    location.reload();
                  } else {
                    toastr.error(json.erro || 'Erro ao trocar empresa');
                  }
                })
                .catch(() => toastr.error('Erro ao enviar requisição'));
              });
            }
          });
        </script>
