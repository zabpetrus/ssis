Use Utilitario;

SELECT * FROM Carga;

-- Verificando todos os que não estão em Clientes, mas estão em Carga

SELECT DISTINCT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais 
FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf;

 -- Verificando os que estão em Carga e que não estão em Clientes

SELECT DISTINCT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais 
FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf WHERE Clientes.cpf IS NULL;

-- Selecionando os produtos

SELECT DISTINCT Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor, Carga.fornecedor, Carga.fornecedor_cnpj 
FROM Carga 
LEFT JOIN 
Produtos ON Produtos.upc = Carga.upc


-- Pedidos é criado somente após a inserção em clientes e produtos
-- Selecionando os dados dos pedidos 

SELECT DISTINCT 
Carga.codigoPedido, 
Clientes.cliente_id, 
Carga.dataPedido, 
Carga.enderecoEntrega, 
Carga.cep,
SP.Status_ID 
FROM Carga
LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf
LEFT JOIN StatusPedido AS SP ON SP.Nome_Status = 'Pendente';


 -- Populando Fornecedor
 SELECT DISTINCT Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
 LEFT JOIN 
 Fornecedores ON Fornecedores.CNPJ = Carga.fornecedor_cnpj;


-- Selecionando os dados para itens_pedidos * errado

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


--atual com verificação de existência

SELECT DISTINCT Pr.pedido_id, 
SUM((Itr.quantidade * Itr.preco_unitario) + Pd.frete_produto) AS total_pedido, 
(SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS status_despacho,
(SELECT GETDATE() ) AS data_despacho
FROM 
Pedidos Pr 
INNER JOIN ItensPedidos Itr ON Pr.pedido_id = Itr.pedido_ID 
INNER JOIN Produtos Pd ON Pd.produto_id = Itr.produto_ID
WHERE NOT EXISTS (
    SELECT 1
    FROM Checkout ck
    WHERE ck.Pedido_id = Pr.pedido_id
)
GROUP BY  Pr.pedido_id, Pr.codigo_Pedido;


-- atual sem verificação de existência

SELECT Pr.pedido_id, 
SUM((Itr.quantidade * Itr.preco_unitario) + Pd.frete_produto) AS total_pedido, 
(SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS status_despacho,
(SELECT GETDATE() ) AS data_despacho
FROM 
Pedidos Pr 
INNER JOIN ItensPedidos Itr ON Pr.pedido_id = Itr.pedido_ID 
INNER JOIN Produtos Pd ON Pd.produto_id = Itr.produto_ID
 GROUP BY  Pr.pedido_id, Pr.codigo_Pedido; 

-- anterior com verificação de existência

SELECT DISTINCT 
Pedidos.pedido_id,
( SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade ) FROM ItensPedidos WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID ) AS Subtotal,
( SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS Status,
( SELECT GETDATE() ) AS data_despacho
FROM Pedidos
WHERE NOT EXISTS (
    SELECT 1
    FROM Checkout
    WHERE Checkout.Pedido_id = Pedidos.pedido_id
);



SELECT DISTINCT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho FROM Pedidos
INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id;

-- Testes para Estoque

SELECT DISTINCT
Produtos.produto_id AS Prod_ID,
COALESCE(SUM(Estoque.quantidade), 0) AS Quantidade,
SUM(ItensPedidos.quantidade) AS Estoque_Minimo	
FROM Produtos 
INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
LEFT JOIN Estoque ON Produtos.produto_id = Estoque.Prod_ID 
GROUP BY
Produtos.produto_id, ItensPedidos.quantidade;



SELECT 
Pr.produto_id AS Produto_id,
COALESCE(SUM(Es.quantidade), 0) AS Quantidade,
COALESCE ( SUM (Ipr.quantidade), 0) AS Estoque_Minimo
FROM Produtos Pr
LEFT JOIN ItensPedidos IPr ON Pr.produto_id = Ipr.produto_ID
LEFT JOIN Estoque Es ON Es.Prod_ID = Pr.produto_id
GROUP BY Pr.produto_id;






SELECT DISTINCT 
Fornecedores.fornecedor_id,
Produtos.produto_id,
ItensPedidos.quantidade,
StatusPedido.Nome_Status,
ItensPedidos.preco_unitario * ItensPedidos.quantidade AS total,
GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ
INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
INNER JOIN StatusPedido ON StatusPedido.Status_ID = 1;
	

-- Select para a criação da view de Estoque
SELECT Estoque.Est_Prod_ID,
	   Pr.nome_Produto,
	   Estoque.Quantidade,
	   Estoque.Estoque_Minimo,
	   Fornecedores.fornecedor_id,
	   Pr.nome_fornecedor
	   
	   FROM Estoque 
	   INNER JOIN Produtos Pr ON Estoque.Prod_ID = Pr.produto_id
	   INNER JOIN Fornecedores ON Fornecedores.CNPJ = Pr.fornecedor_CNPJ;


-- Mais uma forma de se fazer a compra de pedidos
SELECT 
    Fornecedores.fornecedor_id AS Fornecedor_id,
    Produtos.produto_id AS Produto_id,
    SUM(ItensPedidos.quantidade) AS total_quantidade,
    StatusPedido.Status_ID AS compra_status,
    SUM(ItensPedidos.preco_unitario * ItensPedidos.quantidade) AS total,
    GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ
INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
INNER JOIN StatusPedido ON StatusPedido.Nome_Status = 'Pendente'
GROUP BY Fornecedores.fornecedor_id, Produtos.produto_id, StatusPedido.Status_ID;

-- Mas escolhi essa forma: 

SELECT DISTINCT
    Fornecedores.fornecedor_id AS Fornecedor_id,
    Produtos.produto_id AS Produto_id,
    (SELECT SUM(quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total_quantidade,
    (SELECT Status_ID FROM StatusPedido WHERE StatusPedido.Nome_Status = 'Pendente') AS compra_status,
    (SELECT SUM(preco_unitario * quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total,
    GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ;


SELECT DISTINCT 
    Pe.pedido_id AS Pedido_ID,
	( SELECT TOP(1) Tr.Transportadora_id FROM Transportadora Tr WHERE Tr.Tipo_Servico = 'Padrao' ORDER BY tr.Custo_Frete ASC ) As Transportadora_ID,
	( SELECT St.IDStatus FROM StatusDespacho St WHERE St.NomeStatus = 'Em processamento' ) AS Status_Entrega,
	( SELECT CONVERT(date, GETDATE())) AS Data_Entrega
	FROM Pedidos Pe;



SELECT 
    (SELECT COUNT(*) 
     FROM ItensPedidos ipe 
     INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ipe.Item_ID
     WHERE pedido_ID = 3 AND ap.ItensPedidos_status = 0) -
    (SELECT COUNT(*) 
     FROM ItensPedidos ipe 
     INNER JOIN AcompanhamentoPedidos ap ON ap.ItensPedidos_ID = ipe.Item_ID
     WHERE pedido_ID = 3 AND ap.ItensPedidos_status = 1) AS diff;


SELECT ip.pedido_ID
FROM ItensPedidos ip
LEFT JOIN AcompanhamentoPedidos ap ON ip.Item_ID = ap.ItensPedidos_ID
GROUP BY ip.pedido_ID
HAVING COUNT(ap.ItensPedidos_ID) = COUNT(CASE WHEN ap.ItensPedidos_status = 1 THEN 1 END)
