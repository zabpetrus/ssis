CREATE PROCEDURE ReiniciarTabela
AS
BEGIN
    DROP TABLE IF EXISTS Clientes;
	CREATE TABLE Clientes (
		[nomeComprador] varchar(150) not null,
		[endereco] VARCHAR(150) NOT NULL,
		[email] VARCHAR(50) NOT NULL,
		[cep] VARCHAR(50) NOT NULL,
		[uf] VARCHAR(50) NOT NULL,
		[pais] VARCHAR(50) NOT NULL
	);

	CREATE TABLE Produtos (
		[nomeProduto] VARCHAR(150) NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[qte] INT NOT NULL,
		[valor] DECIMAL(10,2) NOT NULL	
	);

	CREATE TABLE Pedidos(
		[codigoPedido] VARCHAR(50) NOT NULL,
		[dataPedido] VARCHAR(50) NOT NULL,
	);

	INSERT INTO Clientes(nomeComprador, endereco, email, cep, uf,pais)
	SELECT nomeComprador, endereco, email, cep, uf, pais 
	FROM PClientes;
END;

EXEC ReiniciarTabela;