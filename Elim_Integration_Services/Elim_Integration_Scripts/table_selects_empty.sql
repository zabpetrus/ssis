Use Utilitario;

SELECT * FROM Carga;

-- Verificando todos os que não estão em Clientes, mas estão em Carga

SELECT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf;

 -- Verificando os que estão em Carga e que não estão em Clientes

SELECT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf WHERE Clientes.cpf IS NULL;

-- Selecionando os produtos

SELECT Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor, Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
LEFT JOIN 
Produtos ON Produtos.upc = Carga.upc


-- Selecionando os dados dos pedidos 

SELECT DISTINCT 
Carga.codigoPedido, 
Clientes.cliente_id, 
Carga.dataPedido, 
Carga.enderecoEntrega, 
Carga.cep,
SP.Status_ID 
FROM Carga
INNER JOIN Clientes ON Clientes.cpf = Carga.cpf
INNER JOIN StatusPedido AS SP ON SP.Nome_Status = 'Pendente';


 -- Populando Fornecedor
 SELECT Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
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


 SELECT 
Pedidos.pedido_id,
( SELECT sum( ItensPedidos.preco_unitario * ItensPedidos.quantidade ) FROM ItensPedidos WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID ) AS Subtotal,
( SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento' ) AS Status,
( SELECT GETDATE() ) AS data_despacho

FROM Pedidos;




SELECT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho FROM Pedidos
INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id;


SELECT 
Produtos.produto_id AS Prod_ID,
COALESCE(SUM(Estoque.quantidade), 0) AS Quantidade,
SUM(ItensPedidos.quantidade) AS Estoque_Minimo	
FROM Produtos 
INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
LEFT JOIN Estoque ON Produtos.produto_id = Estoque.Prod_ID 
GROUP BY
Produtos.produto_id, ItensPedidos.quantidade;

SELECT 
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