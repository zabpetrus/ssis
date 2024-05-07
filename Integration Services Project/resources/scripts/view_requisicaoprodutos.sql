CREATE VIEW Ordem_Requisicao_Compra AS
SELECT DISTINCT
    Fornecedores.fornecedor_id AS Fornecedor_id,
	Fornecedores.Nome_fornecedor,
    Produtos.produto_id AS Produto_id,
	Produtos.nome_Produto AS Nome_Produto,
    (SELECT SUM(quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total_quantidade,
    (SELECT Status_ID FROM StatusPedido WHERE StatusPedido.Nome_Status = 'Pendente') AS compra_status,
    (SELECT SUM(preco_unitario * quantidade) FROM ItensPedidos WHERE ItensPedidos.produto_ID = Produtos.produto_id) AS total,
    GETDATE() AS dataEmissao
FROM Produtos
INNER JOIN Fornecedores ON Fornecedores.CNPJ = Produtos.fornecedor_CNPJ;

