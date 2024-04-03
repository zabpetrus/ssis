CREATE PROCEDURE ReiniciarTabela
AS
BEGIN
    -- Verificar se a tabela existe e, se sim, excluí-la
    IF OBJECT_ID('Temp_Pedidos') IS NOT NULL
        DROP TABLE Temp_Pedidos;

    -- Criar a tabela
    CREATE TABLE Temp_Pedidos (
        [Product ID (SKU)] VARCHAR(50),
        [Locale; Title; Description] VARCHAR(100),
        [Auto Fill Prices] VARCHAR(50),
        [Price] VARCHAR(180),
        [IAP Type] VARCHAR(50),
    );
	   
    -- Fim do procedimento
END;

EXEC ReiniciarTabela;