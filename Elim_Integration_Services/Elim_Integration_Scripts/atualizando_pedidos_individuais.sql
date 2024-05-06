USE [Utilitario]
GO

/*
Ao atualizar Requisicao Compra, modificando o campo compra_status = 2,  estamos
avisando ao banco que o produto requisitado acabou de chegar,e está pronto a ser 
inserido no estoque. O trigger FinalRequestLiberation é responsável por atualizar
a tabela Estoque - coluna Quantidade com o valor especificado. 

*/

-- UPDATE [dbo].[RequisicaoCompra] SET [compra_status] = 2  WHERE RequisicaoCompra.Produto_id = 1;

 UPDATE [dbo].[RequisicaoCompra]
   SET [compra_status] = 2
 WHERE RequisicaoCompra.Produto_id = 5;


GO
