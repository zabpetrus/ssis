
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


    
SELECT DISTINCT 
Pe.pedido_id AS Pedido_ID,
( SELECT TOP(1) Tr.Transportadora_id FROM Transportadora Tr WHERE Tr.Tipo_Servico = 'Padrao' ORDER BY tr.Custo_Frete ASC ) As Transportadora_ID,
( SELECT St.IDStatus FROM StatusDespacho St WHERE St.NomeStatus = 'Em processamento' ) AS Status_Entrega,
( SELECT CONVERT(date, GETDATE())) AS Data_Entrega
FROM Pedidos Pe;
	
           
SELECT * FROM ItensPedidos ip
        INNER JOIN Pedidos ON Pedidos.pedido_id = ip.pedido_ID
        INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ip.Item_ID
        WHERE Pedidos.pedido_id = 1 AND ap.ItensPedidos_status = 1

SELECT IPD.pedido_ID 
    FROM ItensPedidos IPD 
    INNER JOIN AcompanhamentoPedidos AP ON AP.ItensPedidos_ID = IPD.Item_ID
	AND Ap.ItensPedidos_status = 1;

