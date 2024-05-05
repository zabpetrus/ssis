IF OBJECT_ID('LiberarItens', 'P') IS NOT NULL
   DROP PROCEDURE LiberarItens;
GO

CREATE PROCEDURE LiberarItens
AS
BEGIN

DECLARE @qte_item INT;
DECLARE @Item_ID INT;
DECLARE @Quantidade INT;
DECLARE @alf INT;

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

	SELECT @alf = Quantidade - @qte_item FROM Estoque WHERE Prod_ID = @Item_ID AND (Quantidade - @qte_item) > 0;

	IF(@alf >= 0)

	BEGIN

		UPDATE Estoque SET Quantidade = Quantidade - @qte_item WHERE Prod_ID = @Item_ID;

		UPDATE AcompanhamentoPedidos SET ItensPedidos_status = 1 WHERE ItensPedidos_ID = @Item_ID;
	
	END
	
	END


    FETCH NEXT FROM @CursorItens INTO @Item_ID, @Quantidade;
END

CLOSE @CursorItens;
DEALLOCATE @CursorItens;

END