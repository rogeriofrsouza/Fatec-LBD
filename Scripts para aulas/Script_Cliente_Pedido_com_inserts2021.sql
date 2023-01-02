--- Script para aulas práticas Modelo cliente-Pedido
--- Atualização: Fevereiro-2021

--- Excluindo tabelas (caso existam)
DROP TABLE tb_item_pedido;
DROP TABLE tb_pedido;
DROP TABLE tb_cliente;
DROP TABLE tb_vendedor;
DROP TABLE tb_produto;

--
CREATE TABLE tb_cliente(
  cod_cliente NUMBER(5) NOT NULL,
  nome_cliente VARCHAR2(30) NOT NULL,
  endereco VARCHAR2(30),
  cidade VARCHAR2(20),
  cep VARCHAR2(10),
  uf CHAR(2)
);

CREATE TABLE tb_vendedor( 
  cod_vendedor NUMBER(5) NOT NULL,
  nome_vendedor VARCHAR2(30) NOT NULL,
  faixa_comissao NUMBER(4,2),
  salario_fixo NUMBER(7,2)
);

CREATE TABLE tb_produto(
  cod_produto NUMBER(5) NOT NULL,
  descricao varCHAR(30),
  unidade CHAR(2),
  valor_unitario NUMBER(6,2)
);

CREATE TABLE tb_pedido( 
  num_pedido NUMBER(5) NOT NULL,
  prazo_entrega DATE,
  cod_cliente NUMBER(5),
  cod_vendedor NUMBER(5)
);

CREATE TABLE tb_item_pedido(
  num_pedido NUMBER(5) NOT NULL,
  cod_produto NUMBER(5) NOT NULL,
  quantidade NUMBER(5)
);


--- Restrições de PK
ALTER TABLE tb_cliente
ADD CONSTRAINT pk_cliente_cod_cliente PRIMARY KEY(cod_cliente);
 
ALTER TABLE tb_produto 
ADD CONSTRAINT pk_produto_cod_produto PRIMARY KEY(cod_produto);

ALTER TABLE tb_vendedor 
ADD CONSTRAINT pk_vendedor_cod_vendedor PRIMARY KEY(cod_vendedor);

ALTER TABLE tb_pedido 
ADD CONSTRAINT pk_pedido_num_pedido PRIMARY KEY(num_pedido);
 
ALTER TABLE tb_item_pedido 
ADD CONSTRAINT pk_item_pedido_ped_prod PRIMARY KEY(num_pedido, cod_produto);


--- Restrições de FK 
ALTER TABLE tb_pedido 
ADD CONSTRAINT fk_pedido_cod_cli FOREIGN KEY(cod_cliente) REFERENCES tb_cliente;

ALTER TABLE tb_pedido 
ADD CONSTRAINT fk_pedido_cod_vendedor FOREIGN KEY(cod_vendedor) REFERENCES tb_vendedor;


--- item pedido
ALTER TABLE tb_item_pedido 
ADD CONSTRAINT fk_item_pedido_num_pedido FOREIGN KEY(num_pedido) REFERENCES tb_pedido;

ALTER TABLE tb_item_pedido 
ADD CONSTRAINT fk_item_pedido_cod_produto FOREIGN KEY(cod_produto) REFERENCES tb_produto;

---- Inserindo dados
INSERT INTO tb_vendedor VALUES (5, 'Antonio Pedro', 5.0, 400);
INSERT INTO tb_vendedor VALUES (15, 'Carlos Sola', 0.0, 400);
INSERT INTO tb_vendedor VALUES (25, 'Ana Carolina', 1.0, 200);
INSERT INTO tb_vendedor VALUES (35, 'Solange Almeida', 1.0, 300);

--
INSERT INTO tb_cliente VALUES ( 30, 'João da Silva', 'AV. MATT HOFFMANN, 1100', 'SÃO PAULO', '97056-001', 'SP');
INSERT INTO tb_cliente VALUES ( 31, 'LUCAS ANTUNES', 'RUA TRODANI, 120', 'SOROCABA', '19658-023', 'SP');
INSERT INTO tb_cliente VALUES ( 32, 'LAURA STRAUSS', 'RUA TULIPAS, 650', 'PRIMAVERA', '18556-025', 'SP');

--
INSERT INTO tb_produto VALUES (11, 'Apple Watch', 'UN', 975.99);
INSERT INTO tb_produto VALUES (12, 'IPAD', 'UN', 999.70);
INSERT INTO tb_produto VALUES (13, 'PÓ PARA TONER', 'KG', 85.60);
INSERT INTO tb_produto VALUES (14, 'Mouse', 'UN', 45.60);
INSERT INTO tb_produto VALUES (15, 'Caneta digital', 'UN', 100.00);
INSERT INTO tb_produto VALUES (40, 'Mouse sem fio', 'UN', 68.90);
INSERT INTO tb_produto VALUES (42, 'FIO HDMI', 'UN', 18.00);
INSERT INTO tb_produto VALUES (43, 'Pendrive Star Wars', 'UN', 48.00);
INSERT INTO tb_produto VALUES (44, 'Mouse com fio', 'UN', 28.00);
INSERT INTO tb_produto VALUES (45, 'Pendrive do Mickey', 'UN', 50.00);

--
INSERT INTO tb_pedido VALUES (7, '26/02/2020', 31, 15);
INSERT INTO tb_pedido VALUES (8, '23/05/2020', 32, 25);
INSERT INTO tb_pedido VALUES (9, '21/02/2020', 32, 5);
INSERT INTO tb_pedido VALUES (10, '20/02/2020', 30, 5);

--
INSERT INTO tb_item_pedido VALUES (7, 11, 1);
INSERT INTO tb_item_pedido VALUES (7, 40, 2);
INSERT INTO tb_item_pedido VALUES (7, 42, 1);
INSERT INTO tb_item_pedido VALUES (8, 43, 5);
INSERT INTO tb_item_pedido VALUES (9, 12, 1);
INSERT INTO tb_item_pedido VALUES (10, 11, 1);
INSERT INTO tb_item_pedido VALUES (10, 43, 1);
INSERT INTO tb_item_pedido VALUES (10, 13, 2);
INSERT INTO tb_item_pedido VALUES (8, 40, 1);
