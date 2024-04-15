CREATE TRIGGER Colocar_estoque
ON Produtos
AFTER INSERT
AS
BEGIN
	INSERT INTO Estoque( Prod_ID, Quantidade, Estoque_Minimo)
	SELECT Prod_ID, 0, 0 FROM Produtos;
	
	INSERT INTO RequisicaoCompra(Fornecedor_id, Produto_id, qte, status)
	SELECT Fornecedores.Fornecedor_id, Produtos.produto_id, TCarga.qte, StatusDespacho.IDStatus 
	FROM TCarga
	INNER JOIN 
	 	
	
END