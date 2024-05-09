USE [Utilitario];
GO

IF OBJECT_ID('DP2', 'P') IS NOT NULL
   DROP PROCEDURE DP2;
GO

CREATE PROCEDURE DP2
AS
BEGIN 
        -- Transaction begins

        -- Declarando variáveis
        DECLARE @Item_ID INT;
        DECLARE @Produto_ID INT;
        DECLARE @CursorItens CURSOR;
        DECLARE @qtetemp INT;
        DECLARE @currentqte INT;

     
        -- Cursor to get ItensPedidos_ID to be updated
        SET @CursorItens = CURSOR FOR

        SELECT 
		ItensPedidos.Item_ID, 
		ItensPedidos.produto_ID 
		FROM ItensPedidos INNER JOIN Estoque
		ON Estoque.Prod_ID = ItensPedidos.produto_ID
		WHERE Estoque.Quantidade > 0;


        -- Open cursor to fetch
        OPEN @CursorItens;

        -- getting the product id and item id
        FETCH NEXT FROM @CursorItens INTO @Item_ID,  @Produto_ID;

        -- while update, other works are running
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Update ItensPedidos - disponibilidade, atribuindo
            UPDATE ItensPedidos 
            SET disponivel = 1 
            WHERE ItensPedidos.produto_ID = @Produto_ID;

			PRINT 'Atualização em itensPedidos. Produto id ' + CONVERT(VARCHAR, @Produto_ID )  + ' disponivel ';

            -- get quantidade
            SELECT @qtetemp = Quantidade FROM ItensPedidos 
            WHERE produto_ID = @Produto_ID AND Item_ID = @Item_ID;

            -- get current storage number of itenspedidos
            SELECT @currentqte = Quantidade FROM Estoque WHERE Estoque.Prod_ID = @Produto_ID;

            -- updating storage... again
            UPDATE Estoque 
            SET Quantidade = (@currentqte - @qtetemp)  
            WHERE Prod_ID =  @Produto_ID;
            PRINT 'Estoque atualizado = ' + CAST((@currentqte - @qtetemp) AS VARCHAR);



            FETCH NEXT FROM @CursorItens INTO @Item_ID, @Produto_ID;
        END

        CLOSE @CursorItens;
        DEALLOCATE @CursorItens;

    END 

