USE [Utilitario];

IF OBJECT_ID ('dt1','TR') IS NOT NULL
   DROP TRIGGER dt1;
GO


CREATE TRIGGER dt1
ON RequisicaoCompra
AFTER UPDATE
AS
BEGIN
	/*
	Ao atualizar a coluna compra_status, ser� disparado o seguinte gatilho: 
	Contar-se-� os elementos que foram alterados e verificar� se mudou para o valor 2, que � o
	indicativo que o produto chegou
	*/
	IF UPDATE(compra_status)
	BEGIN
		EXEC DP1;
	END
END
