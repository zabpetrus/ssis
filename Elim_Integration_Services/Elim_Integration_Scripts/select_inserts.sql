USE Utilitario;

BEGIN

-- Inserindo em Produtos baseado no select de carga e verificando se não está duplicado
INSERT INTO Produtos ( nome_Produto, descricao, sku, upc, valor, Nome_fornecedor, fornecedor_CNPJ) 
SELECT DISTINCT Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor, Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
LEFT JOIN 
Produtos ON Produtos.upc = Carga.upc
WHERE NOT EXISTS(
SELECT 1 FROM Produtos WHERE Produtos.upc = Carga.upc);




-- Inserindo o cliente e verificando se o cpf não está cadastrado
IF NOT EXISTS ( SELECT * FROM Clientes INNER JOIN Carga ON Clientes.cpf = Carga.cpf )
BEGIN 
	INSERT INTO Clientes (Nome, email, cpf, uf, pais ) 
	SELECT DISTINCT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga 
	LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf  
	WHERE Clientes.cpf IS NULL;	
END



-- Populando Pedidos
INSERT INTO Pedidos 
( codigo_Pedido, cliente_ID, data_Pedido, endereco_entrega, cep, custo_frete, status_pedido ) 
SELECT DISTINCT 
Carga.codigoPedido, 
Clientes.cliente_id, 
Carga.dataPedido, 
Carga.enderecoEntrega, 
Carga.cep, 
Carga.frete, 
StatusPedido.Status_ID FROM Carga 
INNER JOIN Clientes ON 
Clientes.cpf = Carga.cpf AND Clientes.email = Carga.email 
INNER JOIN StatusPedido ON StatusPedido.Nome_Status = 'Pendente'
WHERE NOT EXISTS(
	SELECT 1 FROM Pedidos WHERE Carga.codigoPedido  = Pedidos.codigo_Pedido
	AND Carga.cep = Pedidos.cep AND Carga.dataPedido = Pedidos.data_Pedido
);



-- Populado Itens Pedidos
INSERT INTO ItensPedidos( pedido_ID, produto_ID, quantidade,preco_unitario) 
SELECT DISTINCT 
	P.pedido_id,
	Pr.produto_id, 
	Carga.qte,
	Carga.valor 
FROM Carga
JOIN Pedidos P ON Carga.codigoPedido = P.codigo_Pedido
JOIN Produtos Pr ON Carga.upc = Pr.upc AND Carga.valor = Pr.valor
WHERE NOT EXISTS(
	SELECT 1 FROM ItensPedidos ipe WHERE 
	ipe.pedido_ID = P.pedido_id AND
	ipe.produto_ID = Pr.produto_id AND
	ipe.quantidade = Carga.qte AND
	ipe.preco_unitario = Carga.valor

);





-- Populando checkout
INSERT INTO Checkout( Pedido_id, total_pedido, status_despacho, data_despacho) 
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

-- Inserindo Fornecedores
INSERT INTO Fornecedores (Nome_fornecedor, CNPJ ) 
SELECT Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
 LEFT JOIN 
 Fornecedores ON Fornecedores.CNPJ = Carga.fornecedor_cnpj
 WHERE NOT EXISTS(
 SELECT 1 FROM Fornecedores Fr WHERE Fr.CNPJ = Carga.fornecedor_cnpj
 );



-- GErando Nota Fiscal
INSERT INTO NotaFiscal
( Pedido_ID, Valor_Total, Data_Emissao)
SELECT DISTINCT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho FROM Pedidos
INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id 
WHERE NOT EXISTS(
SELECT 1 FROM NotaFiscal nf WHERE nf.Pedido_ID = Checkout.Pedido_id
);


-- Gerando o estoque
Insert into Estoque (Prod_ID, Quantidade, Estoque_Minimo)
	SELECT DISTINCT
	Produtos.produto_id AS Prod_ID,
	--COALESCE retorna o primeiro valor não nulo da soma da Quantidade no estoque
	COALESCE(SUM(Estoque.quantidade), 0) AS Quantidade,
	SUM(ItensPedidos.quantidade) AS Estoque_Minimo	
	FROM Produtos 
	INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
	LEFT JOIN Estoque ON Produtos.produto_id = Estoque.Prod_ID 
	GROUP BY
	Produtos.produto_id, ItensPedidos.quantidade;



-- Inserindo Requisição de Compra
INSERT INTO [dbo].[RequisicaoCompra]
    ([Fornecedor_id]
    ,[Produto_id]
    ,[qte]
    ,[compra_status]
    ,[total]
    ,[dataEmissao])		     
SELECT DISTINCT
    Fornecedores.fornecedor_id AS Fornecedor_id,
    Produtos.produto_id AS Produto_id,
    ItensPedidos.quantidade AS qte,
    StatusPedido.Nome_Status AS compra_status,
    ItensPedidos.preco_unitario * ItensPedidos.quantidade AS total,
    GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ
INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
INNER JOIN StatusPedido ON StatusPedido.Status_ID = 1;




END;


