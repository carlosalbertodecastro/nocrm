<?php
require_once __DIR__ . '/config/config.php';

try {
    $stmt = $pdo->query("SELECT id, nome, email FROM usuarios");
    $usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if ($usuarios) {
        echo "<h2>Usuários encontrados:</h2><ul>";
        foreach ($usuarios as $usuario) {
            echo "<li>ID: {$usuario['id']} - Nome: {$usuario['nome']} - Email: {$usuario['email']}</li>";
        }
        echo "</ul>";
    } else {
        echo "Nenhum usuário encontrado.";
    }
} catch (PDOException $e) {
    echo "Erro na consulta: " . $e->getMessage();
}
?>
