-- ============================
-- CRIAR BANCO DE DADOS
-- ============================
CREATE DATABASE IF NOT EXISTS woapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE woapp;
#drop database woapp;

/*DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
    id VARCHAR(36) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha TEXT NOT NULL,
    nivel VARCHAR(50),
    foto_base64 LONGTEXT,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS exercicios;
CREATE TABLE exercicios (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    imagem VARCHAR(255),
    tipo_equipamento VARCHAR(50) NOT NULL DEFAULT 'ACADEMIA',
    link_youtube VARCHAR(500)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS exercicio_categoria;
CREATE TABLE exercicio_categoria (
    exercicio_id CHAR(36) NOT NULL,
    categoria_id CHAR(36) NOT NULL,
    PRIMARY KEY (exercicio_id, categoria_id),
    FOREIGN KEY (exercicio_id) REFERENCES exercicios(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS treinos;
CREATE TABLE treinos (
    id CHAR(36) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    botao_escuro BOOLEAN DEFAULT FALSE,
    link_youtube VARCHAR(500),
    nivel VARCHAR(50) NOT NULL,
    usuario_id CHAR(36) NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS treino_exercicios;
CREATE TABLE treino_exercicios (
    treino_id CHAR(36) NOT NULL,
    exercicio_id CHAR(36) NOT NULL,
    PRIMARY KEY (treino_id, exercicio_id),
    FOREIGN KEY (treino_id) REFERENCES treinos(id) ON DELETE CASCADE,
    FOREIGN KEY (exercicio_id) REFERENCES exercicios(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;*/


INSERT INTO categorias (id, nome) VALUES
(UUID(), 'iniciante'),
(UUID(), 'intermediario'),
(UUID(), 'avancado');

INSERT INTO exercicios (id, nome, descricao, imagem, tipo_equipamento, link_youtube) VALUES
(UUID(), 'Supino Reto Barra', 'Exercício de peitoral.', 'supino-reto-barra.png', 'ACADEMIA', 'rT7DgCr-3pg'),
(UUID(), 'Supino Inclinado Halter', 'Parte superior do peitoral.', 'supino-inclinado-halter.png', 'ACADEMIA', 'DbFgADa2PL8'),
(UUID(), 'Flexão de Braço', 'Exercício com peso corporal.', 'flexao.png', 'CASA', 'IODxDxX7oi4'),
(UUID(), 'Tríceps Corda Polia', 'Exercício para tríceps.', 'triceps_corda.png', 'ACADEMIA', '2-LAMcpzODU'),
(UUID(), 'Barra Fixa Assistida', 'Exercício para costas.', 'barra-fixa.png', 'ACADEMIA', 'fGBD30UYYVg'),
(UUID(), 'Remada Unilateral Halter', 'Costas unilateral.', 'remada-unilateral-halter.png', 'ACADEMIA', 'roCP6wCXPqo'),
(UUID(), 'Pulldown Polia Alta', 'Exercício para dorsais.', 'pulldown-polia-alta.png', 'ACADEMIA', 'CAwf7n6Luuc'),
(UUID(), 'Rosca Direta Barra', 'Exercício para bíceps.', 'rosca_direta.png', 'ACADEMIA', 'kwG2ipFRgfo'),
(UUID(), 'Agachamento Livre Barra', 'Exercício de pernas.', 'agachamento-livre.png', 'ACADEMIA', 'ultWZbUMPL8'),
(UUID(), 'Leg Press', 'Quadríceps em máquina.', 'legpress.png', 'ACADEMIA', 'IZxyjW7MPJQ'),
(UUID(), 'Cadeira Extensora', 'Máquina para quadríceps.', 'cadeira-extensora.png', 'ACADEMIA', 'YyvSfVjQeL0'),
(UUID(), 'Desenvolvimento Militar Halter', 'Ombros.', 'desenvolvimento-com-halteres.png', 'ACADEMIA', 'hqEwKCR5JCog'),
(UUID(), 'Crucifixo Inclinado Halter', 'Abertura inclinada.', 'crucifixo-inclinado-halteres.png', 'ACADEMIA', 'IP4VHgVVbIk'),
(UUID(), 'Crossover Polia Alta', 'Peito na polia.', 'crossover-polia-alta.png', 'ACADEMIA', 'taI4XduLpTk'),
(UUID(), 'Barra Fixa', 'Costas.', 'barra-fixa.png', 'CASA', 'eGo4IYlbE5g'),
(UUID(), 'Remada Curvada Barra', 'Costas avançado.', 'remada-curvada-barra.png', 'ACADEMIA', 'kBWAon7ItDw'),
(UUID(), 'Rosca Alternada Halter', 'Bíceps alternado.', 'rosca_alternada.png', 'ACADEMIA', 'sAq_ocpRh_I'),
(UUID(), 'Cadeira Flexora', 'Posterior de coxa.', 'cadeira-flexora.png', 'ACADEMIA', '1Tq3QdYUuHs'),
(UUID(), 'Panturrilha em Pé', 'Panturrilha.', 'panturrilha.png', 'ACADEMIA', 'gwLzBJYoWlI'),
(UUID(), 'Desenvolvimento Militar Barra', 'Ombros com barra.', 'desenvolvimento-com-halteres.png', 'ACADEMIA', '2yjwXTZQDDI'),
(UUID(), 'Elevação Lateral Halter', 'Lateral de ombro.', 'elevacao-lateral.png', 'ACADEMIA', '3VcKaXpzqRo'),
(UUID(), 'Elevação Frontal Halter', 'Frontal de ombro.', 'elevacao-frontal.png', 'ACADEMIA', 'qsl6Joq0cH4'),
(UUID(), 'Encolhimento Barra', 'Trapézio.', 'encolhimento.png', 'ACADEMIA', 'cJRVVxmytaM'),
(UUID(), 'Arnold Press', 'Ombros completo.', 'arnald-press.png', 'ACADEMIA', '6Z15_WdXmVw'),
(UUID(), 'Face Pull', 'Parte posterior do ombro.', 'facepull.png', 'ACADEMIA', 'rep-qVOkqgk'),
(UUID(), 'Tríceps Testa Barra', 'Tríceps com barra.', 'triceps_testa.png', 'ACADEMIA', 'd_KZxkY_0cM'),
(UUID(), 'Rosca Martelo', 'Bíceps, braquial.', 'rosca_martelo.png', 'ACADEMIA', 'zC3nLlEvin4');



-- INICIANTE
INSERT INTO exercicio_categoria (exercicio_id, categoria_id)
SELECT e.id, c.id FROM exercicios e, categorias c
WHERE c.nome = 'iniciante'
AND e.nome IN (
  'Supino Reto Barra',
  'Supino Inclinado Halter',
  'Flexão de Braço',
  'Tríceps Corda Polia',
  'Barra Fixa Assistida',
  'Remada Unilateral Halter',
  'Pulldown Polia Alta',
  'Rosca Direta Barra',
  'Agachamento Livre Barra',
  'Leg Press',
  'Cadeira Extensora',
  'Desenvolvimento Militar Halter'
);

-- INTERMEDIARIO
INSERT INTO exercicio_categoria (exercicio_id, categoria_id)
SELECT e.id, c.id FROM exercicios e, categorias c
WHERE c.nome = 'intermediario'
AND e.nome IN (
  'Supino Reto Barra',
  'Supino Inclinado Halter',
  'Crucifixo Inclinado Halter',
  'Crossover Polia Alta',
  'Tríceps Corda Polia',
  'Barra Fixa',
  'Remada Curvada Barra',
  'Remada Unilateral Halter',
  'Pulldown Polia Alta',
  'Rosca Alternada Halter',
  'Agachamento Livre Barra',
  'Leg Press',
  'Cadeira Extensora',
  'Cadeira Flexora',
  'Panturrilha em Pé',
  'Desenvolvimento Militar Barra',
  'Elevação Lateral Halter',
  'Elevação Frontal Halter',
  'Encolhimento Barra',
  'Arnold Press'
);

-- AVANCADO
INSERT INTO exercicio_categoria (exercicio_id, categoria_id)
SELECT e.id, c.id FROM exercicios e, categorias c
WHERE c.nome = 'avancado'
AND e.nome IN (
  'Supino Reto Barra',
  'Supino Inclinado Halter',
  'Crucifixo Inclinado Halter',
  'Crossover Polia Alta',
  'Flexão de Braço',
  'Barra Fixa',
  'Remada Curvada Barra',
  'Remada Unilateral Halter',
  'Pulldown Polia Alta',
  'Face Pull',
  'Desenvolvimento Militar Barra',
  'Elevação Lateral Halter',
  'Elevação Frontal Halter',
  'Encolhimento Barra',
  'Arnold Press',
  'Agachamento Livre Barra',
  'Leg Press',
  'Cadeira Extensora',
  'Cadeira Flexora',
  'Panturrilha em Pé',
  'Rosca Direta Barra',
  'Rosca Alternada Halter',
  'Tríceps Testa Barra',
  'Tríceps Corda Polia',
  'Rosca Martelo'
);
