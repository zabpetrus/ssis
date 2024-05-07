

CREATE VIEW TotalPedidos AS
(
SELECT Pr.pedido_id, 
Pr.codigo_Pedido, 
Itr.produto_ID, 
Pd.nome_Produto,
Itr.quantidade,
Itr.preco_unitario,
(Itr.quantidade * Itr.preco_unitario ) AS Subtotal,
((Itr.quantidade * Itr.preco_unitario) + Pd.frete_produto) AS TotalComFrete
FROM 
Pedidos Pr 
INNER JOIN ItensPedidos Itr ON Pr.pedido_id = Itr.pedido_ID 
INNER JOIN Produtos Pd ON Pd.produto_id = Itr.produto_ID
ORDER BY TotalComFrete DESC );





