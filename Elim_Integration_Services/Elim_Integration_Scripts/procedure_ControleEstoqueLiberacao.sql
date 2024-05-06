IF OBJECT_ID('ProcControleEstoqueLiberacao', 'PR') IS NOT NULL
   DROP PROCEDURE ProcControleEstoqueLiberacao;
GO

CREATE PROCEDURE ProcControleEstoqueLiberacao
AS
BEGIN
    
    BEGIN TRY

		-- Inicia a começa a transação
        BEGIN TRANSACTION;

		-- Atualizando o estoque com os produtos que chegaram
        UPDATE E
        SET E.Quantidade = RC.qte
        FROM Estoque E
        INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
        WHERE RC.compra_status = 2;


		-- Declarando variáveis

        DECLARE @Item_ID INT;
        DECLARE @Produto_ID INT;
        DECLARE @CursorItens CURSOR;
        DECLARE @qtetemp INT;
        DECLARE @currentqte INT;

        -- Cursor para obter os ItensPedidos_ID a serem atualizados

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

		-- Abrindo o cursor para um fetch

        OPEN @CursorItens;

		-- Adquirindo o item id e os id de produtos

        FETCH NEXT FROM @CursorItens INTO @Item_ID,  @Produto_ID;

		-- Enquanto se faz o update, outras operações são feitas de acordo

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Atualiza o status dos pedidos

            UPDATE AcompanhamentoPedidos 
            SET ItensPedidos_status = 1 
            WHERE ItensPedidos_ID = @Item_ID;

			-- Pegando a quantidade de itensPedidos

            SELECT @qtetemp = Quantidade FROM ItensPedidos 
            WHERE produto_ID = @Produto_ID AND Item_ID = @Item_ID;

			-- Pegando a quantidade corrente no estoque

            SELECT @currentqte = Quantidade FROM Estoque WHERE Estoque.Prod_ID = @Produto_ID;

			-- Atualizando o valor do Estoque de acordo

            UPDATE Estoque SET Quantidade = (@currentqte - @qtetemp)  WHERE Prod_ID =  @Produto_ID;

            FETCH NEXT FROM @CursorItens INTO @Item_ID, @Produto_ID;
        END

        CLOSE @CursorItens;
        DEALLOCATE @CursorItens;

        COMMIT TRANSACTION; -- Confirma a transação se tudo estiver bem
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0

		-- Rollback se ocorrer um erro

            ROLLBACK TRANSACTION;

        -- Manipulação de erros aqui

        PRINT 'Ocorreu um erro no gatilho: ' + ERROR_MESSAGE();
    END CATCH;
   
END
