

-- Criando procedimento enum para o status de envio

CREATE PROCEDURE StatusDeEnvio
WITH EXECUTE AS OWNER, SCHEMABINDING, NATIVE_COMPILATION
AS
BEGIN
	-- Tabela de estado de monitoramento do pedido - controle logístico

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
		
	-- Tabela de estado de monitoramento do pedido - controle de loja

	CREATE TABLE StatusPedido (
		Status_ID INT PRIMARY KEY IDENTITY NOT NULL,
		Nome_Status VARCHAR(50) NOT NULL
	);

	INSERT INTO StatusPedido (Nome_Status) VALUES
	('Pendente'),
	('Em processamento'),
	('Enviado'),
	('Entregue'),
	('Cancelado');

END