Use Utilitario;

BEGIN

-- Começando excluindo as constraints caso elas existam
-- Procedimento para correção do banco

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
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) UNIQUE NOT NULL,
		[valor] DECIMAL(10,2) NOT NULL	
	);
DROP TABLE IF EXISTS Pedidos;
	CREATE TABLE Pedidos(
		[pedido_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[codigo_Pedido] VARCHAR(50) NOT NULL,
		[cliente_ID] INT NOT NULL,
		[data_Pedido] DATETIME NOT NULL,
		[endereco_entrega] VARCHAR(150) NOT NULL,
        [cep] VARCHAR(10) NOT NULL,		
		[custo_frete] DECIMAL(10,2) NOT NULL,
		[status_pedido] INT NOT NULL DEFAULT 1

	);
DROP TABLE IF EXISTS ItensPedidos;
	CREATE TABLE ItensPedidos(
		[Item_ID] INT PRIMARY KEY IDENTITY NOT NULL,
		[pedido_ID] INT NOT NULL,
		[produto_ID] VARCHAR(50) NOT NULL,
		[quantidade] INT NOT NULL,
		[preco_unitario] DECIMAL(10,2) NOT NULL
	);

DROP TABLE IF EXISTS Checkout;
	CREATE TABLE Checkout(
		[total_pedido] DECIMAL(10,2) NOT NULL,
		[status_despacho] VARCHAR(50) NOT NULL,
		[data_despacho] DATETIME NOT NULL,
	);

DROP TABLE IF EXISTS Fornecedores;
	CREATE TABLE Fornecedores(
		[fornecedor_id] INT PRIMARY KEY IDENTITY NOT NULL,
		[Nome_fornecedor] VARCHAR(50) NOT NULL,
		[Contato] VARCHAR(30) NOT NULL,
		[CNPJ] VARCHAR(50) NOT NULL
	);

DROP TABLE IF EXISTS RequisicaoCompra;
	CREATE TABLE RequisicaoCompra(
		[Requisicao_ID] INT PRIMARY KEY IDENTITY NOT NULL,
		[Fornecedor_id] INT NOT NULL,
		[Produto_id] INT NOT NULL,
		[qte] INT NOT NULL,
		[status] VARCHAR(50) NOT NULL
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
		[Status_Entrega] VARCHAR(50) NOT NULL,
		[Data_Entrega] DATETIME NOT NULL
	);

DROP TABLE IF EXISTS Estoque;
	CREATE TABLE Estoque (
		[Est_Prod_ID] INT PRIMARY KEY NOT NULL,
		[Quantidade] INT NOT NULL,
		[Estoque_Minimo] INT NOT NULL,
	);




ALTER TABLE Estoque ADD CONSTRAINT FK_EST_PROD FOREIGN KEY (Est_Prod_ID) REFERENCES Produtos(produto_id);


END
