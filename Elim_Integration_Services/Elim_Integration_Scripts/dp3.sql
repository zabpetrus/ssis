-- Percorrendo os itenspedidos e vendo quais estão prontos
IF OBJECT_ID('DP3', 'P') IS NOT NULL
   DROP PROCEDURE DP3;
GO

CREATE PROCEDURE DP3
AS
BEGIN

	  DECLARE @pedidoID INT;
	  DECLARE @PedidoPronto CURSOR;

	  SET @PedidoPronto = CURSOR FOR

	  SELECT pedido_ID
	  FROM ItensPedidos
	  GROUP BY pedido_ID
	  HAVING SUM(CASE WHEN disponivel = 0 THEN 1 ELSE 0 END) = 0;

	  OPEN @PedidoPronto;

	  FETCH NEXT FROM @PedidoPronto INTO @pedidoID;

	  WHILE @@FETCH_STATUS = 0
      BEGIN

		  UPDATE Pedidos SET status_pedido = 2 WHERE Pedidos.pedido_id = @pedidoID;

		  PRINT 'Pedidos id ' + CONVERT(VARCHAR, @pedidoID )  + 'atualizado ';

		  UPDATE DespachoMercadorias SET Status_Entrega = 2 WHERE DespachoMercadorias.Pedido_ID = @pedidoID;
	 
		  PRINT 'Despacho do pedido ' + CONVERT(VARCHAR, @pedidoID ) ;

		  UPDATE Checkout SET status_despacho = 2, data_despacho = GETDATE() WHERE Checkout.Pedido_id = @pedidoID;

		  PRINT 'Checkout atualizado para o do pedido ' + CONVERT(VARCHAR, @pedidoID ) ;

		  FETCH NEXT FROM @PedidoPronto INTO @pedidoID;

	  END

	   CLOSE @PedidoPronto;
       DEALLOCATE @PedidoPronto;

END