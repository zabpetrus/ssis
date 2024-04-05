"#Projeto da matéria de 5SBD" 

O Repositório consiste de dois projetos:
Um projeto que usa o ssis para estudar sobre consultas complexas e o uso da ferramenta para integração de serviços.
O projeto de Serviços de Integração (SSIS) deve ser sempre executado como administrador por causa dos privilégios do banco de 
dados do SQL Service que devem ser elevados.

O pacote SSMYSQL é uma tentativa de migrar do SQLSERVER para o MYSQL. Até agora não funcionou e as linhas da tabela são descartadas, pois não é possivel fazer manualmente os inserts.
O pacote ETL é o pacote de leitura de um arquivo CSV, criar e popular três tabelas: Clientes, Pedidos e Produtos a partir dos dados do arquivo;
O pacote ETL2 faz a mesma coisa, mas faz o drop da tabela PClientes (tabela temporária) e deve ser executado como administrador (exigência);


O outro projeto abriga o swagger, consiste em uma api construida na arquitetura
DDD (design orientado a domínio). Ainda está em construção, porque não sei como construir ainda.
