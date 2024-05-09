USE [Utilitario];

IF OBJECT_ID ('AtualizandoChegadaProduto','TR') IS NOT NULL
   DROP TRIGGER AtualizandoChegadaProduto;
GO


CREATE TRIGGER AtualizandoChegadaProduto
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
		IF EXISTS (
			SELECT * FROM inserted i
			INNER JOIN deleted d ON i.Produto_id = d.Produto_id
			WHERE i.compra_status <> d.compra_status
			AND i.compra_status = 2
		)
		BEGIN			
			UPDATE E
			SET E.Quantidade = RC.qte
			FROM Estoque E
			INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
			WHERE RC.compra_status = 2;
		END
	END
END
