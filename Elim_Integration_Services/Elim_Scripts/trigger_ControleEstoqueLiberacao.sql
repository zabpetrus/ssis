IF OBJECT_ID('TrgControleEstoqueLiberacao', 'TR') IS NOT NULL
   DROP TRIGGER TrgControleEstoqueLiberacao;
GO

CREATE TRIGGER TrgControleEstoqueLiberacao
ON RequisicaoCompra
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    /*
    Ao atualizar a coluna compra_status, ser� disparado o seguinte gatilho: 
    Contar-se-� os elementos que foram alterados e verificar� se mudou para o valor 2, que � o
    indicativo que o produto chegou
    */
    IF UPDATE(compra_status)
    BEGIN
       EXEC ProcControleEstoqueLiberacao;
    END
END
