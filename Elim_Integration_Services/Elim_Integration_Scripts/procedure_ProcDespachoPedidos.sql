IF OBJECT_ID('ProcDespachoPedidos', 'P') IS NOT NULL
   DROP PROCEDURE ProcDespachoPedidos;
GO

CREATE PROCEDURE ProcDespachoPedidos
AS
BEGIN
    DECLARE @PedidoID INT

    -- Obtém o ID do pedido afetado
    SELECT TOP 1 @PedidoID = ip.pedido_ID
    FROM ItensPedidos ip
    LEFT JOIN AcompanhamentoPedidos ap ON ip.Item_ID = ap.ItensPedidos_ID
    GROUP BY ip.pedido_ID
    HAVING COUNT(ap.ItensPedidos_ID) = COUNT(CASE WHEN ap.ItensPedidos_status = 1 THEN 1 END);

    -- Verifica se o pedido está completo e se não há despacho registrado
    IF @PedidoID IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM DespachoMercadorias dm
        WHERE dm.Pedido_ID = @PedidoID
    )
    BEGIN
        -- Atualiza a tabela de despacho
        UPDATE DespachoMercadorias
        SET Status_Entrega = 2
        WHERE Pedido_ID = @PedidoID;

        PRINT 'Despacho atualizado para o pedido ' + CAST(@PedidoID AS VARCHAR(10))
    END
    ELSE
    BEGIN
        PRINT 'Não há pedidos completos sem despacho registrado.'
    END
END
