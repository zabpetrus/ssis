

-- Criando procedimento enum para o status de envio

CREATE PROCEDURE StatusDeEnvio
WITH EXECUTE AS OWNER, SCHEMABINDING, NATIVE_COMPILATION
AS
BEGIN
	CREATE TABLE StatusDespacho (
		[IDStatus] INT PRIMARY KEY,
		[NomeStatus] VARCHAR(50) NOT NULL
	);
	INSERT INTO StatusDespacho ([IDStatus], [NomeStatus])
	VALUES 
		(1, 'Em processamento'),
		(2, 'Enviado'),
		(3, 'Entregue'),
		(4, 'Cancelado');	
END