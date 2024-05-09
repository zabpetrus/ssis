USE [Utilitario];

IF OBJECT_ID ('dt2','TR') IS NOT NULL
   DROP TRIGGER dt2;
GO


CREATE TRIGGER dt2
ON Estoque
AFTER UPDATE
AS
BEGIN
	/*
	Quando atualiza o estoque, verifica se algum pedido pode ser atendido e 
	,ao ser atendido, é subtraido do estoque.
	*/
	IF UPDATE(Quantidade)
	BEGIN
		EXEC DP2;
	END
END
