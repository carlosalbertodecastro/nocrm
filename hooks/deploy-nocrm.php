<?php
// Arquivo: deploy-nocrm.php

// Define o caminho do projeto
$repoDir = '/www/wwwroot/loubacklancamentos.com.br/gestao-de-leads';
$logFile = '/var/log/deploy-nocrm.log';

// Função para registrar no log
function logMsg($msg) {
    global $logFile;
    file_put_contents($logFile, date('[Y-m-d H:i:s] ') . $msg . "\n", FILE_APPEND);
}

// Confirma que é um POST vindo do GitHub
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(403);
    exit('Acesso negado.');
}

logMsg("🚀 Webhook recebido, executando git pull...");

// Executa o pull no repositório
chdir($repoDir);
$output = shell_exec('git pull origin main 2>&1');

logMsg($output);
echo "Atualizado com sucesso.";
?>
