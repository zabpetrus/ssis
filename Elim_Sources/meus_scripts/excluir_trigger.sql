Use Utilitario;

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'Colocar_estoque' AND parent_class_desc = 'DATABASE' AND type_desc = 'SQL_TRIGGER')
BEGIN
    DROP TRIGGER Colocar_estoque;
END;