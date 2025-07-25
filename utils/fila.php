<?php
require_once __DIR__ . '/logger.php';

function atualizar_fila_round_robin(PDO $pdo, int $conjunto_id, int $corretor_id): void {
    $stmt = $pdo->prepare("
        SELECT ec.corretor_id, c.nome
        FROM elegibilidade_corretores ec
        JOIN corretores c ON ec.corretor_id = c.id
        WHERE ec.conjunto_id = ? AND ec.ativo = 1
        ORDER BY ec.ordem_fila
    ");
    $stmt->execute([$conjunto_id]);
    $corretores = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$corretores || count($corretores) < 2) {
        gravar_log('processo', "ℹ️ Fila do conjunto {$conjunto_id} tem menos de 2 corretores. Nenhuma rotação necessária.");
        return;
    }

    $novaFila = [];
    foreach ($corretores as $item) {
        if ((int)$item['corretor_id'] !== $corretor_id) {
            $novaFila[] = $item;
        }
    }

    // Corrigir posição da fila
    $stmtUpdate = $pdo->prepare("
        UPDATE elegibilidade_corretores 
        SET ordem_fila = :ordem
        WHERE conjunto_id = :conjunto_id AND corretor_id = :corretor_id
    ");

    $posicao = 1;
    foreach ($novaFila as $item) {
        $stmtUpdate->execute([
            ':ordem' => $posicao++,
            ':conjunto_id' => $conjunto_id,
            ':corretor_id' => $item['corretor_id']
        ]);
    }

    // Reinsere o corretor que foi usado no final
    $stmtUpdate->execute([
        ':ordem' => $posicao,
        ':conjunto_id' => $conjunto_id,
        ':corretor_id' => $corretor_id
    ]);

    $nomeMovido = buscar_nome_corretor($pdo, $corretor_id);
    $proximo = $novaFila[0]['nome'] ?? 'indefinido';

    gravar_log('processo', "🔁 Fila atualizada: corretor {$corretor_id} ({$nomeMovido}) movido para o final no conjunto {$conjunto_id}. Próximo da fila: {$proximo}");
}

function buscar_nome_corretor(PDO $pdo, int $corretor_id): string {
    $stmt = $pdo->prepare("SELECT nome FROM corretores WHERE id = ?");
    $stmt->execute([$corretor_id]);
    return $stmt->fetchColumn() ?: 'Desconhecido';
}
