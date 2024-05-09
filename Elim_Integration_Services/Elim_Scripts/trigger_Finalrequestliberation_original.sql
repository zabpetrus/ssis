IF OBJECT_ID('FinalRequestLiberation', 'TR') IS NOT NULL
   DROP TRIGGER FinalRequestLiberation;
GO

CREATE TRIGGER FinalRequestLiberation
ON RequisicaoCompra
AFTER UPDATE
AS
BEGIN
    /*
    Ao atualizar a coluna compra_status, será disparado o seguinte gatilho: 
    Contar-se-á os elementos que foram alterados e verificará se mudou para o valor 2, que é o
    indicativo que o produto chegou
    */
    IF UPDATE(compra_status)
    BEGIN

	UPDATE E
			SET E.Quantidade = RC.qte
			FROM Estoque E
			INNER JOIN RequisicaoCompra RC ON E.Prod_ID = RC.Produto_id
			WHERE RC.compra_status = 2;



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

			OPEN @CursorItens;

			FETCH NEXT FROM @CursorItens INTO @Item_ID,  @Produto_ID;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Atualiza o status dos pedidos
				UPDATE AcompanhamentoPedidos 
				SET ItensPedidos_status = 1 
				WHERE ItensPedidos_ID = @Item_ID;

				SELECT @qtetemp = Quantidade FROM ItensPedidos 
				WHERE produto_ID = @Produto_ID AND Item_ID = @Item_ID;

				SELECT @currentqte = Quantidade FROM Estoque WHERE Estoque.Prod_ID = @Produto_ID;

				UPDATE Estoque SET Quantidade = (@currentqte - @qtetemp)  WHERE Prod_ID =  @Produto_ID;

				FETCH NEXT FROM @CursorItens INTO @Item_ID, @Produto_ID;
			END

			CLOSE @CursorItens;
			DEALLOCATE @CursorItens;     

	END
END
