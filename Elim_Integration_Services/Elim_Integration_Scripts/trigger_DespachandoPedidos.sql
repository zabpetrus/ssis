IF OBJECT_ID('DespachandoPedidos', 'TR') IS NOT NULL
   DROP TRIGGER DespachandoPedidos;
GO


CREATE TRIGGER DespachandoPedidos
ON AcompanhamentoPedidos
AFTER UPDATE
AS
BEGIN
	EXEC ProcDespachoPedidos;
END;
