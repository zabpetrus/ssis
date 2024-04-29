
IF OBJECT_ID ('AtualizandoChegadaProduto','TR') IS NOT NULL
   DROP TRIGGER AtualizandoChegadaProduto;
GO


CREATE TRIGGER AtualizandoChegadaProduto
ON RequisicaoCompra
	AFTER UPDATE
AS
BEGIN
	
	IF UPDATE(compra_status)
	BEGIN
		IF EXISTS (
			SELECT COUNT(*) FROM inserted i
			INNER JOIN deleted d ON i.Produto_id = d.Produto_id
			WHERE i.compra_status <> d.compra_status
			AND i.compra_status = 2
		)
		BEGIN
			SELECT * FROM Estoque;
		END
	END
END