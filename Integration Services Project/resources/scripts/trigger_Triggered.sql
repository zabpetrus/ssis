IF OBJECT_ID('Triggered', 'TR') IS NOT NULL
   DROP TRIGGER Triggered;
GO

/*
UPDATE [dbo].[RequisicaoCompra]
   SET [compra_status] = 2
 WHERE RequisicaoCompra.Produto_id = 6;
GO

*/

CREATE TRIGGER Triggered
ON RequisicaoCompra
AFTER UPDATE
AS
BEGIN
 IF UPDATE(compra_status)  
    BEGIN
			UPDATE E
			SET E.Quantidade = RC.qte
			FROM Estoque E
			INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
			WHERE RC.compra_status = 2;

	
			UPDATE AcompanhamentoPedidos 
			SET ItensPedidos_status = 1 
			WHERE ItensPedidos_ID IN (
				SELECT IP.Item_ID 
				FROM AcompanhamentoPedidos AP 
				INNER JOIN ItensPedidos IP ON IP.Item_ID = AP.ItensPedidos_ID 
				WHERE IP.produto_ID IN (
					SELECT E.Prod_ID 
					FROM Estoque E
					INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
					WHERE RC.compra_status = 2
				)
			);

       
    END
END

