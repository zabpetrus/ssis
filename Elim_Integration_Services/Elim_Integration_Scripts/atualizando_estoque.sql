USE [Utilitario]
GO

UPDATE [dbo].[RequisicaoCompra]
   SET [compra_status] = 2
 WHERE RequisicaoCompra.Produto_id = 6;
GO

