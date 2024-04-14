  /**
  Tabela original de carga. Devido a problemas de conversão de tipos no SSIS
  A coluna dataPedido foi posta como VARCHAR(30).
  A conversão para datetime será feita via sql usando alter table  
  **/

Use Utilitario;
   BEGIN
   DROP TABLE IF EXISTS Carga;   
   CREATE TABLE Carga
	(
		[codigoPedido] VARCHAR(50) NOT NULL,
		[dataPedido] VARCHAR(30) NOT NULL,
		[sku] VARCHAR(50) NOT NULL,
		[upc] VARCHAR(50) NOT NULL,
		[nomeProduto] VARCHAR(150) NOT NULL,
		[Descricao] VARCHAR(150) NOT NULL,
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
