<?php
// config/config.php

// 🕒 Timezone
date_default_timezone_set('America/Sao_Paulo');

// 🔒 Proteção contra execução direta
if (basename(__FILE__) == basename($_SERVER['SCRIPT_FILENAME'])) {
    exit('Acesso direto não permitido.');
}

// ⚙️ Configurações do Banco de Dados
define('DB_HOST', 'localhost');
define('DB_NAME', 'ads');
define('DB_USER', 'sql_carloscastro');
define('DB_PASS', 'cNZxfX8cbhL3DN6p');

try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erro ao conectar ao banco de dados: " . $e->getMessage());
}

// 📲 Configurações da Z-API (idealmente movidas para um arquivo separado futuramente)
define('ZAPI_INSTANCE_ID', '3E3D01D0B8E320CC5E1BAE53A3A095E1');
define('ZAPI_TOKEN', '4BA8F6B61DF887F5BE20B536');
define('ZAPI_SECRET_KEY', 'F48d06a7661ed454ea2e481166d0abc84S');
define('ZAPI_BASE_URL', 'https://api.z-api.io');

