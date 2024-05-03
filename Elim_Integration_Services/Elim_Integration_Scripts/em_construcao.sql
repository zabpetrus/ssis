Use Utilitario;
BEGIN

DECLARE @produto_id INT
DECLARE @estoque_disponivel INT;

-- Obtendo quantidade disponível em estoque para o produto
SELECT @estoque_disponivel = Es.Quantidade FROM Estoque Es WHERE Es.Prod_ID = @produto_id;

-- Obtendo pedidos pendentes que contêm o produto
DECLARE pedidos_pendentes CURSOR FOR
        SELECT pc.pedido_id, pc.quantidade
        FROM ProdutosChegados pc
        WHERE pc.produto_ID = @produto_id
          AND pc.checked = false
          AND pc.despacho = false
        ORDER BY pc.data_despacho;

    -- Iterar sobre os pedidos pendentes
    OPEN pedidos_pendentes;
    DECLARE @pedido_id INT, @quantidade_restante INT;

    FETCH NEXT FROM pedidos_pendentes INTO @pedido_id, @quantidade_restante;

    WHILE @@FETCH_STATUS = 0 AND @estoque_disponivel > 0
    BEGIN
        -- Calcular quantidade a subtrair do estoque
        DECLARE @quantidade_a_subtrair INT;
        IF @estoque_disponivel >= @quantidade_restante
            SET @quantidade_a_subtrair = @quantidade_restante;
        ELSE
            SET @quantidade_a_subtrair = @estoque_disponivel;

        -- Atualizar estoque
        UPDATE Estoque
        SET Quantidade = Quantidade - @quantidade_a_subtrair
        WHERE Prod_ID = @produto_id;

        -- Atualizar quantidade restante do pedido
        UPDATE ProdutosChegados
        SET quantidade = quantidade - @quantidade_a_subtrair
        WHERE pedido_id = @pedido_id AND produto_ID = @produto_id;

        -- Atualizar quantidade disponível em estoque
        SET @estoque_disponivel = @estoque_disponivel - @quantidade_a_subtrair;

        -- Verificar se o pedido foi totalmente atendido
        IF @quantidade_restante - @quantidade_a_subtrair <= 0
        BEGIN
            -- Marcar o pedido como despachado
            UPDATE ProdutosChegados
            SET despacho = true
            WHERE pedido_id = @pedido_id;
        END;

        -- Obter próximo pedido
        FETCH NEXT FROM pedidos_pendentes INTO @pedido_id, @quantidade_restante;
    END;

    CLOSE pedidos_pendentes;
    DEALLOCATE pedidos_pendentes;



	
END