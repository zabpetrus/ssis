
CREATE VIEW CriarVisualizacaoEstoque
AS
(
SELECT Estoque.Est_Prod_ID,
	   Pr.nome_Produto,
	   Estoque.Quantidade,
	   Estoque.Estoque_Minimo,
	   Fornecedores.fornecedor_id,
	   Pr.nome_fornecedor	   
	   FROM Estoque 
	   INNER JOIN Produtos Pr ON Estoque.Prod_ID = Pr.produto_id
	   INNER JOIN Fornecedores ON Fornecedores.CNPJ = Pr.fornecedor_CNPJ);