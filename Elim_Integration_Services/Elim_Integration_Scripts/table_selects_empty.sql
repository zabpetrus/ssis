Use Utilitario;

SELECT * FROM Carga;

-- Verificando todos os que n�o est�o em Clientes, mas est�o em Carga

SELECT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf;

 -- Verificando os que est�o em Carga e que n�o est�o em Clientes

SELECT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf WHERE Clientes.cpf IS NULL;

-- Selecionando os produtos

SELECT Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor FROM Carga LEFT JOIN Produtos ON Produtos.upc = Carga.upc;


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
    Carga AS TC
INNER JOIN 
    Clientes AS C ON C.cpf = TC.cpf AND C.email = TC.email
INNER JOIN 
    StatusPedido AS SP ON SP.Nome_Status = 'Pendente';



 -- Populando Fornecedor
 SELECT Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
 LEFT JOIN 
 Fornecedores ON Fornecedores.CNPJ = Carga.fornecedor_cnpj;


-- Selecionando os dados para itens_pedidos

SELECT DISTINCT
    P.pedido_id,
    Pr.produto_id,
    Carga.qte,
    Carga.valor 
FROM 
    Carga
JOIN Pedidos P ON Carga.codigoPedido = P.codigo_Pedido
JOIN Produtos Pr ON Carga.upc = Pr.upc AND Carga.valor = Pr.valor;


-- Selecionando e preparando para a tabela checkout


 SELECT 
Pedidos.pedido_id,
( SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade ) FROM ItensPedidos WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID ) AS Subtotal,
( SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS Status,
( SELECT GETDATE() ) AS data_despacho

FROM Pedidos;


SELECT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho FROM Pedidos
INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id;


