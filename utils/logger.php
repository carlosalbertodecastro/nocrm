<?php
function gravar_log(string $tipo, string $mensagem): void {
    $tipo = strtolower($tipo);
    $diretorio = __DIR__ . '/../logs';
    if (!is_dir($diretorio)) {
        mkdir($diretorio, 0775, true);
    }

    switch ($tipo) {
        case 'processo':
            $arquivo = $diretorio . '/log_processos.txt';
            break;
        case 'lead':
        case 'receber_lead':
            $arquivo = $diretorio . '/log_receber_lead.txt';
            break;
        case 'interacao':
            $arquivo = $diretorio . '/log_interacoes_lead.txt';
            break;
        case 'cron':
            $arquivo = $diretorio . '/log_cron.txt';
            break;
        default:
            $arquivo = $diretorio . '/log_default.txt';
            break;
    }
    
    $timestamp = date('[d-m-y H:i:s]');
    $linha = "{$timestamp} {$mensagem}\n";

    file_put_contents($arquivo, $linha, FILE_APPEND);
}
