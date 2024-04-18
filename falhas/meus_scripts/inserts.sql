Use Utilitario;

BEGIN
-- Inserindo em Produtos baseado no select de carga
INSERT INTO Produtos ( nome_Produto, sku, upc, valor ) SELECT TCarga.nomeProduto, TCarga.sku, TCarga.upc, TCarga.valor FROM TCarga LEFT JOIN Produtos ON Produtos.upc = TCarga.upc;


-- Inserindo o cliente
INSERT INTO Clientes (Nome, email, cpf, uf, pais ) SELECT TCarga.nomeComprador, TCarga.email, TCarga.cpf, TCarga.uf, TCarga.pais FROM dbo.TCarga LEFT JOIN Clientes ON Clientes.cpf = TCarga.cpf;


-- Populando Pedidos
INSERT INTO Pedidos ( codigo_Pedido, cliente_ID, data_Pedido, endereco_entrega, cep, custo_frete, status_pedido ) SELECT DISTINCT TCarga.codigoPedido, Clientes.cliente_id, TCarga.dataPedido, TCarga.enderecoEntrega, TCarga.cep, TCarga.frete, StatusPedido.Status_ID FROM TCarga 
INNER JOIN Clientes ON Clientes.cpf = TCarga.cpf AND Clientes.email = TCarga.email INNER JOIN StatusPedido ON StatusPedido.Nome_Status = 'Pendente'; 

-- Populado Itens Pedidos
INSERT INTO ItensPedidos( pedido_ID, produto_ID, quantidade,preco_unitario) 
SELECT DISTINCT P.pedido_id,Pr.produto_id, TCarga.qte,TCarga.valor FROM TCarga
JOIN Pedidos P ON TCarga.codigoPedido = P.codigo_Pedido
JOIN Produtos Pr ON TCarga.upc = Pr.upc AND TCarga.valor = Pr.valor;


-- Populando checkout
INSERT INTO Checkout( Pedido_id, total_pedido, status_despacho, data_despacho) 
SELECT DISTINCT 
Pedidos.pedido_id,
( SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade ) FROM ItensPedidos WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID ) AS Subtotal,
( SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS Status,
( SELECT GETDATE() ) AS data_despacho

FROM Pedidos;



END


