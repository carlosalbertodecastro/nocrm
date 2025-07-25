<?php
$arquivo = basename($_GET['arquivo'] ?? '');
$logs_dir = realpath(__DIR__ . '/../logs/');
$caminho = realpath($logs_dir . '/' . $arquivo);

if (!$arquivo) {
    http_response_code(400);
    echo "❌ Nome do arquivo não foi enviado.";
    exit;
}

if (!$caminho || !file_exists($caminho)) {
    http_response_code(404);
    echo "❌ Arquivo não encontrado.";
    exit;
}

if (strpos($caminho, $logs_dir) !== 0) {
    http_response_code(403);
    echo "❌ Acesso negado ao caminho.";
    exit;
}

header('Content-Type: text/plain; charset=utf-8');
readfile($caminho);