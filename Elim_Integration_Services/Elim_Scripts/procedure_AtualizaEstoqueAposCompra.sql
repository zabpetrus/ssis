USE [Utilitario];
GO

-- TRIGGER RequisicaoCompra UPDATE Estoque

IF OBJECT_ID('AtualizaEstoqueAposCompra', 'P') IS NOT NULL
   DROP PROCEDURE AtualizaEstoqueAposCompra;
GO

CREATE PROCEDURE AtualizaEstoqueAposCompra
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION AtualizaEstoqueAposCompra;

        -- Atualizando o estoque com os produtos de Requisicao Compra
        UPDATE Estoque
        SET Quantidade = RC.qte
        FROM Estoque Es
        INNER JOIN RequisicaoCompra RC ON Es.Prod_ID = RC.Produto_id
        WHERE RC.compra_status = 2;

        IF @@ROWCOUNT > 0
        BEGIN
            PRINT 'Estoque atualizado com sucesso! Recarregue para visualizar.';
        END
        ELSE
        BEGIN
            PRINT 'Estoque inalterado';
            ROLLBACK TRANSACTION AtualizaEstoqueAposCompra;
            RETURN;
        END

        COMMIT TRANSACTION AtualizaEstoqueAposCompra;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION AtualizaEstoqueAposCompra;

        -- Manipulação de erros aqui
        PRINT 'Ocorreu um erro no procedimento: ' + ERROR_MESSAGE();
    END CATCH;
END;
