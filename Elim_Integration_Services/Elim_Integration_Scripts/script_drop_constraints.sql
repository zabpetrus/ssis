BEGIN

-- Começando excluindo as constraints caso elas existam
-- Procedimento para correção do banco

-- Remoção da constraint FK_RC_FORN em RequisicaoCompra
-- Remoção da constraint FK_RC_FORN em RequisicaoCompra
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'RequisicaoCompra' 
    AND constraint_name = 'FK_RC_FORN'
)
BEGIN
    ALTER TABLE RequisicaoCompra
    DROP CONSTRAINT FK_RC_FORN;
END;

-- Remoção da constraint FK_RC_PROD em RequisicaoCompra
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'RequisicaoCompra' 
    AND constraint_name = 'FK_RC_PROD'
)
BEGIN
    ALTER TABLE RequisicaoCompra
    DROP CONSTRAINT FK_RC_PROD;
END;

-- Remoção da Constrante FK_RC_STAT em RequisicaoCompra
IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE TABLE_NAME = 'RequisicaoCompra'
	AND CONSTRAINT_NAME = 'FK_RC_STAT'
)
BEGIN
	ALTER TABLE RequisicaoCompra
	DROP CONSTRAINT FK_RC_STAT;
END;


-- Remoção da constraint FK_PED_CLI em Pedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Pedidos' 
    AND constraint_name = 'FK_PED_CLI'
)
BEGIN
    ALTER TABLE Pedidos
    DROP CONSTRAINT FK_PED_CLI;
END;

-- Remoção da constraint FK_IP_PE em ItensPedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'ItensPedidos' 
    AND constraint_name = 'FK_IP_PE'
)
BEGIN
    ALTER TABLE ItensPedidos
    DROP CONSTRAINT FK_IP_PE;
END;


-- Remoção da constraint FK_IP_PROD em ItensPedidos
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'ItensPedidos' 
    AND constraint_name = 'FK_IP_PROD'
)
BEGIN
    ALTER TABLE ItensPedidos
    DROP CONSTRAINT FK_IP_PROD;
END;


-- Remoção da constraint FK_NF_PE em NotaFiscal
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'NotaFiscal' 
    AND constraint_name = 'FK_NF_PE'
)
BEGIN
    ALTER TABLE NotaFiscal
    DROP CONSTRAINT FK_NF_PE;
END;

-- Remoção da constraint FK_SD_D em Checkout
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Checkout' 
    AND constraint_name = 'FK_SD_D'
)
BEGIN
    ALTER TABLE Checkout
    DROP CONSTRAINT FK_SD_D;
END;

-- Remoção da constraint FK_DM_PROD em DespachoMercadorias
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'DespachoMercadorias' 
    AND constraint_name = 'FK_DM_PROD'
)
BEGIN
    ALTER TABLE DespachoMercadorias
    DROP CONSTRAINT FK_DM_PROD;
END;

-- Remoção da constraint FK_DM_TRANS em DespachoMercadorias
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'DespachoMercadorias' 
    AND constraint_name = 'FK_DM_TRANS'
)
BEGIN
    ALTER TABLE DespachoMercadorias
    DROP CONSTRAINT FK_DM_TRANS;
END;

-- Remoção da constraint FK_EST_PROD em Estoque
IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Estoque' 
    AND constraint_name = 'FK_EST_PROD'
)
BEGIN
    ALTER TABLE Estoque
    DROP CONSTRAINT FK_EST_PROD;
END;

IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'Checkout' 
    AND constraint_name = 'FK_P_C'
)
BEGIN
    ALTER TABLE Checkout
    DROP CONSTRAINT FK_P_C;
END;


IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'AcompanhamentoPedidos' 
    AND constraint_name = 'FK_AP_IP'
)
BEGIN
    ALTER TABLE AcompanhamentoPedidos
    DROP CONSTRAINT FK_AP_IP;
END;




END;