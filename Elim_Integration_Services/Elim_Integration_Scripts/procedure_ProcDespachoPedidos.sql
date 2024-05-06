IF OBJECT_ID('ProcDespachoPedidos', 'PR') IS NOT NULL
   DROP PROCEDURE ProcDespachoPedidos;
GO

CREATE PROCEDURE ProcDespachoPedidos
AS
BEGIN
    DECLARE @PedidoID INT

    -- Obtém o ID do pedido afetado
    SELECT @PedidoID = IPD.pedido_ID 
    FROM ItensPedidos IPD 
    INNER JOIN AcompanhamentoPedidos AP ON AP.ItensPedidos_ID = IPD.Item_ID

    -- Verifica se todos os itens do pedido estão completos
    IF NOT EXISTS (
        SELECT * FROM ItensPedidos ip
        INNER JOIN Pedidos ON Pedidos.pedido_id = ip.pedido_ID
        INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ip.Item_ID
        WHERE Pedidos.pedido_id = @PedidoID AND ap.ItensPedidos_status = 0
    )
    BEGIN
        -- Todos os itens estão completos, então verifica se o despacho já foi registrado
        IF NOT EXISTS (
            SELECT * FROM DespachoMercadorias
            WHERE Produto_ID IN (SELECT Item_ID FROM ItensPedidos WHERE pedido_ID = @PedidoID)
        )
        BEGIN
            -- Atualiza a tabela de despacho
            INSERT INTO DespachoMercadorias (Produto_ID, Transportadora_ID, Status_Entrega, Data_Entrega)
            SELECT IPD.Item_ID, 1 AS Transportadora_ID, 1 AS Status_Entrega, GETDATE() AS Data_Entrega
            FROM ItensPedidos IPD
            WHERE IPD.pedido_ID = @PedidoID

            PRINT 'Despacho atualizado para o pedido ' + CAST(@PedidoID AS VARCHAR(10))
        END
    END
END