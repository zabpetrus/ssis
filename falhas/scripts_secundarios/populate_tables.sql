BEGIN
INSERT INTO Clientes(nomeComprador, endereco, email, cep, uf,pais)
	SELECT nomeComprador, endereco, email, cep, uf, pais 
	FROM PClientes;	

INSERT INTO Produtos(nomeProduto, sku, upc, qte, valor)
	SELECT nomeProduto, sku, upc, qte, valor  
	FROM PClientes;

INSERT INTO Pedidos( codigoPedido, dataPedido )
	SELECT codigoPedido, dataPedido
	FROM PClientes;
END