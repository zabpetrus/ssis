
IF OBJECT_ID ('AdicionandoProdutosNoEstoque','TR') IS NOT NULL
   DROP TRIGGER AdicionandoProdutosNoEstoque;
GO


CREATE TRIGGER AdicionandoProdutosNoEstoque
ON Produtos 
   AFTER INSERT
AS 
BEGIN
	Insert into Estoque (Prod_ID, Quantidade, Estoque_Minimo)
	SELECT 
	Produtos.produto_id AS Prod_ID,
	COALESCE(SUM(Estoque.quantidade), 0) AS Quantidade,
	SUM(ItensPedidos.quantidade) AS Estoque_Minimo	
	FROM Produtos 
	INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
	LEFT JOIN Estoque ON Produtos.produto_id = Estoque.Prod_ID 
	GROUP BY
	Produtos.produto_id, ItensPedidos.quantidade;
END



