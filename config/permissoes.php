<?php
// config/permissoes.php

/**
 * Verifica se um cargo tem permissão para determinada ação.
 * 
 * @param PDO $pdo - Conexão com o banco de dados
 * @param int $cargo_id - ID do cargo
 * @param string $recurso - Nome do recurso (ex: 'usuarios', 'leads', 'dashboard')
 * @param string $acao - Ação a ser verificada (ex: 'ver', 'criar', 'editar', 'deletar')
 * @return bool - true se tiver permissão, false caso contrário
 */
function temPermissao(PDO $pdo, int $cargo_id, string $recurso, string $acao): bool {
    try {
        $stmt = $pdo->prepare("
            SELECT permitido FROM permissoes_cargos 
            WHERE cargo_id = :cargo_id 
              AND recurso = :recurso 
              AND acao = :acao
            LIMIT 1
        ");
        $stmt->execute([
            'cargo_id' => $cargo_id,
            'recurso'  => $recurso,
            'acao'     => $acao
        ]);
        $resultado = $stmt->fetch(PDO::FETCH_ASSOC);
        return ($resultado && $resultado['permitido'] == 1);
    } catch (PDOException $e) {
        // Logar erro se necessário
        return false;
    }
}
