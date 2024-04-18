Use Utilitario;

SELECT * FROM TCarga;

-- Verificando todos os que não estão em Clientes, mas estão em TCarga

SELECT TCarga.nomeComprador, TCarga.email, TCarga.cpf, TCarga.uf, TCarga.pais FROM dbo.TCarga LEFT JOIN Clientes ON Clientes.cpf = TCarga.cpf;

 -- Verificando os que estão em TCarga e que não estão em Clientes

SELECT TCarga.nomeComprador, TCarga.email, TCarga.cpf, TCarga.uf, TCarga.pais FROM dbo.TCarga LEFT JOIN Clientes ON Clientes.cpf = TCarga.cpf WHERE Clientes.cpf IS NULL;

-- Selecionando os produtos

SELECT TCarga.nomeProduto, TCarga.sku, TCarga.upc, TCarga.valor FROM TCarga LEFT JOIN Produtos ON Produtos.upc = TCarga.upc;


-- Selecionando os dados dos pedidos 

SELECT DISTINCT 
    TC.codigoPedido,
    C.cliente_id,
    TC.dataPedido,
    TC.enderecoEntrega,
    TC.cep,
    TC.frete,
    SP.Status_ID 
FROM 
    TCarga AS TC
INNER JOIN 
    Clientes AS C ON C.cpf = TC.cpf AND C.email = TC.email
INNER JOIN 
    StatusPedido AS SP ON SP.Nome_Status = 'Pendente';

 

-- Selecionando os dados para itens_pedidos

SELECT DISTINCT
    P.pedido_id,
    Pr.produto_id,
    TCarga.qte,
    TCarga.valor 
FROM 
    TCarga
JOIN Pedidos P ON TCarga.codigoPedido = P.codigo_Pedido
JOIN Produtos Pr ON TCarga.upc = Pr.upc AND TCarga.valor = Pr.valor;


-- Selecionando e preparando para a tabela checkout


 SELECT 
Pedidos.pedido_id,
( SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade ) FROM ItensPedidos WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID ) AS Subtotal,
( SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS Status,
( SELECT GETDATE() ) AS data_despacho

FROM Pedidos;