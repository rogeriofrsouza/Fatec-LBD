-- Aula do dia 08-09-2022
-- Continuação subconsultas

SELECT * FROM tb_vendedor;
SELECT * FROM tb_pedido;
SELECT * FROM tb_cliente;

-- Listar o codigo dos  vendedores que fizeram  mais pedidos que o vendedor de nome 'Carlos Sola'
SELECT p.cod_vendedor, v.nome_vendedor, COUNT(*) AS pedidos
FROM tb_pedido p, tb_vendedor v
WHERE p.cod_vendedor = v.cod_vendedor
GROUP BY p.cod_vendedor, v.nome_vendedor
HAVING COUNT(*) > (SELECT COUNT(*) 
                   FROM tb_pedido p, tb_vendedor v
                   WHERE p.cod_vendedor = v.cod_vendedor
                   AND nome_vendedor = 'Carlos Sola');

---------------------------------------------------------------

-- Operador EXISTS  -  executa a consulta externa se a interna for Verdadeira

-- Exemplo 1: listar o nome dos clientes que tem pedidos

-- Comparação Usando IN
SELECT nome_cliente FROM tb_cliente
WHERE cod_cliente IN (SELECT cod_cliente FROM tb_pedido);

-- usando EXISTS  - comando incorreto
SELECT nome_cliente FROM tb_cliente
WHERE EXISTS (SELECT cod_cliente FROM tb_pedido);
                  
-- EXISTS -- comando correto
SELECT nome_cliente FROM tb_cliente
WHERE EXISTS (SELECT 'a' FROM tb_pedido 
              WHERE tb_cliente.cod_cliente = tb_pedido.cod_cliente);

SELECT * FROM tb_cliente;


-- Exemplo 2: Listar o nome dos clientes que não tem pedidos
NOT EXISTS   --  executa a consulta externa se a interna for FALSO
   
-- usando NOT IN
SELECT nome_cliente FROM tb_cliente
WHERE cod_cliente NOT IN (SELECT cod_cliente FROM tb_pedido);

-- usando NOT EXISTS
SELECT nome_cliente FROM tb_cliente
WHERE NOT EXISTS (SELECT cod_cliente FROM tb_pedido 
                  WHERE tb_cliente.cod_cliente = tb_pedido.cod_cliente);               
                  
-- Exercício: Exibir a frase "não existem pedidos para o cliente 33", se isso for verdade.
SELECT 'oieee' FROM dual;

SELECT 'Não existem pedidos para o cliente 33' AS mensagem FROM dual
WHERE NOT EXISTS (SELECT cod_cliente FROM tb_pedido 
                  WHERE cod_cliente = 33);


-- Usando subconsultas com UPDATE e DELETE

-- EX4: Excluir o cliente que não tem pedidos.
BEGIN
  DELETE FROM tb_cliente
  WHERE cod_cliente NOT IN (SELECT cod_cliente FROM tb_pedido);
END;

SELECT * FROM tb_cliente;

rollback;

DELETE FROM tb_cliente
WHERE NOT EXISTS (SELECT p.cod_cliente 
                  FROM tb_pedido p, tb_cliente c
                  WHERE p.cod_cliente = c.cod_cliente);


-- Ex5: Alterar em menos 20%, o preço dos produtos que não tem pedidos
UPDATE tb_produto
SET valor_unitario = valor_unitario * 0.80
WHERE cod_produto NOT IN (SELECT cod_produto FROM tb_item_pedido);

rollback;

UPDATE produto
SET valor_unitario = valor_unitario * 0.80
WHERE NOT EXISTS (SELECT 1 FROM item_pedido 
                  WHERE item_pedido.cod_produto = produto.cod_produto);

-- ex6 com insert
INSERT INTO cliente_bkp
SELECT FROM tb_cliente WHERE cidade = 'Sorocaba'

-- a tabela cliente _bkp tem que já existir

--=================================================
-- criando uma tabela a partir de outra

CREATE TABLE cliente_bkp
AS SELECT * FROM tb_cliente;

SELECT * FROM cliente_bkp;

CREATE TABLE cliente_bkp2
AS SELECT * FROM tb_cliente WHERE cod_cliente = 9999999;

SELECT * FROM cliente_bkp2;

DROP TABLE cliente_bkp;

CREATE TABLE cliente_bkp
AS SELECT cod_cliente, nome_cliente, cidade FROM tb_cliente;

--===================================================

CREATE TABLE cliente_bkp
AS SELECT * FROM cliente WHERE cod_cliente IS NULL;
