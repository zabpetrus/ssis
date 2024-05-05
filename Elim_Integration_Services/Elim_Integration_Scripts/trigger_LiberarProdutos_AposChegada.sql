
IF OBJECT_ID ('LiberarProdutos_AposChegada','TR') IS NOT NULL
   DROP TRIGGER LiberarProdutos_AposChegada;
GO


CREATE TRIGGER LiberarProdutos_AposChegada
ON Estoque
AFTER UPDATE
AS
BEGIN

DECLARE @qte_item INT;
DECLARE @Item_ID INT;
DECLARE @Quantidade INT;
DECLARE @CursorItens CURSOR;

SET @CursorItens = CURSOR FOR
SELECT ItensPedidos.Item_ID, ItensPedidos.quantidade 
FROM ItensPedidos
INNER JOIN Estoque ON Estoque.Prod_ID = ItensPedidos.produto_ID
WHERE Estoque.Quantidade > 0;



OPEN @CursorItens;

FETCH NEXT FROM @CursorItens INTO @Item_ID, @Quantidade;

WHILE @@FETCH_STATUS = 0
BEGIN

	IF @@FETCH_STATUS = 0

	BEGIN

	SELECT @qte_item = Quantidade FROM ItensPedidos WHERE ItensPedidos.Item_ID = @Item_ID;

	IF @qte_item <= (SELECT Quantidade FROM Estoque WHERE Prod_ID = @Item_ID)
		BEGIN
			-- Verificar se a quantidade após a subtração é maior que zero
			IF (SELECT Quantidade - @qte_item FROM Estoque WHERE Prod_ID = @Item_ID) > 0
			BEGIN
				UPDATE Estoque SET Quantidade = Quantidade - @qte_item WHERE Prod_ID = @Item_ID;
				UPDATE AcompanhamentoPedidos SET ItensPedidos_status = 1 WHERE ItensPedidos_ID = @Item_ID;
			END
		END
	
	END


    FETCH NEXT FROM @CursorItens INTO @Item_ID, @Quantidade;
END

CLOSE @CursorItens;
DEALLOCATE @CursorItens;

END