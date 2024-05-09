USE [Utilitario];

IF OBJECT_ID ('DT3','TR') IS NOT NULL
   DROP TRIGGER dt3;
GO


CREATE TRIGGER DT3
ON ItensPedidos
AFTER UPDATE
AS
BEGIN
	/*
	Quando atualiza a coluna disponivel em Itenspedidos, verifica se algum pedido pode ser atendido e 
	,ao ser atendido, é subtraido do estoque.
	*/
	IF UPDATE(disponivel)
	BEGIN
		EXEC DP3;
	END
END
