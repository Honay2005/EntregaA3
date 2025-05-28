 Arquivo: postgres_db/init.sql


-- Tabela Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telefone VARCHAR(50),
    endereco TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Vendedores
CREATE TABLE IF NOT EXISTS Vendedores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    matricula VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    data_contratacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Produtos (Estoque de Chocolates)
CREATE TABLE IF NOT EXISTS Produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    tipo_chocolate VARCHAR(100), 
    marca VARCHAR(100),
    peso_gramas INTEGER,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    quantidade_em_estoque INTEGER NOT NULL DEFAULT 0,
    data_validade DATE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Vendas
CREATE TABLE IF NOT EXISTS Vendas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES Clientes(id) ON DELETE SET NULL, 
    vendedor_id INTEGER REFERENCES Vendedores(id) ON DELETE SET NULL,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    status_pedido VARCHAR(50) DEFAULT 'Pendente' 
);

-- Tabela ItensVenda (produtos em uma venda específica)
CREATE TABLE IF NOT EXISTS ItensVenda (
    id SERIAL PRIMARY KEY,
    venda_id INTEGER NOT NULL REFERENCES Vendas(id) ON DELETE CASCADE,
    produto_id INTEGER NOT NULL REFERENCES Produtos(id) ON DELETE RESTRICT, 
    quantidade INTEGER NOT NULL,
    preco_unitario_venda DECIMAL(10, 2) NOT NULL 
);

-- Dados iniciais 

-- Vendedores
INSERT INTO Vendedores (nome, matricula, email) VALUES
('Carlos Silva', 'VEND001', 'carlos.silva@chocolateria.com'),
('Ana Pereira', 'VEND002', 'ana.pereira@chocolateria.com')
ON CONFLICT (matricula) DO NOTHING;

-- Clientes
INSERT INTO Clientes (nome, email, telefone, endereco) VALUES
('João Oliveira', 'joao.oliveira@email.com', '11999990001', 'Rua das Amoras, 123'),
('Maria Souza', 'maria.souza@email.com', '21988880002', 'Avenida Central, 456'),
('Pedro Santos', 'pedro.santos@email.com', '31977770003', 'Praça da Alegria, 789'),
('Laura Costa', 'laura.costa@email.com', '41966660004', 'Travessa dos Sonhos, 101'),
('Fernanda Lima', 'fernanda.lima@email.com', '51955550005', 'Alameda dos Sabores, 202')
ON CONFLICT (email) DO NOTHING;

-- Produtos 
INSERT INTO Produtos (nome, descricao, tipo_chocolate, marca, peso_gramas, preco_unitario, quantidade_em_estoque, data_validade) VALUES
('Barra Chocolate Ao Leite Clássico', 'Deliciosa barra de chocolate ao leite tradicional.', 'Ao Leite', 'ChocoBom', 100, 5.50, 50, '2025-12-31'),
('Barra Chocolate Amargo 70%', 'Chocolate amargo com 70% de cacau.', 'Amargo', 'CacauIntenso', 90, 7.20, 30, '2026-06-30'),
('Bombom Recheado de Avelã', 'Bombom cremoso com recheio de avelã.', 'Recheado', 'DoceMagia', 20, 1.80, 100, '2025-10-15'),
('Chocolate Branco com Castanhas', 'Chocolate branco crocante com pedaços de castanha.', 'Branco', 'ChocoBom', 120, 6.90, 40, '2025-11-20'),
('Trufa Tradicional de Chocolate', 'Trufa macia coberta com cacau em pó.', 'Trufa', 'CacauIntenso', 15, 2.50, 80, '2025-09-01'),
('Caixa de Bombons Sortidos Pequena', 'Caixa com uma seleção de bombons.', 'Sortido', 'DoceMagia', 150, 15.00, 25, '2026-01-10'),
('Chocolate Diet Ao Leite', 'Chocolate ao leite sem adição de açúcar.', 'Ao Leite Diet', 'ChocoBom', 80, 8.00, 20, '2025-08-25'),
('Pastilhas de Chocolate Menta', 'Pequenas pastilhas de chocolate com sabor refrescante de menta.', 'Saborizado', 'CacauIntenso', 50, 4.50, 60, '2026-03-05'),
('Ovo de Páscoa Trufado Médio', 'Ovo de chocolate ao leite com recheio trufado.', 'Ao Leite Recheado', 'DoceMagia', 350, 45.00, 15, '2026-04-01'),
('Chocolate em Pó 50% Cacau', 'Ideal para receitas e bebidas quentes.', 'Pó', 'CacauIntenso', 200, 12.00, 35, '2026-07-15'),
('Barra Chocolate Meio Amargo com Laranja', 'Combinação de chocolate meio amargo com toque cítrico de laranja.', 'Meio Amargo Saborizado', 'ChocoBom', 100, 6.50, 28, '2025-12-01')
ON CONFLICT (nome) DO NOTHING; 

-- Exemplo de como adicionar um índice para otimizar consultas
CREATE INDEX IF NOT EXISTS idx_produtos_nome ON Produtos(nome);
CREATE INDEX IF NOT EXISTS idx_vendas_cliente_id ON Vendas(cliente_id);
CREATE INDEX IF NOT EXISTS idx_vendas_data_venda ON Vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_itensvenda_venda_id ON ItensVenda(venda_id);
CREATE INDEX IF NOT EXISTS idx_itensvenda_produto_id ON ItensVenda(produto_id);

SELECT 'Banco de dados Chocolateria inicializado com sucesso!' AS status;
