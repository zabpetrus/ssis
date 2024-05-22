USE Utilitario;

BEGIN

-- INSERINDO TRANSPORTADORAS!!!

INSERT INTO [dbo].[Transportadora]
           ([Nome_Transportadora]
           ,[CNPJ_Transportadora]
           ,[Tipo_Servico]
           ,[Custo_Frete])
     VALUES
		   ('Rupiao Entregas Brasil LTDA', '01.503.315/0001-14', 'Padrao',19.99 ),
           ('America Transportes', '97.064.519/0001-75', 'Padrao', 25.99),           
		   ('Calango Express', '46.458.091/0001-04', 'Expressa', 55.99),
		   ('Guanabara Fretes e Entregas LTDA', '17.342.627/0001-23', 'Expressa', 45.99),
		   ('Ronaldo Entregas Express', '49.623.352/0001-92', 'Expressa', 60.99);


-- PRIMEIRAS INSERCOES EM CLIENTES E PRODUTOS

-- Inserindo em Produtos baseado no select de carga e verificando se não está duplicado
INSERT INTO Produtos ( nome_Produto, descricao, sku, upc, valor,frete_produto, Nome_fornecedor, fornecedor_CNPJ) 
SELECT DISTINCT Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor,Carga.frete, Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
LEFT JOIN 
Produtos ON Produtos.upc = Carga.upc
WHERE NOT EXISTS(
SELECT 1 FROM Produtos WHERE Produtos.upc = Carga.upc);

PRINT 'INSERINDO EM PRODUTOS';



-- Inserindo o cliente e verificando se o cpf não está cadastrado
IF NOT EXISTS ( SELECT * FROM Clientes INNER JOIN Carga ON Clientes.cpf = Carga.cpf )
BEGIN 
	INSERT INTO Clientes (Nome, email, cpf, uf, pais ) 
	SELECT DISTINCT Carga.nomeComprador, Carga.email, Carga.cpf, Carga.uf, Carga.pais FROM dbo.Carga 
	LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf  
	WHERE Clientes.cpf IS NULL;	
END

PRINT 'INSERINDO EM CLIENTES';

-- Populando pedidos
INSERT INTO [dbo].[Pedidos]
           ([codigo_Pedido]
           ,[cliente_ID]
           ,[data_Pedido]
           ,[endereco_entrega]
           ,[cep]
           ,[status_pedido])
     
        SELECT DISTINCT 
		Carga.codigoPedido, 
		Clientes.cliente_id, 
		Carga.dataPedido, 
		Carga.enderecoEntrega, 
		Carga.cep,
		SP.Status_ID 
		FROM Carga
		INNER JOIN Clientes ON Clientes.cpf = Carga.cpf
		INNER JOIN StatusPedido AS SP ON SP.Nome_Status = 'Pendente' ORDER BY Carga.dataPedido;  


PRINT 'INSERINDO EM PEDIDOS';

-- Populado Itens Pedidos
INSERT INTO ItensPedidos( pedido_ID, produto_ID, quantidade,preco_unitario, disponivel) 
SELECT DISTINCT 
    Pedidos.pedido_id,
	Produtos.produto_id, 
	Carga.qte, 
	Carga.valor,
	0
	FROM Carga 
	LEFT JOIN Produtos ON Carga.upc = Produtos.upc AND Carga.sku = Produtos.sku
	LEFT JOIN Pedidos ON Pedidos.codigo_Pedido = Carga.codigoPedido;


PRINT 'INSERINDO EM ITENS PEDIDOS';


-- Populando checkout
INSERT INTO Checkout( Pedido_id, total_pedido, status_despacho, data_despacho) 

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


PRINT 'INSERINDO EM CHECKOUT';



-- Inserindo Fornecedores
INSERT INTO Fornecedores (Nome_fornecedor, CNPJ ) 
SELECT DISTINCT Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
 LEFT JOIN 
 Fornecedores ON Fornecedores.CNPJ = Carga.fornecedor_cnpj
 WHERE NOT EXISTS(
 SELECT 1 FROM Fornecedores Fr WHERE Fr.CNPJ = Carga.fornecedor_cnpj
 );

PRINT 'INSERINDO EM FORNECEDORES';


-- GErando Nota Fiscal
INSERT INTO NotaFiscal
( Pedido_ID, Valor_Total, Data_Emissao)
SELECT DISTINCT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho FROM Pedidos
INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id 
WHERE NOT EXISTS(
SELECT 1 FROM NotaFiscal nf WHERE nf.Pedido_ID = Checkout.Pedido_id
);

PRINT 'INSERINDO EM NOTA FISCAL';

-- Gerando o estoque
INSERT into Estoque (Prod_ID, Quantidade, Estoque_Minimo)
SELECT 
Pr.produto_id AS Produto_id,
COALESCE( SUM( Es.quantidade ), 0) AS Quantidade,
COALESCE ( SUM (Ipr.quantidade), 0) AS Estoque_Minimo
FROM Produtos Pr
LEFT JOIN ItensPedidos IPr ON Pr.produto_id = Ipr.produto_ID
LEFT JOIN Estoque Es ON Es.Prod_ID = Pr.produto_id
GROUP BY Pr.produto_id;


PRINT 'INSERINDO EM ESTOQUE';


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
    (SELECT SUM(quantidade) * 10 FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total_quantidade,
    (SELECT Status_ID FROM StatusPedido WHERE StatusPedido.Nome_Status = 'Pendente') AS compra_status,
    (SELECT SUM(preco_unitario * quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total,
    GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ ORDER BY total;

PRINT 'INSERINDO EM REQUISICAO DE COMPRAS';


-- Inserindo em Despacho de Mercadorias

INSERT INTO [dbo].[DespachoMercadorias]
           ([Pedido_ID],[Transportadora_ID],[Status_Entrega],[Data_Liberacao])
    
	SELECT DISTINCT 
    Pe.pedido_id AS Pedido_ID,
	( SELECT TOP(1) Tr.Transportadora_id FROM Transportadora Tr WHERE Tr.Tipo_Servico = 'Padrao' ORDER BY tr.Custo_Frete ASC ) As Transportadora_ID,
	( SELECT St.IDStatus FROM StatusDespacho St WHERE St.NomeStatus = 'Em processamento' ) AS Status_Entrega,
	( SELECT CONVERT(date, GETDATE())) AS Data_Liberacao
	FROM Pedidos Pe;

	PRINT 'INSERINDO EM DESPACHO DE MERCADORIAS';
	

END;


