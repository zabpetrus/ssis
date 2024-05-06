
SELECT * FROM Carga;


 SELECT ItensPedidos.pedido_ID FROM ItensPedidos INNER JOIN  AcompanhamentoPedidos ON
 AcompanhamentoPedidos.ItensPedidos_ID = ItensPedidos.Item_ID;

SELECT 
IPD.Item_ID,
AP.ItensPedidos_ID, 
AP.ItensPedidos_status, 
PE.codigo_Pedido, PE.pedido_id FROM
ItensPedidos IPD INNER JOIN Pedidos PE ON PE.pedido_id = IPD.pedido_ID
INNER JOIN AcompanhamentoPedidos AP ON IPD.Item_ID = AP.ItensPedidos_ID;


SELECT * FROM ItensPedidos ip
INNER JOIN Pedidos ON Pedidos.pedido_id = ip.pedido_ID
INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ip.Item_ID
WHERE Pedidos.pedido_id = 5 AND ap.ItensPedidos_status = 0;

