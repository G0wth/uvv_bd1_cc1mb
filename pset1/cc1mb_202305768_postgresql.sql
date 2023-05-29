-- TURMA: CC1MB
-- ALUNO: Vitor Hugo Burns Lessa


-- Apagar o banco de dados e o usuário caso existam:

-- Banco de Dados
DROP DATABASE IF EXISTS uvv;

-- Usuário
DROP USER     IF EXISTS vitor;


-- Criar um novo usuário com acesso a um novo banco de dados

CREATE USER vitor
WITH CREATEDB INHERIT login password 'vhbl';


-- Criar um banco de dados de nome "uvv" com os devidos parâmetros

CREATE DATABASE       	      uvv
	OWNER 		      vitor
	TEMPLATE 	      template0
	ENCODING 	      'UTF8'
	LC_COLLATE 	      'pt_BR.UTF-8'
	LC_CTYPE 	      'pt_BR.UTF-8'
	ALLOW_CONNECTIONS true;


-- Comentar sobre o banco de dados "lojas uvv"

COMMENT ON DATABASE uvv
IS 'Banco de Dados: Lojas UVV';


-- Conectar com o banco de dados "uvv" com o usuário "vitor" e a senha "vhbl" sem requisita-la

\c 'dbname=uvv user=vitor password=vhbl';


-- Criar o esquema "lojas" e atribuir a autorização para o usuário "vitor"

CREATE SCHEMA lojas
AUTHORIZATION vitor;


-- Definir o esquema "lojas" como o padrão para o usuário "vitor"

                    SET SEARCH_PATH TO lojas, "$user", public;
ALTER USER vitor    SET SEARCH_PATH TO lojas, "$user", public;




-- Criar a tabela produtos

CREATE TABLE produtos (
                produto_id 		  	NUMERIC(38) 	NOT NULL,
                nome 			  	VARCHAR(255) 	NOT NULL,
                preco_unitario 		  	NUMERIC(10,2),
                detalhes 		  	BYTEA,
                imagem 			  	BYTEA,
                imagem_mime_type 	 	VARCHAR(512),
                imagem_arquivo 		  	VARCHAR(512),
                imagem_charset 		  	VARCHAR(512),
                imagem_ultima_atualizacao 	DATE,

                CONSTRAINT pk_produto_id    	PRIMARY KEY (produto_id)
);


/*
Comentar a tabela produtos
Comentar as colunas da tabela produtos
*/

-- Tabela produtos
COMMENT ON TABLE produtos 			         IS 'Tabela para armazenar informações sobre produtos';

-- Colunas da tabela produtos
COMMENT ON COLUMN produtos.produto_id 	             	 IS 'Chave primária, id identificador do produto';
COMMENT ON COLUMN produtos.nome 		         IS 'Nome do produto';
COMMENT ON COLUMN produtos.preco_unitario 	         IS 'Preço do produto';
COMMENT ON COLUMN produtos.detalhes 		         IS 'Detalhes do produto';
COMMENT ON COLUMN produtos.imagem 		         IS 'Imagem do produto';
COMMENT ON COLUMN produtos.imagem_mime_type 	   	 IS 'Tipo MIME da imagem';
COMMENT ON COLUMN produtos.imagem_arquivo 	         IS 'Caminho do arquivo de imagem';
COMMENT ON COLUMN produtos.imagem_charset 	         IS 'Charset da imagem';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao 	 IS 'Data da última atualização da imagem';


--Restrições de checagem da tabela produtos:

-- Valor em produto_id ser maior do que 0
ALTER TABLE 	produtos
ADD CONSTRAINT  chk_produto_id
CHECK 	    	(produto_id > 0);

-- Valor em preço_unitario ser maior do que 0
ALTER TABLE 	produtos
ADD CONSTRAINT  chk_preco_unitario
CHECK 	    	(preco_unitario > 0);




-- Criar a tabela lojas

CREATE TABLE lojas (
                loja_id 		    NUMERIC(38) 	NOT NULL,
                nome 			    VARCHAR(255) 	NOT NULL,
                endereco_web 		    VARCHAR(100),
                endereco_fisico 	    VARCHAR(512),
                latitude 		    NUMERIC,
                longitude 		    NUMERIC,
                logo 			    BYTEA,
                logo_mime_type 		    VARCHAR(512),
                logo_arquivo 		    VARCHAR(512),
                logo_charset 		    VARCHAR(512),
                logo_ultima_atualizacao     DATE,

                CONSTRAINT pk_loja_id       PRIMARY KEY (loja_id)
);


/*
Comentar a tabela lojas
Comentar as colunas da tabela lojas
*/

-- Tabela lojas
COMMENT ON TABLE lojas 				        IS 'Tabela que armazena informações das lojas';

-- Colunas da tabela lojas
COMMENT ON COLUMN lojas.loja_id 	              	IS 'Identificador único da loja';
COMMENT ON COLUMN lojas.nome 			        IS 'Nome da loja';
COMMENT ON COLUMN lojas.endereco_web 	        	IS 'Endereço web da loja';
COMMENT ON COLUMN lojas.endereco_fisico         	IS 'Endereço físico da loja';
COMMENT ON COLUMN lojas.latitude 	            	IS 'Latitude da localização da loja';
COMMENT ON COLUMN lojas.longitude 	            	IS 'Longitude da localização da loja';
COMMENT ON COLUMN lojas.logo 			        IS 'Logo da loja (em formato binário)';
COMMENT ON COLUMN lojas.logo_mime_type 	    	    	IS 'Tipo MIME da imagem do logo';
COMMENT ON COLUMN lojas.logo_arquivo 		        IS 'Nome do arquivo da imagem do logo';
COMMENT ON COLUMN lojas.logo_charset 		        IS 'Charset da imagem do logo';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao     	IS 'Data da última atualização do logo';


--Restrições de checagem da tabela lojas:

-- Valor em loja_id ser maior que 0
ALTER TABLE 	lojas
ADD CONSTRAINT  check_loja_id
CHECK	    	(loja_id > 0);

-- O endereço web ou endereço físico da loja deve ser preenchido (não podem ser ambos nulos)
ALTER TABLE 	lojas
ADD CONSTRAINT  check_endereco
CHECK	    	(endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);




-- Criar a tabela estoques

CREATE TABLE estoques (
                estoque_id 		NUMERIC(38) 	NOT NULL,
                loja_id 		NUMERIC(38) 	NOT NULL,
                produto_id 		NUMERIC(38) 	NOT NULL,
                quantidade 		NUMERIC(38) 	NOT NULL,

                CONSTRAINT pk_estoque_id       		PRIMARY KEY (estoque_id)
);



/*
Comentar a tabela estoques
Comentar as colunas da tabela estoques
*/

-- Tabela estoques
COMMENT ON TABLE estoques 		IS 'Tabela que armazena informações dos estoques';

-- Colunas da tabela estoques
COMMENT ON COLUMN estoques.estoque_id 	IS 'Identificador único do estoque';
COMMENT ON COLUMN estoques.loja_id 	IS 'Identificador da loja relacionada ao estoque';
COMMENT ON COLUMN estoques.produto_id 	IS 'Identificador do produto relacionado ao estoque';
COMMENT ON COLUMN estoques.quantidade 	IS 'Quantidade de produtos em estoque';


-- Restrições de checagem da tabela estoques:

-- Valor em estoque_id ser maior do que 0
ALTER TABLE 	estoques
ADD CONSTRAINT  chk_estoque_id 
CHECK 		(estoque_id > 0);

-- Valor em quantidade ser maior ou igual a 0
ALTER TABLE 	estoques
ADD CONSTRAINT  chk_quantidade 
CHECK 		(quantidade >= 0);




-- Criar a tabela clientes

CREATE TABLE clientes (
                cliente_id 	NUMERIC(38) 	NOT NULL,
                email 		VARCHAR(255) 	NOT NULL,
                nome 		VARCHAR(255) 	NOT NULL,
                telefone1 	VARCHAR(20),
                telefone2 	VARCHAR(20),
                telefone3 	VARCHAR(20),

                CONSTRAINT pk_cliente_id        PRIMARY KEY (cliente_id)
);


/*
Comentar a tabela clientes
Comentar as colunas da tabela clientes
*/

-- Tabela clientes
COMMENT ON TABLE clientes 		IS 'Tabela que armazena informações dos clientes';

-- Colunas da tabela clientes
COMMENT ON COLUMN clientes.cliente_id 	IS 'Identificador único do cliente';
COMMENT ON COLUMN clientes.email 	IS 'Endereço de email do cliente';
COMMENT ON COLUMN clientes.nome 	IS 'Nome do cliente';
COMMENT ON COLUMN clientes.telefone1    IS 'Primeiro número de telefone do cliente';
COMMENT ON COLUMN clientes.telefone2 	IS 'Segundo número de telefone do cliente';
COMMENT ON COLUMN clientes.telefone3 	IS 'Terceiro número de telefone do cliente';


-- Criar as restrições de checagem para a tabela clientes:

-- Valor em cliente_id ser maior do que 0
ALTER TABLE 	clientes
ADD CONSTRAINT  chk_cliente_id 
CHECK 		(cliente_id > 0);




-- Criar a tabela envios

CREATE TABLE envios (
                envio_id 		NUMERIC(38) 	NOT NULL,
                loja_id 		NUMERIC(38) 	NOT NULL,
                cliente_id 		NUMERIC(38) 	NOT NULL,
                endereco_entrega 	VARCHAR(512) 	NOT NULL,
                status 			VARCHAR(15) 	NOT NULL,

                CONSTRAINT pk_envio_id  PRIMARY KEY (envio_id)
);


/*
Comentar a tabela envios
Comentar as colunas da tabela envios
*/

-- Tabela envios
COMMENT ON TABLE envios 		        IS 'Tabela que armazena informações dos envios';

-- Colunas da tabela envios
COMMENT ON COLUMN envios.envio_id 		IS 'Identificador único do envio';
COMMENT ON COLUMN envios.loja_id 		IS 'Identificador da loja relacionada ao envio';
COMMENT ON COLUMN envios.cliente_id 		IS 'Identificador do cliente relacionado ao envio';
COMMENT ON COLUMN envios.endereco_entrega 	IS 'Endereço de entrega do envio';
COMMENT ON COLUMN envios.status 		IS 'Status do envio';


-- Criar as restrições de checagem para a tabela envios:

-- Valor em envio_id ser maior do que 0
ALTER TABLE 	envios
ADD CONSTRAINT  chk_envio_id
CHECK 		(envio_id > 0);

-- Criar a restrição de checagem para status seguir os valores (CRIADO, ENVIADO, TRANSITO, ENTREGUE)
ALTER TABLE 	envios
ADD CONSTRAINT  chk_status
CHECK 		(status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));




-- Criar a tabela pedidos

CREATE TABLE pedidos (
                pedido_id   NUMERIC(38)	    NOT NULL,
                data_hora   TIMESTAMP 	    NOT NULL,
                cliente_id  NUMERIC(38)	    NOT NULL,
                status      VARCHAR(15)     NOT NULL,
                loja_id     NUMERIC(38)     NOT NULL,

                CONSTRAINT pk_pedido_id     PRIMARY KEY (pedido_id)
);


/*
Comentar a tabela pedidos
Comentar as colunas da tabela pedidos
*/

-- Tabela pedidos
COMMENT ON TABLE pedidos 		IS 'Tabela que armazena informações dos pedidos';

-- Colunas da tabela pedidos
COMMENT ON COLUMN pedidos.pedido_id 	IS 'Identificador único do pedido';
COMMENT ON COLUMN pedidos.data_hora 	IS 'Data e hora do pedido';
COMMENT ON COLUMN pedidos.cliente_id 	IS 'Identificador do cliente relacionado ao pedido';
COMMENT ON COLUMN pedidos.status 	IS 'Status do pedido';
COMMENT ON COLUMN pedidos.loja_id 	IS 'Identificador da loja relacionada ao pedido';


-- Criar as restrições de checagem para a tabela pedidos:

-- Criar a restrição de checagem para pedido_id (pedido_id > 0)
ALTER TABLE 	pedidos
ADD CONSTRAINT  chk_pedido_id
CHECK 		(pedido_id > 0);

-- Criar a restrição de checagem para status (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'))
ALTER TABLE 	pedidos
ADD CONSTRAINT  chk_status
CHECK 		(status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));




-- Criar a tabela pedidos_itens

CREATE TABLE pedidos_itens (
                pedido_id 		    NUMERIC(38) 	NOT NULL,
                produto_id 		    NUMERIC(38) 	NOT NULL,
                numero_da_linha 	    NUMERIC(38) 	NOT NULL,
                preco_unitario		    NUMERIC(10,2) 	NOT NULL,
                quantidade		    NUMERIC(38) 	NOT NULL,
                envio_id		    NUMERIC(38) 	NOT NULL,

                CONSTRAINT pk_pedidos_itens         		PRIMARY KEY (pedido_id, produto_id)
);


/*
Comentar a tabela pedidos_itens
Comentar as colunas da tabela pedidos_itens
*/

-- Tabela pedidos_itens
COMMENT ON TABLE pedidos_itens 			 	IS 'Tabela que armazena informações dos itens de pedidos';

-- Colunas da tabela pedidos_itens
COMMENT ON COLUMN pedidos_itens.pedido_id 		IS 'Identificador do pedido relacionado ao item';
COMMENT ON COLUMN pedidos_itens.produto_id 		IS 'Identificador do produto relacionado ao item';
COMMENT ON COLUMN pedidos_itens.numero_da_linha 	IS 'Número da linha do item no pedido';
COMMENT ON COLUMN pedidos_itens.preco_unitario 		IS 'Preço unitário do item';
COMMENT ON COLUMN pedidos_itens.quantidade 		IS 'Quantidade do item';
COMMENT ON COLUMN pedidos_itens.envio_id 		IS 'Identificador do envio relacionado ao item';


-- Crias as restrições de checagem para a tabelas pedidos_itens:

-- Valor em numero_da_linha ser maior do que 0
ALTER TABLE 	pedidos_itens
ADD CONSTRAINT  chk_numero_da_linha
CHECK 		(numero_da_linha > 0);

-- Valor em preco_unitario ser maior do que 0
ALTER TABLE 	pedidos_itens
ADD CONSTRAINT  chk_preco_unitario
CHECK 		(preco_unitario > 0);

-- Valor em pedidos_itens ser maior ou igual a 0
ALTER TABLE 	pedidos_itens
ADD CONSTRAINT  chk_quantidade
CHECK 		(quantidade >= 0);




-- Relações entre as tabelas

-- Tabela estoques: 
ALTER TABLE         estoques 
ADD CONSTRAINT      produtos_estoques_fk
FOREIGN KEY         (produto_id)
REFERENCES          produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE         estoques 
ADD CONSTRAINT      lojas_estoques_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Tabela envios:
ALTER TABLE         envios 
ADD CONSTRAINT      lojas_envios_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE         envios 
ADD CONSTRAINT      clientes_envios_fk
FOREIGN KEY         (cliente_id)
REFERENCES          clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Tabela pedidos:
ALTER TABLE         pedidos 
ADD CONSTRAINT      lojas_pedidos_fk
FOREIGN KEY         (loja_id)
REFERENCES          lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE         pedidos 
ADD CONSTRAINT      clientes_pedidos_fk
FOREIGN KEY         (cliente_id)
REFERENCES          clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Tabela pedidos itens:
ALTER TABLE         pedidos_itens 
ADD CONSTRAINT      produtos_pedidos_itens_fk
FOREIGN KEY         (produto_id)
REFERENCES          produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE         pedidos_itens 
ADD CONSTRAINT      fk_envios_pedidos_itens
FOREIGN KEY         (envio_id)
REFERENCES          envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE         pedidos_itens 
ADD CONSTRAINT      pedidos_pedidos_itens_fk
FOREIGN KEY         (pedido_id)
REFERENCES          pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
