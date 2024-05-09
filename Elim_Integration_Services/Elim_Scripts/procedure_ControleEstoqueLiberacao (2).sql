USE [Utilitario];
GO

IF OBJECT_ID('ProcControleEstoqueLiberacao', 'P') IS NOT NULL
   DROP PROCEDURE ProcControleEstoqueLiberacao;
GO

CREATE PROCEDURE ProcControleEstoqueLiberacao
AS
BEGIN
    
    BEGIN TRY
        -- Transaction begins
        BEGIN TRANSACTION ProcControleEstoqueLiberacao;

        -- Declarando variáveis
        DECLARE @Item_ID INT;
        DECLARE @Produto_ID INT;
        DECLARE @CursorItens CURSOR;
        DECLARE @qtetemp INT;
        DECLARE @currentqte INT;

        -- Updating the storage
        UPDATE Estoque
        SET Quantidade = RC.qte
        FROM Estoque Es
        INNER JOIN RequisicaoCompra RC ON Es.Prod_ID = RC.Produto_id
        WHERE RC.compra_status = 2;
        
        IF @@ROWCOUNT > 0
            PRINT 'Estoque Atualizado com sucesso! Recarregue para visualizar';
        ELSE
        BEGIN
            PRINT 'Estoque Inalterado';
            ROLLBACK;
            RETURN;
        END

        -- Cursor to get ItensPedidos_ID to be updated
        SET @CursorItens = CURSOR FOR
            SELECT AP.ItensPedidos_ID, IP.produto_ID
            FROM AcompanhamentoPedidos AP
            INNER JOIN ItensPedidos IP ON IP.Item_ID = AP.ItensPedidos_ID 
            WHERE IP.produto_ID IN (
                SELECT E.Prod_ID 
                FROM Estoque E
                INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
                WHERE RC.compra_status = 2
            );

        -- Open cursor to fetch
        OPEN @CursorItens;

        -- getting the product id and item id
        FETCH NEXT FROM @CursorItens INTO @Item_ID,  @Produto_ID;

        -- while update, other works are running
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Update AcompanhamentoPedidos
            UPDATE AcompanhamentoPedidos 
            SET ItensPedidos_status = 1 
            WHERE ItensPedidos_ID = @Item_ID;

            -- get quantidade
            SELECT @qtetemp = Quantidade FROM ItensPedidos 
            WHERE produto_ID = @Produto_ID AND Item_ID = @Item_ID;

            -- get current storage number of itenspedidos
            SELECT @currentqte = Quantidade FROM Estoque WHERE Estoque.Prod_ID = @Produto_ID;

            -- updating storage... again
            UPDATE Estoque 
            SET Quantidade = (@currentqte - @qtetemp)  
            WHERE Prod_ID =  @Produto_ID;
            PRINT 'Estoque = ' + CAST((@currentqte - @qtetemp) AS VARCHAR);

            FETCH NEXT FROM @CursorItens INTO @Item_ID, @Produto_ID;
        END

        CLOSE @CursorItens;
        DEALLOCATE @CursorItens;

        COMMIT TRANSACTION ProcControleEstoqueLiberacao; -- Confirma a transação se tudo estiver bem
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        -- Rollback se ocorrer um erro
            ROLLBACK TRANSACTION ProcControleEstoqueLiberacao;

        -- Manipulação de erros aqui
        PRINT 'Ocorreu um erro no procedimento: ' + ERROR_MESSAGE();
    END CATCH;
   
END
