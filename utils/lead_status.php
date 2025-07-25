<?php
require_once __DIR__ . '/logger.php';

function atualizar_lead_recebido(PDO $pdo, int $lead_id, ?string $message_id, string $status, ?int $corretor_id = null): bool {
    try {
        $stmt = $pdo->prepare("
            UPDATE leads_recebidos 
            SET whatsapp_enviado = 1,
                status = 1,
                data_envio_whatsapp = NOW(),
                zapi_message_id = :message_id,
                corretor_id = COALESCE(:corretor_id, corretor_id)
            WHERE id = :lead_id
        ");

        $stmt->execute([
            ':message_id' => $message_id,
            ':corretor_id' => $corretor_id,
            ':lead_id' => $lead_id
        ]);

        gravar_log('processo', "✔️ Lead #{$lead_id} marcado como ENVIADO com message_id={$message_id}");
        return true;

    } catch (Exception $e) {
        gravar_log('processo', "❌ Erro ao atualizar lead #{$lead_id}: " . $e->getMessage());
        return false;
    }
}
