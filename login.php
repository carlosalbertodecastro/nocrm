<<<<<<< HEAD
<?php
session_start();
require_once 'config/config.php';
require_once 'config/niveis.php';

$erro = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $senha = $_POST['senha'] ?? '';

    if ($email && $senha) {
        $stmt = $pdo->prepare("
            SELECT u.id, u.nome, u.email, u.senha, u.empresa_id, uc.cargo_id, c.nivel_acesso, c.nome AS cargo_nome
            FROM usuarios u
            JOIN usuarios_cargos uc ON uc.usuario_id = u.id
            JOIN cargos c ON c.id = uc.cargo_id
            WHERE u.email = ?
            LIMIT 1
        ");
        $stmt->execute([$email]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario && password_verify($senha, $usuario['senha'])) {
            // Define variáveis de sessão
            $_SESSION['usuario_id'] = $usuario['id'];
            $_SESSION['nome'] = $usuario['nome'];
            $_SESSION['email'] = $usuario['email'];
            $_SESSION['empresa_id'] = $usuario['empresa_id'];
            $_SESSION['empresa_visualizada_id'] = $usuario['empresa_id'];
            $_SESSION['cargo_id'] = $usuario['cargo_id'];
            $_SESSION['nivel_acesso'] = $usuario['nivel_acesso'];
            $_SESSION['cargo_nome'] = $usuario['cargo_nome'];

            // Define níveis dinamicamente
            definirNiveisGlobais($pdo, $usuario['empresa_id']);

            if ($usuario['nivel_acesso'] == 1) {
                header('Location: corretor.php');
            } else {
                header('Location: dashboard.php');
            }
            exit;
        } else {
            $erro = 'E-mail ou senha inválidos.';
        }
    } else {
        $erro = 'Preencha todos os campos.';
    }
}
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>NoCRM – Gestão Inteligente de Leads</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007bff, #00c6ff);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .card-title {
            font-weight: bold;
            color: #007bff;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: none;
        }

        .logo {
            font-size: 2rem;
            font-weight: bold;
            color: #007bff;
        }

        .bg-white-90 {
            background-color: rgba(255,255,255,0.95);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card bg-white-90 p-4">
                <div class="text-center mb-4">
                    <div class="logo">NoCRM</div>
                    <small class="text-muted">Gestão Inteligente de Leads</small>
                </div>

                <?php if ($erro): ?>
                    <div class="alert alert-danger text-center"><?= htmlspecialchars($erro) ?></div>
                <?php endif; ?>

                <form method="POST" action="">
                    <div class="mb-3">
                        <label for="email" class="form-label">E-mail</label>
                        <input type="email" class="form-control" name="email" id="email" required autofocus>
                    </div>

                    <div class="mb-3">
                        <label for="senha" class="form-label">Senha</label>
                        <input type="password" class="form-control" name="senha" id="senha" required>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Entrar</button>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <small class="text-muted">© <?= date('Y') ?> NoCRM</small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
=======
<?php
session_start();
require_once 'config/config.php';
require_once 'config/niveis.php';

$erro = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $senha = $_POST['senha'] ?? '';

    if ($email && $senha) {
        $stmt = $pdo->prepare("
            SELECT u.id, u.nome, u.email, u.senha, u.empresa_id, uc.cargo_id, c.nivel_acesso, c.nome AS cargo_nome
            FROM usuarios u
            JOIN usuarios_cargos uc ON uc.usuario_id = u.id
            JOIN cargos c ON c.id = uc.cargo_id
            WHERE u.email = ?
            LIMIT 1
        ");
        $stmt->execute([$email]);
        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($usuario && password_verify($senha, $usuario['senha'])) {
            // Define variáveis de sessão
            $_SESSION['usuario_id'] = $usuario['id'];
            $_SESSION['nome'] = $usuario['nome'];
            $_SESSION['email'] = $usuario['email'];
            $_SESSION['empresa_id'] = $usuario['empresa_id'];
            $_SESSION['empresa_visualizada_id'] = $usuario['empresa_id'];
            $_SESSION['cargo_id'] = $usuario['cargo_id'];
            $_SESSION['nivel_acesso'] = $usuario['nivel_acesso'];
            $_SESSION['cargo_nome'] = $usuario['cargo_nome'];

            // Define níveis dinamicamente
            definirNiveisGlobais($pdo, $usuario['empresa_id']);

            if ($usuario['nivel_acesso'] == 1) {
                header('Location: corretor.php');
            } else {
                header('Location: dashboard.php');
            }
            exit;
        } else {
            $erro = 'E-mail ou senha inválidos.';
        }
    } else {
        $erro = 'Preencha todos os campos.';
    }
}
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>NoCRM – Gestão Inteligente de Leads</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007bff, #00c6ff);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .card-title {
            font-weight: bold;
            color: #007bff;
        }

        .form-control:focus {
            border-color: #007bff;
            box-shadow: none;
        }

        .logo {
            font-size: 2rem;
            font-weight: bold;
            color: #007bff;
        }

        .bg-white-90 {
            background-color: rgba(255,255,255,0.95);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card bg-white-90 p-4">
                <div class="text-center mb-4">
                    <div class="logo">NoCRM</div>
                    <small class="text-muted">Gestão Inteligente de Leads</small>
                </div>

                <?php if ($erro): ?>
                    <div class="alert alert-danger text-center"><?= htmlspecialchars($erro) ?></div>
                <?php endif; ?>

                <form method="POST" action="">
                    <div class="mb-3">
                        <label for="email" class="form-label">E-mail</label>
                        <input type="email" class="form-control" name="email" id="email" required autofocus>
                    </div>

                    <div class="mb-3">
                        <label for="senha" class="form-label">Senha</label>
                        <input type="password" class="form-control" name="senha" id="senha" required>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Entrar</button>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <small class="text-muted">© <?= date('Y') ?> NoCRM</small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
>>>>>>> 6c2fbeaafb0caf8a3337125370993ce78f69acf6
