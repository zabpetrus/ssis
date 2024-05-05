Use  Utilitario;
GO

SELECT ItensPedidos_ID, ItensPedidos_status FROM AcompanhamentoPedidos;



-- SELECT produto_ID, quantidade FROM ItensPedidos;
SELECT * FROM ItensPedidos;

-- SELECT Prod_ID, Quantidade,Estoque_Minimo  FROM Estoque;
SELECT * FROM Estoque;


/*
EM
SELECT ItensPedidos_ID, ItensPedidos_status FROM AcompanhamentoPedidos;

*/

-- Verificando quem atualizou SE:

SELECT DISTINCT ItensPedidos.Item_ID, ItensPedidos.quantidade FROM ItensPedidos
INNER JOIN Estoque ON Estoque.Prod_ID = ItensPedidos.produto_ID
WHERE Estoque.Quantidade >= Estoque.Estoque_Minimo;

SELECT Quantidade FROM ItensPedidos WHERE ItensPedidos.Item_ID = 6;

UPDATE AcompanhamentoPedidos 
SET ItensPedidos_status = 1 
WHERE ItensPedidos_ID IN (
    SELECT ItensPedidos.Item_ID 
    FROM ItensPedidos
    INNER JOIN Estoque ON Estoque.Prod_ID = ItensPedidos.produto_ID
    WHERE Estoque.Quantidade > 0
);

SELECT * FROM AcompanhamentoPedidos;
