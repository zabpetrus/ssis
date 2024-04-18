-- 1. Adicionar uma nova coluna do tipo datetime
USE Utilitario;
BEGIN

	SELECT * FROM [dbo].[Carga];

	SELECT CAST( Carga.dataPedido AS datetime ) dDATA FROM Carga WHERE Carga.qte <> 0;

	DECLARE @foo INT;
	SELECT @foo = COUNT(*) FROM Carga WHERE Carga.qte = 0;
	IF @foo > 0
	BEGIN
		 DELETE FROM Carga WHERE qte = 0;
		 PRINT CONCAT('Foram exclu�das ', @foo, ' linhas.');	
	END
	ELSE
	BEGIN
		PRINT 'Nenhum resultado para a consulta';
	END
	
	IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Carga' AND COLUMN_NAME = 'tempDataPedido'
	)
	BEGIN
		ALTER TABLE Carga ADD tempDataPedido DATETIME;
		PRINT 'Coluna j� criada';			
	END
	
	-- Ap�s ver se a tabela existe, fa�o um upgrade da coluna

	IF EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Carga' AND COLUMN_NAME = 'tempDataPedido'
	)
	BEGIN
		UPDATE Carga 
		SET tempDataPedido = CONVERT(datetime, dataPedido);
	END	

END



