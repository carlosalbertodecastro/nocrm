
<?php
// includes/menu_lateral.php
$nivel = $_SESSION['nivel_acesso'] ?? 0;
$empresa_id = $_SESSION['empresa_id'] ?? 0;
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

  <!-- Acesso Corretor -->
  <li class="nav-item"><a class="nav-link" href="corretor.php"><i class="fas fa-user"></i> <span>Página do Corretor</span></a></li>
  <li class="nav-item"><a class="nav-link" href="leads.php"><i class="fas fa-address-card"></i> <span>Leads</span></a></li>
  <li class="nav-item"><a class="nav-link" href="historico.php"><i class="fas fa-history"></i> <span>Histórico</span></a></li>
  <li class="nav-item"><a class="nav-link" href="historico_lead.php"><i class="fas fa-clock"></i> <span>Histórico de Lead</span></a></li>

  <!-- Gerente/Regional/Dono -->
  <?php if ($nivel >= obterNivelPorCargo('Gerente')): ?>
    <li class="nav-item"><a class="nav-link" href="corretores.php"><i class="fas fa-user-tie"></i> <span>Corretores</span></a></li>
    <li class="nav-item"><a class="nav-link" href="associar_corretores.php"><i class="fas fa-users"></i> <span>Associar Corretores</span></a></li>
    <li class="nav-item"><a class="nav-link" href="campanhas.php"><i class="fas fa-bullhorn"></i> <span>Campanhas</span></a></li>
    <li class="nav-item"><a class="nav-link" href="conjuntos.php"><i class="fas fa-layer-group"></i> <span>Conjuntos</span></a></li>
    <li class="nav-item"><a class="nav-link" href="dashboard.php"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
    <li class="nav-item"><a class="nav-link" href="leads_pendentes_whatsapp.php"><i class="fas fa-exclamation-circle"></i> <span>Leads Pendentes</span></a></li>
    <li class="nav-item"><a class="nav-link" href="simular_lead.php"><i class="fas fa-vial"></i> <span>Simular Lead</span></a></li>
  <?php endif; ?>

  <!-- Dono -->
  <?php if ($nivel >= obterNivelPorCargo('Dono')): ?>
    <li class="nav-item"><a class="nav-link" href="usuarios.php"><i class="fas fa-users-cog"></i> <span>Usuários</span></a></li>
    <li class="nav-item"><a class="nav-link" href="cargos_niveis.php"><i class="fas fa-sitemap"></i> <span>Cargos e Níveis</span></a></li>
    <li class="nav-item"><a class="nav-link" href="configuracoes.php"><i class="fas fa-cogs"></i> <span>Configurações</span></a></li>
    <li class="nav-item"><a class="nav-link" href="log.php"><i class="fas fa-file-alt"></i> <span>Log do Sistema</span></a></li>
    <li class="nav-item"><a class="nav-link" href="permissoes.php"><i class="fas fa-lock"></i> <span>Permissões</span></a></li>
    <li class="nav-item"><a class="nav-link" href="permissoes_cargos.php"><i class="fas fa-user-shield"></i> <span>Permissões por Cargo</span></a></li>
  <?php endif; ?>

  <!-- Master (empresa_id 1) -->
  <?php if ($empresa_id == 1): ?>
    <li class="nav-item"><a class="nav-link" href="empresas.php"><i class="fas fa-building"></i> <span>Empresas</span></a></li>
  <?php endif; ?>

  <hr class="sidebar-divider d-none d-md-block">
</ul>
