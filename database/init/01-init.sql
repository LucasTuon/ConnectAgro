
USE connect_agro_db;

-- Tabela de Usuarios 
CREATE TABLE IF NOT EXISTS Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('PRODUTOR', 'PONTO_DE_VENDA') NOT NULL,
    nome_estabelecimento VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    foto_url VARCHAR(2083),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de Produtos 
CREATE TABLE IF NOT EXISTS Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    unidade VARCHAR(50),
    imagem_url VARCHAR(2083),
    categoria ENUM('VEGETAIS', 'FRUTAS', 'ERVAS', 'CEREAIS') NOT NULL,
    quantidade_estoque INT DEFAULT 0,
    avaliacao_media DECIMAL(3, 2) DEFAULT 0.0,
    total_avaliacoes INT DEFAULT 0,
    data_colheita DATE,
    produtor_id INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (produtor_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

-- Tabela de Compras (historico)
CREATE TABLE IF NOT EXISTS Compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ponto_de_venda_id INT NOT NULL,   -- Quem comprou
    produto_id INT NOT NULL,          -- O que foi comprado
    produtor_id INT NOT NULL,         -- De quem foi comprado
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantidade INT NOT NULL,
    preco_total DECIMAL(10, 2) NOT NULL,
    status_entrega ENUM('EM_PREPARACAO', 'A_CAMINHO', 'ENTREGUE') NOT NULL,
    
    FOREIGN KEY (ponto_de_venda_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id) ON DELETE CASCADE,
    FOREIGN KEY (produtor_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);