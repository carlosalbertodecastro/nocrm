-- Use esse comando PHP no terminal ou app para inserir o usuário corretamente:
$senha = password_hash('carlos576', PASSWORD_DEFAULT);
-- Ou use o hash abaixo (gerado com SHA-256 como exemplo, substitua por password_hash no PHP real):

INSERT INTO usuarios (nome, email, senha, ativo) VALUES 
('Carlos Castro', 'carloscastro.louback@gmail.com', '26ef4a168e0f9aab8214d1a73f8e7c49fa251205b7c3c7367dfdef404c6e021f', 1);
