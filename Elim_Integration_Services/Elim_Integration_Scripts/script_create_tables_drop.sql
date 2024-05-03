BEGIN

-- Começando excluindo as constraints caso elas existam
-- Procedimento para correção do banco

-- Remoção da constraint FK_RC_FORN em RequisicaoCompra
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'RequisicaoCompra' 
    AND constraint_name = 'FK_RC_FORN'
)
BEGIN
    ALTER TABLE RequisicaoCompra
    DROP CONSTRAINT FK_RC_FORN;
END;

-- Remoção da constraint FK_RC_PROD em RequisicaoCompra
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'RequisicaoCompra' 
    AND constraint_name = 'FK_RC_PROD'
)
BEGIN
    ALTER TABLE RequisicaoCompra
    DROP CONSTRAINT FK_RC_PROD;
END;

-- Remoção da Constrante FK_RC_STAT em RequisicaoCompra
IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE TABLE_NAME = 'RequisicaoCompra'
	AND CONSTRAINT_NAME = 'FK_RC_STAT'
)
BEGIN
	ALTER TABLE RequisicaoCompra
	DROP CONSTRAINT FK_RC_STAT;
END;


-- Remoção da constraint FK_PED_CLI em Pedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Pedidos' 
    AND constraint_name = 'FK_PED_CLI'
)
BEGIN
    ALTER TABLE Pedidos
    DROP CONSTRAINT FK_PED_CLI;
END;

-- Remoção da constraint FK_IP_PE em ItensPedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'ItensPedidos' 
    AND constraint_name = 'FK_IP_PE'
)
BEGIN
    ALTER TABLE ItensPedidos
    DROP CONSTRAINT FK_IP_PE;
END;


-- Remoção da constraint FK_IP_PROD em ItensPedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'ItensPedidos' 
    AND constraint_name = 'FK_IP_PROD'
)
BEGIN
    ALTER TABLE ItensPedidos
    DROP CONSTRAINT FK_IP_PROD;
END;


-- Remoção da constraint FK_NF_PE em NotaFiscal
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'NotaFiscal' 
    AND constraint_name = 'FK_NF_PE'
)
BEGIN
    ALTER TABLE NotaFiscal
    DROP CONSTRAINT FK_NF_PE;
END;

-- Remoção da constraint FK_SD_D em Checkout
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Checkout' 
    AND constraint_name = 'FK_SD_D'
)
BEGIN
    ALTER TABLE Checkout
    DROP CONSTRAINT FK_SD_D;
END;

-- Remoção da constraint FK_DM_PROD em DespachoMercadorias
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'DespachoMercadorias' 
    AND constraint_name = 'FK_DM_PROD'
)
BEGIN
    ALTER TABLE DespachoMercadorias
    DROP CONSTRAINT FK_DM_PROD;
END;

-- Remoção da constraint FK_DM_TRANS em DespachoMercadorias
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'DespachoMercadorias' 
    AND constraint_name = 'FK_DM_TRANS'
)
BEGIN
    ALTER TABLE DespachoMercadorias
    DROP CONSTRAINT FK_DM_TRANS;
END;

-- Remoção da constraint FK_EST_PROD em Estoque
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Estoque' 
    AND constraint_name = 'FK_EST_PROD'
)
BEGIN
    ALTER TABLE Estoque
    DROP CONSTRAINT FK_EST_PROD;
END;

IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Checkout' 
    AND constraint_name = 'FK_P_C'
)
BEGIN
    ALTER TABLE Checkout
    DROP CONSTRAINT FK_P_C;
END;


IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'AcompanhamentoPedidos' 
    AND constraint_name = 'FK_AP_IP'
)
BEGIN
    ALTER TABLE AcompanhamentoPedidos
    DROP CONSTRAINT FK_AP_IP;
END;



-- Criando Tabelas Enum

DROP TABLE IF EXISTS StatusDespacho;
CREATE TABLE StatusDespacho (
		[IDStatus] INT PRIMARY KEY,
		[NomeStatus] VARCHAR(50) NOT NULL
	);
	INSERT INTO StatusDespacho ([IDStatus], [NomeStatus])
	VALUES 
		(1, 'Em processamento'),
		(2, 'Enviado'),
		(3, 'Entregue'),
		(4, 'Cancelado');
		
	-- Tabela de estado de monitoramento do pedido - controle de loja

DROP TABLE IF EXISTS StatusPedido;
	CREATE TABLE StatusPedido (
		Status_ID INT PRIMARY KEY NOT NULL,
		Nome_Status VARCHAR(50) NOT NULL
	);

	INSERT INTO StatusPedido (Status_ID, Nome_Status) VALUES
	(1,'Pendente'),
	(2, 'Em processamento'),
	(3, 'Enviado'),
	(4, 'Entregue'),
	(5,'Cancelado');

-- Fim TAbelas Enum


DROP TABLE IF EXISTS Clientes;
	CREATE TABLE Clientes (
		[cliente_id] INT PRIMARY KEY IDENTITY not null,
		[Nome] varchar(150) not null,
		[email] VARCHAR(50) NOT NULL,
		[cpf] VARCHAR(30) UNIQUE NOT NULL,
		[uf] VARCHAR(50) NOT NULL,
		[pais] VARCHAR(50) NOT NULL,
	);


DROP TABLE IF EXISTS Produtos;
	CREATE TABLE Produtos (
		[produto_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[nome_Produto] VARCHAR(150) NOT NULL,
		[descricao] VARCHAR(150) NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[valor] DECIMAL(10,2) NOT NULL,
		[frete_produto] DECIMAL(10,2) NOT NULL,
		[nome_fornecedor] VARCHAR(50) NOT NULL,
		[fornecedor_CNPJ] VARCHAR(50) NOT NULL
	);


DROP TABLE IF EXISTS Pedidos;
	CREATE TABLE Pedidos(
		[pedido_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[codigo_Pedido] VARCHAR(50) NOT NULL,
		[cliente_ID] INT NOT NULL,
		[data_Pedido] DATETIME NOT NULL,
		[endereco_entrega] VARCHAR(150) NOT NULL,
        [cep] VARCHAR(10) NOT NULL,		
		[status_pedido] INT NOT NULL DEFAULT 1

	);
DROP TABLE IF EXISTS ItensPedidos;
	CREATE TABLE ItensPedidos(
		[Item_ID] INT PRIMARY KEY IDENTITY NOT NULL,
		[pedido_ID] INT NOT NULL,
		[produto_ID] INT NOT NULL,
		[quantidade] INT NOT NULL,
		[preco_unitario] DECIMAL(10,2) NOT NULL
	);

DROP TABLE IF EXISTS Checkout;
	CREATE TABLE Checkout(
		[Pedido_id] INT NOT NULL,
		[total_pedido] DECIMAL(10,2) NOT NULL,
		[status_despacho] INT NOT NULL,
		[data_despacho] DATETIME NOT NULL,
	);

DROP TABLE IF EXISTS Fornecedores;
	CREATE TABLE Fornecedores(
		[fornecedor_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[Nome_fornecedor] VARCHAR(50) NOT NULL,
		[CNPJ] VARCHAR(50) NOT NULL
	);

DROP TABLE IF EXISTS RequisicaoCompra;
	CREATE TABLE RequisicaoCompra(
		[Requisicao_ID] INT PRIMARY KEY IDENTITY NOT NULL,
		[Fornecedor_id] INT NOT NULL,
		[Produto_id] INT NOT NULL,
		[qte] INT NOT NULL,
		[compra_status] INT NOT NULL,
		[total] DECIMAL(10, 2) NOT NULL,
		[dataEmissao] DATETIME NOT NULL
	);

DROP TABLE IF EXISTS NotaFiscal;
	CREATE TABLE NotaFiscal(
		[NotaFiscal_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[Pedido_ID] INT  NOT NULL,
		[Valor_Total] DECIMAL(10,2) NOT NULL,
		[Data_Emissao] DATETIME NOT NULL
	);

DROP TABLE IF EXISTS Transportadora;
	CREATE TABLE Transportadora(
		[Transportadora_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[Nome_Transportadora] VARCHAR(150) NOT NULL,
		[CNPJ_Transportadora] VARCHAR(50) NOT NULL,
		[Tipo_Servico] VARCHAR(50) NOT NULL,
		[Custo_Frete] DECIMAL(18,0) NOT NULL
	);

DROP TABLE IF EXISTS DespachoMercadorias;
	CREATE TABLE DespachoMercadorias(
		[Despacho_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[Produto_ID] INT NOT NULL,
		[Transportadora_ID] INT NOT NULL,
		[Status_Entrega] INT NOT NULL,
		[Data_Entrega] DATETIME NOT NULL
	);

DROP TABLE IF EXISTS Estoque;
	CREATE TABLE Estoque (
		[Est_Prod_ID] INT PRIMARY KEY IDENTITY NOT NULL,
        [Prod_ID] INT NOT NULL,
		[Quantidade] INT CHECK (Quantidade >= 0) DEFAULT 0,
		[Estoque_Minimo] INT NOT NULL DEFAULT 0,
	);

DROP TABLE IF EXISTS AcompanhamentoPedidos;
	CREATE TABLE AcompanhamentoPedidos (
		[ItensPedidos_ID] INT PRIMARY KEY NOT NULL,
        [ItensPedidos_status] BIT NOT NULL		
	);


ALTER TABLE AcompanhamentoPedidos ADD CONSTRAINT FK_AP_IP FOREIGN KEY (ItensPedidos_ID) REFERENCES ItensPedidos(Item_ID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RequisicaoCompra ADD CONSTRAINT FK_RC_FORN FOREIGN KEY (Fornecedor_id) REFERENCES Fornecedores(Fornecedor_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RequisicaoCompra ADD CONSTRAINT FK_RC_PROD FOREIGN KEY (Produto_id) REFERENCES Produtos(produto_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RequisicaoCompra ADD CONSTRAINT FK_RC_STAT FOREIGN KEY (compra_status) REFERENCES StatusPedido (Status_ID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Pedidos ADD CONSTRAINT FK_PED_CLI FOREIGN KEY (cliente_ID) REFERENCES Clientes (cliente_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ItensPedidos ADD CONSTRAINT FK_IP_PE FOREIGN KEY (pedido_ID) REFERENCES Pedidos (pedido_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ItensPedidos ADD CONSTRAINT FK_IP_PROD FOREIGN KEY (produto_ID) REFERENCES Produtos (produto_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE NotaFiscal ADD CONSTRAINT FK_NF_PE FOREIGN KEY (Pedido_ID) REFERENCES Pedidos (pedido_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Checkout ADD CONSTRAINT FK_P_C FOREIGN KEY (Pedido_id) REFERENCES Pedidos (Pedido_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Checkout ADD CONSTRAINT FK_SD_D FOREIGN KEY (status_despacho) REFERENCES StatusDespacho(IDStatus) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DespachoMercadorias ADD CONSTRAINT FK_DM_PROD FOREIGN KEY (Produto_ID) REFERENCES Produtos (produto_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DespachoMercadorias ADD CONSTRAINT FK_DM_TRANS FOREIGN KEY (Transportadora_ID) REFERENCES Transportadora (Transportadora_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Estoque ADD CONSTRAINT FK_EST_PROD FOREIGN KEY (Prod_ID) REFERENCES Produtos(produto_id)ON DELETE CASCADE ON UPDATE CASCADE;

END
