USE Utilitario;

-- Populando Produtos

MERGE INTO Produtos AS target
USING (
SELECT DISTINCT 
Carga.nomeProduto,Carga.descricao, Carga.sku, Carga.upc, Carga.valor, Carga.fornecedor, Carga.fornecedor_cnpj FROM Carga 
) AS source ON target.upc = source.upc
WHEN NOT MATCHED THEN 
INSERT ( nome_Produto, descricao, sku, upc, valor, Nome_fornecedor, fornecedor_CNPJ)
VALUES (source.nomeProduto, source.descricao, source.sku, source.upc, source.valor, source.fornecedor, source.fornecedor_cnpj);



-- Populando Clientes

MERGE INTO Clientes AS target
USING (
    SELECT DISTINCT nomeComprador, email, cpf, uf, pais
    FROM dbo.Carga
) AS source
ON target.cpf = source.cpf
WHEN NOT MATCHED THEN
    INSERT (Nome, email, cpf, uf, pais)
    VALUES (source.nomeComprador, source.email, source.cpf, source.uf, source.pais);


-- Populando Pedidos
MERGE INTO Pedidos AS target
USING (
    SELECT DISTINCT 
        Carga.codigoPedido, 
        Clientes.cliente_id, 
        Carga.dataPedido, 
        Carga.enderecoEntrega, 
        Carga.cep, 
        Carga.frete, 
        StatusPedido.Status_ID 
    FROM Carga 
    INNER JOIN Clientes ON Clientes.cpf = Carga.cpf AND Clientes.email = Carga.email 
    INNER JOIN StatusPedido ON StatusPedido.Nome_Status = 'Pendente'
) AS source
ON 
    target.codigo_Pedido = source.codigoPedido
    AND target.cep = source.cep 
    AND target.data_Pedido = source.dataPedido
WHEN NOT MATCHED THEN
    INSERT 
    (
        codigo_Pedido, 
        cliente_ID, 
        data_Pedido, 
        endereco_entrega, 
        cep, 
        custo_frete, 
        status_pedido
    )
    VALUES 
    (
        source.codigoPedido, 
        source.cliente_id, 
        source.dataPedido, 
        source.enderecoEntrega, 
        source.cep, 
        source.frete, 
        source.Status_ID
    );


-- Populando ItensPedidos

MERGE INTO ItensPedidos AS target
USING (
    SELECT DISTINCT 
        P.pedido_id,
        Pr.produto_id, 
        Carga.qte,
        Carga.valor 
    FROM Carga
    JOIN Pedidos P ON Carga.codigoPedido = P.codigo_Pedido
    JOIN Produtos Pr ON Carga.upc = Pr.upc AND Carga.valor = Pr.valor
) AS source
ON 
    target.pedido_ID = source.pedido_id
    AND target.produto_ID = source.produto_id
    AND target.quantidade = source.qte
    AND target.preco_unitario = source.valor
WHEN NOT MATCHED THEN
    INSERT 
    (
        pedido_ID, 
        produto_ID, 
        quantidade,
        preco_unitario
    )
    VALUES 
    (
        source.pedido_id,
        source.produto_id, 
        source.qte,
        source.valor 
    );


MERGE INTO Checkout AS target
USING (
    SELECT DISTINCT 
        Pedidos.pedido_id,
        (
            SELECT SUM(ItensPedidos.preco_unitario * ItensPedidos.quantidade) 
            FROM ItensPedidos 
            WHERE Pedidos.pedido_id = ItensPedidos.pedido_ID
        ) AS Subtotal,
        (
            SELECT IDStatus 
            FROM StatusDespacho 
            WHERE NomeStatus = 'Em processamento'
        ) AS Status,
        GETDATE() AS data_despacho
    FROM Pedidos
) AS source
ON target.Pedido_id = source.pedido_id
WHEN NOT MATCHED THEN
    INSERT 
    (
        Pedido_id, 
        total_pedido, 
        status_despacho, 
        data_despacho
    )
    VALUES 
    (
        source.pedido_id,
        source.Subtotal,
        source.Status,
        source.data_despacho
    );


-- Populando checkout

MERGE INTO Checkout AS target
USING (
    SELECT DISTINCT 
        Pedidos.pedido_id,
        SUM(ItensPedidos.preco_unitario * ItensPedidos.quantidade) AS Subtotal,
        StatusDespacho.IDStatus AS Status,
        GETDATE() AS data_despacho
    FROM Pedidos
    JOIN ItensPedidos ON Pedidos.pedido_id = ItensPedidos.pedido_ID
    JOIN StatusDespacho ON StatusDespacho.NomeStatus = 'Em processamento'
    GROUP BY Pedidos.pedido_id, StatusDespacho.IDStatus
) AS source
ON target.Pedido_id = source.pedido_id
WHEN NOT MATCHED THEN
INSERT 
(
    Pedido_id, 
    total_pedido, 
    status_despacho, 
    data_despacho
)
VALUES 
(
    source.pedido_id,
    source.Subtotal,
    source.Status,
    source.data_despacho
);

-- Populando forncedores

MERGE INTO Fornecedores AS target
USING (
    SELECT DISTINCT 
        Carga.fornecedor AS Nome_fornecedor, 
        Carga.fornecedor_cnpj AS CNPJ 
    FROM Carga
) AS source
ON target.CNPJ = source.CNPJ
WHEN NOT MATCHED THEN
    INSERT ( Nome_fornecedor, CNPJ ) VALUES ( source.Nome_fornecedor, source.CNPJ );


-- Nota Fiscal

MERGE INTO NotaFiscal AS target
USING (
    SELECT Pedidos.pedido_id, Checkout.total_pedido, Checkout.data_despacho
    FROM Pedidos
    INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id
) AS source
ON target.Pedido_ID = source.pedido_id
WHEN NOT MATCHED THEN
    INSERT  ( Pedido_ID, Valor_Total, Data_Emissao )
    VALUES ( source.pedido_id, source.total_pedido, source.data_despacho );

 

-- Estoque

MERGE INTO Estoque AS target
USING (
    SELECT 
        Produtos.produto_id AS Prod_ID,
        COALESCE(SUM(Estoque.quantidade), 0) AS Quantidade,
        SUM(ItensPedidos.quantidade) AS Estoque_Minimo
    FROM Produtos 
    INNER JOIN ItensPedidos ON ItensPedidos.produto_ID = Produtos.produto_id
    LEFT JOIN Estoque ON Produtos.produto_id = Estoque.Prod_ID 
    GROUP BY Produtos.produto_id
) AS source
ON target.Prod_ID = source.Prod_ID
WHEN MATCHED THEN
    UPDATE SET 
        target.Quantidade = source.Quantidade,
        target.Estoque_Minimo = source.Estoque_Minimo
WHEN NOT MATCHED THEN
    INSERT (  Prod_ID, Quantidade, Estoque_Minimo )
    VALUES ( source.Prod_ID, source.Quantidade, source.Estoque_Minimo    );



-- requisicao compra

MERGE INTO RequisicaoCompra AS target
USING (
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
    INNER JOIN StatusPedido ON StatusPedido.Status_ID = 1
) AS source
ON 
    target.Fornecedor_id = source.Fornecedor_id
    AND target.Produto_id = source.Produto_id
    AND target.qte = source.qte
    AND target.compra_status = source.compra_status
    AND target.total = source.total
    AND target.dataEmissao = source.dataEmissao
WHEN NOT MATCHED THEN
    INSERT 
    (
        Fornecedor_id,
        Produto_id,
        qte,
        compra_status,
        total,
        dataEmissao
    )
    VALUES 
    (
        source.Fornecedor_id,
        source.Produto_id,
        source.qte,
        source.compra_status,
        source.total,
        source.dataEmissao
    );




