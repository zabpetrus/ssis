USE Utilitario;
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'AtualizarEstoqueAposChegadaProduto')
BEGIN
    DROP PROCEDURE AtualizarEstoqueAposChegadaProduto;
END
GO

CREATE PROCEDURE AtualizarEstoqueAposChegadaProduto
AS
BEGIN
	-- Excluindo o cursor se ele existe
	IF CURSOR_STATUS('global', 'atualiza_estoque') >= 0
	BEGIN
		CLOSE atualiza_estoque;
		DEALLOCATE atualiza_estoque;
	END

	-- Declarando as variáveis
	DECLARE @ItensPedidos_ID INT;
	DECLARE @ItensPedidos_status BIT; 
	DECLARE @qte INT;
	DECLARE @id INT;
	DECLARE @habl INT;

	-- Quando chega o produto, quantidade muda, logo essa sentença será válida
	SELECT TOP 1 @id = Es.Prod_ID 
	FROM Estoque Es 
	WHERE Es.Quantidade >= Es.Estoque_Minimo;

	IF @id IS NOT NULL

	BEGIN
		SELECT @habl = COUNT(*) 
		FROM Estoque Es 
		WHERE Es.Quantidade >= Es.Estoque_Minimo;

		-- Verificar os produtos
		SELECT @qte = IPx.quantidade 
		FROM ItensPedidos IPx 
		WHERE IPx.produto_ID = @id;

		-- Declarando o cursor para o select em AcompanhamentoPedidos
		DECLARE atualiza_estoque CURSOR FOR 
		SELECT ItensPedidos_ID, ItensPedidos_status 
		FROM AcompanhamentoPedidos;

		-- Abrindo o cursor atualiza_estoque
		OPEN atualiza_estoque;

		-- Instrução em SQL que busca a próxima linha de dados do cursor e armazena os valores nas variáveis 
		FETCH NEXT FROM atualiza_estoque INTO @ItensPedidos_ID, @ItensPedidos_status;

		-- enquanto tiver resultados faça
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ItensPedidos_ID = @id AND @habl > 0
			BEGIN
				UPDATE AcompanhamentoPedidos 
				SET ItensPedidos_status = 1 
				WHERE ItensPedidos_ID = @ItensPedidos_ID;

				UPDATE Estoque 
				SET Quantidade = Quantidade - @qte 
				WHERE Prod_ID = @id;
            
				SET @habl = @habl - 1;
			END

			FETCH NEXT FROM atualiza_estoque INTO @ItensPedidos_ID, @ItensPedidos_status;
		END

		CLOSE atualiza_estoque;
		DEALLOCATE atualiza_estoque; 
	END

END
