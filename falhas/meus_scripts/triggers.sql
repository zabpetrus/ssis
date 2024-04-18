USE Utilitario;
GO

CREATE TRIGGER Colocar_estoque
ON Produtos
AFTER INSERT
AS
BEGIN
	INSERT INTO Estoque( Prod_ID, Quantidade, Estoque_Minimo)
	SELECT produto_id, 0, 0 FROM Produtos;


		
END
GO