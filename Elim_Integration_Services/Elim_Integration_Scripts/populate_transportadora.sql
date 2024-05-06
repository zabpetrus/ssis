USE [Utilitario]
GO


INSERT INTO [dbo].[Transportadora]
           ([Nome_Transportadora]
           ,[CNPJ_Transportadora]
           ,[Tipo_Servico]
           ,[Custo_Frete])
     VALUES
           ('America Transportes', '97.064.519/0001-75', 'Padrao', 25.99),
           ('Rupiao Entregas Brasil LTDA', '01.503.315/0001-14', 'Padrao',19.99 ),
		   ('Calango Express', '46.458.091/0001-04', 'Expressa', 55.99),
		   ('Guanabara Fretes e Entregas LTDA', '17.342.627/0001-23', 'Expressa', 45.99),
		   ('Ronaldo Entregas Express', '49.623.352/0001-92', 'Expressa', 60.99);
GO


