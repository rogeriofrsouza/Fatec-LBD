/* b) Criação das tabelas e definição de restrições */
CREATE TABLE Cliente ( 
  codCliente NUMBER(5) NOT NULL, 
  nome VARCHAR2(30) NOT NULL, 
  email VARCHAR2(30),
  senha VARCHAR2(20),
  codEndereco NUMBER(5)
);

CREATE TABLE Loja ( 
  codLoja NUMBER(5) NOT NULL, 
  nome VARCHAR2(30) NOT NULL
);

CREATE TABLE Produto ( 
  codProduto NUMBER(7) NOT NULL, 
  nomeProd VARCHAR2(30), 
  tipoProd VARCHAR2(20), 
  material VARCHAR2(20)
);

CREATE TABLE Pedido ( 
  codPedido NUMBER(7) NOT NULL, 
  prazo_entrega DATE, 
  codCliente NUMBER(5), 
  codEndereco NUMBER(5)
);

CREATE TABLE Loja_Produto (
  codLoja NUMBER(5) NOT NULL, 
  codProduto NUMBER(5) NOT NULL 
);

CREATE TABLE Item ( 
  codItem NUMBER(5) NOT NULL, 
  preco NUMBER(12, 2), 
  qtde VARCHAR2(20), 
  codProduto NUMBER(7),
  codloja NUMBER(5),
  codOrcamento NUMBER(5),
  codPedido NUMBER(7)
);

CREATE TABLE Endereco (
  codEndereco NUMBER(5),
  endereco VARCHAR2(30), 
  cidade VARCHAR2(20), 
  cep VARCHAR2(10), 
  uf CHAR(2)
);

CREATE TABLE Orcamento (
  codOrcamento NUMBER(5),
  preco NUMBER(10, 2),
  especificacoes VARCHAR2(100)
);

CREATE TABLE Tablog ( 
  numLog NUMBER PRIMARY KEY, 
  datalog DATE, 
  usuario VARCHAR2(15), 
  tabela VARCHAR2(15), 
  oldcampo VARCHAR2(50), 
  newcampo VARCHAR2(50), 
  campo1 VARCHAR2(30)
);

CREATE SEQUENCE seqlog;

------------------------------------------------------------

ALTER TABLE Cliente 
ADD CONSTRAINT PK_Cliente_codCliente PRIMARY KEY(codCliente);

ALTER TABLE Loja 
ADD CONSTRAINT PK_Loja_codLoja PRIMARY KEY(codLoja);

ALTER TABLE Produto 
ADD CONSTRAINT PK_Produto_codProduto PRIMARY KEY(codProduto);

ALTER TABLE Pedido
ADD CONSTRAINT PK_Pedido_codPedido PRIMARY KEY(codPedido);

ALTER TABLE Loja_Produto 
ADD CONSTRAINT PK_LojaProduto_LojaProd PRIMARY KEY(codLoja, codProduto);

ALTER TABLE Item 
ADD CONSTRAINT PK_Item_coditem PRIMARY KEY(Coditem);

ALTER TABLE Endereco 
ADD CONSTRAINT PK_Endereco_codEndereco PRIMARY KEY(codEndereco);

ALTER TABLE Orcamento 
ADD CONSTRAINT PK_Orcamento_codOrcamento PRIMARY KEY(codOrcamento);

ALTER TABLE Cliente 
ADD CONSTRAINT FK_Cliente_codEndereco FOREIGN KEY(codEndereco) REFERENCES Endereco;
 
ALTER TABLE Pedido 
ADD CONSTRAINT FK_Pedido_codCliente FOREIGN KEY(codCliente) REFERENCES Cliente;
 
ALTER TABLE Pedido 
ADD CONSTRAINT FK_Pedido_codEndereco FOREIGN KEY(codEndereco) REFERENCES Endereco;

ALTER TABLE Item
ADD CONSTRAINT FK_Item_codProduto FOREIGN KEY(codProduto) REFERENCES Produto;
 
ALTER TABLE Item 
ADD CONSTRAINT FK_Item_codLoja FOREIGN KEY(codLoja) REFERENCES Loja;
 
ALTER TABLE Item 
ADD CONSTRAINT FK_Item_codOrcamento FOREIGN KEY(codOrcamento) REFERENCES Orcamento;

ALTER TABLE Item 
ADD CONSTRAINT FK_Item_codPedido FOREIGN KEY(codPedido) REFERENCES Pedido;

--------------------------------------------------------------------------

/* c) Inserção de dados */
-- Endereco
INSERT INTO Endereco VALUES (130, 'R. Odorico Ribeiro, 172', 'Votorantim', '18117671', 'SP');
INSERT INTO Endereco VALUES (131, 'R. Américo Barroso, 70', 'Votorantim', '18113828', 'SP');
INSERT INTO Endereco VALUES (132, 'R. Dimas da Cunha, 120', 'Votorantim', '18114568', 'SP');
INSERT INTO Endereco VALUES (133, 'Av. Antonio Passos, 168', 'Sorocaba', '18114674', 'SP');
INSERT INTO Endereco VALUES (134, 'Av. Abel Oliveira, 78', 'Sorocaba', '18114112', 'SP');
 
-- Cliente
INSERT INTO Cliente VALUES (1, 'Amilton Nascimento', 'Amil@gmail.com', 'tonton21', 130);
INSERT INTO Cliente VALUES (2, 'Douglas Costa', 'douglinhaBR34@gmail.com', 'dougcos27', 131); 
INSERT INTO Cliente VALUES (3, 'Jayson Tatum', 'jay0Mvp@gmail.com', 'BC2022', 132);
INSERT INTO Cliente VALUES (4, 'Marcus Smart', 'defmarcus2022@gmail.com', 'bigdog22', 133);
INSERT INTO Cliente VALUES (5, 'Jaylen Brown', 'brownjay30@gmail.com', 'badman2', 134);
INSERT INTO Cliente VALUES (6, 'Andersen Hans', 'ander44@gmail.com', 'ardmr4', 130);

-- Loja
INSERT INTO Loja VALUES (11, 'ManMade');
INSERT INTO Loja VALUES (12, 'CanecasPerso');
INSERT INTO Loja VALUES (13, 'Tapetes Dona Maria');
INSERT INTO Loja VALUES (14, 'Horford Arts');
INSERT INTO Loja VALUES (15, 'Grant Personalizações');
INSERT INTO Loja VALUES (16, 'Melhor dos Games');
INSERT INTO Loja VALUES (17, 'Vendedor TOP');

-- Produto
INSERT INTO Produto VALUES (10, 'Quadro personalizado', 'Decoração', 'Madeira');
INSERT INTO Produto VALUES (20, 'Caneca personalizada', 'Louça', 'Porcelana');
INSERT INTO Produto VALUES (30, 'Estátua Mario', 'Decoração', 'Madeira');
INSERT INTO Produto VALUES (40, 'Colar de namorados', 'Acessório', 'Prata');
INSERT INTO Produto VALUES (50, 'Camiseta NBA', 'Vestuário' , 'Nylon');
INSERT INTO Produto VALUES (60, 'Mega Drive', 'Game', 'Plástico');

-- Loja_Produto
INSERT INTO Loja_Produto VALUES (11, 10);
INSERT INTO Loja_Produto VALUES (12, 20);
INSERT INTO Loja_Produto VALUES (13, 30);
INSERT INTO Loja_Produto VALUES (14, 40);
INSERT INTO Loja_Produto VALUES (15, 50);
INSERT INTO Loja_Produto VALUES (16, 10);

-- Orcamento
INSERT INTO Orcamento VALUES (110, 30.00, 'Moldura branca, 30x42cm, Arte Geek');
INSERT INTO Orcamento VALUES (111, 45.90, 'Escrito em fonte Poppins');
INSERT INTO Orcamento VALUES (112, 48.90, 'Roupa do personagem trocada por Verde');
INSERT INTO Orcamento VALUES (113, 94.90, 'Adicionar data ao colar: 01/11/2017');
INSERT INTO Orcamento VALUES (114, 142.90, 'Adicionar nome e número no verso da camisa: Drazen número 3');
INSERT INTO Orcamento VALUES (115, 200, 'Jogo Super Mario');

-- Pedido
INSERT INTO Pedido VALUES (120, '25-JUN-2022', 1, 130);
INSERT INTO Pedido VALUES (121, '26-JUN-2022', 2, 131);
INSERT INTO Pedido VALUES (122, '27-JUN-2022', 3, 132);
INSERT INTO Pedido VALUES (123, '24-MAR-2022', 4, 133);
INSERT INTO Pedido VALUES (124, '05-AUG-2022', 5, 134);
INSERT INTO Pedido VALUES (125, '01-JUN-2021', 3, 133);
INSERT INTO Pedido VALUES (126, '26-OUT-2022', 2, 131);

-- Item
INSERT INTO Item VALUES (105, 49.90, 1, 10, 11, 110, 120);
INSERT INTO Item VALUES (106, 39.00, 1, 20, 12, 111, 121);
INSERT INTO Item VALUES (107, 25.90, 2, 30, 13, 112, 122);
INSERT INTO Item VALUES (108, 79.50, 1, 40, 14, 113, 123);
INSERT INTO Item VALUES (109, 120.90, 3, 50, 15, 114, 124);
INSERT INTO Item VALUES (110, 22.10, 3, 30, 11, 115, 120);
INSERT INTO Item VALUES (111, 22.55, 1, 10, 16, 115, 126);

/* d) Índice para consulta de email dos clientes e consulta de especificações do orcamento */ 
CREATE INDEX clientes_email ON Cliente(email); 

CREATE INDEX especificacoes_orcamento ON Orcamento(especificacoes); 

-------------------------------------------------------------------

/* 
  3. Consultas
  a) Selecionar nome e endereco do cliente com pedido 123 
*/
SELECT c.nome, e.endereco
FROM Cliente c
INNER JOIN Endereco e
ON c.codEndereco = e.codEndereco
INNER JOIN Pedido p
ON p.codEndereco = e.codEndereco
WHERE codPedido = 123;


/* b) Selecionar email e qtde de pedidos do cliente 3 no ano passado */
SELECT c.email, COUNT(*) AS qtde_pedidos
FROM cliente c
INNER JOIN pedido p
ON c.codCliente = p.codCliente
WHERE p.codCliente = 3 AND
EXTRACT(year FROM p.prazo_entrega) = EXTRACT(year FROM sysdate) - 1
GROUP BY c.email;


/* c) Selecionar código do produto, nome do produto e quantidade de pedidos dele */
SELECT p.codProduto, p.nomeProd, COUNT(i.codProduto) AS pedidos
FROM Produto p
LEFT JOIN Item i
ON p.codProduto = i.codProduto
GROUP BY i.codProduto, p.codProduto, p.nomeProd;


/* d) Mostrar todos os códigos de pedidos que existem na tabela Item e na tabela Pedido, sem repetir o código. */
SELECT i.codPedido FROM Item i
UNION 
SELECT p.codPedido FROM Pedido p;


/* e) Exibir o nome de todos os clientes cadastrados na loja, mas que não possuem pedidos. */
SELECT nome FROM Cliente
WHERE CodCliente = (SELECT CodCliente FROM Cliente
                    MINUS
                    SELECT CodCliente FROM Pedido);


/* f) Exibir os produtos cadastrados que não possuem pedidos. */
SELECT * FROM Produto 
WHERE CodProduto NOT IN (SELECT CodProduto FROM Item
                         WHERE CodPedido IN (SELECT CodPedido FROM Item
                                             INTERSECT 
                                             SELECT CodPedido FROM Pedido));

---------------------------------------------------

/* 
  4. Subconsultas
  a) Listar codigo, nome e endereco dos clientes que tem pedidos 
*/
SELECT c.codCliente, c.nome, e.endereco 
FROM Cliente c
INNER JOIN Endereco e
ON c.codEndereco = e.codEndereco
WHERE c.codCliente IN (SELECT codCliente FROM Pedido);


/* b) Listar código e nome do produto sem pedidos */
SELECT p.codProduto, p.nomeProd 
FROM Produto p
WHERE NOT EXISTS (SELECT 1 FROM item i
                  WHERE p.codProduto = i.codProduto);


/* c) Aumentar em 15 dias o prazo de entrega de pedidos com preço acima de R$100 */
UPDATE Pedido 
SET prazo_entrega = prazo_entrega + 15
WHERE codPedido IN (SELECT codPedido FROM Item
                    WHERE preco > 100.00);


/* d) Deletar empresa/vendedor que não possui pedidos neste ano */
DELETE Loja
WHERE codLoja NOT IN (SELECT i.codLoja FROM Loja_Produto lp
                      INNER JOIN Item i
                      ON lp.codLoja = i.codLoja
                      INNER JOIN Pedido p
                      ON i.codPedido = p.codPedido
                      WHERE EXTRACT(year FROM p.prazo_entrega) = EXTRACT(year FROM sysdate));

-------------------------------------------------------------

/* 
  PL/SQL
  a) Aumentar o preço dos orçamentos em 10% para os pedidos de clientes morando em Sorocaba 
*/
CREATE OR REPLACE PROCEDURE SP_Verifica_Pedidos(P_codPedido Pedido.codPedido%TYPE) AS
  V_cidade Endereco.cidade%TYPE;

  BEGIN
    /* verificando endereço */
    SELECT e.cidade INTO V_cidade
    FROM Endereco e
    INNER JOIN Cliente c
    ON e.codEndereco = c.codEndereco
    INNER JOIN Pedido p
    ON c.codCliente = p.codCliente
    WHERE p.codPedido = P_codPedido;
    
    IF V_cidade = 'Sorocaba' THEN
      /* atualizando preco do Orcamento */
      UPDATE Orcamento
      SET preco = preco * 1.1
      WHERE codOrcamento = (SELECT o.codOrcamento
                            FROM Orcamento o
                            INNER JOIN Item i
                            ON o.codOrcamento = i.codOrcamento
                            WHERE i.codPedido = P_codPedido);
    END IF;
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20500, 'Código de Pedido não existente');
  END SP_Verifica_Pedidos;

EXEC SP_Verifica_Pedidos(123);


/* b) Retorna o valor do orçamento do item com desconto de 20%*/
CREATE OR REPLACE FUNCTION Fn_Desconto_Orcamento(P_codItem item.codItem%TYPE) 
RETURN Orcamento.preco%TYPE 
AS
V_preco Orcamento.preco%TYPE;
 
  BEGIN
    SELECT o.preco INTO V_preco
    FROM Orcamento o 
    INNER JOIN Item i
    ON o.codOrcamento = i.codOrcamento
    WHERE coditem = P_codItem;

    RETURN (V_preco * 0.8);
  END Fn_Desconto_Orcamento;
 
SELECT coditem, Fn_ValorOrcamento(coditem) FROM item;


/* c) Registra toda mudança de email do cliente, gravando qual foi essa mudança e quem a fez */
CREATE OR REPLACE TRIGGER Tr_MUDA_EMAIL
AFTER UPDATE OF EMAIL ON CLIENTE
FOR EACH ROW

  BEGIN
    INSERT INTO Tablog VALUES (seqlog.nextval, sysdate, user, 'CLIENTE', :OLD.email, :NEW.email, 'EMAIL');
  END Tr_MUDA_EMAIL;


/* d) Verifica se o prazo escolhido para o pedido é posterior a data do sistema, permitindo assim somente prazos válidos de entrega */
CREATE OR REPLACE TRIGGER Tr_VERIFICA_PRAZO
BEFORE UPDATE OF prazo_entrega OR INSERT ON PEDIDO
FOR EACH ROW

  BEGIN
    IF :NEW.prazo_entrega <= (SYSDATE) THEN
      raise_application_error(-20600, 'Prazo de Entrega não permitido. Escolha uma data posterior a hoje. HOJE: ' || sysdate || '; PRAZO ESCOLHIDO: ' || :NEW.prazo_entrega);
    END IF;
  END Tr_VERIFICA_PRAZO;
