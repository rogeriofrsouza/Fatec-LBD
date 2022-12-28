-- aula do dia 15-09-2022

-- Junção:
SELECT * FROM tb_produto;
SELECT * FROM tb_item_pedido;
SELECT * FROM tb_cliente;
SELECT * FROM tb_pedido;

UPDATE tb_cliente
SET cidade = 'São Paulo'
WHERE cod_cliente = 30;

UPDATE tb_cliente
SET cidade = 'Sorocaba'
WHERE cod_cliente = 31;

/* 1.	Listar o código e o nome dos vendedores que efetuaram vendas para o cliente com código 10. */
SELECT v.cod_vendedor, v.nome_vendedor
FROM tb_vendedor v
INNER JOIN tb_pedido p
ON v.cod_vendedor = p.cod_vendedor
WHERE p.cod_cliente = 32;


/* 2.	Listar o número do pedido, prazo de entrega, a quantidade e a descrição do produto com código 100. */
SELECT ped.num_pedido, ped.prazo_entrega, item.quantidade, prod.descricao
FROM tb_pedido ped
INNER JOIN tb_item_pedido item
ON ped.num_pedido = item.num_pedido
INNER JOIN tb_produto prod
ON prod.cod_produto = item.cod_produto
WHERE prod.cod_produto = 11;


/* 3.	Quais os vendedores (código e nome) fizeram pedidos para o cliente 'João da Silva'. */
SELECT v.cod_vendedor, v.nome_vendedor
FROM tb_vendedor v
INNER JOIN tb_pedido p
ON v.cod_vendedor = p.cod_vendedor
INNER JOIN tb_cliente c
ON p.cod_cliente = c.cod_cliente
WHERE c.nome_cliente = 'João da Silva';


/* 4.	Listar o número do pedido, o código do produto, a descrição do produto, o código do vendedor, o nome do vendedor e o nome do cliente, para todos os clientes que moram em Sorocaba. */
SELECT ped.num_pedido, prod.cod_produto, prod.descricao, vend.cod_vendedor, vend.nome_vendedor, cli.nome_cliente
FROM tb_pedido ped
INNER JOIN tb_item_pedido item
ON ped.num_pedido = item.num_pedido
INNER JOIN tb_produto prod
ON item.cod_produto = prod.cod_produto
INNER JOIN tb_vendedor vend
ON ped.cod_vendedor = vend.cod_vendedor
INNER JOIN tb_cliente cli
ON ped.cod_cliente = cli.cod_cliente
WHERE cli.cidade = 'Sorocaba';

------------------------------------

-- Subconsultas:
SELECT * FROM tb_produto;
SELECT * FROM tb_item_pedido;
SELECT * FROM tb_cliente;
SELECT * FROM tb_pedido;
SELECT * FROM tb_vendedor;

INSERT INTO tb_cliente VALUES(33, 'Maria da Silva', 'Rua Primavera, 25', 'Sorocaba', '89231-046', 'SP');
INSERT INTO tb_cliente VALUES(34, 'Gustavo Henrique Pereira', 'Rua João Antunes Matos, 97', 'São Paulo', '18155-636', 'SP');
INSERT INTO tb_cliente VALUES(35, 'Zé do Hamburger', 'Rua Barão, 640', 'São Paulo', '19728-014', 'SP');

/* 1.	Listar todos os clientes que moram na mesma cidade que 'João da Silva'. */
SELECT cod_cliente, nome_cliente 
FROM tb_cliente
WHERE nome_cliente <> 'João da Silva' 
AND cidade = (SELECT cidade FROM tb_cliente 
              WHERE nome_cliente = 'João da Silva');


/* 2.	Quais produtos tem valor unitário maior que a média. */
SELECT cod_produto, descricao 
FROM tb_produto
WHERE valor_unitario > (SELECT AVG(valor_unitario) AS media
                        FROM tb_produto);


/* 3.	Quais os clientes que só compraram com o vendedor de codigo 5 e com mais nenhum outro vendedor (fidelidade). */
SELECT c.cod_cliente, c.nome_cliente 
FROM tb_cliente c
INNER JOIN tb_pedido p
ON c.cod_cliente = p.cod_cliente
WHERE p.cod_vendedor = 5 
AND c.cod_cliente NOT IN (SELECT cod_cliente FROM tb_pedido 
                          WHERE cod_vendedor <> 5);

SELECT cod_cliente, nome_cliente 
FROM tb_cliente
WHERE cod_cliente IN (SELECT cod_cliente FROM tb_pedido
                      WHERE cod_vendedor = 5
                      MINUS
                      SELECT cod_cliente FROM tb_pedido
                      WHERE cod_vendedor <> 5);


/* 4.	Quais vendedores não fizeram maior ou igual a 2 pedidos. */
SELECT * FROM tb_vendedor
WHERE cod_vendedor NOT IN (SELECT cod_vendedor FROM tb_pedido 
                           GROUP BY cod_vendedor
                           HAVING COUNT(*) >= 2);

-- Não inclui o vendedor que nunca fez pedido
SELECT cod_vendedor, COUNT(*) AS qtde_pedidos
FROM tb_pedido
GROUP BY cod_vendedor
HAVING COUNT(*) < 2;


/* 5.	Quais os vendedores que não fizeram nenhum pedido no mês de maio/2020 */
SELECT cod_vendedor, nome_vendedor FROM tb_vendedor
WHERE cod_vendedor NOT IN (SELECT cod_vendedor FROM tb_pedido
                           WHERE prazo_entrega BETWEEN '01-05-2020' AND '31-05-2020');


/* 6. Listar o nome do vendedor que mais fez pedidos. */
SELECT p.cod_vendedor, v.nome_vendedor, COUNT(*)
FROM tb_pedido p
INNER JOIN tb_vendedor v
ON p.cod_vendedor = v.cod_vendedor
GROUP BY p.cod_vendedor, v.nome_vendedor 
ORDER BY COUNT(*) DESC;

-- Desnecessário, muito complexo
SELECT v.cod_vendedor, v.nome_vendedor, COUNT(*) 
FROM tb_pedido p
INNER JOIN tb_vendedor v
ON p.cod_vendedor = v.cod_vendedor
GROUP BY v.cod_vendedor, v.nome_vendedor
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM tb_pedido 
                   GROUP BY cod_vendedor);


/* 7- Listar o nome dos clientes e o número total de pedidos associados a cada cliente em ordem decrescente de vendas, 
isto é, do cliente que mais tem pedidos para o que menos tem. */
SELECT p.cod_cliente, c.nome_cliente, COUNT(*) AS total
FROM tb_pedido p
INNER JOIN tb_cliente c
ON p.cod_cliente = c.cod_cliente
GROUP BY p.cod_cliente, c.nome_cliente
ORDER BY total DESC;


/* 8.	Excluir todos os itens dos pedidos feitos pelo cliente de código 31 */
DELETE FROM tb_item_pedido
WHERE num_pedido IN (SELECT num_pedido FROM tb_pedido 
                     WHERE cod_cliente = 31);

rollback;


/* 9.	Alterar o valor unitário de todos os produtos sem vendas no ano de 2020 para menos 20%. */
UPDATE tb_produto
SET valor_unitario = valor_unitario * 0.8
WHERE cod_produto NOT IN (SELECT item.cod_produto FROM tb_item_pedido item 
                          INNER JOIN tb_pedido ped
                          ON item.num_pedido = ped.num_pedido
                          WHERE ped.prazo_entrega BETWEEN '01-01-2020' AND '31-12-2020');
