Use Utilitario;
BEGIN

   /*
	SELECT COUNT( Estoque.Prod_ID ) FROM Estoque
	INNER JOIN ItensPedidos itp ON
	itp.produto_ID = Estoque.Prod_ID;
	 	
	

	-- se o produto id consta, atualiza com o valor de carga
--	INSERT INTO RequisicaoCompra ( Fornecedor_id, Produto_id, qte, status ) VALUES

	*/

	SELECT * FROM RequisicaoCompra;
	SELECT * FROM ItensPedidos;
	SELECT *  FROM Pedidos;

	--SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade )from ItensPedidos;
	INSERT INTO RequisicaoCompra ( Fornecedor_id, Produto_id, qte, compra_status, total, dataEmissao ) 
	SELECT 
	Fornecedores.fornecedor_id,
	Produtos.produto_id,
	ItensPedidos.quantidade,
	StatusPedido.Nome_Status,
	ItensPedidos.preco_unitario * ItensPedidos.quantidade AS total,
	GETDATE() AS dataEmissao
	FROM Produtos
	INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ
	INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
	INNER JOIN StatusPedido ON StatusPedido.Status_ID = 1;
	



	
	


END