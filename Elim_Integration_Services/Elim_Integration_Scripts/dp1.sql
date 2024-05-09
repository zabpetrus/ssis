USE [Utilitario];
GO

IF OBJECT_ID('DP1', 'P') IS NOT NULL
   DROP PROCEDURE DP1;
GO

CREATE PROCEDURE DP1
AS
BEGIN
	-- Em requisicao compra vemos os produtos que chegaram

	DECLARE @id INT;
	DECLARE @qte INT;

	SELECT @id = rc.Produto_id, @qte = rc.qte FROM RequisicaoCompra rc WHERE rc.compra_status = 2;

	UPDATE Estoque SET Quantidade = @qte WHERE Prod_ID = @id;

	PRINT 'Atualizacao do Produto de ID ' + CONVERT(VARCHAR, @id )  + ' no Estoque, inseridas ' + CONVERT(VARCHAR, @qte )  + ' unidades';

END
