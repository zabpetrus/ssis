/*
Procedimento de exclusão de todas as tabelas e procedures 
que foram feitas
*/

USE [Utilitario]
GO

DROP PROCEDURE IF EXISTS [dbo].[StatusDeEnvio]
GO

/****** Object:  Table [dbo].[Carga]    Script Date: 12/04/2024 13:07:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carga]') AND type in (N'U'))
DROP TABLE [dbo].[Carga]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND type in (N'U'))
DROP TABLE [dbo].[Clientes]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DespachoMercadorias]') AND type in (N'U'))
DROP TABLE [dbo].[DespachoMercadorias]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fornecedores]') AND type in (N'U'))
DROP TABLE [dbo].[Fornecedores]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItensPedidos]') AND type in (N'U'))
DROP TABLE [dbo].[ItensPedidos]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotaFiscal]') AND type in (N'U'))
DROP TABLE [dbo].[NotaFiscal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND type in (N'U'))
DROP TABLE [dbo].[Pedidos]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produtos]') AND type in (N'U'))
DROP TABLE [dbo].[Produtos]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequisicaoCompra]') AND type in (N'U'))
DROP TABLE [dbo].[RequisicaoCompra]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusDespacho]') AND type in (N'U'))
DROP TABLE [dbo].[StatusDespacho]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transportadora]') AND type in (N'U'))
DROP TABLE [dbo].[Transportadora]
GO

/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Estoque]') AND type in (N'U'))
DROP TABLE [dbo].[Estoque]
ALTER TABLE Estoque
DROP CONSTRAINT FK_EST_PROD; 

GO
*/




