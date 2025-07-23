<?php
require_once '../config/config.php';

$allowed_logs = [
    'log_leads.txt',
    'log_zapi.txt',
    'log_erros.txt',
    'log_webhook.txt',
    'log_input.txt'
];

$file = $_GET['file'] ?? '';
if (!in_array($file, $allowed_logs)) {
    http_response_code(403);
    echo "Acesso negado.";
    exit;
}

$path = __DIR__ . '/../logs/' . $file;
if (!file_exists($path)) {
    echo "Arquivo não encontrado.";
} else {
    echo file_get_contents($path);
}
