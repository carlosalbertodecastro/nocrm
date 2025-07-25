<?php
require_once '../config/config.php';
require_once '../utils/zapi.php';

$telefone = '553195293737'; // Seu número de teste
$mensagem = "🧪 *Teste com opções via função utils/zapi.php*";
$opcoes = [
    [ 'id' => 'whatsapp',     'title' => 'Conversei por WhatsApp',   'description' => 'Conseguiu falar com o cliente via WhatsApp' ],
    [ 'id' => 'telefone',     'title' => 'Liguei para o cliente',    'description' => 'Conseguiu contato por ligação telefônica' ],
    [ 'id' => 'nao-contato',  'title' => 'Não consegui contato',     'description' => 'Cliente não atendeu ou não respondeu' ],
    [ 'id' => 'desqualificado','title' => 'Desqualificado',          'description' => 'Lead fora do perfil ou inválido' ],
];

$resposta = enviar_mensagem_com_opcoes($telefone, $mensagem, $opcoes);

echo "<pre>";
echo "✅ Enviado para: $telefone\n";
print_r($resposta);
echo "</pre>";
