  Use Utilitario;
  GO
  BEGIN
   DROP TABLE IF EXISTS Carga;   
   CREATE TABLE TCarga
	(
		[codigoPedido] VARCHAR(50) NOT NULL,
		[dataPedido] DATETIME NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[nomeProduto] VARCHAR(150) NOT NULL,
		[qte] INT  NOT NULL,
		[valor] DECIMAL(18,0) NOT NULL,
		[frete] DECIMAL(18,0)  NOT NULL,
		[email] VARCHAR(50) NOT NULL,
		[cpf] VARCHAR(30) NOT NULL,
		[nomeComprador] VARCHAR(150) NOT NULL,
		[enderecoEntrega] VARCHAR(150) NOT NULL,
		[cep] VARCHAR(10) NOT NULL,
		[uf] VARCHAR(2) NOT NULL,
		[pais] VARCHAR(30) NOT NULL
	)
   END
