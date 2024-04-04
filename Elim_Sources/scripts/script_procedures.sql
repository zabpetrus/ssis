BEGIN;

CREATE TABLE #PClientes
(
	[codigoPedido] VARCHAR(50) NOT NULL,
	[dataPedido] VARCHAR(50) NOT NULL,
	[sku] VARCHAR(50) NOT NULL,
	[upc] VARCHAR(50) NOT NULL,
	[nomeProduto] VARCHAR(150) NOT NULL,
	[qte] VARCHAR(50) NOT NULL,
	[valor] VARCHAR(50) NOT NULL,
	[frete] VARCHAR(50) NOT NULL,
	[email] VARCHAR(50) NOT NULL,
	[nomeComprador] VARCHAR(50) NOT NULL,
	[endereco] VARCHAR(100) NOT NULL,
	[cep] VARCHAR(50) NOT NULL,
	[uf] VARCHAR(50) NOT NULL,
	[pais] VARCHAR(50) NOT NULL
);


END;