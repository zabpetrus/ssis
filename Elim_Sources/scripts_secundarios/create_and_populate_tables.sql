Use Utilitario;

BEGIN

DROP TABLE IF EXISTS Clientes;
	CREATE TABLE Clientes (
		[id] int not null,
		[Nome] varchar(150) not null,
		[endereco] VARCHAR(150) NOT NULL,
		[email] VARCHAR(50) NOT NULL,
		[cep] VARCHAR(50) NOT NULL,
		[uf] VARCHAR(50) NOT NULL,
		[pais] VARCHAR(50) NOT NULL,
	);
DROP TABLE IF EXISTS Produtos;
	CREATE TABLE Produtos (
		[IDProduto] INT NOT NULL,
		[Nome_Produto] VARCHAR(150) NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[qte] INT NOT NULL,
		[valor] DECIMAL(10,2) NOT NULL	
	);
DROP TABLE IF EXISTS Pedidos;
	CREATE TABLE Pedidos(
		[codigo_Pedido] VARCHAR(50) NOT NULL,
		[cliente_ID] INT NOT NULL,
		[data_Pedido] VARCHAR(50) NOT NULL,
		[status_pedido] VARCHAR(50) NOT NULL,
		[endereco_entrega] VARCHAR(150) NOT NULL,
		[total_pedido] DECIMAL(10,2) NOT NULL,
		[status_despacho] VARCHAR(50) NOT NULL,
		[data_despacho] DATETIME NOT NULL
	);
DROP TABLE IF EXISTS ItensPedidos;
	CREATE TABLE ItensPedidos(
		[Item_ID] INT IDENTITY NOT NULL,
		[pedido_ID] INT NOT NULL,
		[produto_ID] VARCHAR(50) NOT NULL,
		[quantidade] INT NOT NULL,
		[preco_unitario] DECIMAL(10,2) NOT NULL
	);
DROP TABLE IF EXISTS Fornecedores;
	CREATE TABLE Fornecedores(
		[FID] INT IDENTITY NOT NULL,
		[Nome_fornecedor] VARCHAR(50) NOT NULL,
		[Contato] VARCHAR(150) NOT NULL,
		[CNPJ] VARCHAR(50) NOT NULL
	);

DROP TABLE IF EXISTS RequisicaoCompra;
	CREATE TABLE RequisicaoCompra(
		[Req_ID] INT IDENTITY NOT NULL,
		[FID] INT NOT NULL,
		[Produto_ID] INT NOT NULL,
		[qte] INT NOT NULL,
		[status] VARCHAR(50) NOT NULL
	);

DROP TABLE IF EXISTS NotaFiscal;
	CREATE TABLE NotaFiscal(
		[Pedido_ID] INT  NOT NULL,
		[Valor_Total] DECIMAL(10,2) NOT NULL,
		[Data_Emissao] DATETIME NOT NULL
	);

DROP TABLE IF EXISTS Transportadora;
	CREATE TABLE Transportadora(
		[Tid] INT IDENTITY NOT NULL,
		[Nome_Transportadora] VARCHAR(150) NOT NULL,
		[CNPJ_Transportadora] VARCHAR(50) NOT NULL,
		[Tipo_Servico] VARCHAR(50) NOT NULL,
		[Custo_Frete] DECIMAL(18,0) NOT NULL
	);

DROP TABLE IF EXISTS DespachoMercadorias;
	CREATE TABLE DespachoMercadorias(
		[DMid] INT IDENTITY NOT NULL,
		[Produto_ID] INT NOT NULL,
		[Transportadora_ID] INT NOT NULL,
		[Status_Entrega] VARCHAR(50) NOT NULL,
		[Data_Entrega] DATETIME NOT NULL
	);

END
