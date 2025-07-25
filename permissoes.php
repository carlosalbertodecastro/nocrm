<?php
// Incluir os arquivos de configuração e definição de níveis
require_once __DIR__ . '/config/config.php'; // Conexão com o banco de dados
require_once __DIR__ . '/config/niveis.php'; // Definição dos níveis de acesso

// Iniciar a sessão, caso ainda não tenha sido iniciada
if (!isset($_SESSION)) {
    session_start();
}

// Definir os níveis de acesso para a empresa visualizada
definirNiveisGlobais($pdo, $_SESSION['empresa_id']); // Certifique-se de que a função foi chamada com o $pdo e o ID da empresa

// Verificar se o usuário tem o nível de acesso adequado (sócios/diretores podem editar permissões)
if ($_SESSION['nivel_acesso'] < NIVEL_SOCIO) {
    header('Location: sem_permissao.php'); // Redireciona caso o usuário não tenha permissão
    exit;
}

// Busca todos os cargos da empresa visualizada
$stmt = $pdo->prepare("SELECT id, nome FROM cargos WHERE empresa_id = ?");
$stmt->execute([$_SESSION['empresa_id']]);
$cargos = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Busca todas as permissões existentes
$stmt2 = $pdo->query("SELECT DISTINCT pagina, acao FROM permissoes_cargos ORDER BY pagina, acao");
$permissoesExistentes = $stmt2->fetchAll(PDO::FETCH_ASSOC);
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

                <!-- Permissões por Cargo -->
                <h1 class="h3 text-gray-800 mb-4"><i class="fas fa-lock me-2"></i>Permissões por Cargo</h1>

                <div class="table-responsive">
                    <table id="tabelaPermissoes" class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Cargo</th>
                                <?php foreach ($permissoesExistentes as $p): ?>
                                    <th><?= htmlspecialchars($p['pagina']) ?> (<?= $p['acao'] ?>)</th>
                                <?php endforeach; ?>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($cargos as $cargo): ?>
                                <tr>
                                    <td><strong><?= htmlspecialchars($cargo['nome']) ?></strong></td>
                                    <?php foreach ($permissoesExistentes as $p): ?>
                                        <?php
                                        $stmtPerm = $pdo->prepare("SELECT permitido FROM permissoes_cargos WHERE cargo_id = ? AND pagina = ? AND acao = ?");
                                        $stmtPerm->execute([$cargo['id'], $p['pagina'], $p['acao']]);
                                        $permitido = $stmtPerm->fetchColumn() ?: 0;
                                        ?>
                                        <td class="text-center">
                                            <input type="checkbox" class="perm-checkbox" 
                                                data-cargo="<?= $cargo['id'] ?>" 
                                                data-pagina="<?= $p['pagina'] ?>" 
                                                data-acao="<?= $p['acao'] ?>" 
                                                <?= $permitido ? 'checked' : '' ?>>
                                        </td>
                                    <?php endforeach; ?>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>

                <!-- Scripts -->
                <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/toastr@2.1.4/build/toastr.min.js"></script>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastr@2.1.4/build/toastr.min.css"/>

                <script>
                    $(document).ready(function () {
                        $('#tabelaPermissoes').DataTable({
                            scrollX: true
                        });

                        $('.perm-checkbox').on('change', function () {
                            const checkbox = $(this);
                            const cargo_id = checkbox.data('cargo');
                            const pagina = checkbox.data('pagina');
                            const acao = checkbox.data('acao');
                            const permitido = checkbox.is(':checked') ? 1 : 0;

                            $.post('ajax/permissoes_cargos.php', {
                                cargo_id, pagina, acao, permitido
                            }, function (res) {
                                toastr.success(res.message || 'Permissão atualizada.');
                            }).fail(function () {
                                toastr.error('Erro ao salvar permissão.');
                            });
                        });
                    });
                </script>
            </div>
        </div>
    </div>
</body>
</html>
