<?php
// includes/menu_lateral.php
?>

<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
  <!-- Logo -->
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="dashboard.php">
    <div class="sidebar-brand-icon">
      <i class="fas fa-chart-line"></i>
    </div>
    <div class="sidebar-brand-text mx-2">NoCRM</div>
  </a>

  <hr class="sidebar-divider my-0">

  <li class="nav-item">
    <a class="nav-link" href="dashboard.php">
      <i class="fas fa-tachometer-alt"></i>
      <span>Dashboard</span>
    </a>
  </li>

  <li class="nav-item">
    <a class="nav-link" href="leads.php">
      <i class="fas fa-address-card"></i>
      <span>Leads</span>
    </a>
  </li>

  <?php if ($_SESSION['nivel_acesso'] >= obterNivelPorCargo('Gerente')): ?>
    <li class="nav-item">
      <a class="nav-link" href="corretores.php">
        <i class="fas fa-user-tie"></i>
        <span>Corretores</span>
      </a>
    </li>
  <?php endif; ?>

  <?php if ($_SESSION['nivel_acesso'] >= obterNivelPorCargo('Dono')): ?>
    <li class="nav-item">
      <a class="nav-link" href="cargos.php">
        <i class="fas fa-sitemap"></i>
        <span>Cargos</span>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="permissoes.php">
        <i class="fas fa-lock"></i>
        <span>Permissões</span>
      </a>
    </li>
  <?php endif; ?>

  <?php if ($_SESSION['nivel_acesso'] >= obterNivelPorCargo('Admin NoCRM')): ?>
    <li class="nav-item">
      <a class="nav-link" href="empresas.php">
        <i class="fas fa-building"></i>
        <span>Empresas</span>
      </a>
    </li>
  <?php endif; ?>

  <hr class="sidebar-divider d-none d-md-block">
</ul>
