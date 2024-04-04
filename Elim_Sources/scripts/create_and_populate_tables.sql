 DROP TABLE IF EXISTS Clientes;
	CREATE TABLE Clientes (
		[nomeComprador] varchar(150) not null,
		[endereco] VARCHAR(150) NOT NULL,
		[email] VARCHAR(50) NOT NULL,
		[cep] VARCHAR(50) NOT NULL,
		[uf] VARCHAR(50) NOT NULL,
		[pais] VARCHAR(50) NOT NULL
	);
DROP TABLE IF EXISTS Produtos;
	CREATE TABLE Produtos (
		[nomeProduto] VARCHAR(150) NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[qte] INT NOT NULL,
		[valor] DECIMAL(10,2) NOT NULL	
	);
DROP TABLE IF EXISTS Pedidos;
	CREATE TABLE Pedidos(
		[codigoPedido] VARCHAR(50) NOT NULL,
		[dataPedido] VARCHAR(50) NOT NULL,
	);

