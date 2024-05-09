USE [Utilitario];

IF OBJECT_ID('VerificandoTodosItensPedido', 'P') IS NOT NULL
   DROP PROCEDURE VerificandoTodosItensPedido;
GO

CREATE PROCEDURE VerificandoTodosItensPedido
AS
BEGIN
	

	CREATE TABLE #PedidosParaAtualizar ( pedido_ID INT);

	INSERT INTO #PedidosParaAtualizar (pedido_ID)
	SELECT TOP 1 ip.pedido_ID
	FROM ItensPedidos ip
	INNER JOIN AcompanhamentoPedidos ac ON ac.ItensPedidos_ID = ip.Item_ID 
	GROUP BY ip.pedido_ID
	HAVING COUNT(*) = SUM(CASE WHEN ItensPedidos_status = 1 THEN 1 ELSE 0 END);

	
	UPDATE Pedidos 
	SET status_pedido = 2 
	WHERE pedido_ID IN (SELECT pedido_ID FROM #PedidosParaAtualizar);
	
	DROP TABLE #PedidosParaAtualizar;   	 


END