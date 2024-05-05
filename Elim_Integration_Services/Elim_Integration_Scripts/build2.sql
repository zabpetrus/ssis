BEGIN

DECLARE @qte_item INT;
DECLARE @Item_ID INT;
DECLARE @Quantidade INT;

DECLARE @CursorItens CURSOR;

SET @CursorItens = CURSOR FOR
SELECT ItensPedidos.Item_ID, ItensPedidos.quantidade 
FROM ItensPedidos
INNER JOIN Estoque ON Estoque.Prod_ID = ItensPedidos.produto_ID
WHERE Estoque.Quantidade >= 0;



OPEN @CursorItens;

FETCH NEXT FROM @CursorItens INTO @Item_ID, @Quantidade;

WHILE @@FETCH_STATUS = 0
BEGIN

	IF @@FETCH_STATUS = 0

	BEGIN

	SELECT @qte_item = Quantidade FROM ItensPedidos WHERE ItensPedidos.Item_ID = @Item_ID;

--	PRINT 'Item ID: ' + CAST(@Item_ID AS NVARCHAR(10)) + ' Quantidade: ' + CAST(@Quantidade AS NVARCHAR(10));
		
	-- Aqui você pode fazer a atualização na outra tabela
--	PRINT 'UPDATE Estoque SET Quantidade = Quantidade - ' + CAST(@qte_item AS NVARCHAR(10)) + ' WHERE Prod_ID = ' + CAST(@Item_ID AS NVARCHAR(10));

	UPDATE Estoque SET Quantidade = Quantidade - @qte_item WHERE Prod_ID = @Item_ID;

--	PRINT 'UPDATE AcompanhamentoPedidos SET ItensPedidos_status = 1 WHERE ItensPedidos_ID = ' + CAST(@Item_ID AS NVARCHAR(10));

	UPDATE AcompanhamentoPedidos SET ItensPedidos_status = 1 WHERE ItensPedidos_ID = @Item_ID;
	
	END


    FETCH NEXT FROM @CursorItens INTO @Item_ID, @Quantidade;
END

CLOSE @CursorItens;
DEALLOCATE @CursorItens;

END