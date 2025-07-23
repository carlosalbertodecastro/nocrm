-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 21-Jul-2025 às 06:24
-- Versão do servidor: 5.7.37-log
-- versão do PHP: 7.4.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `ads`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `campanhas`
--

CREATE TABLE `campanhas` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(150) NOT NULL,
  `descricao` text,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `campanhas`
--

INSERT INTO `campanhas` (`id`, `empresa_id`, `nome`, `descricao`, `ativo`, `created_at`, `updated_at`) VALUES
(1, 2, 'Cadastros', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09');

-- --------------------------------------------------------

--
-- Estrutura da tabela `cargos`
--

CREATE TABLE `cargos` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `nivel_acesso` int(11) NOT NULL DEFAULT '1' COMMENT '1=Corretor, 2=Gerente, 3=Regional, 4=Dono, 5=Admin NoCRM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `cargos`
--

INSERT INTO `cargos` (`id`, `empresa_id`, `nome`, `created_at`, `updated_at`, `nivel_acesso`) VALUES
(1, 2, 'Regional', '2025-07-02 22:15:57', '2025-07-17 04:25:29', 3),
(2, 2, 'Gerente', '2025-07-02 22:15:57', '2025-07-17 04:25:29', 2),
(3, 2, 'Corretor', '2025-07-02 22:15:57', '2025-07-17 03:11:09', 1),
(4, 2, 'Gerente de Vendas', '2025-07-02 22:15:57', '2025-07-17 04:25:29', 2),
(5, 1, 'Administrador Geral', '2025-07-17 04:25:46', '2025-07-17 04:25:46', 5),
(6, 1, 'Master', '2025-07-17 04:33:40', '2025-07-17 04:33:40', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `configuracoes_sistema`
--

CREATE TABLE `configuracoes_sistema` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `chave` varchar(100) NOT NULL,
  `valor` text NOT NULL,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `configuracoes_sistema`
--

INSERT INTO `configuracoes_sistema` (`id`, `empresa_id`, `chave`, `valor`, `atualizado_em`) VALUES
(1, 2, 'corretor_padrao_id', '1', '2025-07-17 03:11:09'),
(2, 2, 'tempo_reenvio_whatsapp', '120', '2025-07-17 03:11:09'),
(3, 2, 'mensagem_padrao_lead', '📢 *Novo Lead Recebido!*', '2025-07-17 03:11:09'),
(4, 2, 'ativo_envio_whatsapp', '1', '2025-07-17 03:11:09'),
(5, 2, 'whatsapp_envio', '{\"corretor_padrao_id\":\"1\",\"tempo_reenvio\":\"1\",\"mensagem_padrao\":\"\"}', '2025-07-17 03:11:09');

-- --------------------------------------------------------

--
-- Estrutura da tabela `configuracoes_zapi`
--

CREATE TABLE `configuracoes_zapi` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `numero_telefone` varchar(20) NOT NULL,
  `instance_id` varchar(100) NOT NULL,
  `token` varchar(100) NOT NULL,
  `secret_key` varchar(255) DEFAULT NULL,
  `base_url` varchar(255) DEFAULT 'https://api.z-api.io',
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `configuracoes_zapi`
--

INSERT INTO `configuracoes_zapi` (`id`, `empresa_id`, `numero_telefone`, `instance_id`, `token`, `secret_key`, `base_url`, `ativo`, `criado_em`, `atualizado_em`) VALUES
(1, 2, '+553135671007', '3E3D01D0B8E320CC5E1BAE53A3A095E1', '4BA8F6B61DF887F5BE20B536', 'F48d06a7661ed454ea2e481166d0abc84S', 'https://api.z-api.io', 1, '2025-07-17 04:12:36', '2025-07-17 04:12:36');

-- --------------------------------------------------------

--
-- Estrutura da tabela `conjuntos_anuncio`
--

CREATE TABLE `conjuntos_anuncio` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `campanha_id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `codigo_facebook` varchar(100) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `conjuntos_anuncio`
--

INSERT INTO `conjuntos_anuncio` (`id`, `empresa_id`, `campanha_id`, `nome`, `codigo_facebook`, `ativo`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'Investidores Alphaville', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(2, 2, 1, 'Investidores Interior', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(3, 2, 1, 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(4, 2, 1, 'Pampulha 8km ADVANTAGE', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(5, 2, 1, 'Teste — Terramaris Vespasiano', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(6, 2, 1, 'Terramaris Vespasiano', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(7, 2, 1, 'Pampulha 16KM Direcionado', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(8, 2, 1, 'Centro Sul - Carlos Castro', NULL, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09'),
(9, 2, 1, '(ADSET) (Carrossel) Terramaris Renda 3800', NULL, 1, '2025-07-10 04:33:06', '2025-07-17 03:11:09'),
(10, 2, 1, 'Simular Lead', NULL, 1, '2025-07-12 03:08:37', '2025-07-17 03:11:09'),
(11, 2, 1, 'Vetor Norte 18 - 45', NULL, 1, '2025-07-18 03:54:10', '2025-07-20 21:20:49');

-- --------------------------------------------------------

--
-- Estrutura da tabela `corretores`
--

CREATE TABLE `corretores` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone_whatsapp` varchar(20) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `equipe_id` int(11) DEFAULT NULL,
  `cargo_id` int(11) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `foto_perfil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `corretores`
--

INSERT INTO `corretores` (`id`, `empresa_id`, `nome`, `email`, `telefone_whatsapp`, `instagram`, `equipe_id`, `cargo_id`, `ativo`, `created_at`, `updated_at`, `foto_perfil`) VALUES
(1, 2, 'Carlos Castro', NULL, '553195293737', 'https://www.instagram.com/carlosoanalista/', NULL, 1, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/436765478_1223887825452402_4140436558568914144_n.jpg?ccb=11-4&oh=01_Q5Aa2AG6TqSU2ugAa9BDCG2iUZlCJLaBCxXZNnF4j3ZIPuWK3g&oe=6882AC6D&_nc_sid=5e03e0&_nc_cat=106'),
(2, 2, 'Inêz Eva', NULL, '5531989432440', 'https://www.instagram.com/inezeva.imoveis/', NULL, 3, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/322307554_1254067798529331_4294597342560330887_n.jpg?ccb=11-4&oh=01_Q5Aa2AFH6ZPg74OXh8I4u_J9Lhdnw-LZyECXrK8jK-UybVUkxg&oe=6883756F&_nc_sid=5e03e0&_nc_cat=105'),
(3, 2, 'Renata Lamarca', NULL, '553186941158', 'https://www.instagram.com/renata_slamarca/', NULL, 4, 0, '2025-07-02 22:15:57', '2025-07-20 18:34:36', 'https://pps.whatsapp.net/v/t61.24694-24/325964477_1268116127077325_3808359931227649868_n.jpg?ccb=11-4&oh=01_Q5Aa2AGOvsI8Q0zOFz-pHMQujC3QhVUPi_nFDUt0UlRE0tPx3g&oe=6883B15F&_nc_sid=5e03e0&_nc_cat=101'),
(4, 2, 'Rodrigo Santos', NULL, '5531987373923', 'https://www.instagram.com/rodrig_imovel/', NULL, 4, 1, '2025-07-02 22:15:57', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/488424949_1216256819895736_7687727721182670441_n.jpg?ccb=11-4&oh=01_Q5Aa2AHGtFEYalnjwwapyJgtpdFJHo0Cn3neIs5udvb4VhBpMA&oe=68829736&_nc_sid=5e03e0&_nc_cat=104'),
(5, 2, 'Adilson de Souza', NULL, '553183509051', 'https://www.instagram.com/adilson_corretor_imob/', NULL, 3, 1, '2025-07-03 19:49:18', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/458208680_1203481707367213_5187179835634724207_n.jpg?ccb=11-4&oh=01_Q5Aa2AGxXGtXY08aFJAkep3-0w_ZXwxaOUKtbhvVAMW6PT0_Ag&oe=688399E8&_nc_sid=5e03e0&_nc_cat=104'),
(6, 2, 'Cibele Gonçalves', NULL, '553183327758', '', NULL, 3, 1, '2025-07-03 19:51:22', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/491837912_1198175891782175_436915499651130956_n.jpg?ccb=11-4&oh=01_Q5Aa2AFoniXHhdtM-EGieUhInmleTQ2jofBNbew3CsNik63lqw&oe=6883A495&_nc_sid=5e03e0&_nc_cat=104'),
(7, 2, 'Sara Souza', NULL, '5531999341753', '', NULL, 3, 1, '2025-07-03 21:13:29', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/473396452_1775715603283837_5557129483846184644_n.jpg?ccb=11-4&oh=01_Q5Aa2AFkeyqI9h7q2h1tQY9F7i0-MU1Pt_r2mEe21Dn2fZFoBw&oe=6883D1FB&_nc_sid=5e03e0&_nc_cat=102'),
(8, 2, 'Suelem Miranda', NULL, '553182206936', '', NULL, 3, 1, '2025-07-03 21:14:22', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/491877244_1409201270214128_5112327228060926676_n.jpg?ccb=11-4&oh=01_Q5Aa2AH1dXeVnQi0D-Bax1NZiTT3uhbCLQduZiyYsksh9QXfvQ&oe=6883C7E6&_nc_sid=5e03e0&_nc_cat=110'),
(9, 2, 'Helena Castro', NULL, '31998500741', '', NULL, 3, 1, '2025-07-11 04:25:26', '2025-07-17 03:11:09', 'https://pps.whatsapp.net/v/t61.24694-24/521431374_1080604013479404_7873005671538256177_n.jpg?ccb=11-4&oh=01_Q5Aa2AG3SVJwurODX1QHj2bOEmPn6EzAAjNbHCOf19mVTdNvSw&oe=6883FFA5&_nc_sid=5e03e0&_nc_cat=108');

-- --------------------------------------------------------

--
-- Estrutura da tabela `elegibilidade_corretores`
--

CREATE TABLE `elegibilidade_corretores` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `conjunto_id` int(11) NOT NULL,
  `corretor_id` int(11) NOT NULL,
  `ordem_fila` int(11) DEFAULT '0',
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `elegibilidade_corretores`
--

INSERT INTO `elegibilidade_corretores` (`id`, `empresa_id`, `conjunto_id`, `corretor_id`, `ordem_fila`, `ativo`, `created_at`, `updated_at`) VALUES
(66, 2, 1, 1, 1, 1, '2025-07-11 04:01:48', '2025-07-20 17:00:16'),
(67, 2, 3, 3, 1, 1, '2025-07-11 04:01:58', '2025-07-20 22:19:56'),
(68, 2, 3, 2, 3, 1, '2025-07-11 04:02:01', '2025-07-20 22:19:56'),
(69, 2, 3, 4, 2, 1, '2025-07-11 04:02:11', '2025-07-20 22:19:56'),
(70, 2, 9, 6, 3, 1, '2025-07-11 04:02:15', '2025-07-17 03:11:09'),
(71, 2, 9, 7, 1, 1, '2025-07-11 04:02:19', '2025-07-17 03:11:09'),
(72, 2, 9, 8, 2, 1, '2025-07-11 04:02:21', '2025-07-17 03:11:09'),
(74, 2, 6, 6, 2, 1, '2025-07-11 04:02:37', '2025-07-20 18:09:00'),
(75, 2, 6, 7, 1, 1, '2025-07-11 04:02:40', '2025-07-20 18:09:00'),
(76, 2, 6, 8, 3, 1, '2025-07-11 04:02:43', '2025-07-20 18:09:00'),
(77, 2, 6, 5, 4, 1, '2025-07-11 04:02:46', '2025-07-20 18:09:00'),
(78, 2, 2, 1, 1, 1, '2025-07-11 04:02:53', '2025-07-17 03:11:09'),
(79, 2, 2, 2, 2, 1, '2025-07-11 04:02:56', '2025-07-17 03:11:09'),
(80, 2, 2, 5, 3, 1, '2025-07-11 04:02:59', '2025-07-17 03:11:09'),
(81, 2, 7, 4, 2, 1, '2025-07-11 04:03:03', '2025-07-17 03:11:09'),
(83, 2, 4, 2, 2, 1, '2025-07-11 04:03:09', '2025-07-18 12:59:09'),
(84, 2, 7, 2, 1, 1, '2025-07-11 04:03:13', '2025-07-17 03:11:09'),
(85, 2, 1, 2, 3, 1, '2025-07-11 04:03:17', '2025-07-20 17:00:16'),
(87, 2, 8, 1, 2, 1, '2025-07-11 04:03:27', '2025-07-17 03:11:09'),
(88, 2, 5, 8, 3, 1, '2025-07-11 04:03:37', '2025-07-17 03:11:09'),
(89, 2, 5, 7, 1, 1, '2025-07-11 04:03:47', '2025-07-17 03:11:09'),
(90, 2, 5, 4, 2, 1, '2025-07-11 04:03:49', '2025-07-17 03:11:09'),
(92, 2, 8, 2, 1, 1, '2025-07-11 04:22:44', '2025-07-17 03:11:09'),
(93, 2, 8, 5, 3, 1, '2025-07-11 04:23:58', '2025-07-17 03:11:09'),
(95, 2, 10, 1, 2, 1, '2025-07-12 03:09:26', '2025-07-17 07:42:06'),
(96, 2, 10, 9, 1, 1, '2025-07-12 03:09:29', '2025-07-17 07:42:06'),
(97, 2, 1, 5, 2, 1, '2025-07-13 06:56:58', '2025-07-20 17:00:16'),
(98, NULL, 11, 2, 1, 1, '2025-07-18 14:54:58', '2025-07-18 14:54:58'),
(99, NULL, 11, 4, 5, 1, '2025-07-18 14:55:03', '2025-07-20 12:42:27'),
(100, NULL, 11, 7, 4, 1, '2025-07-18 14:55:10', '2025-07-20 12:42:27'),
(101, NULL, 11, 8, 3, 1, '2025-07-18 14:55:12', '2025-07-20 12:42:27'),
(102, NULL, 11, 5, 2, 1, '2025-07-18 14:55:15', '2025-07-20 12:42:25');

-- --------------------------------------------------------

--
-- Estrutura da tabela `empresas`
--

CREATE TABLE `empresas` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `email_contato` varchar(255) DEFAULT NULL,
  `telefone_contato` varchar(20) DEFAULT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `dominio` varchar(255) DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  `data_criacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `empresas`
--

INSERT INTO `empresas` (`id`, `nome`, `email_contato`, `telefone_contato`, `cnpj`, `dominio`, `ativa`, `data_criacao`) VALUES
(1, 'NoCRM', NULL, '+55 (31) 99529-3737', NULL, 'nocrm.com.br', 1, '2025-07-17 03:08:11'),
(2, 'Louback Imóveis', NULL, '(31) 3567-1007', '33.765.217/0001-41', 'loubacklancamentos.com.br', 1, '2025-07-17 03:08:11');

-- --------------------------------------------------------

--
-- Estrutura da tabela `equipes`
--

CREATE TABLE `equipes` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fluxos_pipeline`
--

CREATE TABLE `fluxos_pipeline` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `nome_etapa` varchar(100) DEFAULT NULL,
  `ordem` int(11) DEFAULT NULL,
  `cor` varchar(20) DEFAULT '#007bff'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `formularios_origem`
--

CREATE TABLE `formularios_origem` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `form_id` varchar(100) NOT NULL,
  `canal` varchar(50) DEFAULT 'facebook',
  `ativo` tinyint(4) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `formularios_origem`
--

INSERT INTO `formularios_origem` (`id`, `empresa_id`, `nome`, `form_id`, `canal`, `ativo`, `criado_em`) VALUES
(1, 2, 'Formulário Padrão FaceAds', '1299695773996064', 'facebook', 1, '2025-07-17 05:14:56');

-- --------------------------------------------------------

--
-- Estrutura da tabela `interacoes_leads`
--

CREATE TABLE `interacoes_leads` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `lead_id` int(11) NOT NULL,
  `corretor_id` int(11) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `message_id` varchar(100) DEFAULT NULL,
  `opcao_escolhida` varchar(100) DEFAULT NULL,
  `texto_exibido` varchar(255) DEFAULT NULL,
  `tipo_contato` enum('telefone','whatsapp','sem_contato','desqualificado','nao-contatado','lembrete') DEFAULT NULL,
  `data_interacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_resposta` datetime DEFAULT NULL,
  `observacao` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `interacoes_leads`
--

INSERT INTO `interacoes_leads` (`id`, `empresa_id`, `lead_id`, `corretor_id`, `telefone`, `message_id`, `opcao_escolhida`, `texto_exibido`, `tipo_contato`, `data_interacao`, `data_resposta`, `observacao`) VALUES
(1, 2, 160, 1, '553195293737', '3EB0AED1B57D196B0CB6DB', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-14 23:20:12', '2025-07-14 20:20:12', NULL),
(2, 2, 158, 1, '553195293737', '3EB019DBCCC72220E247A2', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-14 23:22:18', '2025-07-14 20:22:18', NULL),
(3, 2, 158, 1, '553195293737', '3EB019DBCCC72220E247A2', 'desqualificado', 'Lead Desqualificado', 'whatsapp', '2025-07-14 23:23:14', '2025-07-14 20:23:14', NULL),
(4, 2, 164, 7, '553199341753', '3EB034DDC1331DA30591E9', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 01:40:04', '2025-07-14 22:40:04', NULL),
(5, 2, 165, 9, '553198500741', '3EB0316E837E3B8E0CC499', 'desqualificado', 'Lead Desqualificado', 'whatsapp', '2025-07-15 02:02:39', '2025-07-14 23:02:39', NULL),
(6, 2, 166, 1, '553195293737', '3EB0ACDC4F7D6DBC0745CB', 'telefone', 'Contato por Telefone', 'whatsapp', '2025-07-15 02:23:03', '2025-07-14 23:23:03', NULL),
(7, 2, 167, 8, '553182206936', '3EB0969792D157DEDD0C5F', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 03:02:47', '2025-07-15 00:02:47', NULL),
(8, 2, 106, 1, '553195293737', '3EB0A77C3EC66ACC63B523', 'desqualificado', 'Lead Desqualificado', 'whatsapp', '2025-07-15 03:29:49', '2025-07-15 00:29:49', NULL),
(9, 2, 169, 5, '553183509051', '3EB034C6C6660922DB70CF', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 13:27:44', '2025-07-15 10:27:44', NULL),
(10, 2, 168, 4, '5531987373923', '3EB0B000A6F6A918ED1970', 'lembrete', 'Mensagem de lembrete enviada automaticamente', 'whatsapp', '2025-07-15 15:50:46', NULL, NULL),
(11, 2, 168, 4, '553187373923', '3EB0B000A6F6A918ED1970', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 16:33:31', '2025-07-15 13:33:31', NULL),
(12, 2, 173, 4, '553187373923', '3EB0C1865CECFD1AA05127', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 17:30:42', '2025-07-15 14:30:42', NULL),
(13, 2, 174, 7, '553199341753', '3EB05CA6087288721640D3', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 18:28:07', '2025-07-15 15:28:07', NULL),
(14, 2, 175, 8, '553182206936', '3EB0C1297E34F4914083FD', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 18:57:12', '2025-07-15 15:57:12', NULL),
(15, 2, 176, 5, '553183509051', '3EB0119FC87EF92FDCEC56', 'desqualificado', 'Lead Desqualificado', 'whatsapp', '2025-07-15 19:05:32', '2025-07-15 16:05:32', NULL),
(16, 2, 179, 7, '553199341753', '3EB0FC799E876B8118491A', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-15 19:20:52', '2025-07-15 16:20:52', NULL),
(17, 2, 177, 2, '553189432440', '3EB0A90B33F1F9E5B3FCC4', 'telefone', 'Contato por Telefone', 'whatsapp', '2025-07-15 19:55:27', '2025-07-15 16:55:27', NULL),
(18, 2, 180, 8, '553182206936', '3EB0C3F3F5960025FF1BD4', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-15 20:21:42', '2025-07-15 17:21:42', NULL),
(19, 2, 182, 5, '553183509051', '3EB07F50882FBFC6C512C7', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-15 20:37:23', '2025-07-15 17:37:23', NULL),
(20, 2, 187, 8, '553182206936', '3EB0FF3B2A677D406D119E', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 01:07:00', '2025-07-15 22:07:00', NULL),
(21, 2, 185, 4, '553187373923', '3EB05735E3DE43C1FEACE7', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 11:41:20', '2025-07-16 08:41:20', NULL),
(22, 2, 191, 4, '553187373923', '3EB049DF2FDCDFD4E03392', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 11:41:35', '2025-07-16 08:41:35', NULL),
(23, 2, 191, 4, '553187373923', '3EB049DF2FDCDFD4E03392', 'desqualificado', 'Lead Desqualificado', 'whatsapp', '2025-07-16 11:48:45', '2025-07-16 08:48:45', NULL),
(24, 2, 183, 6, '553183327758', '3EB048A3B3BE765068ECBC', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 11:49:05', '2025-07-16 08:49:05', NULL),
(25, 2, 195, 2, '5531989432440', '3EB049E8E3126DA344FE1D', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(26, 2, 194, 8, '553182206936', '3EB0D9CA167512B796303F', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(27, 2, 193, 7, '5531999341753', '3EB025CD2AD10295CDF803', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(28, 2, 192, 6, '553183327758', '3EB0762294C910D7BB3AC1', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(29, 2, 190, 5, '553183509051', '3EB04D522E83E11539EED7', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(30, 2, 189, 3, '553186941158', '3EB020DB93989B36001E4C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(31, 2, 188, 5, '553183509051', '3EB0966654AC7B48E718A1', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(32, 2, 186, 2, '5531989432440', '3EB0246272DC4F550E9EAC', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(33, 2, 184, 7, '5531999341753', '3EB0C961234D17273227B3', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(34, 2, 181, 3, '553186941158', '3EB06E717A4C61411AC99F', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:40', NULL, NULL),
(35, 2, 178, 6, '553183327758', '3EB08704DDBEE951F89EE2', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(36, 2, 172, 3, '553186941158', '3EB0E7D9A868DEBEF65D4C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(37, 2, 171, 6, '553183327758', '3EB0705518FB03ED77AB38', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(38, 2, 170, 2, '5531989432440', '3EB0E82C57B3B06845DD95', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(39, 2, 163, 6, '553183327758', '3EB0A0C32882F0DC89BE86', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(40, 2, 162, 5, '553183509051', '3EB0BB659B2E9240563E69', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(41, 2, 161, 3, '553186941158', '3EB09FD76C306C24F8FE81', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(42, 2, 159, 9, '31998500741', '3EB0E1D19EEB0F0BA79811', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 15:59:41', NULL, NULL),
(43, 2, 194, 8, '553182206936', '3EB0D9CA167512B796303F', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-16 16:10:53', '2025-07-16 13:10:53', NULL),
(44, 2, 184, 7, '553199341753', '3EB0C961234D17273227B3', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-16 16:32:24', '2025-07-16 13:32:24', NULL),
(45, 2, 162, 5, '553183509051', '3EB0BB659B2E9240563E69', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-16 16:35:55', '2025-07-16 13:35:55', NULL),
(46, 2, 188, 5, '553183509051', '3EB0966654AC7B48E718A1', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 19:50:53', '2025-07-16 16:50:53', NULL),
(47, 2, 190, 5, '553183509051', '3EB04D522E83E11539EED7', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 19:51:04', '2025-07-16 16:51:04', NULL),
(48, 2, 193, 7, '5531999341753', '3EB012A524F37BD5B53FA5', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(49, 2, 192, 6, '553183327758', '3EB081BA8F138056DB7FD6', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(50, 2, 189, 3, '553186941158', '3EB0219D571645BF1018CA', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(51, 2, 186, 2, '5531989432440', '3EB0BBDB0FB45A7ADDE312', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(52, 2, 181, 3, '553186941158', '3EB047399BDC96E9C3865F', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(53, 2, 178, 6, '553183327758', '3EB05B27A8003A2E0570EC', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(54, 2, 172, 3, '553186941158', '3EB065A44D37952819714D', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(55, 2, 171, 6, '553183327758', '3EB01587124BBEB8A08510', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(56, 2, 170, 2, '5531989432440', '3EB0907A6BBAE4959E1D9A', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(57, 2, 163, 6, '553183327758', '3EB050D5BF81020FD8E93C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:01', NULL, NULL),
(58, 2, 161, 3, '553186941158', '3EB0FD430C4026ED68B4F8', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:02', NULL, NULL),
(59, 2, 159, 9, '31998500741', '3EB0EAFB6DF34038BC06F2', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 20:00:02', NULL, NULL),
(60, 2, 193, 7, '553199341753', '3EB012A524F37BD5B53FA5', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 21:04:27', '2025-07-16 18:04:27', NULL),
(61, 2, 197, 5, '553183509051', '3EB02F05FB04EAF546EAAA', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 21:55:01', NULL, NULL),
(62, 2, 196, 2, '5531989432440', '3EB0429FA87F3F99251F0C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-16 21:55:01', NULL, NULL),
(63, 2, 196, 2, '553189432440', '3EB0429FA87F3F99251F0C', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 22:16:21', '2025-07-16 19:16:21', NULL),
(64, 2, 170, 2, '553189432440', '3EB0907A6BBAE4959E1D9A', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 22:18:47', '2025-07-16 19:18:47', NULL),
(65, 2, 186, 2, '553189432440', '3EB0BBDB0FB45A7ADDE312', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-16 22:20:04', '2025-07-16 19:20:04', NULL),
(66, 2, 200, 8, '553182206936', '3EB0258B92329110C40F3A', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 01:20:53', '2025-07-16 22:20:53', NULL),
(67, NULL, 199, 7, '5531999341753', '3EB08624B9D066ABA173EF', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(68, NULL, 198, 6, '553183327758', '3EB01D2A5964D9E85D6B95', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(69, NULL, 197, 5, '553183509051', '3EB0881C4C0D3AAD028255', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(70, NULL, 192, 6, '553183327758', '3EB0CC48AF0BC9DF8D3E3A', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(71, NULL, 189, 3, '553186941158', '3EB06F810241BA5924B02C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(72, NULL, 181, 3, '553186941158', '3EB0B9671522FF96BE1284', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(73, NULL, 178, 6, '553183327758', '3EB008E95AE929D6D4FE11', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(74, NULL, 172, 3, '553186941158', '3EB02A36273AC58435D401', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(75, NULL, 171, 6, '553183327758', '3EB091A161DD53C6B03C36', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 11:00:01', NULL, NULL),
(76, NULL, 181, 3, '553186941158', '3EB0B9671522FF96BE1284', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 11:09:04', '2025-07-17 08:09:04', NULL),
(77, NULL, 197, 5, '553183509051', '3EB0881C4C0D3AAD028255', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 13:55:48', '2025-07-17 10:55:48', NULL),
(78, NULL, 188, 5, '553183509051', '3EB0966654AC7B48E718A1', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 14:07:28', '2025-07-17 11:07:28', NULL),
(79, NULL, 190, 5, '553183509051', '3EB04D522E83E11539EED7', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 14:11:52', '2025-07-17 11:11:52', NULL),
(80, NULL, 182, 5, '553183509051', '3EB07F50882FBFC6C512C7', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-17 14:25:11', '2025-07-17 11:25:11', NULL),
(81, NULL, 198, 6, '553183327758', '3EB031675F385586342F98', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 15:00:01', NULL, NULL),
(82, NULL, 192, 6, '553183327758', '3EB018DEE5E57017BBE2D9', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 15:00:01', NULL, NULL),
(83, NULL, 189, 3, '553186941158', '3EB03269B76CF6E85C9684', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 15:00:01', NULL, NULL),
(84, NULL, 178, 6, '553183327758', '3EB0D5DACA37D0149AAE92', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 15:00:01', NULL, NULL),
(85, NULL, 171, 6, '553183327758', '3EB0A71904C7B50944B981', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 15:00:01', NULL, NULL),
(86, NULL, 189, 3, '553186941158', '3EB03269B76CF6E85C9684', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-17 15:10:24', '2025-07-17 12:10:24', NULL),
(87, NULL, 190, 5, '553183509051', '3EB04D522E83E11539EED7', 'desqualificado', 'Lead desqualificado', 'whatsapp', '2025-07-17 18:26:38', '2025-07-17 15:26:38', NULL),
(88, NULL, 198, 6, '553183327758', '3EB084D256BBBE6BAD3F08', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 19:00:01', NULL, NULL),
(89, NULL, 192, 6, '553183327758', '3EB0241D60CCD0B6FFCDAC', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 19:00:01', NULL, NULL),
(90, NULL, 178, 6, '553183327758', '3EB092C03E8D2F64F7CC79', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 19:00:01', NULL, NULL),
(91, NULL, 171, 6, '553183327758', '3EB062DBC89A6BFC6AB5C6', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-17 19:00:01', NULL, NULL),
(92, NULL, 198, 6, '553183327758', '3EB017B4EDC771333A621D', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 11:00:01', NULL, NULL),
(93, NULL, 240, 4, '5531987373923', '3EB0AA62707804E93CB991', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 15:00:01', NULL, NULL),
(94, NULL, 198, 6, '553183327758', '3EB01DBE72465A072AA77B', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 15:00:01', NULL, NULL),
(95, NULL, 240, 4, '553187373923', '3EB0AA62707804E93CB991', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-18 15:01:26', '2025-07-18 12:01:26', NULL),
(96, NULL, 217, 4, '553187373923', '3EB0BEB9D080422471DE52', NULL, 'Array', 'whatsapp', '2025-07-18 16:48:20', NULL, NULL),
(97, NULL, 217, 4, '553187373923', '3EB0BEB9D080422471DE52', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-18 16:49:07', '2025-07-18 13:49:07', NULL),
(98, NULL, 232, 8, '553182206936', '3EB0D27437FE1215841BD7', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 16:50:01', NULL, NULL),
(99, NULL, 226, 7, '5531999341753', '3EB079B6E2FE97521CD5CC', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 16:50:01', NULL, NULL),
(100, NULL, 225, 5, '553183509051', '3EB06BC913B84865CB14E4', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 16:50:02', NULL, NULL),
(101, NULL, 226, 7, '553199341753', '3EB079B6E2FE97521CD5CC', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-18 19:07:16', '2025-07-18 16:07:16', NULL),
(102, NULL, 232, 8, '553182206936', '3EB01386F7B2D5B5711ACB', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 20:50:01', NULL, NULL),
(103, NULL, 225, 5, '553183509051', '3EB084569B8996C1D27056', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 20:55:01', NULL, NULL),
(104, NULL, 232, 8, '553182206936', '3EB01386F7B2D5B5711ACB', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-18 21:11:20', '2025-07-18 18:11:20', NULL),
(105, NULL, 199, 7, '553199341753', '3EB08624B9D066ABA173EF', 'desqualificado', 'Lead desqualificado', 'whatsapp', '2025-07-18 21:18:15', '2025-07-18 18:18:15', NULL),
(106, NULL, 225, 5, '553183509051', '3EB084569B8996C1D27056', 'whatsapp', 'Contato via WhatsApp', 'whatsapp', '2025-07-18 21:27:36', '2025-07-18 18:27:36', NULL),
(107, NULL, 247, 2, '5531989432440', '3EB06954E7E16E3AF441C0', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 21:35:01', NULL, NULL),
(108, NULL, 250, 7, '5531999341753', '3EB087D38F10E30F1FBBD4', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-18 22:00:01', NULL, NULL),
(109, NULL, 250, 7, '5531999341753', '3EB022CEB0DC22086CC548', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-19 12:00:01', NULL, NULL),
(110, NULL, 247, 2, '5531989432440', '3EB0F9089C35FDDFE704B1', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-19 12:00:01', NULL, NULL),
(111, NULL, 264, 8, '553182206936', '3EB01CD05674F7501B7355', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-19 14:00:01', NULL, NULL),
(112, NULL, 260, 4, '5531987373923', '3EB0D6BA07656E1B42FD73', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-19 14:00:01', NULL, NULL),
(113, NULL, 259, 5, '553183509051', '3EB01D8554FE41DB61B215', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-19 14:00:01', NULL, NULL),
(114, NULL, 264, 8, '553182206936', '3EB01CD05674F7501B7355', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-19 14:41:53', '2025-07-19 11:41:53', NULL),
(115, NULL, 260, 4, '5531987373923', '3EB0531972C60E6380BA60', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:00:02', NULL, NULL),
(116, NULL, 259, 5, '553183509051', '3EB039029B269F32CE0501', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:00:02', NULL, NULL),
(117, NULL, 250, 7, '5531999341753', '3EB0442277232FE05FEE36', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:00:02', NULL, NULL),
(118, NULL, 247, 2, '5531989432440', '3EB08250C3FA48DBB690C4', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:00:02', NULL, NULL),
(119, NULL, 259, 5, '553183509051', '3EB039029B269F32CE0501', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-20 12:14:28', '2025-07-20 09:14:28', NULL),
(120, NULL, 285, 6, '553183327758', '3EB098606465D1977504B7', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(121, NULL, 284, 4, '5531987373923', '3EB026A883321E375088D1', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(122, NULL, 276, 4, '5531987373923', '3EB052E21C04A997426276', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(123, NULL, 275, 4, '5531987373923', '3EB05AA9AEE0FF9610087D', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(124, NULL, 269, 6, '553183327758', '3EB0212D221DB16833C7A8', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(125, NULL, 256, 7, '5531999341753', '3EB0CF3F70F51549E1CE9C', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(126, NULL, 252, 8, '553182206936', '3EB08550D0869A1958B241', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(127, NULL, 251, 8, '553182206936', '3EB04BD50788FB05D2F493', NULL, 'Lembrete enviado automaticamente', 'lembrete', '2025-07-20 12:45:01', NULL, NULL),
(128, NULL, 250, 7, '553199341753', '3EB0442277232FE05FEE36', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-20 13:50:11', '2025-07-20 10:50:11', NULL),
(129, NULL, 256, 7, '553199341753', '3EB0CF3F70F51549E1CE9C', 'nao-contatado', 'Não consegui contato', 'whatsapp', '2025-07-20 13:52:12', '2025-07-20 10:52:12', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `leads_pendentes`
--

CREATE TABLE `leads_pendentes` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `corretor_id` int(11) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  `json_recebido` text NOT NULL,
  `motivo` text,
  `data_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `lead_id` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `leads_pendentes`
--

INSERT INTO `leads_pendentes` (`id`, `empresa_id`, `corretor_id`, `telefone`, `json_recebido`, `motivo`, `data_registro`, `lead_id`) VALUES
(1, 2, NULL, NULL, '{\n  \"lead_id\": \"718663464226878\",\n  \"form_id\": \"1299695773996064\",\n  \"data_criacao\": \"2025-07-03T04:35:39.000Z\",\n  \"pagina_id\": \"108038728224299\",\n  \"nome\": \"Anderson Oliveira\",\n  \"telefone\": \"+5531990721977\",\n  \"email\": \"andersonoliveirasouza5000@gmail.com\",\n  \"adset_nome\": \"Terramaris Vespasiano\",\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\n  \"plataforma\": \"fb\",\n  \"veiculo\": \"\",\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219824720770308\",\n\"plataforma\": \"fb\"\n}', 'Nenhum corretor elegível', '2025-07-03 18:10:43', ''),
(2, 2, NULL, NULL, '{\r\n  \"lead_id\": \"1510397193278727\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-04T12:35:13.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Danielle Silva\",\r\n  \"telefone\": \"31985961409\",\r\n  \"email\": \"danielledesouzas89@gmail.com\",\r\n  \"adset_nome\": \"\",\r\n  \"anuncio_nome\": \"\",\r\n  \"plataforma\": \"\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"\",\n  \"conjunto_id\": \"\",\n\"plataforma\": \"\"\r\n}', 'Campos obrigatórios ausentes', '2025-07-04 13:58:03', ''),
(3, NULL, 1, '+5531988887777', '{\r\n  \"lead_id\": \"999999999999999\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"pagina_id\": \"1122334455667788\",\r\n  \"conjunto_id\": \"SIMULARLEAD\",\r\n  \"adset_nome\": \"Simular Lead\",\r\n  \"anuncio_nome\": \"[Teste] Simulação de Envio de Lead\",\r\n  \"nome\": \"Cliente 2 Teste Empresa 2\",\r\n  \"telefone\": \"+5531988887777\",\r\n  \"email\": \"teste.empresa2@exemplo.com\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"simulador\",\r\n  \"campanha_nome\": \"Simular Lead\",\r\n  \"data_criacao\": \"2025-07-17T14:00:00.000Z\"\r\n}', NULL, '2025-07-17 05:46:06', '203'),
(4, NULL, 1, '+5531988887777', '{\r\n  \"lead_id\": \"999999999999999\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"pagina_id\": \"1122334455667788\",\r\n  \"conjunto_id\": \"SIMULARLEAD\",\r\n  \"adset_nome\": \"Simular Lead\",\r\n  \"anuncio_nome\": \"[Teste] Simulação de Envio de Lead\",\r\n  \"nome\": \"Cliente 7 Teste Empresa 2\",\r\n  \"telefone\": \"+5531988887777\",\r\n  \"email\": \"teste.empresa2@exemplo.com\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"simulador\",\r\n  \"campanha_nome\": \"Simular Lead\",\r\n  \"data_criacao\": \"2025-07-17T14:00:00.000Z\"\r\n}', NULL, '2025-07-17 06:23:18', '205'),
(5, NULL, 1, '+5531988887777', '{\r\n  \"lead_id\": \"999999999999999\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"pagina_id\": \"1122334455667788\",\r\n  \"conjunto_id\": \"SIMULARLEAD\",\r\n  \"adset_nome\": \"Simular Lead\",\r\n  \"anuncio_nome\": \"[Teste] Simulação de Envio de Lead\",\r\n  \"nome\": \"Cliente 7 Teste Empresa 2\",\r\n  \"telefone\": \"+5531988887777\",\r\n  \"email\": \"teste.empresa2@exemplo.com\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"simulador\",\r\n  \"campanha_nome\": \"Simular Lead\",\r\n  \"data_criacao\": \"2025-07-17T14:00:00.000Z\"\r\n}', NULL, '2025-07-17 06:35:36', '206'),
(6, NULL, 9, '+553100000000', '{\r\n        \"lead_id\": \"00001\",\r\n        \"form_id\": \"1299695773996064\",\r\n        \"data_criacao\": \"2025-07-17T00:04:18.000Z\",\r\n        \"pagina_id\": \"108038728224299\",\r\n        \"nome\": \"Teste\",\r\n        \"telefone\": \"+553100000000\",\r\n        \"email\": \"00teste00@yahoo.com.br\",\r\n        \"adset_nome\": \"Simular Lead\",\r\n        \"anuncio_nome\": \"AD [VIDEO 40s] - Teste Mirante do Castelo Renda 8 a 12mil\",\r\n        \"plataforma\": \"ig\",\r\n        \"veiculo\": \"\",\r\n        \"campanha_nome\": \"Cadastros\",\r\n        \"conjunto_id\": \"\"\r\n    }\r\n', NULL, '2025-07-17 07:29:42', '208'),
(7, NULL, 9, NULL, '{\r\n        \"nome_cliente\": \"Fernanda Fernandes\",\r\n        \"telefone_cliente\": \"+5531933897625\",\r\n        \"email_cliente\": \"fernanda.fernandes@teste.com\",\r\n        \"conjunto_id\": \"10\",\r\n        \"adset_nome\": \"Simular Lead\",\r\n        \"anuncio_nome\": \"Anúncio Teste\",\r\n        \"plataforma\": \"fb\",\r\n        \"lead_id\": \"999999999999999\",\r\n        \"form_id\": \"1299695773996064\",\r\n        \"pagina_id\": \"pagina_simulador\"\r\n    }', NULL, '2025-07-17 07:32:57', '209'),
(8, NULL, 9, NULL, '{\r\n        \"nome_cliente\": \"Fernanda Fernandes\",\r\n        \"telefone_cliente\": \"+5531933897625\",\r\n        \"email_cliente\": \"fernanda.fernandes@teste.com\",\r\n        \"conjunto_id\": \"10\",\r\n        \"adset_nome\": \"Simular Lead\",\r\n        \"anuncio_nome\": \"Anúncio Teste\",\r\n        \"plataforma\": \"fb\",\r\n        \"lead_id\": \"999999999999999\",\r\n        \"form_id\": \"1299695773996064\",\r\n        \"pagina_id\": \"pagina_simulador\"\r\n    }', NULL, '2025-07-17 07:36:08', '210');

-- --------------------------------------------------------

--
-- Estrutura da tabela `leads_recebidos`
--

CREATE TABLE `leads_recebidos` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome_cliente` varchar(100) DEFAULT NULL,
  `telefone_cliente` varchar(20) DEFAULT NULL,
  `email_cliente` varchar(100) DEFAULT NULL,
  `data_recebido` datetime DEFAULT CURRENT_TIMESTAMP,
  `conjunto_id` int(11) DEFAULT NULL,
  `campanha_id` int(11) DEFAULT NULL,
  `corretor_id` int(11) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0=Pendente, 1=Entregue, 2=Em atendimento, 3=Desqualificado, 4=Sem resposta',
  `status_envio` varchar(50) DEFAULT 'pendente',
  `whatsapp_status` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lead_id` varchar(100) DEFAULT NULL,
  `form_id` varchar(100) DEFAULT NULL,
  `pagina_id` varchar(100) DEFAULT NULL,
  `adset_nome` varchar(255) DEFAULT NULL,
  `anuncio_nome` varchar(255) DEFAULT NULL,
  `plataforma` varchar(100) DEFAULT NULL,
  `veiculo` varchar(100) DEFAULT NULL,
  `campanha_nome` varchar(150) DEFAULT NULL,
  `whatsapp_enviado` tinyint(1) DEFAULT '0',
  `data_envio_whatsapp` datetime DEFAULT NULL,
  `enviado_whatsapp` tinyint(1) DEFAULT '0',
  `resposta_contato` varchar(50) DEFAULT NULL,
  `data_contato` datetime DEFAULT NULL,
  `message_id_enviado` varchar(255) DEFAULT NULL,
  `zapi_message_id` varchar(100) DEFAULT NULL,
  `tentativas_contato` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `leads_recebidos`
--

INSERT INTO `leads_recebidos` (`id`, `empresa_id`, `nome_cliente`, `telefone_cliente`, `email_cliente`, `data_recebido`, `conjunto_id`, `campanha_id`, `corretor_id`, `status`, `status_envio`, `whatsapp_status`, `created_at`, `updated_at`, `lead_id`, `form_id`, `pagina_id`, `adset_nome`, `anuncio_nome`, `plataforma`, `veiculo`, `campanha_nome`, `whatsapp_enviado`, `data_envio_whatsapp`, `enviado_whatsapp`, `resposta_contato`, `data_contato`, `message_id_enviado`, `zapi_message_id`, `tentativas_contato`) VALUES
(1, 2, 'Kelly Faria', '+5531988623108', 'keyfebh@hotmail.com', '2025-07-04 14:45:56', 5, 1, 7, 0, 'pendente', NULL, '2025-07-04 06:45:56', '2025-07-17 03:11:09', '2184653485367880', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(2, 2, 'Rosiane Oliveira', '+5531993149266', 'rosianeoliveiram74@gmail.com', '2025-07-04 14:46:24', 5, 1, 8, 0, 'pendente', NULL, '2025-07-04 06:46:24', '2025-07-17 03:11:09', '746929661186282', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(3, 2, 'Willian Maias', '+5531994256515', 'willianmaias@hotmail.com', '2025-07-04 14:49:19', 4, 1, 2, 0, 'pendente', NULL, '2025-07-04 06:49:19', '2025-07-17 03:11:09', '1240331567549874', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(4, 2, 'Talita Alves', '+5531973370218', 'talitayslanasousaalves@gmail.com', '2025-07-04 14:50:41', 5, 1, 6, 0, 'pendente', NULL, '2025-07-04 06:50:41', '2025-07-17 03:11:09', '1129782062512942', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(5, 2, 'Maria A. Brum', '+5531984213836', 'mariabrum569@gmail.com', '2025-07-04 14:50:45', 6, 1, 8, 0, 'pendente', NULL, '2025-07-04 06:50:45', '2025-07-17 03:11:09', '1049747837364948', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(6, 2, 'Michael', '+5531985873184', 'michael_rocha85@outlook.com', '2025-07-04 14:50:48', 6, 1, 7, 0, 'pendente', NULL, '2025-07-04 06:50:48', '2025-07-17 03:11:09', '735302569191224', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(7, 2, '𝗞𝗹𝗲𝗯𝗲𝗿 𝗣𝗶𝗺𝗲𝗻𝘁𝗲𝗹 | 𝗠𝗮𝘀𝘀𝗼𝘁𝗲𝗿𝗮𝗽𝗲𝘂𝘁𝗮 𝗲𝗺 𝗕𝗛', '+5531987221928', 'pimentel.empresarial@gmail.com', '2025-07-04 14:51:44', 3, 1, 4, 0, 'pendente', NULL, '2025-07-04 06:51:44', '2025-07-17 03:11:09', '1823637291833533', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(8, 2, 'José Antonio Gomes', '+5538991339311', 'joseantoniogomes1508@gmail.com', '2025-07-04 14:51:48', 5, 1, 7, 0, 'pendente', NULL, '2025-07-04 06:51:48', '2025-07-17 03:11:09', '2013587605838256', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(9, 2, 'Luciana Santos', '+553187496250', 'luc394711@gmail.com', '2025-07-04 15:35:37', 5, 1, 8, 0, 'pendente', NULL, '2025-07-04 07:35:37', '2025-07-17 03:11:09', '1258670055836109', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(10, 2, 'João Ferenczi', '+5531988222379', 'j.fiapo2379@gmail.com', '2025-07-04 15:35:40', 5, 1, 6, 0, 'pendente', NULL, '2025-07-04 07:35:40', '2025-07-17 03:11:09', '1878617422984785', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(11, 2, 'Paulo Henrique', '+5531985123313', 'martinspaulo1201@gmail.com', '2025-07-04 15:35:43', 3, 1, 5, 0, 'pendente', NULL, '2025-07-04 07:35:43', '2025-07-17 03:11:09', '1110838227594040', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(12, 2, 'Maosquecuram_reiki', '+5531999357572', 'anaruthpm2@yahoo.com.br', '2025-07-04 15:35:47', 5, 1, 7, 0, 'pendente', NULL, '2025-07-04 07:35:47', '2025-07-17 03:11:09', '907818358210882', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(13, 2, 'Nathália Lorrany', '+5531995916959', 'nathalia.lorrany.moura.2000@gmail.com', '2025-07-04 03:30:14', 5, 1, NULL, 0, 'pendente', NULL, '2025-07-04 07:51:10', '2025-07-17 03:11:09', '745647514629778', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(14, 2, 'Alan Najara', '+5531997104638', 'artetudep@gmail.com', '2025-07-04 03:51:56', 5, 1, NULL, 0, 'pendente', NULL, '2025-07-04 07:51:15', '2025-07-17 03:11:09', '9298941536875164', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(15, 2, 'Cão Chick', '+5531975082515', 'almrdeandrade@gmail.com', '2025-07-04 08:30:30', 5, 1, NULL, 0, 'pendente', NULL, '2025-07-04 08:30:34', '2025-07-17 03:11:09', '956543529854982', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(16, 2, 'Cleber Ferreira', '+5531971769079', 'cleber.advmg@gmail.com', '2025-07-04 13:07:23', 3, 1, NULL, 0, 'pendente', NULL, '2025-07-04 13:58:26', '2025-07-17 03:11:09', '1369375600791255', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(17, 2, 'Leandro Amorim', '+5531991995190', 'legam@hotmail.com', '2025-07-04 15:10:31', 5, 1, 8, 0, 'pendente', NULL, '2025-07-04 15:10:36', '2025-07-17 03:11:09', '1175668164330660', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(18, 2, 'Carlos Henrique', '+5531995330243', 'chenrique2180ag@gmail.com', '2025-07-04 15:42:33', 6, 1, 6, 0, 'pendente', NULL, '2025-07-04 15:42:38', '2025-07-17 03:11:09', '2745998742254035', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(19, 2, 'Dalila Teixeira Da Silva', '+5531998884587', 'dollyoliveira370@gmail.com', '2025-07-04 15:51:46', 6, 1, 6, 0, 'pendente', NULL, '2025-07-04 15:51:51', '2025-07-17 03:11:09', '979900310780436', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(20, 2, 'Carol', '+5531991914291', 'carolsefs@hotmail.com', '2025-07-04 16:46:54', 4, 1, 5, 0, 'pendente', NULL, '2025-07-04 16:46:58', '2025-07-17 03:11:09', '1244959523670108', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(21, 2, 'Guilherme', '+5531998736752', 'gh881605@gmail.com', '2025-07-04 17:31:31', 3, 1, 2, 0, 'pendente', NULL, '2025-07-04 17:31:35', '2025-07-17 03:11:09', '2619982608340507', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(22, 2, 'Elisangela Alves', '+5531984068859', 'dandalvis@yahoo.com.br', '2025-07-04 18:15:19', 6, 1, 6, 0, 'pendente', NULL, '2025-07-04 18:15:23', '2025-07-17 03:11:09', '1229896611675518', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(23, 2, 'Brunna Roberta', '+5531972010054', 'brurik456@gmail.com', '2025-07-04 18:57:14', 6, 1, 6, 0, 'pendente', NULL, '2025-07-04 18:57:19', '2025-07-17 03:11:09', '3592480041047651', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(24, 2, 'Suzana Apolinário', '+5531982632776', 'suzana.apolinario@educacao.mg.gov.br', '2025-07-04 21:53:14', 5, 1, 8, 0, 'pendente', NULL, '2025-07-04 21:53:19', '2025-07-17 03:11:09', '1811569832787304', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(25, 2, 'Thiago Moreira', '+5531997663980', 'thiagobr7@yahoo.com.br', '2025-07-04 22:16:40', 1, 1, 2, 0, 'pendente', NULL, '2025-07-04 22:16:44', '2025-07-17 03:11:09', '1443687866834789', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(26, 2, 'Vitor Martins', '+553184205959', 'Vitinhofernando2018@gmail.com', '2025-07-04 23:41:12', 5, 1, 8, 0, 'pendente', NULL, '2025-07-04 23:41:19', '2025-07-17 03:11:09', '1817107555869460', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(27, 2, 'Edinilton soares de moura', '+553194899517', 'ediniltonm@yahoo.com.br', '2025-07-05 01:04:12', 4, 1, 4, 0, 'pendente', NULL, '2025-07-05 01:04:17', '2025-07-17 03:11:09', '1940737353332819', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(28, 2, 'Alessandra Reginapereira', '+5531987794925', 'alerepereira@gmail.com', '2025-07-05 01:13:39', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 01:13:44', '2025-07-17 03:11:09', '1106852154625620', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(29, 2, 'José de Alencar Machado', '+553175010857', 'josealencarm@gmail.com', '2025-07-05 02:11:58', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 02:12:03', '2025-07-17 03:11:09', '9951369781579580', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(30, 2, 'Thamara Canavesio', '+5531991887636', 'thamaracanavesio@gmail.com', '2025-07-05 03:42:13', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 03:42:19', '2025-07-17 03:11:09', '3642227329414935', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(31, 2, 'Silvana A. Schmidt', '+5531998395512', 'silvanaschmidt97@gmail.com', '2025-07-05 05:30:34', 4, 1, 4, 0, 'pendente', NULL, '2025-07-05 05:30:39', '2025-07-17 03:11:09', '731129829868111', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(32, 2, 'Adrian Alexandre', '+5531992267957', 'adrianalexandre2850@gmail.com', '2025-07-05 09:57:48', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 09:57:52', '2025-07-17 03:11:09', '1122701209886922', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(33, 2, 'Gleyciane Valeriana Cardoso Costa', '+5531992099758', 'gleycianevcosta@yahoo.com.br', '2025-07-05 14:41:16', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 14:41:22', '2025-07-17 03:11:09', '1089187719819093', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(34, 2, '𝓙𝓮𝓪𝓷 𝓖𝓪𝓫𝓻𝓲𝓮𝓵', '+5531991189097', 'jeangt2001@gmail.com', '2025-07-05 15:04:00', 6, 1, 6, 0, 'pendente', NULL, '2025-07-05 15:04:05', '2025-07-17 03:11:09', '1952951012202970', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(35, 2, 'Joana Chellini', '+5531999215517', 'joana.chellini@hotmail.com', '2025-07-05 15:37:44', 6, 1, 6, 0, 'pendente', NULL, '2025-07-05 15:37:48', '2025-07-17 03:11:09', '1250292719344508', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(36, 2, 'Drielly', '+5531984306560', 'drysoraia23@gmail.com', '2025-07-05 16:20:38', 6, 1, 6, 0, 'pendente', NULL, '2025-07-05 16:20:43', '2025-07-17 03:11:09', '1045481077745485', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(37, 2, 'Maria Lucia', '+5531987342489', 'ml014028@gmail.com', '2025-07-05 16:22:51', 6, 1, 6, 0, 'pendente', NULL, '2025-07-05 16:22:55', '2025-07-17 03:11:09', '715673158016547', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(38, 2, 'Joelma Nunes', '+5531992888027', 'ohane@terra.com.br', '2025-07-05 16:27:42', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 16:27:46', '2025-07-17 03:11:09', '607216731975085', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(39, 2, 'Marlon Cristiam', '+5531975286642', 'marloncristiam@yahoo.com.br', '2025-07-05 17:48:07', 4, 1, 4, 0, 'pendente', NULL, '2025-07-05 17:48:13', '2025-07-17 03:11:09', '713021958285328', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(40, 2, 'Jaine Alecrim', '+553189643319', 'Jainealecrimp@gmail.com', '2025-07-05 18:35:13', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 18:35:18', '2025-07-17 03:11:09', '1461418991540245', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(41, 2, 'Manoel Marinho', '+5531996822208', 'aconel.manoel@gmail.com', '2025-07-05 20:06:22', 3, 1, 2, 0, 'pendente', NULL, '2025-07-05 20:06:28', '2025-07-17 03:11:09', '1251532639939280', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(42, 2, 'geraldo malaquias', '+5531996184684', 'geraldob17@hotmail.com', '2025-07-05 22:16:17', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 22:16:21', '2025-07-17 03:11:09', '1443779086796363', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(43, 2, 'Paulo Pena', '+5531987381693', 'penaalbano@gmail.com', '2025-07-05 22:46:40', 5, 1, 8, 0, 'pendente', NULL, '2025-07-05 22:46:45', '2025-07-17 03:11:09', '736686472343305', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(44, 2, 'Josiane Nicomedes Gomes Costa', '+5531989876720', 'josianengc0704@gmail.com', '2025-07-06 02:05:56', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 02:06:01', '2025-07-17 03:11:09', '1421818785691882', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(45, 2, 'Luciana Fortes', '+5531987477562', 'lucianaofortes43@gmail.com', '2025-07-06 02:09:31', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 02:09:37', '2025-07-17 03:11:09', '717905011117045', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(46, 2, 'Joao Marcos', '+553193009109', 'joaomarcosusa@outlook.com', '2025-07-06 03:29:51', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 03:29:56', '2025-07-17 03:11:09', '1422614972408079', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(47, 2, 'Geovani Cruz', '+5531997524029', 'goncalvesgeovani@yahoo.com', '2025-07-06 12:10:44', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 12:10:48', '2025-07-17 03:11:09', '643240304729802', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(48, 2, 'Débora Dede Gomes', '+5531994590792', 'deboragomesserafim2@gmail.com', '2025-07-06 12:45:05', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 12:45:11', '2025-07-17 03:11:09', '4258495684472649', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(49, 2, 'Carlos Magno Goulart', '+5531988883351', 'carlosmgoulart17@gmail.com', '2025-07-06 13:42:58', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 13:43:05', '2025-07-17 03:11:09', '733603242485500', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(50, 2, 'weverton evaristo de jesus', '+5531987574438', 'wevertonevaristo112@gmail.com', '2025-07-06 14:41:15', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 14:41:22', '2025-07-17 03:11:09', '1454695642212091', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(51, 2, 'Patrick Menezes', '+5531993946068', 'patrickdmenezes@hotmail.com', '2025-07-06 15:22:30', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 15:22:35', '2025-07-17 03:11:09', '1122423999791315', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(52, 2, 'hesdra haianny', '+5531975082623', 'haiannyhesdra@gmail.com', '2025-07-06 16:09:13', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 16:09:19', '2025-07-17 03:11:09', '1452695965752097', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(53, 2, 'Nilcemar Fernandes', '+5531998212075', 'nlfernandes61@gmail.com', '2025-07-06 16:47:03', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 16:47:07', '2025-07-17 03:11:09', '1102060171817586', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(54, 2, 'Cleide Mendes Malta', '+5531995006197', 'cleidemm.57@gmail.com', '2025-07-06 16:58:58', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 16:59:04', '2025-07-17 03:11:09', '4253845848236030', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(55, 2, 'Mauricio Rodriguez', '+5531994947038', 'mauriciorodriguesrs7@gmail.com', '2025-07-06 17:31:11', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 17:31:16', '2025-07-17 03:11:09', '590271974152647', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(56, 2, 'Camilla Martins', '+5531998112305', 'camillabizu@hotmail.com', '2025-07-06 17:46:53', 4, 1, 4, 0, 'pendente', NULL, '2025-07-06 17:46:58', '2025-07-17 03:11:09', '1368273294263253', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(57, 2, 'Celso', '+5531986941321', 'celsosoares149@gmail.com', '2025-07-06 17:58:27', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 17:58:31', '2025-07-17 03:11:09', '1070149958029534', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(58, 2, 'Eryksson Souza', '+5531971284465', 'eryksson.souza@gmail.com', '2025-07-06 19:15:04', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 19:15:09', '2025-07-17 03:11:09', '765018729217179', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(59, 2, 'Jefinho', '+5531996122356', 'Jefinho_pim@hotmail.com', '2025-07-06 19:37:09', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 19:37:13', '2025-07-17 03:11:09', '1638598554076620', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(60, 2, 'Marcello Conde', '+553185489009', 'condeleao@hotmail.com', '2025-07-06 21:07:30', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 21:07:37', '2025-07-17 03:11:09', '1280854553617026', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(61, 2, 'Erica carla de Souza', '+553172167428', 'erica.s.medicina@gmail.com', '2025-07-06 21:11:02', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 21:11:08', '2025-07-17 03:11:09', '1247979746555321', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(62, 2, 'Enio M. Cabral Junior', '+5531987638495', 'eniocabraljunior@hotmail.com', '2025-07-06 21:56:50', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 21:56:57', '2025-07-17 03:11:09', '1432432627956584', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(63, 2, 'Angelita Martins', '+5531996392758', 'martinsangelita@hotmail.com', '2025-07-06 22:05:17', 4, 1, 4, 0, 'pendente', NULL, '2025-07-06 22:05:22', '2025-07-17 03:11:09', '3865852330225322', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(64, 2, 'Edvaldo Barbosa', '+5531984310061', 'edivaldobarbosadireito@yahoo.com.br', '2025-07-06 22:16:21', 5, 1, 8, 0, 'pendente', NULL, '2025-07-06 22:16:25', '2025-07-17 03:11:09', '31041142405529637', '1299695773996064', '108038728224299', 'Teste — Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano IMG', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(65, 2, 'Luiz Gustavo Abreu', '+5531993531886', 'luizgustavoabreumeire@gmail.com', '2025-07-06 22:16:43', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 22:16:48', '2025-07-17 03:11:09', '762237913158060', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(66, 2, 'Iratan Da Costa Correia', '+5531985717699', 'irarancosta@gmail.com', '2025-07-06 22:26:06', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 22:26:19', '2025-07-17 03:11:09', '733062776330647', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(67, 2, 'Adao Monge', '+5531994177728', 'adaomonge8@gmail.com', '2025-07-06 22:32:36', 3, 1, 2, 0, 'pendente', NULL, '2025-07-06 22:32:40', '2025-07-17 03:11:09', '23899542546400412', '1299695773996064', '108038728224299', 'Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]', 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(68, 2, 'Maria Paula', '31988882249', 'mariapaulabh66@gmail.com', '2025-07-06 23:18:24', 6, 1, 6, 0, 'pendente', NULL, '2025-07-06 23:18:30', '2025-07-17 03:11:09', '746807331236917', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(69, 2, 'Maria Carmo Teixeira', '+5531996337914', 'mariajuliateixeira@yahoo.com.br', '2025-07-07 00:09:45', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 00:09:50', '2025-07-17 03:11:09', '1682396166483627', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(70, 2, 'Brayanne Nascimento', '+5531993003654', 'brayanneaguiar@icloud.com', '2025-07-07 00:27:17', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 00:27:20', '2025-07-17 03:11:09', '1080870724138946', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(71, 2, 'Anna', '+5531989564980', 'paulatdlt@gmail.com', '2025-07-07 00:42:04', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 00:42:08', '2025-07-17 03:11:09', '742134235430013', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(72, 2, 'Monica Santos Pimenta', '+5531993409437', 'monica70pimenta@hotmail.com', '2025-07-07 01:13:08', 4, 1, 4, 0, 'pendente', NULL, '2025-07-07 01:13:14', '2025-07-17 03:11:09', '1075195417913617', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(73, 2, 'Glauber Alonso', '+5531991791010', 'glauber3g@hotmail.com', '2025-07-07 09:32:38', 1, 1, 2, 0, 'pendente', NULL, '2025-07-07 09:32:43', '2025-07-17 03:11:09', '757015623365967', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(74, 2, 'Gonçalves', '+5531982824206', 'waterloogoncalves0@gmail.com', '2025-07-07 11:24:00', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 11:24:06', '2025-07-17 03:11:09', '1280491033678321', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, NULL, 0, NULL, NULL, NULL, NULL, 0),
(75, 2, 'Brenda Souza', '+5531995243129', 'Brenda.fabrine11@gmail.com', '2025-07-07 16:40:10', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 16:40:14', '2025-07-17 03:11:09', '664823329928557', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(76, 2, 'Kimberly Nayara', '+5531993241336', 'kim170415@gmail.com', '2025-07-07 18:27:08', 6, 1, 6, 0, 'pendente', NULL, '2025-07-07 18:27:12', '2025-07-17 03:11:09', '1031559495436909', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, NULL, 0, NULL, NULL, NULL, NULL, 0),
(77, 2, 'Celio Trindade', '+5531984773396', 'celiojunior@facecolor.com.br', '2025-07-08 01:17:06', 1, 1, 2, 0, 'pendente', NULL, '2025-07-08 01:17:11', '2025-07-17 03:11:09', '734933319081731', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 1, NULL, 0, NULL, NULL, NULL, NULL, 0),
(78, 2, 'Emerson Fernandes', '+553135770650', 'emerson.fernandes@ciser.com.br', '2025-07-08 01:46:09', 4, 1, 4, 0, 'pendente', NULL, '2025-07-08 01:46:14', '2025-07-17 03:11:09', '704341412375075', '1299695773996064', '108038728224299', 'Pampulha 8km ADVANTAGE', 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(79, 2, 'Diego de Brito', '+553193068943', 'Primal.earth@gmail.com', '2025-07-08 02:33:21', 6, 1, 4, 0, 'pendente', NULL, '2025-07-08 02:33:26', '2025-07-17 03:11:09', '2176197602900137', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(80, 2, 'Manoel Santos', '+5531983013652', 'santosmanoel1968@gmail.com', '2025-07-08 03:35:44', 6, 1, 4, 0, 'pendente', NULL, '2025-07-08 03:35:50', '2025-07-17 03:11:09', '1462933018173196', '1299695773996064', '108038728224299', 'Terramaris Vespasiano', '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(81, 2, 'Carlucio Pereira Batista', '+553899868750', 'carluciopereirabatista@hotmail.com', '2025-07-08 21:45:43', 1, 1, 2, 0, 'pendente', NULL, '2025-07-08 21:45:47', '2025-07-17 03:11:09', '1069696131328776', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(82, 2, 'Renovar Veiculos', '+5531999411576', 'brigadeiroveiculos@gmail.com', '2025-07-08 23:10:31', 1, 1, 2, 0, 'pendente', NULL, '2025-07-08 23:10:37', '2025-07-17 03:11:09', '1285703953065188', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(83, 2, 'Gabriel Felipe', '+553189025616', 'aparecidapoliana23@gmail.com', '2025-07-09 08:51:15', 1, 1, 2, 0, 'pendente', NULL, '2025-07-09 08:51:20', '2025-07-17 03:11:09', '23874787198796958', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(84, 2, 'Paola Rettore', '+5531998712414', 'paola@paolarettore.com', '2025-07-09 11:04:41', 1, 1, 2, 0, 'pendente', NULL, '2025-07-09 11:04:46', '2025-07-17 03:11:09', '1358672085235473', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(85, 2, 'Gilberto Bueno Bueno', '+5531999853805', 'gilbertoap@hotmail.com', '2025-07-09 16:17:51', 1, 1, 2, 0, 'pendente', NULL, '2025-07-09 16:17:56', '2025-07-17 03:11:09', '1829513227597110', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'fb', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(86, 2, 'João do prumo', '+5575982310148', 'joaozito0726@gmail.com', '2025-07-09 19:29:29', 1, 1, 2, 0, 'pendente', NULL, '2025-07-09 19:29:33', '2025-07-17 03:11:09', '1044978547828146', '1299695773996064', '108038728224299', 'Investidores Alphaville', '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(87, 2, 'Eli Lopes do nascimento', '+5531993394918', 'Elipinturas1@gmail.com.br', '2025-07-10 11:24:18', 1, 1, 2, 0, 'pendente', NULL, '2025-07-10 06:01:52', '2025-07-17 03:11:09', '759377050096212', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(88, 2, 'Felipe Maciel Maciel', '+5531995218588', 'felipetecnicoseguranca@gmail.com', '2025-07-10 17:13:45', 6, 1, 4, 0, 'pendente', NULL, '2025-07-10 09:13:49', '2025-07-17 03:11:09', '999444638782088', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(89, 2, 'walison__oliveira', '+5538999851454', 'walisonbarbosadeoliveira@gmail.com', '2025-07-10 20:39:29', 4, 1, 4, 0, 'pendente', NULL, '2025-07-10 12:39:34', '2025-07-17 03:11:09', '2193542851092464', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(90, 2, 'wille Vinicius zaratini mendes', '+5531995226146', 'wille.zaratini@gmail.com', '2025-07-10 20:41:32', 6, 1, 4, 0, 'pendente', NULL, '2025-07-10 12:41:38', '2025-07-17 03:11:09', '1945425682938505', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(91, 2, 'Nycollas Augusto', '+5531989821243', 'Nycollasaugustofe@gmail.com', '2025-07-11 00:09:53', 6, 1, 4, 0, 'pendente', NULL, '2025-07-10 16:09:57', '2025-07-17 03:11:09', '1096872655645063', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(92, 2, 'Desafio Melhorar De Vida', '+5531995450670', 'gerencci@hotmail.com', '2025-07-11 01:05:44', 1, 1, 2, 0, 'pendente', NULL, '2025-07-10 17:05:49', '2025-07-17 03:11:09', '1467919884647271', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(93, 2, 'André Loureiro', '+5531994152935', 'andrebh14@gmail.com', '2025-07-11 05:17:44', 4, 1, 4, 0, 'pendente', NULL, '2025-07-10 21:17:49', '2025-07-17 03:11:09', '1290420549265417', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(94, 2, 'Barbara Flaviano', '+5531971611756', 'barbaraflaviano2320@gmail.com', '2025-07-11 06:36:15', 6, 1, 4, 0, 'pendente', NULL, '2025-07-10 22:36:20', '2025-07-17 03:11:09', '1770951334302433', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(95, 2, 'Hélio Amândula', '+5531996276374', 'helioamandula@yahoo.com.br', '2025-07-11 08:02:44', 4, 1, 4, 0, 'pendente', NULL, '2025-07-11 00:02:49', '2025-07-17 03:11:09', '747992460980270', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 1, NULL, NULL, NULL, NULL, 0),
(96, 2, 'Claret Laurente Sabioni', '+5531983320101', 'claretls@gmail.com', '2025-07-11 08:03:37', 1, 1, 2, 0, 'pendente', NULL, '2025-07-11 00:03:42', '2025-07-17 03:11:09', '1027959799320314', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(97, 2, 'Daniel Silva', '+5531971185223', 'danielsilvasantos714@gmail.com', '2025-07-11 09:25:59', 4, 1, 4, 0, 'pendente', NULL, '2025-07-11 01:26:04', '2025-07-17 03:11:09', '713779268129115', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 1, NULL, 1, NULL, '2025-07-11 20:43:26', NULL, NULL, 0),
(98, 2, 'Luiz Carlos Pujoni Pujoni', '+553191102567', 'luiz-pujoni@hotmail.com', '2025-07-11 23:36:02', 6, 1, 1, 0, 'pendente', NULL, '2025-07-11 15:36:09', '2025-07-17 03:11:09', '2835733463425155', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, NULL, 0, NULL, '2025-07-11 17:40:28', NULL, NULL, 0),
(99, 2, 'Suellen Aguiar', '+5531982511205', 'contatosuellenjaguiar@gmail.com', '2025-07-12 09:37:37', 4, 1, 4, 0, 'pendente', NULL, '2025-07-12 01:37:42', '2025-07-17 03:11:09', '4068366266823977', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(100, 2, 'Ana Silva', '31996396745', 'ana.silva@teste.com', '2025-07-12 11:27:00', 10, 1, 1, 0, 'pendente', NULL, '2025-07-12 03:27:00', '2025-07-17 03:11:09', '', '', '', NULL, 'Anúncio Teste', '', '', '', 1, NULL, 0, NULL, '2025-07-12 14:28:16', NULL, '3EB0561F64BBE7A9ED26E0', 0),
(101, 2, 'Paulo Lima', '31996845708', 'paulo.lima@teste.com', '2025-07-12 11:28:59', 10, 1, 1, 0, 'pendente', NULL, '2025-07-12 03:28:59', '2025-07-17 03:11:09', '', '', '', NULL, 'Anúncio Teste', '', '', '', 1, NULL, 0, NULL, '2025-07-12 14:21:43', NULL, '3EB0FF3E547E8FF73A629E', 0),
(102, 2, 'Rober Brier', '+5531996351902', 'rbrierleite@gmail.com', '2025-07-12 17:05:40', 4, 1, 4, 0, 'pendente', NULL, '2025-07-12 09:05:45', '2025-07-17 03:11:09', '747020407857646', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(103, 2, 'Kettlyn Vitória', '+5531984100346', 'kettlynvitoriasfernandesr@gmail.com', '2025-07-12 18:57:15', 4, 1, 2, 0, 'pendente', NULL, '2025-07-12 10:57:19', '2025-07-17 03:11:09', '1180178840791577', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 1, NULL, 0, NULL, '2025-07-12 14:07:54', NULL, '3EB0D6EE906FA4CE7A67A1', 0),
(104, 2, 'Cátia Cardilo', '+5531996029006', 'catia.cardilo@educacao.mg.gov.br', '2025-07-12 20:27:09', 4, 1, 4, 3, 'pendente', NULL, '2025-07-12 12:27:12', '2025-07-17 03:11:09', '1451323842842115', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 1, NULL, 0, NULL, '2025-07-12 14:01:10', NULL, '3EB0E28B95BBAA71719A01', 0),
(105, 2, 'Isabella Nascimento', '+5531973524772', 'isabela2241ramos@icloud.com', '2025-07-12 22:19:29', 6, 1, 6, 0, 'pendente', NULL, '2025-07-12 14:19:34', '2025-07-17 03:11:09', '24052474764405020', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(106, 2, 'Lucas Silva', '+5531914269484', 'lucas.silva@teste.com', '2025-07-12 23:20:52', 10, 1, 1, 3, 'pendente', NULL, '2025-07-12 15:20:52', '2025-07-17 03:11:09', 'SIMULADO_4097922397', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 1, '2025-07-15 03:28:54', 0, 'desqualificado', '2025-07-15 03:29:49', NULL, '3EB0A77C3EC66ACC63B523', 0),
(107, 2, 'Suziane Reis Assunção', '+5531982601344', 'suziholanda467@gmail.com', '2025-07-12 23:28:46', 6, 1, 6, 0, 'pendente', NULL, '2025-07-12 15:28:51', '2025-07-17 03:11:09', '2083450655517959', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(108, 2, 'João Pedro Ferreira', '+5531982607153', 'jppepeu03@gmail.com', '2025-07-12 23:29:44', 6, 1, 6, 0, 'pendente', NULL, '2025-07-12 15:29:49', '2025-07-17 03:11:09', '764782292787724', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(109, 2, 'Tadeu Camargos', '+553196325073', 'tadeucoelho10@gmail.com', '2025-07-13 01:12:44', 3, 1, 3, 0, 'pendente', NULL, '2025-07-12 17:12:51', '2025-07-17 03:11:09', '1041677478033718', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(110, 2, 'Ademir Meireles Barroso', '+351968523054', 'meirelesademir@gmail.com', '2025-07-13 02:07:37', 3, 1, 3, 0, 'pendente', NULL, '2025-07-12 18:07:41', '2025-07-17 03:11:09', '1756020585043823', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(111, 2, 'Jac Couto', '+5531975436111', 'jacsgtpm@gmail.com', '2025-07-13 05:05:29', 3, 1, 2, 0, 'pendente', NULL, '2025-07-12 21:05:33', '2025-07-17 03:11:09', '762542086194528', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(112, 2, 'Afrânio', '+5531986703558', 'afranio_henrique@hotmail.com', '2025-07-13 06:02:33', 4, 1, 4, 0, 'pendente', NULL, '2025-07-12 22:02:39', '2025-07-17 03:11:09', '744587391294691', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(113, 2, 'Elaine Barros', '+5531973441026', 'elainegbarros81@gmail.com', '2025-07-13 09:25:32', 6, 1, 6, 0, 'pendente', NULL, '2025-07-13 01:25:36', '2025-07-17 03:11:09', '1460617592041364', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(114, 2, 'André Ícaro', '+5531982414408', 'andre.icaro@yahoo.com.br', '2025-07-13 09:37:34', 1, 1, 3, 0, 'pendente', NULL, '2025-07-13 01:37:40', '2025-07-17 03:11:09', '717606414225865', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(115, 2, 'Ana Lima', '+5531923459068', 'ana.lima@teste.com', '2025-07-13 10:57:52', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 02:57:52', '2025-07-17 03:11:09', 'SIMULADO_3175766611', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(116, 2, 'Fernanda Alves', '+5531919669782', 'fernanda.alves@teste.com', '2025-07-13 03:42:32', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 03:42:32', '2025-07-17 03:11:09', 'SIMULADO_7234141921', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(117, 2, 'Carlos Teste', '+5531999999999', 'teste@lead.com', '2025-07-13 03:49:45', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 03:49:45', '2025-07-17 03:11:09', 'SIMULADO_692617', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(118, 2, 'Simulado 750', '+5531993076761', 'simulado.750@teste.com', '2025-07-13 03:54:32', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 03:54:32', '2025-07-17 03:11:09', 'SIMULADO_7388755', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(119, 2, 'Simulado 657', '+5531992312294', 'simulado.657@teste.com', '2025-07-13 03:55:03', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 03:55:03', '2025-07-17 03:11:09', 'SIMULADO_9900607', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(120, 2, 'Simulado 312', '+5531998748638', 'simulado.312@teste.com', '2025-07-13 04:01:29', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:01:29', '2025-07-17 03:11:09', 'SIMULADO_1694647', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(121, 2, 'Simulado 205', '+5531991296740', 'simulado.205@teste.com', '2025-07-13 04:01:33', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:01:33', '2025-07-17 03:11:09', 'SIMULADO_9321903', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(122, 2, 'Simulado 269', '+5531995233038', 'simulado.269@teste.com', '2025-07-13 04:04:51', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:04:51', '2025-07-17 03:11:09', 'SIMULADO_5491470', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(123, 2, 'Simulado 741', '+5531995232602', 'simulado.741@teste.com', '2025-07-13 04:04:59', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:04:59', '2025-07-17 03:11:09', 'SIMULADO_7769816', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(124, 2, 'Simulado 350', '+5531995519095', 'simulado.350@teste.com', '2025-07-13 04:06:05', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:06:05', '2025-07-17 03:11:09', 'SIMULADO_7122979', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(125, 2, 'Simulado 297', '+5531992724734', 'simulado.297@teste.com', '2025-07-13 04:08:43', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 04:08:43', '2025-07-17 03:11:09', 'SIMULADO_5660987', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(126, 2, 'Simulado 718', '+5531994372284', 'simulado.718@teste.com', '2025-07-13 04:13:21', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 04:13:21', '2025-07-17 03:11:09', 'SIMULADO_7488380', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(127, 2, 'Simulado 729', '+5531998767661', 'simulado.729@teste.com', '2025-07-13 05:44:59', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 05:44:59', '2025-07-17 03:11:09', 'SIMULADO_6588746', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(128, 2, 'Fernanda Fernandes', '+5531935369096', 'fernanda.fernandes@teste.com', '2025-07-13 05:47:26', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 05:47:26', '2025-07-17 03:11:09', 'SIMULADO_479721457', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(129, 2, 'Fernanda Oliveira', '+5531967274971', 'fernanda.oliveira@teste.com', '2025-07-13 06:34:40', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 06:34:40', '2025-07-17 03:11:09', 'SIMULADO_2392322863', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(130, 2, 'Janaína Teste', '+5531922848506', 'ajanaina@teste.com', '2025-07-13 06:36:38', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 06:36:38', '2025-07-17 03:11:09', 'SIMULADO_2528361912', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(131, 2, 'Paulo Oliveira', '+5531917047648', 'paulo.oliveira@teste.com', '2025-07-13 06:46:34', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 06:46:34', '2025-07-17 03:11:09', 'SIMULADO_9308214529', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(132, 2, 'Teste Carlos Souza', '+5531970239255', 'testecarlos.souza@teste.com', '2025-07-13 06:46:55', 10, 1, 1, 0, 'pendente', NULL, '2025-07-13 06:46:55', '2025-07-17 03:11:09', 'SIMULADO_8492194514', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(133, 2, 'Janete Mendes', '+5531972109961', 'hair.batom.mendes@gmail.com', '2025-07-13 13:08:22', 3, 1, 2, 0, 'pendente', NULL, '2025-07-13 13:08:22', '2025-07-17 03:11:09', '729478039826950', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(134, 2, 'Thales', '+5531982725766', 'thallesars2@hormail.com', '2025-07-13 14:08:52', 3, 1, 3, 0, 'pendente', NULL, '2025-07-13 14:08:52', '2025-07-17 03:11:09', '730098353051768', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(135, 2, 'Walker Rosa', '+5531995512650', 'xcontrolconsultoria@gmail.com', '2025-07-13 14:20:53', 1, 1, 2, 0, 'pendente', NULL, '2025-07-13 14:20:53', '2025-07-17 03:11:09', '2716535535404790', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0);
INSERT INTO `leads_recebidos` (`id`, `empresa_id`, `nome_cliente`, `telefone_cliente`, `email_cliente`, `data_recebido`, `conjunto_id`, `campanha_id`, `corretor_id`, `status`, `status_envio`, `whatsapp_status`, `created_at`, `updated_at`, `lead_id`, `form_id`, `pagina_id`, `adset_nome`, `anuncio_nome`, `plataforma`, `veiculo`, `campanha_nome`, `whatsapp_enviado`, `data_envio_whatsapp`, `enviado_whatsapp`, `resposta_contato`, `data_contato`, `message_id_enviado`, `zapi_message_id`, `tentativas_contato`) VALUES
(136, 2, 'Otávio Alcântara Bernardes', '+5531991795075', 'otavio.ibc@gmail.com', '2025-07-13 15:08:41', 3, 1, 4, 0, 'pendente', NULL, '2025-07-13 15:08:41', '2025-07-17 03:11:09', '1382236176212072', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(137, 2, 'Joenyo Henrique', '+5531992657310', 'Joenyo.henrique2018@gmail.com', '2025-07-13 15:20:15', 3, 1, 2, 0, 'pendente', NULL, '2025-07-13 15:20:15', '2025-07-17 03:11:09', '728333976674015', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(138, 2, 'TATIANE SANTOS DA SILVA', '+5511997470194', 'tatybudget17@gmail.com', '2025-07-13 16:12:21', 6, 1, 6, 0, 'pendente', NULL, '2025-07-13 16:12:21', '2025-07-17 03:11:09', '2142562372885910', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(139, 2, 'Thaynara Marthins', '+5531981187229', 'tainaramartinsmaps@gmail.com', '2025-07-13 16:35:37', 6, 1, 7, 0, 'pendente', NULL, '2025-07-13 16:35:37', '2025-07-17 03:11:09', '1456064878848122', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(140, 2, 'Graziela Teodoro', '+5531993764829', 'grazi.teodoro@yahoo.com.br', '2025-07-13 20:07:38', 6, 1, 8, 0, 'pendente', NULL, '2025-07-13 20:07:38', '2025-07-17 03:11:09', '1953145742118601', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(141, 2, 'GUERREIRO DE CRISTO', '+5531989646311', 'alipiodelimagiovanni@gmail.com', '2025-07-13 20:33:04', 4, 1, 4, 0, 'pendente', NULL, '2025-07-13 20:33:04', '2025-07-17 03:11:09', '1246202356968204', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(142, 2, 'Paulo Lima', '+5531964314437', 'paulo.lima@teste.com', '2025-07-13 20:41:50', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 20:41:50', '2025-07-17 03:11:09', 'SIMULADO_7951868265', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(143, 2, 'Paulo Souza', '+5531976821487', 'paulo.souza@teste.com', '2025-07-13 20:48:24', 10, 1, 9, 0, 'pendente', NULL, '2025-07-13 20:48:24', '2025-07-17 03:11:09', 'SIMULADO_6043837551', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(144, 2, 'Elisena Leao', '+5531999732800', 'li.leao@yahoo.com.br', '2025-07-13 22:55:04', 6, 1, 8, 0, 'pendente', NULL, '2025-07-13 22:55:04', '2025-07-17 03:11:09', '699901546372659', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(145, 2, 'José Carlos', '+5531986643606', 'gabriel10carlos@hotmail.com', '2025-07-13 23:11:25', 6, 1, 5, 0, 'pendente', NULL, '2025-07-13 23:11:25', '2025-07-17 03:11:09', '3135040709996926', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(146, 2, 'Pedro Henrique', '+553171270342', 'Caldascaldaspedro@gmail.com', '2025-07-13 23:27:46', 6, 1, 6, 0, 'pendente', NULL, '2025-07-13 23:27:46', '2025-07-17 03:11:09', '1777153560351429', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(147, 2, 'Fabio Santos Nogueira', '+5531994445564', 'santosnogueirafabio4@gmail.com', '2025-07-13 23:55:48', 4, 1, 4, 0, 'pendente', NULL, '2025-07-13 23:55:48', '2025-07-17 03:11:09', '4051666234979584', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(148, 2, 'Charlene Souza', '+5531985775007', 'charlene.souza34@gmail.com', '2025-07-14 00:05:04', 6, 1, 7, 0, 'pendente', NULL, '2025-07-14 00:05:04', '2025-07-17 03:11:09', '717578704414025', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(149, 2, 'Sonia Marcia De Oliveira', '+553198050266', 'soniadonizete525@gmail.com', '2025-07-14 00:06:04', 4, 1, 2, 0, 'pendente', NULL, '2025-07-14 00:06:04', '2025-07-17 03:11:09', '1292173149145236', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(150, 2, 'Tiquitos Kids', '+5531991307533', 'ranyerreynar@gmail.com', '2025-07-14 00:38:46', 3, 1, 3, 0, 'pendente', NULL, '2025-07-14 00:38:46', '2025-07-17 03:11:09', '750817163985699', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(151, 2, 'André Max', '+5531996084108', 'andre7max@gmail.com', '2025-07-14 01:10:33', 3, 1, 4, 0, 'pendente', NULL, '2025-07-14 01:10:33', '2025-07-17 03:11:09', '3224575767690800', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'fb', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(152, 2, 'Paulo Silva', '+5513996492367', 'estudos.oficial2024@gmail.com', '2025-07-14 01:31:38', 3, 1, 2, 0, 'pendente', NULL, '2025-07-14 01:31:38', '2025-07-17 03:11:09', '1245579410050753', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(153, 2, 'Regina Ap Ribeiro', '+5531986202663', 'reginabio61@gmail.com', '2025-07-14 01:48:23', 6, 1, 8, 0, 'pendente', NULL, '2025-07-14 01:48:23', '2025-07-17 03:11:09', '1416179116332646', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(154, 2, 'Marcos Teste da  Silva', '+5531949951955', 'marcosteste.silva@teste.com', '2025-07-14 03:19:51', 10, 1, 1, 0, 'pendente', NULL, '2025-07-14 03:19:51', '2025-07-17 03:11:09', 'SIMULADO_431844462', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(155, 2, 'Sonia Paixão', '+5531997874711', 'sonia_ma2@hotmail.com', '2025-07-14 03:30:31', 6, 1, 5, 0, 'pendente', NULL, '2025-07-14 03:30:31', '2025-07-17 03:11:09', '1248964776695450', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(156, 2, 'João Eduardo Silva Júnior', '+5531991198488', 'joao.e.s.junior@hotmail.com', '2025-07-14 04:29:21', 3, 1, 3, 0, 'pendente', NULL, '2025-07-14 04:29:21', '2025-07-17 03:11:09', '1643731496491080', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(157, 2, 'Davi Guilherme Dos Santos', '+5531983796646', 'daviguiestudos@gmail.com', '2025-07-14 19:41:55', 4, 1, 4, 0, 'pendente', NULL, '2025-07-14 19:41:55', '2025-07-17 03:11:09', '1956131095156250', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(158, 2, 'Carlos Oliveira', '+5531931632433', 'carlos.oliveira@teste.com', '2025-07-14 21:28:15', 10, 1, 1, 3, 'pendente', NULL, '2025-07-14 21:28:15', '2025-07-17 03:11:09', 'SIMULADO_1736502095', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 1, '2025-07-14 23:22:04', 0, 'desqualificado', '2025-07-14 23:23:14', NULL, '3EB019DBCCC72220E247A2', 0),
(159, 2, 'Paulo Lima', '+5531921242726', 'paulo.lima@teste.com', '2025-07-14 21:35:30', 10, 1, 9, 1, 'pendente', NULL, '2025-07-14 21:35:30', '2025-07-17 03:11:09', 'SIMULADO_9058635471', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 1, '2025-07-16 20:00:02', 0, NULL, NULL, NULL, '3EB0EAFB6DF34038BC06F2', 5),
(160, 2, 'Danilo Paidha', '+5521985398931', 'albertodeveloper@gmail.com', '2025-07-14 21:38:25', 1, 1, 1, 1, 'pendente', NULL, '2025-07-14 21:38:25', '2025-07-17 03:11:09', '588631580731654', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 1, '2025-07-14 21:38:25', 0, 'nao-contatado', '2025-07-14 23:20:12', NULL, '3EB0AED1B57D196B0CB6DB', 0),
(161, 2, 'Rafael Cardoso', '+5531991217158', 'rafaelmakio_@hotmail.com', '2025-07-14 21:47:11', 3, 1, 3, 1, 'pendente', NULL, '2025-07-14 21:47:11', '2025-07-17 12:26:23', '766869226019122', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'fb', '', 'Cadastros', 1, '2025-07-16 20:00:02', 0, 'nao-contatado', '2025-07-17 12:26:23', NULL, '3EB0FD430C4026ED68B4F8', 5),
(162, 2, 'ÉsobreViver_JuPerdigão', '+5531987136457', 'jusperdigao@gmail.com', '2025-07-14 21:50:56', 6, 1, 5, 2, 'pendente', NULL, '2025-07-14 21:50:56', '2025-07-17 03:11:09', '2222683821519756', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 1, '2025-07-16 15:59:41', 0, 'whatsapp', '2025-07-16 16:35:55', NULL, '3EB0BB659B2E9240563E69', 4),
(163, 2, 'Catia Cecilia Xavier', '+5531988968385', 'catiaceciliadv@yahoo.com.br', '2025-07-15 00:40:37', 6, 1, 6, 1, 'pendente', NULL, '2025-07-15 00:40:37', '2025-07-17 03:11:09', '732543056085975', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 1, '2025-07-16 20:00:01', 0, NULL, NULL, NULL, '3EB050D5BF81020FD8E93C', 5),
(164, 2, 'Marcelo Letro', '+5531997394552', 'marcelletro@hotmail.com', '2025-07-15 01:35:00', 6, 1, 7, 1, 'pendente', NULL, '2025-07-15 01:35:00', '2025-07-17 03:11:09', '2857103967825023', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 1, '2025-07-15 01:35:00', 0, 'nao-contatado', '2025-07-15 01:40:04', NULL, '3EB034DDC1331DA30591E9', 0),
(165, 2, 'Ana Oliveira', '+5531971437022', 'ana.oliveira@teste.com', '2025-07-15 02:02:16', 10, 1, 9, 3, 'pendente', NULL, '2025-07-15 02:02:16', '2025-07-17 03:11:09', 'SIMULADO_7970273450', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 1, '2025-07-15 02:02:16', 0, 'desqualificado', '2025-07-15 02:02:39', NULL, '3EB0316E837E3B8E0CC499', 0),
(166, 2, 'Maria Souza', '+5531934344170', 'maria.souza@teste.com', '2025-07-15 02:22:51', 10, 1, 1, 2, 'pendente', NULL, '2025-07-15 02:22:51', '2025-07-17 03:11:09', 'SIMULADO_484017141', 'form_simulador', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', 'Campanha Simulada', 1, '2025-07-15 02:22:51', 0, 'telefone', '2025-07-15 02:23:03', NULL, '3EB0ACDC4F7D6DBC0745CB', 0),
(167, 2, 'Vinícius Souza', '+5533988163269', 'viniciussouza201909@gmail.com', '2025-07-15 02:59:11', 6, 1, 8, 1, 'pendente', NULL, '2025-07-15 02:59:11', '2025-07-17 03:11:09', '4160879870799197', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 1, '2025-07-15 02:59:11', 0, 'nao-contatado', '2025-07-15 03:02:47', NULL, '3EB0969792D157DEDD0C5F', 0),
(168, 2, 'amonfb', '+5531987578889', 'amonbh@hotmail.com', '2025-07-15 06:12:41', 3, 1, 4, 1, 'pendente', NULL, '2025-07-15 06:12:41', '2025-07-17 03:11:09', '1310119437401973', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-15 15:50:46', 0, 'nao-contatado', '2025-07-15 16:33:31', NULL, '3EB0B000A6F6A918ED1970', 1),
(169, 2, 'Leandro Leo', '+553196234278', 'joleandro2008@gmail.com', '2025-07-15 13:11:12', 6, 1, 5, 1, 'pendente', NULL, '2025-07-15 13:11:12', '2025-07-17 03:11:09', '1123590916256422', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'fb', '', 'Cadastros', 1, '2025-07-15 13:11:12', 0, 'nao-contatado', '2025-07-15 13:27:44', NULL, '3EB034C6C6660922DB70CF', 0),
(170, 2, 'Josiele Cordeiro', '+5531998529610', 'josielemacedo.med@gmail.com', '2025-07-15 13:30:49', 3, 1, 2, 1, 'pendente', NULL, '2025-07-15 13:30:49', '2025-07-17 03:11:09', '605797819247898', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-16 20:00:01', 0, 'nao-contatado', '2025-07-16 22:18:47', NULL, '3EB0907A6BBAE4959E1D9A', 2),
(171, 2, 'Jose Maria De Souza Souza', '+553199055958', 'aacesquadrias@hotmail.com', '2025-07-15 14:46:23', 6, 1, 6, 1, 'pendente', NULL, '2025-07-15 14:46:23', '2025-07-17 19:00:01', '626423049903995', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 1, '2025-07-17 19:00:01', 0, NULL, NULL, NULL, '3EB062DBC89A6BFC6AB5C6', 5),
(172, 2, 'Fernanda Kelly', '+5531993904957', 'fekemartins@icloud.com', '2025-07-15 17:15:47', 3, 1, 3, 1, 'pendente', NULL, '2025-07-15 17:15:47', '2025-07-17 12:27:00', '1245802640558946', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-17 11:00:01', 0, 'nao-contatado', '2025-07-17 12:27:00', NULL, '3EB02A36273AC58435D401', 3),
(173, 2, 'Cael Almeida', '+5531975281276', 'Caelalmeidasw@gmail.com', '2025-07-15 17:17:58', 3, 1, 4, 1, 'pendente', NULL, '2025-07-15 17:17:58', '2025-07-17 03:11:09', '703951805946942', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-15 17:17:58', 0, 'nao-contatado', '2025-07-15 17:30:42', NULL, '3EB0C1865CECFD1AA05127', 0),
(174, 2, 'Mariana Dos Santos Franco', '+5531991987771', 'marifranco10@yahoo.com.br', '2025-07-15 18:02:38', 6, 1, 7, 1, 'pendente', NULL, '2025-07-15 18:02:38', '2025-07-17 03:11:09', '1407797247196317', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-15 18:02:38', 0, 'nao-contatado', '2025-07-15 18:28:07', NULL, '3EB05CA6087288721640D3', 0),
(175, 2, 'Gisele Freitas', '+5561991031399', 'gisaafreitas@hotmail.com', '2025-07-15 18:13:10', 6, 1, 8, 1, 'pendente', NULL, '2025-07-15 18:13:10', '2025-07-17 03:11:09', '617957601336050', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-15 18:13:10', 0, 'nao-contatado', '2025-07-15 18:57:12', NULL, '3EB0C1297E34F4914083FD', 0),
(176, 2, 'Marcelo Junior Raposo Santos', '+13132821656', 'marcelo.mjrs@hotmail.com', '2025-07-15 18:44:15', 6, 1, 5, 3, 'pendente', NULL, '2025-07-15 18:44:15', '2025-07-17 03:11:09', '2134228247062607', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-15 18:44:15', 0, 'desqualificado', '2025-07-15 19:05:32', NULL, '3EB0119FC87EF92FDCEC56', 0),
(177, 2, 'Edgar Maia', '+5531994470433', 'edgar.maia2022@gmail.com', '2025-07-15 18:52:23', 3, 1, 2, 2, 'pendente', NULL, '2025-07-15 18:52:23', '2025-07-17 03:11:09', '1409463830361945', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-15 18:52:24', 0, 'telefone', '2025-07-15 19:55:27', NULL, '3EB0A90B33F1F9E5B3FCC4', 0),
(178, 2, 'Vitalina Julião Juliao', '+5531999648783', 'vitalinajuliao67@gmail.com', '2025-07-15 19:05:49', 6, 1, 6, 1, 'pendente', NULL, '2025-07-15 19:05:49', '2025-07-17 19:00:01', '587817090822005', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-17 19:00:01', 0, NULL, NULL, NULL, '3EB092C03E8D2F64F7CC79', 5),
(179, 2, 'Ricardina Elis', '+5531973423328', 'rikardina03@gmail.com', '2025-07-15 19:12:05', 6, 1, 7, 2, 'pendente', NULL, '2025-07-15 19:12:05', '2025-07-17 03:11:09', '1806984563565137', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-15 19:12:05', 0, 'whatsapp', '2025-07-15 19:20:52', NULL, '3EB0FC799E876B8118491A', 0),
(180, 2, 'Educação é o futuro', '+5531984413006', 'cirleida.aparecida@edu.pbh.gov.br', '2025-07-15 19:31:54', 6, 1, 8, 2, 'pendente', NULL, '2025-07-15 19:31:54', '2025-07-17 03:11:09', '1948415762671312', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-15 19:31:54', 0, 'whatsapp', '2025-07-15 20:21:42', NULL, '3EB0C3F3F5960025FF1BD4', 0),
(181, 2, 'Laço Feliz', '+5531997252216', 'samirassouza@yahoo.com.br', '2025-07-15 20:01:06', 3, 1, 3, 1, 'pendente', NULL, '2025-07-15 20:01:06', '2025-07-17 11:09:04', '1199329571994142', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-17 11:00:01', 0, 'nao-contatado', '2025-07-17 11:09:04', NULL, '3EB0B9671522FF96BE1284', 3),
(182, 2, 'Júlia Rafaele dos anjos', '+5531986945133', 'juliar20braga@gmail.com', '2025-07-15 20:25:54', 6, 1, 5, 1, 'pendente', NULL, '2025-07-15 20:25:54', '2025-07-17 14:25:11', '2488629568163665', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-15 20:25:54', 0, 'nao-contatado', '2025-07-17 14:25:11', NULL, '3EB07F50882FBFC6C512C7', 0),
(183, 2, 'Maxwell Brain', '+5531994555298', 'max.bpg@hotmail.com', '2025-07-15 21:56:26', 6, 1, 6, 1, 'pendente', NULL, '2025-07-15 21:56:26', '2025-07-17 03:11:09', '662254806887853', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-15 21:56:26', 0, 'nao-contatado', '2025-07-16 11:49:05', NULL, '3EB048A3B3BE765068ECBC', 0),
(184, 2, 'Uberlene F Costa', '+5531972273033', 'orquideasvermelhas33@gmail.com', '2025-07-15 21:57:50', 6, 1, 7, 2, 'pendente', NULL, '2025-07-15 21:57:50', '2025-07-17 03:11:09', '1463144118339306', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-16 15:59:40', 0, 'whatsapp', '2025-07-16 16:32:24', NULL, '3EB0C961234D17273227B3', 1),
(185, 2, 'Natália Fernandes', '+5531985067501', 'natty_silva@hotmail.com', '2025-07-15 23:52:17', 3, 1, 4, 1, 'pendente', NULL, '2025-07-15 23:52:17', '2025-07-17 03:11:09', '721549600519848', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-15 23:52:17', 0, 'nao-contatado', '2025-07-16 11:41:20', NULL, '3EB05735E3DE43C1FEACE7', 0),
(186, 2, 'Mery Cristina', '+5531975567067', 'meryodonto@outlook.com', '2025-07-16 00:53:40', 3, 1, 2, 1, 'pendente', NULL, '2025-07-16 00:53:40', '2025-07-17 03:11:09', '756231763483746', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-16 20:00:01', 0, 'nao-contatado', '2025-07-16 22:20:04', NULL, '3EB0BBDB0FB45A7ADDE312', 2),
(187, 2, 'Maria Theresa de Melo', '+5531988861132', 'mariatheresa.melo@gmail.com', '2025-07-16 01:06:33', 6, 1, 8, 1, 'pendente', NULL, '2025-07-16 01:06:33', '2025-07-17 03:11:09', '636900025449952', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-16 01:06:34', 0, 'nao-contatado', '2025-07-16 01:07:00', NULL, '3EB0FF3B2A677D406D119E', 0),
(188, 2, 'Thavison Vilela', '+5531986580732', 'tvilelama@gmail.com', '2025-07-16 02:02:47', 1, 1, 5, 1, 'pendente', NULL, '2025-07-16 02:02:47', '2025-07-17 14:07:28', '1107039347949829', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 1, '2025-07-16 15:59:40', 0, 'nao-contatado', '2025-07-17 14:07:28', NULL, '3EB0966654AC7B48E718A1', 1),
(189, 2, 'Elton Souza', '+5531995899157', 'elton@locsoft.com.br', '2025-07-16 02:14:51', 3, 1, 3, 2, 'pendente', NULL, '2025-07-16 02:14:51', '2025-07-17 15:10:24', '1297601541797058', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-17 15:00:01', 0, 'whatsapp', '2025-07-17 15:10:24', NULL, '3EB03269B76CF6E85C9684', 4),
(190, 2, 'Sergiana Luiza da Rocha', '31984068098', 'sergianaluiza87@gmail.com', '2025-07-16 04:47:03', 6, 1, 5, 3, 'pendente', NULL, '2025-07-16 04:47:03', '2025-07-17 18:26:38', '1844848076148958', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'fb', '', 'Cadastros', 1, '2025-07-16 15:59:40', 0, 'desqualificado', '2025-07-17 18:26:38', NULL, '3EB04D522E83E11539EED7', 1),
(191, 2, 'tales silva #', '+5531991888354', 'talesantonio734@gmail.com', '2025-07-16 11:40:51', 3, 1, 4, 3, 'pendente', NULL, '2025-07-16 11:40:51', '2025-07-17 03:11:09', '2231042340671797', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-16 11:40:51', 0, 'desqualificado', '2025-07-16 11:48:45', NULL, '3EB049DF2FDCDFD4E03392', 0),
(192, 2, 'Rosany Pedra', '+5531973039238', 'rosany.pedrita@gmail.com', '2025-07-16 12:39:44', 6, 1, 6, 1, 'pendente', NULL, '2025-07-16 12:39:44', '2025-07-17 19:00:01', '1267827551399440', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-17 19:00:01', 0, NULL, NULL, NULL, '3EB0241D60CCD0B6FFCDAC', 5),
(193, 2, 'Lamídia de Paula Lima', '+553186506960', 'lamidiaplima@hotmail.com', '2025-07-16 12:58:59', 6, 1, 7, 1, 'pendente', NULL, '2025-07-16 12:58:59', '2025-07-17 03:11:09', '4080918585529826', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-16 20:00:01', 0, 'nao-contatado', '2025-07-16 21:04:27', NULL, '3EB012A524F37BD5B53FA5', 2),
(194, 2, 'Elisania Coutinho', '+5531991694519', 'elisaniacoutinho@gmail.com', '2025-07-16 13:23:48', 6, 1, 8, 2, 'pendente', NULL, '2025-07-16 13:23:48', '2025-07-17 03:11:09', '653493254523310', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-16 15:59:40', 0, 'whatsapp', '2025-07-16 16:10:53', NULL, '3EB0D9CA167512B796303F', 1),
(195, 2, 'Lucas avila', '+5531972488677', 'lucasalklk121280@gmail.com', '2025-07-16 13:30:35', 3, 1, 2, 1, 'pendente', NULL, '2025-07-16 13:30:35', '2025-07-17 03:11:09', '750811230802977', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 1, '2025-07-16 15:59:40', 0, NULL, NULL, NULL, '3EB049E8E3126DA344FE1D', 5),
(196, 2, 'Euzebio Leite', '+5531992642680', 'euzebio.leite1620@gmail.com', '2025-07-16 21:52:24', 1, 1, 2, 1, 'pendente', NULL, '2025-07-16 21:52:24', '2025-07-17 03:11:09', '4028070527433427', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 1, '2025-07-16 21:55:01', 0, 'nao-contatado', '2025-07-16 22:16:21', NULL, '3EB0429FA87F3F99251F0C', 1),
(197, 2, 'Arquimedes Vieira', '+5531995142914', 'arquimedesribeirovieira@hotmail.com', '2025-07-16 21:54:50', 6, 1, 5, 1, 'pendente', NULL, '2025-07-16 21:54:50', '2025-07-17 13:55:48', '1949095422603537', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-17 11:00:01', 0, 'nao-contatado', '2025-07-17 13:55:48', NULL, '3EB0881C4C0D3AAD028255', 2),
(198, 2, 'Ariel Marques Villarroel', '+553197461781', 'arielbfr@hotmail.com', '2025-07-16 23:12:29', 6, 1, 6, 1, 'pendente', NULL, '2025-07-16 23:12:29', '2025-07-18 15:00:01', '2461177654244111', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-18 15:00:01', 0, NULL, NULL, NULL, '3EB01DBE72465A072AA77B', 5),
(199, 2, 'Alessandra Valeria', '+553197898831', 'alessandravaleria38@yahoo.com.br', '2025-07-17 00:53:17', 6, 1, 7, 3, 'pendente', NULL, '2025-07-17 00:53:17', '2025-07-18 21:18:15', '759127523353110', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-17 11:00:01', 0, 'desqualificado', '2025-07-18 21:18:15', NULL, '3EB08624B9D066ABA173EF', 1),
(200, 2, 'Katia Cilene', '+553194938695', 'katiacilenesilvasantos53@gmail.com', '2025-07-17 01:13:27', 6, 1, 8, 1, 'pendente', NULL, '2025-07-17 01:13:27', '2025-07-17 03:11:09', '958922139633423', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 1, '2025-07-17 01:13:27', 0, 'nao-contatado', '2025-07-17 01:20:53', NULL, '3EB0258B92329110C40F3A', 0),
(201, NULL, 'Lucas Amorim', '+5531992768694', 'lucasamorim_b@hotmail.com', '2025-07-17 04:45:53', 3, 1, 3, 0, 'pendente', NULL, '2025-07-17 04:45:53', '2025-07-17 04:45:53', '1855852225339525', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(202, NULL, 'Cliente Teste Empresa 2', '+5531988887777', 'teste.empresa2@exemplo.com', '2025-07-17 05:40:38', NULL, NULL, 1, 0, 'pendente', NULL, '2025-07-17 05:40:38', '2025-07-17 05:40:38', '999999999999999', '1299695773996064', '1122334455667788', NULL, '[Teste] Simulação de Envio de Lead', 'fb', 'simulador', 'Simulação 2025', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(203, NULL, 'Cliente 2 Teste Empresa 2', '+5531988887777', 'teste.empresa2@exemplo.com', '2025-07-17 05:46:06', NULL, NULL, 1, 0, 'pendente', NULL, '2025-07-17 05:46:06', '2025-07-17 05:46:06', '999999999999999', '1299695773996064', '1122334455667788', NULL, '[Teste] Simulação de Envio de Lead', 'fb', 'simulador', 'Simular Lead', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(204, 2, 'Cliente 7 Teste Empresa 2', '+5531988887777', 'teste.empresa2@exemplo.com', '2025-07-17 06:22:41', NULL, NULL, 1, 0, 'pendente', NULL, '2025-07-17 06:22:41', '2025-07-17 06:22:41', '999999999999999', '1299695773996064', '1122334455667788', NULL, '[Teste] Simulação de Envio de Lead', 'fb', 'simulador', 'Simular Lead', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(205, 2, 'Cliente 7 Teste Empresa 2', '+5531988887777', 'teste.empresa2@exemplo.com', '2025-07-17 06:23:18', NULL, NULL, 1, 0, 'pendente', NULL, '2025-07-17 06:23:18', '2025-07-17 06:23:18', '999999999999999', '1299695773996064', '1122334455667788', NULL, '[Teste] Simulação de Envio de Lead', 'fb', 'simulador', 'Simular Lead', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(206, 2, 'Cliente 7 Teste Empresa 2', '+5531988887777', 'teste.empresa2@exemplo.com', '2025-07-17 06:35:36', NULL, NULL, 1, 0, 'pendente', NULL, '2025-07-17 06:35:36', '2025-07-17 06:35:36', '999999999999999', '1299695773996064', '1122334455667788', NULL, '[Teste] Simulação de Envio de Lead', 'fb', 'simulador', 'Simular Lead', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(207, 2, 'Teste', '+553100000000', '00teste00@yahoo.com.br', '2025-07-17 07:29:10', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:29:10', '2025-07-17 07:29:10', '00001', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Teste Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(208, 2, 'Teste', '+553100000000', '00teste00@yahoo.com.br', '2025-07-17 07:29:42', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:29:42', '2025-07-17 07:29:42', '00001', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Teste Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(209, 2, '', '', '', '2025-07-17 07:32:57', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:32:57', '2025-07-17 07:32:57', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(210, 2, '', '', '', '2025-07-17 07:36:08', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:36:08', '2025-07-17 07:36:08', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(211, 2, '', '', '', '2025-07-17 07:38:10', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:38:10', '2025-07-17 07:38:10', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(212, 2, '', '', '', '2025-07-17 07:40:51', 10, 1, 9, 0, 'pendente', NULL, '2025-07-17 07:40:51', '2025-07-17 07:40:51', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, NULL, 0, NULL, NULL, NULL, NULL, 0),
(213, 2, '', '', '', '2025-07-17 07:41:34', 10, 1, 9, 1, 'pendente', NULL, '2025-07-17 07:41:34', '2025-07-17 07:41:34', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, '2025-07-17 07:41:34', 0, NULL, NULL, '3EB0843EBF50AEE0B7651B', NULL, 0),
(214, 2, 'Fernanda Fernandes', '+5531933897625', '', '2025-07-17 07:42:06', 10, 1, 1, 1, 'pendente', NULL, '2025-07-17 07:42:06', '2025-07-17 07:42:06', '999999999999999', '1299695773996064', 'pagina_simulador', NULL, 'Anúncio Teste', 'fb', '', '', 0, '2025-07-17 07:42:06', 0, NULL, NULL, '3EB0D20F420440378DC4C8', NULL, 0),
(215, 2, 'Denisé Fsoarés', '+5531982996315', 'denisefsoares88@gmail.com', '2025-07-17 08:39:19', 6, 1, 5, 1, 'pendente', NULL, '2025-07-17 08:39:19', '2025-07-17 08:39:20', '4035951339976165', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-17 08:39:20', 0, NULL, NULL, '3EB0B1FFF8615EA3600387', NULL, 0),
(216, 2, 'Marcela Ribeiro', '+5531991805772', 'marcelamara1988@hotmail.com', '2025-07-17 09:42:59', 3, 1, 3, 1, 'pendente', NULL, '2025-07-17 09:42:59', '2025-07-17 09:42:59', '600985293063708', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-17 09:42:59', 0, NULL, NULL, '3EB0B706E43113A4B35F43', NULL, 0),
(217, 2, 'Aline Freire Ferranti', '+5531988178947', 'afonali@yahoo.com.br', '2025-07-17 10:24:29', NULL, NULL, 4, 1, 'pendente', NULL, '2025-07-17 10:24:29', '2025-07-18 16:49:07', '1259572982464898', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-18 16:47:37', 0, 'nao-contatado', '2025-07-18 16:49:07', '3EB0C75CC435EFFCBBCBE2', '3EB0BEB9D080422471DE52', 0),
(218, 2, 'Rogesther Mendes', '+5531998159525', 'rogesther2005@yahoo.com.br', '2025-07-17 10:58:15', 3, 1, 4, 1, 'pendente', NULL, '2025-07-17 10:58:15', '2025-07-17 10:58:15', '722129390733918', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-17 10:58:15', 0, NULL, NULL, '3EB08EC6368C33AA1153C0', NULL, 0),
(219, 2, 'Jéssica Dos Santos', '+5531986934788', 'jessicapoliane@yahoo.com.br', '2025-07-17 13:42:24', 6, 1, 6, 1, 'pendente', NULL, '2025-07-17 13:42:24', '2025-07-17 13:42:24', '1083766720355722', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-17 13:42:24', 0, NULL, NULL, '3EB0E7AD9676A34867BF61', NULL, 0),
(220, 2, 'Geysa Ribeiro', '+5527996313002', 'lila-2100@hotmail.com', '2025-07-17 13:55:26', 1, 1, 1, 1, 'pendente', NULL, '2025-07-17 13:55:26', '2025-07-17 13:55:26', '1784347985495796', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-17 13:55:26', 0, NULL, NULL, '3EB0C2CDED50744F376331', NULL, 0),
(221, 2, 'R I C H A R D S O N', '+5531999267852', 'richardson200002@gmail.com', '2025-07-17 14:38:48', 3, 1, 2, 1, 'pendente', NULL, '2025-07-17 14:38:48', '2025-07-17 14:38:48', '1096350545729143', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-17 14:38:48', 0, NULL, NULL, '3EB0FB80BF5C09C925AF59', NULL, 0),
(222, 2, 'Alessandra', '+5531987210607', 'ale23deabril@yahoo.com.br', '2025-07-17 18:41:41', 4, 1, 2, 1, 'pendente', NULL, '2025-07-17 18:41:41', '2025-07-17 18:41:41', '701963199272752', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-17 18:41:41', 0, NULL, NULL, '3EB0C8950BFBC1768B1FB1', NULL, 0),
(223, 2, 'Simone Medeiros', '+5531995855218', 'smfbhz@hotmail.com', '2025-07-17 18:53:41', 6, 1, 7, 1, 'pendente', NULL, '2025-07-17 18:53:41', '2025-07-17 18:53:41', '3332832360199105', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-17 18:53:41', 0, NULL, NULL, '3EB0A9B873913F7832743C', NULL, 0),
(224, 2, 'Yasmin Martins', '+5531971124073', 'yamartins@me.com', '2025-07-17 19:05:58', 6, 1, 8, 1, 'pendente', NULL, '2025-07-17 19:05:58', '2025-07-17 19:05:58', '1352184722971853', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-17 19:05:58', 0, NULL, NULL, '3EB0C7566092B748C39427', NULL, 0),
(225, 2, 'Gonçalves.', '+5531982596652', 'daniellliam513@gmail.com', '2025-07-17 21:01:19', NULL, NULL, 5, 2, 'pendente', NULL, '2025-07-17 21:01:19', '2025-07-18 21:27:36', '4075003326160768', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-18 20:55:01', 0, 'whatsapp', '2025-07-18 21:27:36', '3EB0073F5B5462A8DA58D4', '3EB084569B8996C1D27056', 2),
(226, 2, 'Bárbara', '+5531992572428', 'barbara-flim@hotmail.com', '2025-07-17 21:56:26', NULL, NULL, 7, 1, 'pendente', NULL, '2025-07-17 21:56:26', '2025-07-18 19:07:16', '1715911512649817', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-18 16:50:01', 0, 'nao-contatado', '2025-07-18 19:07:16', '3EB0CC8F7475E9B2C8BEC8', '3EB079B6E2FE97521CD5CC', 1),
(227, 2, 'Gabriel Diniz', '+5531994576094', 'gsousadbeta@gmail.com', '2025-07-17 22:39:54', 3, 1, 3, 1, 'pendente', NULL, '2025-07-17 22:39:54', '2025-07-17 22:39:54', '1248753590122720', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-17 22:39:54', 0, NULL, NULL, '3EB0D05C498C6BBDA8F197', NULL, 0),
(228, 2, 'Aline Rocha', '+5531991642316', 'alinesoseforeu@yahoo.com.br', '2025-07-17 23:06:41', 6, 1, 5, 1, 'pendente', NULL, '2025-07-17 23:06:41', '2025-07-17 23:06:42', '1512127259775041', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-17 23:06:42', 0, NULL, NULL, '3EB04365A6394CCE7BC4A0', NULL, 0),
(229, 2, 'Arthur Pimenta', '+5531997323036', 'arthur-0001@hotmail.com', '2025-07-17 23:40:33', 1, 1, 5, 1, 'pendente', NULL, '2025-07-17 23:40:33', '2025-07-17 23:40:34', '717467971254170', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-17 23:40:34', 0, NULL, NULL, '3EB032091532F8BE9C99D3', NULL, 0),
(230, 2, 'Emilene Silva', '+5531996376383', 'emilene.silvaa@hotmail.com', '2025-07-17 23:47:30', 6, 1, 6, 1, 'pendente', NULL, '2025-07-17 23:47:30', '2025-07-17 23:47:30', '1434858487556780', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-17 23:47:30', 0, NULL, NULL, '3EB064B1875D8062C1FDD3', NULL, 0),
(231, 2, 'Raquel Ramirez', '+5532988972681', 'raquelramirez63@yahoo.com.br', '2025-07-18 00:35:36', 4, 1, 4, 1, 'pendente', NULL, '2025-07-18 00:35:36', '2025-07-18 00:35:36', '1254183509543307', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-18 00:35:36', 0, NULL, NULL, '3EB0BB59E45A95BE1D3349', NULL, 0),
(232, 2, 'Marcos Martins', '+5531987879736', 'marcramones@gmail.com', '2025-07-18 00:37:18', NULL, NULL, 8, 1, 'pendente', NULL, '2025-07-18 00:37:18', '2025-07-18 21:11:20', '528082730327976', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-18 20:50:01', 0, 'nao-contatado', '2025-07-18 21:11:20', '3EB0945B118C4B9A286B34', '3EB01386F7B2D5B5711ACB', 2),
(233, 2, 'Helbert Dos Reis Abdala', '+5531988450975', 'helbertabdala@yahoo.com.br', '2025-07-18 01:17:19', 6, 1, 7, 1, 'pendente', NULL, '2025-07-18 01:17:19', '2025-07-18 01:17:19', '2540272646308377', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-18 01:17:19', 0, NULL, NULL, '3EB0D5758E5A3282F450A1', NULL, 0),
(234, 2, 'Patrícia Bastos', '+5531995354042', 'patricia.csbastos@hotmail.com', '2025-07-18 01:34:42', 1, 1, 2, 1, 'pendente', NULL, '2025-07-18 01:34:42', '2025-07-18 01:34:42', '722487880495608', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-18 01:34:42', 0, NULL, NULL, '3EB02262DA46ABE75B4888', NULL, 0),
(235, 2, 'Yasmim', '+5531986139420', 'aparecida401@gmail.com', '2025-07-18 02:34:06', 4, 1, 2, 1, 'pendente', NULL, '2025-07-18 02:34:06', '2025-07-18 02:34:06', '1853316578546363', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-18 02:34:06', 0, NULL, NULL, '3EB05E106C717A383A6988', NULL, 0),
(236, 2, 'Andre Gomes Carvalhaes', '+5531998375440', 'andrecarvalhaes@hotmail.com', '2025-07-18 03:32:35', 4, 1, 4, 1, 'pendente', NULL, '2025-07-18 03:32:35', '2025-07-18 03:32:36', '1236509927737728', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-18 03:32:36', 0, NULL, NULL, '3EB0C361398F423AA5D48A', NULL, 0),
(237, 2, 'Everaldoalexandrefrade Frade', '+5531992554060', 'everaldoalexandrefrade@gmail.com', '2025-07-18 03:38:59', 3, 1, 4, 1, 'pendente', NULL, '2025-07-18 03:38:59', '2025-07-18 03:38:59', '756823923414423', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 03:38:59', 0, NULL, NULL, '3EB066B28E2BF135A5431A', NULL, 0),
(238, 2, 'Wesley Carvalho', '+5531998569436', 'wleonardocarvalho@gmail.com', '2025-07-18 04:29:19', 3, 1, 2, 1, 'pendente', NULL, '2025-07-18 04:29:19', '2025-07-18 04:29:19', '1231332341614071', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 04:29:19', 0, NULL, NULL, '3EB0CA05E961233AFD6F95', NULL, 0),
(239, 2, 'Margalucia Gonçalves de Souza', '+553192915168', 'margaluciagoncalves@hotmail.com', '2025-07-18 09:30:23', 4, 1, 2, 1, 'pendente', NULL, '2025-07-18 09:30:23', '2025-07-18 09:30:23', '1839979810249749', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 0, '2025-07-18 09:30:23', 0, NULL, NULL, '3EB0DF423A893437F60BF3', NULL, 0),
(240, 2, 'Felipe', '+5531994788406', 'goncalvesfelipe921@gmail.com', '2025-07-18 10:11:24', 11, 1, 4, 1, 'pendente', NULL, '2025-07-18 10:11:24', '2025-07-18 15:01:26', '728870353463897', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-18 15:00:01', 0, 'nao-contatado', '2025-07-18 15:01:26', '3EB07C1CFFA2CDA53386E7', '3EB0AA62707804E93CB991', 1),
(241, 2, 'irinha_oficial', '+553198946179', 'irisfernandes517@gmail.com', '2025-07-18 12:09:49', 4, 1, 4, 1, 'pendente', NULL, '2025-07-18 12:09:49', '2025-07-18 12:09:49', '722400143759092', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-18 12:09:49', 0, NULL, NULL, '3EB0593E7A0E51A0E0D88B', NULL, 0),
(242, 2, 'Marcela Silva', '+5531996609058', 'marceladsmkt@gmail.com', '2025-07-18 12:59:09', 4, 1, 2, 1, 'pendente', NULL, '2025-07-18 12:59:09', '2025-07-18 12:59:09', '1802648667130785', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-18 12:59:09', 0, NULL, NULL, '3EB054218DC92902146FA2', NULL, 0),
(243, 2, 'Patrícia de Souza', '+5531985751796', 'esporteradical44@gmail.com', '2025-07-18 13:02:52', 3, 1, 3, 1, 'pendente', NULL, '2025-07-18 13:02:52', '2025-07-18 13:02:52', '1311164330598201', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 13:02:52', 0, NULL, NULL, '3EB0E793099DDB49F308B0', NULL, 0),
(244, 2, 'Carlos Eduardo Cacá', '+5531997784718', 'cacakes@gmail.com', '2025-07-18 13:35:02', 1, 1, 1, 1, 'pendente', NULL, '2025-07-18 13:35:02', '2025-07-18 13:35:02', '1268245881471168', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-18 13:35:02', 0, NULL, NULL, '3EB0E0944CCC01484E951E', NULL, 0),
(245, 2, 'Ana Andrade', '+5531997233651', 'almav5626@gmail.com', '2025-07-18 15:29:22', 6, 1, 8, 1, 'pendente', NULL, '2025-07-18 15:29:22', '2025-07-18 15:29:23', '706664422208854', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-18 15:29:23', 0, NULL, NULL, '3EB0DD2083E8F7D67542F1', NULL, 0),
(246, 2, 'Simone da Cruz', '+5531993448049', 'simonedacruz2009@hotmail.com', '2025-07-18 18:03:48', 3, 1, 4, 1, 'pendente', NULL, '2025-07-18 18:03:48', '2025-07-18 18:03:48', '1898210064352911', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 18:03:48', 0, NULL, NULL, '3EB045DBD970896F6D6DAB', NULL, 0),
(247, 2, 'valor', '+5531999098284', 'alceudisporvan@gmail.com', '2025-07-18 19:15:06', 4, 1, 2, 1, 'pendente', NULL, '2025-07-18 19:15:06', '2025-07-20 12:00:02', '1008360147886611', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 1, '2025-07-20 12:00:02', 0, NULL, NULL, '3EB029A872354755D01846', '3EB08250C3FA48DBB690C4', 3),
(248, 2, 'Mary Gonçalves', '+5531997947415', 'mary.am86@yahoo.com.br', '2025-07-18 21:36:51', 3, 1, 2, 1, 'pendente', NULL, '2025-07-18 21:36:51', '2025-07-18 21:36:51', '781818960941705', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 21:36:51', 0, NULL, NULL, '3EB09D88217DAD123D4AD8', NULL, 0),
(249, 2, 'Jacque Grace', '+5531992058724', 'jacquelinegracce@gmail.com', '2025-07-18 21:43:36', 3, 1, 3, 1, 'pendente', NULL, '2025-07-18 21:43:36', '2025-07-18 21:43:37', '712215761714347', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 21:43:37', 0, NULL, NULL, '3EB0DA37428A1DA96A5F38', NULL, 0),
(250, 2, 'Flavio Arias', '+5531984722275', 'flaviorochacouto@yahoo.com', '2025-07-18 21:55:31', 6, 1, 7, 1, 'pendente', NULL, '2025-07-18 21:55:31', '2025-07-20 13:50:11', '1420229215927205', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:00:02', 0, 'nao-contatado', '2025-07-20 13:50:11', '3EB0F7F4F1D0A7D513FF8E', '3EB0442277232FE05FEE36', 3),
(251, 2, 'Sergio Andrade Ferreira', '+559930203434', 'franas1971@yahoo.com.br', '2025-07-18 23:25:37', 11, 1, 8, 1, 'pendente', NULL, '2025-07-18 23:25:37', '2025-07-20 12:45:01', '2262379997514032', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB095007818166A31604B', '3EB04BD50788FB05D2F493', 1),
(252, 2, 'Suzana Martins', '+553199292722', 'suzinmm@yahoo.com.br', '2025-07-18 23:37:35', 11, 1, 8, 1, 'pendente', NULL, '2025-07-18 23:37:35', '2025-07-20 12:45:01', '716479214700943', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB0366B9511B506EB795E', '3EB08550D0869A1958B241', 1),
(253, 2, 'Heder De Almeida Gomes', '+5531992020758', 'hedergomes@gmail.com', '2025-07-18 23:45:10', 3, 1, 4, 1, 'pendente', NULL, '2025-07-18 23:45:10', '2025-07-18 23:45:10', '727134216754317', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-18 23:45:10', 0, NULL, NULL, '3EB089B67FC71F16348985', NULL, 0),
(254, 2, 'JoseSena', '+5561981652950', 'sena.advocacia@gmail.com', '2025-07-19 01:18:08', 1, 1, 5, 1, 'pendente', NULL, '2025-07-19 01:18:08', '2025-07-19 01:18:08', '1805991273645856', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-19 01:18:08', 0, NULL, NULL, '3EB0187D43A2576F972C4F', NULL, 0),
(255, 2, 'Carla Damasceno', '+5531992659573', 'carladaianamoreira@hotmail.com', '2025-07-19 02:23:24', 3, 1, 2, 1, 'pendente', NULL, '2025-07-19 02:23:24', '2025-07-19 02:23:24', '1266128181788869', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 02:23:24', 0, NULL, NULL, '3EB0FCFA6588D29ABE4A62', NULL, 0),
(256, 2, 'Vinicius Antônio', '+553194910422', 'viniassuncao83@gmail.com', '2025-07-19 02:31:59', 11, 1, 7, 1, 'pendente', NULL, '2025-07-19 02:31:59', '2025-07-20 13:52:12', '1495828538072052', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, 'nao-contatado', '2025-07-20 13:52:12', '3EB092291D5A26772EC882', '3EB0CF3F70F51549E1CE9C', 1),
(257, 2, 'Saúde para você', '+5533984416627', 'dhiennsonsilva.adm@gmail.com', '2025-07-19 02:43:46', 4, 1, 2, 1, 'pendente', NULL, '2025-07-19 02:43:46', '2025-07-19 02:43:46', '568977172818899', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-19 02:43:46', 0, NULL, NULL, '3EB01BE719066153CAB06C', NULL, 0),
(258, 2, 'Thalles Gaiotti', '+5531971081795', 'thallesgaiotti@gmail.com', '2025-07-19 03:33:51', 6, 1, 6, 1, 'pendente', NULL, '2025-07-19 03:33:51', '2025-07-19 03:33:52', '773255678559907', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 03:33:52', 0, NULL, NULL, '3EB0A1FF0818C090D6C549', NULL, 0),
(259, 2, 'Ruby Car', '+5531999144405', 'arthurptbrasil@hotmail.com', '2025-07-19 03:37:02', 11, 1, 5, 1, 'pendente', NULL, '2025-07-19 03:37:02', '2025-07-20 12:14:28', '1861616434698278', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:00:02', 0, 'nao-contatado', '2025-07-20 12:14:28', '3EB0481432ADB4E9B7D24B', '3EB039029B269F32CE0501', 2),
(260, 2, 'Everaldo Júnior', '+5531993386534', 'everaldomoreirasilvajunior@gmail.com', '2025-07-19 11:19:46', 11, 1, 4, 1, 'pendente', NULL, '2025-07-19 11:19:46', '2025-07-20 12:00:02', '24602609889325253', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:00:02', 0, NULL, NULL, '3EB0408E852B134BE15D10', '3EB0531972C60E6380BA60', 2),
(261, 2, 'Kelly Fernandes', '+5531993800207', 'kellyfbol@gmail.com', '2025-07-19 12:21:45', 6, 1, 8, 1, 'pendente', NULL, '2025-07-19 12:21:45', '2025-07-19 12:21:45', '629102542993209', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 12:21:45', 0, NULL, NULL, '3EB0EEEEC5277EF6CF39F7', NULL, 0),
(262, 2, 'Nice Silva', '+5531995438727', 'ulenicearaujo@gmail.com', '2025-07-19 12:28:40', 6, 1, 5, 1, 'pendente', NULL, '2025-07-19 12:28:40', '2025-07-19 12:28:40', '718366814158592', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 12:28:40', 0, NULL, NULL, '3EB0C11462A04F5138793B', NULL, 0);
INSERT INTO `leads_recebidos` (`id`, `empresa_id`, `nome_cliente`, `telefone_cliente`, `email_cliente`, `data_recebido`, `conjunto_id`, `campanha_id`, `corretor_id`, `status`, `status_envio`, `whatsapp_status`, `created_at`, `updated_at`, `lead_id`, `form_id`, `pagina_id`, `adset_nome`, `anuncio_nome`, `plataforma`, `veiculo`, `campanha_nome`, `whatsapp_enviado`, `data_envio_whatsapp`, `enviado_whatsapp`, `resposta_contato`, `data_contato`, `message_id_enviado`, `zapi_message_id`, `tentativas_contato`) VALUES
(263, 2, 'Jussara Silva', '+5531999046475', 'jussaradasilva291@gmail.com', '2025-07-19 12:40:52', 6, 1, 7, 1, 'pendente', NULL, '2025-07-19 12:40:52', '2025-07-19 12:40:52', '2933538856854016', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 12:40:52', 0, NULL, NULL, '3EB01EFBF4B396DCA26696', NULL, 0),
(264, 2, 'Messias Ferreira Lima', '+5531983485657', 'sologatoferreira@gmail.com', '2025-07-19 13:07:03', 11, 1, 8, 1, 'pendente', NULL, '2025-07-19 13:07:03', '2025-07-19 14:41:53', '1737089620250119', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 1, '2025-07-19 14:00:01', 0, 'nao-contatado', '2025-07-19 14:41:53', '3EB0FFACC0B0000DE3BADE', '3EB01CD05674F7501B7355', 1),
(265, 2, 'Barbara Esteves', '+5531998795117', 'barbarakaesteves@outlook.com', '2025-07-19 13:17:02', 3, 1, 3, 1, 'pendente', NULL, '2025-07-19 13:17:02', '2025-07-19 13:17:02', '1266764795088055', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 13:17:02', 0, NULL, NULL, '3EB04928F6C14CD2358EFE', NULL, 0),
(266, 2, 'Marly Praxedes', '+5531991079553', 'marlypraxedes@hotmail.com', '2025-07-19 14:08:27', 3, 1, 4, 1, 'pendente', NULL, '2025-07-19 14:08:27', '2025-07-19 14:08:27', '1162866528983603', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 14:08:27', 0, NULL, NULL, '3EB0D05920E967936FA637', NULL, 0),
(267, 2, 'Daniele Oliveira', '+5531987376737', 'danioliveiracastro@gmail.com', '2025-07-19 16:01:34', 3, 1, 2, 1, 'pendente', NULL, '2025-07-19 16:01:34', '2025-07-19 16:01:34', '1276486424106218', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 16:01:34', 0, NULL, NULL, '3EB0034F51DD9AC23E1BBA', NULL, 0),
(268, 2, 'Vanusa Moura', '+5531973541288', 'vanusa.mendes78@gmail.com', '2025-07-19 16:37:47', 6, 1, 6, 1, 'pendente', NULL, '2025-07-19 16:37:47', '2025-07-19 16:37:47', '1393455975044947', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 16:37:47', 0, NULL, NULL, '3EB08D45F5B738D65E4863', NULL, 0),
(269, 2, 'Gabriele Ávila', '+553493338918', 'gabrieleavs@hotmail.com', '2025-07-19 17:57:04', 11, 1, 6, 1, 'pendente', NULL, '2025-07-19 17:57:04', '2025-07-20 12:45:01', '1994224297984469', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB049385593913A571B36', '3EB0212D221DB16833C7A8', 1),
(270, 2, 'Luiz Silva', '+5531982700068', 'lhsilva.lulu@gmail.com', '2025-07-19 18:45:52', 6, 1, 8, 1, 'pendente', NULL, '2025-07-19 18:45:52', '2025-07-19 18:45:52', '727804883475250', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-19 18:45:52', 0, NULL, NULL, '3EB030A04E5B665CA30097', NULL, 0),
(271, 2, 'Tiago Paixão', '+5537991558136', 'Tiagofarma037@gmail.com', '2025-07-19 19:49:24', 3, 1, 3, 1, 'pendente', NULL, '2025-07-19 19:49:24', '2025-07-19 19:49:24', '1511958523492142', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'fb', '', 'Cadastros', 0, '2025-07-19 19:49:24', 0, NULL, NULL, '3EB0A9E3EC04F2F01E6268', NULL, 0),
(272, 2, 'Nayara Louback', '+5531993817241', 'naclouback@hotmail.com', '2025-07-19 22:37:53', 3, 1, 4, 1, 'pendente', NULL, '2025-07-19 22:37:53', '2025-07-19 22:37:53', '1065046619059054', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 22:37:53', 0, NULL, NULL, '3EB038A8D3F0D7651CB0C5', NULL, 0),
(273, 2, 'Francis flor', '+5531992087144', 'francisflorlopes182@gmail.com', '2025-07-19 22:55:05', 3, 1, 2, 1, 'pendente', NULL, '2025-07-19 22:55:05', '2025-07-19 22:55:05', '669216922837334', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 22:55:05', 0, NULL, NULL, '3EB072E828801E31A3F64C', NULL, 0),
(274, 2, 'Roberta Silva', '+553188090050', 'robertas056@gmail.com', '2025-07-19 23:12:17', 3, 1, 3, 1, 'pendente', NULL, '2025-07-19 23:12:17', '2025-07-19 23:12:17', '1730445247833051', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-19 23:12:17', 0, NULL, NULL, '3EB07CD7F3C28A84FCAF55', NULL, 0),
(275, 2, 'Charles Fenix Terceiro', '+5531986619495', 'fenixcfn@yahoo.com.br', '2025-07-19 23:34:03', 11, 1, 4, 1, 'pendente', NULL, '2025-07-19 23:34:03', '2025-07-20 12:45:01', '594128053507999', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB03458D9520567DF73AB', '3EB05AA9AEE0FF9610087D', 1),
(276, 2, 'Nivia Liliane dos Santos', '+5531992718954', 'nliliane1@gmail.com', '2025-07-20 01:10:49', 11, 1, 4, 1, 'pendente', NULL, '2025-07-20 01:10:49', '2025-07-20 12:45:01', '1377465073339909', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB0139655662F1190E24F', '3EB052E21C04A997426276', 1),
(277, 2, 'Thais Gea', '+553188443536', 't-horta@uol.com.br', '2025-07-20 01:25:39', 6, 1, 5, 1, 'pendente', NULL, '2025-07-20 01:25:39', '2025-07-20 01:25:39', '1315167986605850', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-20 01:25:39', 0, NULL, NULL, '3EB048A00A6CC42F961A0C', NULL, 0),
(278, 2, 'adamaria.silva73@gmail.com Silva', '+553184608518', 'adamaria.silva73@gmail.com', '2025-07-20 01:29:03', 6, 1, 7, 1, 'pendente', NULL, '2025-07-20 01:29:03', '2025-07-20 01:29:03', '1434269517874796', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-20 01:29:03', 0, NULL, NULL, '3EB057770A4C9F97110BDB', NULL, 0),
(279, 2, 'Nivia Rodrigues Godinho', '+5541992424941', 'niviarg@gmail.com', '2025-07-20 01:47:21', 6, 1, 6, 1, 'pendente', NULL, '2025-07-20 01:47:21', '2025-07-20 01:47:21', '1122551229923114', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-20 01:47:21', 0, NULL, NULL, '3EB07A9068937427B88891', NULL, 0),
(280, 2, 'Regis Oliver', '+553194794144', 'reginmusic70@gmail.com', '2025-07-20 01:57:26', 6, 1, 8, 1, 'pendente', NULL, '2025-07-20 01:57:26', '2025-07-20 01:57:26', '1468926724547124', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-20 01:57:26', 0, NULL, NULL, '3EB04FA4DEE21C44563B4A', NULL, 0),
(281, 2, 'Gilberto Flouzino', '+5531986714474', 'giltimtim55@gmail.com', '2025-07-20 02:39:20', 3, 1, 4, 1, 'pendente', NULL, '2025-07-20 02:39:20', '2025-07-20 02:39:21', '1111638324358064', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'fb', '', 'Cadastros', 0, '2025-07-20 02:39:21', 0, NULL, NULL, '3EB082E3B50D2D2648E442', NULL, 0),
(282, 2, 'Elicassio Campanha', '+5531997697168', 'elicassiocampanha@gmail.com', '2025-07-20 02:58:22', 1, 1, 2, 1, 'pendente', NULL, '2025-07-20 02:58:22', '2025-07-20 02:58:22', '4138254243063946', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-20 02:58:22', 0, NULL, NULL, '3EB00E2F874936A0E014A5', NULL, 0),
(283, 2, 'Celeste Mendes Portela', '+5531991219113', 'celestemendesportela@gmail.com', '2025-07-20 03:18:24', 1, 1, 1, 1, 'pendente', NULL, '2025-07-20 03:18:24', '2025-07-20 03:18:24', '751893167213627', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-20 03:18:24', 0, NULL, NULL, '3EB09A6A38C5B0C65C7962', NULL, 0),
(284, 2, 'Lucas Martins', '+5531971225934', 'Lucasmartins290@yahoo.com.br', '2025-07-20 11:38:42', 11, 1, 4, 1, 'pendente', NULL, '2025-07-20 11:38:42', '2025-07-20 12:45:01', '1106776634679643', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB034649DAD206530F957', '3EB026A883321E375088D1', 1),
(285, 2, 'Jéssica Francielen', '+5531995951359', 'jessicafrancielen@hotmail.com', '2025-07-20 12:11:49', 11, 1, 6, 1, 'pendente', NULL, '2025-07-20 12:11:49', '2025-07-20 12:45:01', '1236486854471869', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 1, '2025-07-20 12:45:01', 0, NULL, NULL, '3EB0C1A4048D121D05943D', '3EB098606465D1977504B7', 1),
(286, 2, 'Maria Fioca', '+5531995193363', 'fioquinha56@gmail.com', '2025-07-20 12:35:48', 6, 1, 5, 1, 'pendente', NULL, '2025-07-20 12:35:48', '2025-07-20 12:35:48', '2428835444166970', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, '2025-07-20 12:35:48', 0, NULL, NULL, '3EB0CE28127BA4A645C75F', NULL, 0),
(287, 2, 'Silvana da silva p de AQUINO', '+553186098828', 'paquino.silvana@gmail.com', '2025-07-20 15:38:29', 4, 1, 2, 1, 'pendente', NULL, '2025-07-20 15:38:29', '2025-07-20 15:38:29', '1153000916568184', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'fb', '', 'Cadastros', 0, '2025-07-20 15:38:29', 0, NULL, NULL, '3EB010EF6DEE896389E62E', NULL, 0),
(288, 2, 'Victor Hugo', '+5531993043251', 'victorestadual2@hotmail.com', '2025-07-20 15:48:57', 1, 1, 5, 1, 'pendente', NULL, '2025-07-20 15:48:57', '2025-07-20 15:48:57', '745260501334088', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-20 15:48:57', 0, NULL, NULL, '3EB038B64A9DFA6868462B', NULL, 0),
(289, 2, 'Rodney', '+5531987897715', 'rodney_fernandes@hotmail.coml', '2025-07-20 15:55:47', 6, 1, 7, 1, 'pendente', NULL, '2025-07-20 15:55:47', '2025-07-20 15:55:47', '1147921573795194', '1299695773996064', '108038728224299', NULL, '(ADSET) (Carrossel) Terramaris Renda 3800', 'ig', '', 'Cadastros', 0, '2025-07-20 15:55:47', 0, NULL, NULL, '3EB0AB31EFA067C3E0821A', NULL, 0),
(290, 2, 'Luiz Fernando Kuchenbecker', '+5531993146877', 'lfkuchenbecker@yahoo.com.br', '2025-07-20 17:00:16', 1, 1, 2, 1, 'pendente', NULL, '2025-07-20 17:00:16', '2025-07-20 17:00:16', '1546989446277047', '1299695773996064', '108038728224299', NULL, '[AD] (VIDEO) -  HydePark CIA ADVANTEGE', 'ig', '', 'Cadastros', 0, '2025-07-20 17:00:16', 0, NULL, NULL, '3EB0C059F50297148E9772', NULL, 0),
(291, 2, 'Regiane da Cruz', '+553171720327', 'regydacruz009@gmail.com', '2025-07-20 17:43:49', 6, 1, 6, 1, 'pendente', NULL, '2025-07-20 17:43:49', '2025-07-20 17:43:49', '598897829644865', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-20 17:43:49', 0, NULL, NULL, '3EB0D7A39B575CD37F208A', NULL, 0),
(292, 2, 'Débora Gradizzi Duarte', '+553192808127', 'deboragd@live.com', '2025-07-20 17:59:11', 6, 1, 8, 1, 'pendente', NULL, '2025-07-20 17:59:11', '2025-07-20 17:59:11', '557925963952679', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'fb', '', 'Cadastros', 0, '2025-07-20 17:59:11', 0, NULL, NULL, '3EB025B6D48DE79E83AC8B', NULL, 0),
(293, 2, 'bete C Mauricio', '+5531986383006', 'betecmauricio@gmail.com', '2025-07-20 18:09:00', 6, 1, 5, 1, 'pendente', NULL, '2025-07-20 18:09:00', '2025-07-20 18:09:00', '617831987579379', '1299695773996064', '108038728224299', NULL, '[ADSET] (IMG) - Terramaris Vespasiano 249mil', 'ig', '', 'Cadastros', 0, '2025-07-20 18:09:00', 0, NULL, NULL, '3EB010B2B4757B60EF80DD', NULL, 0),
(294, 2, 'Suzi Lazara Dias da Silva', '+553491669923', 'suzilazara@hotmail.com', '2025-07-20 19:58:13', 11, 1, 1, 1, 'pendente', NULL, '2025-07-20 19:58:13', '2025-07-20 19:58:13', '1412698810018233', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'fb', '', 'Cadastros', 0, '2025-07-20 19:58:13', 0, NULL, NULL, '3EB03831818E98291A80EB', NULL, 0),
(295, 2, 'Yasmin Franca', '+5531971816798', 'yasminfrancal15@gmail.com', '2025-07-20 19:58:41', 4, 1, 2, 1, 'pendente', NULL, '2025-07-20 19:58:41', '2025-07-20 19:58:41', '1026602585959897', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-20 19:58:41', 0, NULL, NULL, '3EB014E71009C46313CBD3', NULL, 0),
(296, 2, 'Rodney Heleno', '+5531987037057', 'azusdesentupidora@gmail.com', '2025-07-20 20:25:51', 11, 1, 1, 1, 'pendente', NULL, '2025-07-20 20:25:51', '2025-07-20 20:25:51', '4283223835239840', '1299695773996064', '108038728224299', NULL, '[AD] (IMG) - Chicago Varandão 5mil', 'ig', '', 'Cadastros', 0, '2025-07-20 20:25:51', 0, NULL, NULL, '3EB04A61BC6CC8A7C5DCFD', NULL, 0),
(297, 2, 'Gabrielly Fernandes', '+553191785472', 'biby.fernandes14@gmail.com', '2025-07-20 20:42:17', 4, 1, 2, 1, 'pendente', NULL, '2025-07-20 20:42:17', '2025-07-20 20:42:18', '760913939766988', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil', 'ig', '', 'Cadastros', 0, '2025-07-20 20:42:18', 0, NULL, NULL, '3EB08617F687F3CD68D057', NULL, 0),
(298, 2, 'Amaral Cleberton', '+5537988433086', 'kimkabrow@outlook.com', '2025-07-20 22:19:55', 3, 1, 2, 1, 'pendente', NULL, '2025-07-20 22:19:55', '2025-07-20 22:19:56', '1103113815004743', '1299695773996064', '108038728224299', NULL, 'AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL', 'ig', '', 'Cadastros', 0, '2025-07-20 22:19:56', 0, NULL, NULL, '3EB098391A2EE2E3A2E6FC', NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `leads_respostas_whatsapp`
--

CREATE TABLE `leads_respostas_whatsapp` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `corretor_id` int(11) DEFAULT NULL,
  `message_id` varchar(64) DEFAULT NULL,
  `resposta` varchar(255) DEFAULT NULL,
  `resposta_texto` text,
  `data_resposta` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `leads_sem_contato`
--

CREATE TABLE `leads_sem_contato` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `lead_id` int(11) NOT NULL,
  `corretor_id` int(11) NOT NULL,
  `status_id` int(11) DEFAULT '4',
  `data_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tentativas_total` int(11) DEFAULT '0',
  `json_recebido` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `logs_webhook`
--

CREATE TABLE `logs_webhook` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `json_recebido` text,
  `ip_origem` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `mensagem` text,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `logs_webhook`
--

INSERT INTO `logs_webhook` (`id`, `empresa_id`, `json_recebido`, `ip_origem`, `status`, `mensagem`, `criado_em`) VALUES
(1, 2, '71866346422687812996957739960642025-07-03T04:35:39.000Z108038728224299Anderson Oliveira+5531990721977andersonoliveirasouza5000@gmail.comTerramaris Vespasiano[ADSET] (IMG) - Terramaris Vespasiano 249milfbCadastros', '172.68.245.233', 'erro', 'JSON inválido', '2025-07-03 04:35:43'),
(2, 2, '718663464226878,1299695773996064,2025-07-03T04:35:39.000Z,108038728224299,Anderson Oliveira,+5531990721977,andersonoliveirasouza5000@gmail.com,Terramaris Vespasiano,[ADSET] (IMG) - Terramaris Vespasiano 249mil,fb,,Cadastros', '104.23.209.175', 'erro', 'JSON inválido', '2025-07-03 17:42:57'),
(3, 2, '{\r\n  \"lead_id\": \"718663464226878\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T04:35:39.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Anderson Oliveira\",\r\n  \"telefone\": \"+5531990721977\",\r\n  \"email\": \"andersonoliveirasouza5000@gmail.com\",\r\n  \"adset_nome\": \"Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\"\r\n}', '172.70.135.93', 'erro', 'Campos obrigatórios ausentes.', '2025-07-03 17:53:53'),
(4, 2, '{\r\n  \"lead_id\": \"718663464226878\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T04:35:39.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Anderson Oliveira\",\r\n  \"telefone\": \"+5531990721977\",\r\n  \"email\": \"andersonoliveirasouza5000@gmail.com\",\r\n  \"adset_nome\": \"Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\"\r\n}', '172.70.38.7', 'erro', 'Campos obrigatórios ausentes.', '2025-07-03 17:57:04'),
(5, 2, '{\r\n  \"lead_id\": \"718663464226878\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T04:35:39.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Anderson Oliveira\",\r\n  \"telefone\": \"+5531990721977\",\r\n  \"email\": \"andersonoliveirasouza5000@gmail.com\",\r\n  \"adset_nome\": \"Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219824720770308\",\n\"plataforma\": \"fb\"\r\n}', '172.71.223.68', 'erro', 'Conjunto de anúncio não encontrado.', '2025-07-03 18:06:36'),
(6, 2, '{\n  \"lead_id\": \"718663464226878\",\n  \"form_id\": \"1299695773996064\",\n  \"data_criacao\": \"2025-07-03T04:35:39.000Z\",\n  \"pagina_id\": \"108038728224299\",\n  \"nome\": \"Anderson Oliveira\",\n  \"telefone\": \"+5531990721977\",\n  \"email\": \"andersonoliveirasouza5000@gmail.com\",\n  \"adset_nome\": \"Terramaris Vespasiano\",\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\n  \"plataforma\": \"fb\",\n  \"veiculo\": \"\",\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219824720770308\",\n\"plataforma\": \"fb\"\n}', '172.70.134.218', 'pendente', 'Sem corretor disponível. Lead pendente.', '2025-07-03 18:10:43'),
(7, 2, '{\r\n  \"lead_id\": \"2184653485367880\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T11:47:18.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Kelly Faria\",\r\n  \"telefone\": \"+5531988623108\",\r\n  \"email\": \"keyfebh@hotmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"ig\"\r\n}', '172.71.194.170', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:45:56'),
(8, 2, '{\r\n  \"lead_id\": \"746929661186282\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T14:25:30.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Rosiane Oliveira\",\r\n  \"telefone\": \"+5531993149266\",\r\n  \"email\": \"rosianeoliveiram74@gmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"ig\"\r\n}', '172.70.38.106', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:46:24'),
(9, 2, '{\r\n  \"lead_id\": \"1240331567549874\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T15:16:30.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Willian Maias\",\r\n  \"telefone\": \"+5531994256515\",\r\n  \"email\": \"willianmaias@hotmail.com\",\r\n  \"adset_nome\": \"Pampulha 8km ADVANTAGE\",\r\n  \"anuncio_nome\": \"AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120213956977700308\",\n\"plataforma\": \"ig\"\r\n}', '172.68.244.147', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:49:19'),
(10, 2, '{\r\n  \"lead_id\": \"1129782062512942\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T18:14:52.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Talita Alves\",\r\n  \"telefone\": \"+5531973370218\",\r\n  \"email\": \"talitayslanasousaalves@gmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"fb\"\r\n}', '172.70.43.208', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:50:41'),
(11, 2, '{\r\n  \"lead_id\": \"1049747837364948\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T19:01:22.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Maria A. Brum\",\r\n  \"telefone\": \"+5531984213836\",\r\n  \"email\": \"mariabrum569@gmail.com\",\r\n  \"adset_nome\": \"Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219824720770308\",\n\"plataforma\": \"ig\"\r\n}', '172.70.39.26', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:50:45'),
(12, 2, '{\r\n  \"lead_id\": \"735302569191224\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T19:04:55.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Michael\",\r\n  \"telefone\": \"+5531985873184\",\r\n  \"email\": \"michael_rocha85@outlook.com\",\r\n  \"adset_nome\": \"Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano 249mil\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219824720770308\",\n\"plataforma\": \"ig\"\r\n}', '172.71.190.108', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:50:48'),
(13, 2, '{\r\n  \"lead_id\": \"1823637291833533\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T21:07:20.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"𝗞𝗹𝗲𝗯𝗲𝗿 𝗣𝗶𝗺𝗲𝗻𝘁𝗲𝗹 | 𝗠𝗮𝘀𝘀𝗼𝘁𝗲𝗿𝗮𝗽𝗲𝘂𝘁𝗮 𝗲𝗺 𝗕𝗛\",\r\n  \"telefone\": \"+5531987221928\",\r\n  \"email\": \"pimentel.empresarial@gmail.com\",\r\n  \"adset_nome\": \"Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]\",\r\n  \"anuncio_nome\": \"AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120213392760550308\",\n\"plataforma\": \"ig\"\r\n}', '104.23.213.198', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:51:44'),
(14, 2, '{\r\n  \"lead_id\": \"2013587605838256\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T22:03:44.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"José Antonio Gomes\",\r\n  \"telefone\": \"+5538991339311\",\r\n  \"email\": \"joseantoniogomes1508@gmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"ig\"\r\n}', '172.70.43.212', 'sucesso', 'Lead processado com sucesso', '2025-07-04 06:51:48'),
(15, 2, '{\r\n  \"lead_id\": \"1258670055836109\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T22:49:32.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Luciana Santos\",\r\n  \"telefone\": \"+553187496250\",\r\n  \"email\": \"luc394711@gmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"fb\"\r\n}', '104.23.209.174', 'sucesso', 'Lead processado com sucesso', '2025-07-04 07:35:37'),
(16, 2, '{\r\n  \"lead_id\": \"1878617422984785\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T23:08:36.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"João Ferenczi\",\r\n  \"telefone\": \"+5531988222379\",\r\n  \"email\": \"j.fiapo2379@gmail.com\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"ig\"\r\n}', '172.70.42.159', 'sucesso', 'Lead processado com sucesso', '2025-07-04 07:35:40'),
(17, 2, '{\r\n  \"lead_id\": \"1110838227594040\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-03T23:50:47.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Paulo Henrique\",\r\n  \"telefone\": \"+5531985123313\",\r\n  \"email\": \"martinspaulo1201@gmail.com\",\r\n  \"adset_nome\": \"Contagem Direcionado 20 - 60 [Cópia de Aberto 18-55]\",\r\n  \"anuncio_nome\": \"AD [VIDEO 33s] -Inspire 3mil + Parcelas de 825 Renda `apartir de 6mil- AZUL\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120213392760550308\",\n\"plataforma\": \"ig\"\r\n}', '104.23.211.126', 'sucesso', 'Lead processado com sucesso', '2025-07-04 07:35:43'),
(18, 2, '{\r\n  \"lead_id\": \"907818358210882\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-04T01:09:35.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Maosquecuram_reiki\",\r\n  \"telefone\": \"+5531999357572\",\r\n  \"email\": \"anaruthpm2@yahoo.com.br\",\r\n  \"adset_nome\": \"Teste — Terramaris Vespasiano\",\r\n  \"anuncio_nome\": \"[ADSET] (IMG) - Terramaris Vespasiano IMG\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120219831290250308\",\n\"plataforma\": \"ig\"\r\n}', '104.23.209.107', 'sucesso', 'Lead processado com sucesso', '2025-07-04 07:35:47'),
(19, 2, '{\r\n  \"lead_id\": \"704341412375075\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-08T01:46:09.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Emerson Fernandes\",\r\n  \"telefone\": \"+553135770650\",\r\n  \"email\": \"emerson.fernandes@ciser.com.br\",\r\n  \"adset_nome\": \"Pampulha 8km ADVANTAGE\",\r\n  \"anuncio_nome\": \"AD [VIDEO 40s] - Mirante do Castelo Renda 8 a 12mil\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120213956977700308\",\n\"plataforma\": \"fb\"\r\n}', '172.70.42.163', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-08 01:46:15'),
(20, 2, '{\r\n  \"lead_id\": \"1069696131328776\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-08T21:45:43.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Carlucio Pereira Batista\",\r\n  \"telefone\": \"+553899868750\",\r\n  \"email\": \"carluciopereirabatista@hotmail.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"fb\"\r\n}', '172.70.35.85', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-08 21:45:47'),
(21, 2, '{\r\n  \"lead_id\": \"1285703953065188\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-08T23:10:31.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Renovar Veiculos\",\r\n  \"telefone\": \"+5531999411576\",\r\n  \"email\": \"brigadeiroveiculos@gmail.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"ig\"\r\n}', '172.71.190.160', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-08 23:10:38'),
(22, 2, '{\r\n  \"lead_id\": \"23874787198796958\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-09T08:51:15.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Gabriel Felipe\",\r\n  \"telefone\": \"+553189025616\",\r\n  \"email\": \"aparecidapoliana23@gmail.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"ig\"\r\n}', '172.71.222.163', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-09 08:51:21'),
(23, 2, '{\r\n  \"lead_id\": \"1358672085235473\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-09T11:04:41.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Paola Rettore\",\r\n  \"telefone\": \"+5531998712414\",\r\n  \"email\": \"paola@paolarettore.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"ig\"\r\n}', '172.71.194.120', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-09 11:04:46'),
(24, 2, '{\r\n  \"lead_id\": \"1829513227597110\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-09T16:17:51.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"Gilberto Bueno Bueno\",\r\n  \"telefone\": \"+5531999853805\",\r\n  \"email\": \"gilbertoap@hotmail.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"fb\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"fb\"\r\n}', '104.23.209.172', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-09 16:17:56'),
(25, 2, '{\r\n  \"lead_id\": \"1044978547828146\",\r\n  \"form_id\": \"1299695773996064\",\r\n  \"data_criacao\": \"2025-07-09T19:29:29.000Z\",\r\n  \"pagina_id\": \"108038728224299\",\r\n  \"nome\": \"João do prumo\",\r\n  \"telefone\": \"+5575982310148\",\r\n  \"email\": \"joaozito0726@gmail.com\",\r\n  \"adset_nome\": \"Investidores Alphaville\",\r\n  \"anuncio_nome\": \"[AD] (VIDEO) -  HydePark CIA ADVANTEGE\",\r\n  \"plataforma\": \"ig\",\r\n  \"veiculo\": \"\",\r\n  \"campanha_nome\": \"Cadastros\",\n  \"conjunto_id\": \"120224575143970308\",\n\"plataforma\": \"ig\"\r\n}', '172.70.35.210', 'sucesso', 'Lead recebido e processado com sucesso.', '2025-07-09 19:29:34');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pipeline_leads`
--

CREATE TABLE `pipeline_leads` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `lead_id` int(11) NOT NULL,
  `corretor_id` int(11) NOT NULL,
  `etapa_id` int(11) NOT NULL,
  `data_etapa` datetime DEFAULT CURRENT_TIMESTAMP,
  `observacao` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estrutura da tabela `status_lead`
--

CREATE TABLE `status_lead` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text,
  `cor` varchar(20) DEFAULT '#999999',
  `ativo` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `status_lead`
--

INSERT INTO `status_lead` (`id`, `empresa_id`, `nome`, `descricao`, `cor`, `ativo`) VALUES
(0, 2, 'Pendente', 'Lead ainda não foi respondido', '#FFC107', 1),
(1, 2, 'Entregue', 'Lead entregue ao corretor', '#17A2B8', 1),
(2, 2, 'Em atendimento', 'Corretor iniciou contato com o cliente', '#007BFF', 1),
(3, 2, 'Desqualificado', 'Lead sem perfil para compra', '#DC3545', 1),
(4, 2, 'Tentativas Exauridas', 'Após 5 tentativas por 3 dias sem sucesso', '#6C757D', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `empresa_id`, `nome`, `email`, `senha`, `ativo`, `criado_em`) VALUES
(1, 2, 'Carlos Castro', 'carloscastro.louback@gmail.com', 'carlos576', 1, '2025-07-02 22:43:55'),
(2, 2, 'Carlos Castro', 'carloscastro@louback.com.br', '$2b$12$NL8eSvhvd9yD2N0dORreQOASls0cpKyA0ses77g54HdikDwLcTwjC', 1, '2025-07-02 22:55:18'),
(3, 1, 'Carlos Castro', 'carloscastro@nocrm.com.br', '$2y$10$F0G4k7T3qypZibHtH4f8R.3BvEQjZVqZz7s8uxFlrZ8BjxUwbyJ5e', 1, '2025-07-17 04:25:55'),
(4, 1, 'Carlos Castro', 'carlos@nocrm.com.br', '$2y$10$NHynL/4eGpsXXhwGbk8vDePSy5H2MHYdVKudZ5p6KbdnvwKym.b9.', 1, '2025-07-18 03:30:44');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios_cargos`
--

CREATE TABLE `usuarios_cargos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `cargo_id` int(11) NOT NULL,
  `empresa_id` int(11) NOT NULL,
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuarios_cargos`
--

INSERT INTO `usuarios_cargos` (`id`, `usuario_id`, `cargo_id`, `empresa_id`, `criado_em`) VALUES
(1, 1, 5, 1, '2025-07-17 04:26:15'),
(2, 2, 2, 2, '2025-07-17 04:45:02'),
(3, 3, 1, 2, '2025-07-17 04:45:02'),
(4, 4, 6, 1, '2025-07-18 03:36:36');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `campanhas`
--
ALTER TABLE `campanhas`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices para tabela `configuracoes_sistema`
--
ALTER TABLE `configuracoes_sistema`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chave` (`chave`);

--
-- Índices para tabela `configuracoes_zapi`
--
ALTER TABLE `configuracoes_zapi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `conjuntos_anuncio`
--
ALTER TABLE `conjuntos_anuncio`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campanha_id` (`campanha_id`);

--
-- Índices para tabela `corretores`
--
ALTER TABLE `corretores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `equipe_id` (`equipe_id`),
  ADD KEY `cargo_id` (`cargo_id`);

--
-- Índices para tabela `elegibilidade_corretores`
--
ALTER TABLE `elegibilidade_corretores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `conjunto_id` (`conjunto_id`,`corretor_id`),
  ADD KEY `corretor_id` (`corretor_id`);

--
-- Índices para tabela `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `equipes`
--
ALTER TABLE `equipes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `fluxos_pipeline`
--
ALTER TABLE `fluxos_pipeline`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `formularios_origem`
--
ALTER TABLE `formularios_origem`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `form_id` (`form_id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `interacoes_leads`
--
ALTER TABLE `interacoes_leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`),
  ADD KEY `corretor_id` (`corretor_id`);

--
-- Índices para tabela `leads_pendentes`
--
ALTER TABLE `leads_pendentes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `leads_recebidos`
--
ALTER TABLE `leads_recebidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conjunto_id` (`conjunto_id`),
  ADD KEY `campanha_id` (`campanha_id`),
  ADD KEY `corretor_id` (`corretor_id`);

--
-- Índices para tabela `leads_respostas_whatsapp`
--
ALTER TABLE `leads_respostas_whatsapp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `leads_sem_contato`
--
ALTER TABLE `leads_sem_contato`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lead_id` (`lead_id`),
  ADD KEY `corretor_id` (`corretor_id`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `logs_webhook`
--
ALTER TABLE `logs_webhook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `pipeline_leads`
--
ALTER TABLE `pipeline_leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa_id` (`empresa_id`);

--
-- Índices para tabela `status_lead`
--
ALTER TABLE `status_lead`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- Índices para tabela `usuarios_cargos`
--
ALTER TABLE `usuarios_cargos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_empresa_usuario` (`empresa_id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `campanhas`
--
ALTER TABLE `campanhas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `cargos`
--
ALTER TABLE `cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `configuracoes_sistema`
--
ALTER TABLE `configuracoes_sistema`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `configuracoes_zapi`
--
ALTER TABLE `configuracoes_zapi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `conjuntos_anuncio`
--
ALTER TABLE `conjuntos_anuncio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `corretores`
--
ALTER TABLE `corretores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `elegibilidade_corretores`
--
ALTER TABLE `elegibilidade_corretores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT de tabela `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `equipes`
--
ALTER TABLE `equipes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `fluxos_pipeline`
--
ALTER TABLE `fluxos_pipeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `formularios_origem`
--
ALTER TABLE `formularios_origem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `interacoes_leads`
--
ALTER TABLE `interacoes_leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT de tabela `leads_pendentes`
--
ALTER TABLE `leads_pendentes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `leads_recebidos`
--
ALTER TABLE `leads_recebidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=299;

--
-- AUTO_INCREMENT de tabela `leads_respostas_whatsapp`
--
ALTER TABLE `leads_respostas_whatsapp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `leads_sem_contato`
--
ALTER TABLE `leads_sem_contato`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `logs_webhook`
--
ALTER TABLE `logs_webhook`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de tabela `pipeline_leads`
--
ALTER TABLE `pipeline_leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `status_lead`
--
ALTER TABLE `status_lead`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `usuarios_cargos`
--
ALTER TABLE `usuarios_cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `configuracoes_zapi`
--
ALTER TABLE `configuracoes_zapi`
  ADD CONSTRAINT `configuracoes_zapi_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`);

--
-- Limitadores para a tabela `conjuntos_anuncio`
--
ALTER TABLE `conjuntos_anuncio`
  ADD CONSTRAINT `conjuntos_anuncio_ibfk_1` FOREIGN KEY (`campanha_id`) REFERENCES `campanhas` (`id`);

--
-- Limitadores para a tabela `corretores`
--
ALTER TABLE `corretores`
  ADD CONSTRAINT `corretores_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `equipes` (`id`),
  ADD CONSTRAINT `corretores_ibfk_2` FOREIGN KEY (`cargo_id`) REFERENCES `cargos` (`id`);

--
-- Limitadores para a tabela `elegibilidade_corretores`
--
ALTER TABLE `elegibilidade_corretores`
  ADD CONSTRAINT `elegibilidade_corretores_ibfk_1` FOREIGN KEY (`conjunto_id`) REFERENCES `conjuntos_anuncio` (`id`),
  ADD CONSTRAINT `elegibilidade_corretores_ibfk_2` FOREIGN KEY (`corretor_id`) REFERENCES `corretores` (`id`);

--
-- Limitadores para a tabela `formularios_origem`
--
ALTER TABLE `formularios_origem`
  ADD CONSTRAINT `formularios_origem_ibfk_1` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `interacoes_leads`
--
ALTER TABLE `interacoes_leads`
  ADD CONSTRAINT `interacoes_leads_ibfk_1` FOREIGN KEY (`lead_id`) REFERENCES `leads_recebidos` (`id`),
  ADD CONSTRAINT `interacoes_leads_ibfk_2` FOREIGN KEY (`corretor_id`) REFERENCES `corretores` (`id`);

--
-- Limitadores para a tabela `leads_recebidos`
--
ALTER TABLE `leads_recebidos`
  ADD CONSTRAINT `leads_recebidos_ibfk_1` FOREIGN KEY (`conjunto_id`) REFERENCES `conjuntos_anuncio` (`id`),
  ADD CONSTRAINT `leads_recebidos_ibfk_2` FOREIGN KEY (`campanha_id`) REFERENCES `campanhas` (`id`),
  ADD CONSTRAINT `leads_recebidos_ibfk_3` FOREIGN KEY (`corretor_id`) REFERENCES `corretores` (`id`);

--
-- Limitadores para a tabela `usuarios_cargos`
--
ALTER TABLE `usuarios_cargos`
  ADD CONSTRAINT `fk_empresa_usuario` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
