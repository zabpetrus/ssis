USE [Utilitario];
GO

MERGE INTO Produtos AS target
USING (
    SELECT DISTINCT 
        Carga.nomeProduto,
        Carga.descricao,
        Carga.sku,
        Carga.upc,
        Carga.valor,
        Carga.frete,
        Carga.fornecedor,
        Carga.fornecedor_cnpj
    FROM Carga
) AS source
ON target.upc = source.upc
WHEN NOT MATCHED THEN
    INSERT (nome_Produto, descricao, sku, upc, valor, frete_produto, Nome_fornecedor, fornecedor_CNPJ)
    VALUES (source.nomeProduto, source.descricao, source.sku, source.upc, source.valor, source.frete, source.fornecedor, source.fornecedor_cnpj);





MERGE INTO Clientes AS target
USING (
    SELECT DISTINCT 
        Carga.nomeComprador AS Nome,
        Carga.email,
        Carga.cpf,
        Carga.uf,
        Carga.pais
    FROM dbo.Carga
    LEFT JOIN Clientes ON Clientes.cpf = Carga.cpf  
    WHERE Clientes.cpf IS NULL
) AS source
ON target.cpf = source.cpf
WHEN NOT MATCHED THEN
    INSERT (Nome, email, cpf, uf, pais)
    VALUES (source.Nome, source.email, source.cpf, source.uf, source.pais);





MERGE INTO [dbo].[Pedidos] AS target
USING (
    SELECT DISTINCT 
        Carga.codigoPedido AS codigo_Pedido,
        Clientes.cliente_id,
        Carga.dataPedido AS data_Pedido,
        Carga.enderecoEntrega AS endereco_entrega,
        Carga.cep,
        SP.Status_ID AS status_pedido
    FROM Carga
    INNER JOIN Clientes ON Clientes.cpf = Carga.cpf
    INNER JOIN StatusPedido AS SP ON SP.Nome_Status = 'Pendente'
    ORDER BY Carga.dataPedido
) AS source
ON target.codigo_Pedido = source.codigo_Pedido
WHEN NOT MATCHED THEN
    INSERT (
        codigo_Pedido,
        cliente_ID,
        data_Pedido,
        endereco_entrega,
        cep,
        status_pedido
    )
    VALUES (
        source.codigo_Pedido,
        source.cliente_id,
        source.data_Pedido,
        source.endereco_entrega,
        source.cep,
        source.status_pedido
    );


MERGE INTO ItensPedidos AS target
USING (
    SELECT DISTINCT 
        Pedidos.pedido_id,
        Produtos.produto_id,
        Carga.qte AS quantidade,
        Carga.valor AS preco_unitario
    FROM Carga
    LEFT JOIN Produtos ON Carga.upc = Produtos.upc AND Carga.sku = Produtos.sku
    LEFT JOIN Pedidos ON Pedidos.codigo_Pedido = Carga.codigoPedido
) AS source
ON target.pedido_ID = source.pedido_id
   AND target.produto_ID = source.produto_id
WHEN NOT MATCHED THEN
    INSERT (pedido_ID, produto_ID, quantidade, preco_unitario)
    VALUES (source.pedido_id, source.produto_id, source.quantidade, source.preco_unitario);





	MERGE INTO Checkout AS target
USING (
    SELECT DISTINCT 
        Pr.pedido_id,
        SUM((Itr.quantidade * Itr.preco_unitario) + Pd.frete_produto) AS total_pedido,
        (SELECT StatusDespacho.IDStatus FROM StatusDespacho WHERE StatusDespacho.NomeStatus = 'Em processamento') AS status_despacho,
        GETDATE() AS data_despacho
    FROM 
        Pedidos Pr 
        INNER JOIN ItensPedidos Itr ON Pr.pedido_id = Itr.pedido_ID 
        INNER JOIN Produtos Pd ON Pd.produto_id = Itr.produto_ID
    WHERE NOT EXISTS (
        SELECT 1
        FROM Checkout ck
        WHERE ck.Pedido_id = Pr.pedido_id
    )
    GROUP BY  Pr.pedido_id, Pr.codigo_Pedido
) AS source
ON target.Pedido_id = source.pedido_id
WHEN NOT MATCHED THEN
    INSERT (Pedido_id, total_pedido, status_despacho, data_despacho)
    VALUES (source.pedido_id, source.total_pedido, source.status_despacho, source.data_despacho);





	MERGE INTO Fornecedores AS target
USING (
    SELECT DISTINCT 
        Carga.fornecedor AS Nome_fornecedor,
        Carga.fornecedor_cnpj AS CNPJ
    FROM Carga
    LEFT JOIN Fornecedores ON Fornecedores.CNPJ = Carga.fornecedor_cnpj
    WHERE NOT EXISTS (
        SELECT 1 FROM Fornecedores Fr WHERE Fr.CNPJ = Carga.fornecedor_cnpj
    )
) AS source
ON target.CNPJ = source.CNPJ
WHEN NOT MATCHED THEN
    INSERT (Nome_fornecedor, CNPJ)
    VALUES (source.Nome_fornecedor, source.CNPJ);






	MERGE INTO NotaFiscal AS target
USING (
    SELECT DISTINCT 
        Pedidos.pedido_id AS Pedido_ID,
        Checkout.total_pedido AS Valor_Total,
        Checkout.data_despacho AS Data_Emissao
    FROM Pedidos
    INNER JOIN Checkout ON Checkout.Pedido_id = Pedidos.pedido_id 
    WHERE NOT EXISTS (
        SELECT 1 FROM NotaFiscal nf WHERE nf.Pedido_ID = Checkout.Pedido_id
    )
) AS source
ON target.Pedido_ID = source.Pedido_ID
WHEN NOT MATCHED THEN
    INSERT (Pedido_ID, Valor_Total, Data_Emissao)
    VALUES (source.Pedido_ID, source.Valor_Total, source.Data_Emissao);




	MERGE INTO Estoque AS target
USING (
    SELECT 
        Pr.produto_id AS Prod_ID,
        COALESCE(SUM(Es.quantidade), 0) AS Quantidade,
        COALESCE(SUM(Ipr.quantidade), 0) AS Estoque_Minimo
    FROM Produtos Pr
    LEFT JOIN ItensPedidos IPr ON Pr.produto_id = IPr.produto_ID
    LEFT JOIN Estoque Es ON Es.Prod_ID = Pr.produto_id
    GROUP BY Pr.produto_id
) AS source
ON target.Prod_ID = source.Prod_ID
WHEN MATCHED THEN
    UPDATE SET
        Quantidade = source.Quantidade,
        Estoque_Minimo = source.Estoque_Minimo
WHEN NOT MATCHED THEN
    INSERT (Prod_ID, Quantidade, Estoque_Minimo)
    VALUES (source.Prod_ID, source.Quantidade, source.Estoque_Minimo);





MERGE INTO RequisicaoCompra AS target
USING (
    SELECT DISTINCT
        Fornecedores.fornecedor_id AS Fornecedor_id,
        Produtos.produto_id AS Produto_id,
        (SELECT SUM(quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS qte,
        (SELECT Status_ID FROM StatusPedido WHERE StatusPedido.Nome_Status = 'Pendente') AS compra_status,
        (SELECT SUM(preco_unitario * quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total,
        GETDATE() AS dataEmissao
    FROM Produtos
    INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ
) AS source
ON target.Fornecedor_id = source.Fornecedor_id
   AND target.Produto_id = source.Produto_id
WHEN NOT MATCHED THEN
    INSERT (
        Fornecedor_id,
        Produto_id,
        qte,
        compra_status,
        total,
        dataEmissao
    )
    VALUES (
        source.Fornecedor_id,
        source.Produto_id,
        source.qte,
        source.compra_status,
        source.total,
        source.dataEmissao
    );




	MERGE INTO [dbo].[AcompanhamentoPedidos] AS target
USING (
    SELECT  
        ItensPedidos.Item_ID AS ItensPedidos_ID,
        CAST(0 AS BIT) AS ItensPedidos_status
    FROM ItensPedidos
) AS source
ON target.ItensPedidos_ID = source.ItensPedidos_ID
WHEN NOT MATCHED THEN
    INSERT (
        ItensPedidos_ID,
        ItensPedidos_status
    )
    VALUES (
        source.ItensPedidos_ID,
        source.ItensPedidos_status
    );



