IF OBJECT_ID('ProcDespachoPedidos', 'PR') IS NOT NULL
   DROP PROCEDURE ProcDespachoPedidos;
GO

CREATE PROCEDURE ProcDespachoPedidos
AS
BEGIN
    DECLARE @PedidoID INT

    -- Obt�m o ID do pedido afetado
    SELECT @PedidoID = IPD.pedido_ID 
    FROM ItensPedidos IPD 
    INNER JOIN AcompanhamentoPedidos AP ON AP.ItensPedidos_ID = IPD.Item_ID
	AND Ap.ItensPedidos_status = 1;


    -- Verifica se todos os itens do pedido est�o completos
    IF EXISTS (
        SELECT * FROM ItensPedidos ip
        INNER JOIN Pedidos ON Pedidos.pedido_id = ip.pedido_ID
        INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ip.Item_ID
        WHERE Pedidos.pedido_id = @PedidoID AND ap.ItensPedidos_status = 1
    )
    BEGIN
        -- Todos os itens est�o completos, ent�o verifica se o despacho j� foi registrado
         
        -- Atualiza a tabela de despacho
        UPDATE DespachoMercadorias SET Status_Entrega = 2 WHERE 
		DespachoMercadorias.Pedido_ID = @PedidoID;

        PRINT 'Despacho atualizado para o pedido ' + CAST(@PedidoID AS VARCHAR(10))
    
    END
END