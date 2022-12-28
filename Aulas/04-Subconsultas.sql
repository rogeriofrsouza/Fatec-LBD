-- Aula do dia 01-09-22 Diurno
/*
 * Subconsultas
 * ============
 *
 * Uma subquery ou subconsulta é quando o resultado de uma consulta é utilizado por
 * outra consulta, de forma encadeada e contida no mesmo comando SQL.
 *
 * Restrições:
 *
 * - A query interna deve ser usada dentro de parênteses
 * - A subquery não pode conter a cláusula order by
 * - Quando utilizando múltiplas colunas em uma subquery, estas colunas devem aparecer na mesma ordem 
 * e com os mesmos tipos de dados da query principal, além do mesmo número de colunas
 * - Podem ser utilizados operadores lógicos
 */
SELECT ...... FROM ....
WHERE a = (SELECT a FROM ...
           WHERE....);

-------------------------------------------
SELECT * FROM tb_produto;
SELECT * FROM tb_vendedor;
SELECT * FROM tb_cliente;
SELECT * FROM tb_pedido;
SELECT * FROM tb_item_pedido;
 
-- Exemplo1: Listar a descrição do produto que tem o preço unitário maior que a média.
SELECT descricao FROM tb_produto
WHERE valor_unitario > (SELECT AVG(valor_unitario) FROM tb_produto);


-- Exemplo2: Listar o nome dos clientes que moram na mesma cidade do 'João da Silva';
SELECT nome_cliente FROM tb_cliente
WHERE nome_cliente <> 'João da Silva'  
AND cidade = (SELECT cidade FROM tb_cliente 
              WHERE nome_cliente = 'João da Silva');

INSERT INTO tb_cliente VALUES(36, 'Ana da Silva', 'AV. MATT HOFFMANN, 1100', 'São Paulo', '97056-001', 'SP');


-- Exemplo 3: Listar o nome dos clientes que tem pedidos
-- usando subconsulta:
SELECT nome_cliente FROM tb_cliente
WHERE cod_cliente IN (SELECT cod_cliente FROM tb_pedido);

-- usando junção (mais indicado neste caso pq utilizará os índices)
SELECT DISTINCT nome_cliente 
FROM tb_cliente 
INNER JOIN tb_pedido
ON tb_cliente.cod_cliente = tb_pedido.cod_cliente;

SELECT cod_cliente FROM tb_cliente
INTERSECT 
SELECT cod_cliente FROM tb_pedido;

-- Exemplo 4: Listar o nome dos clientes que não tem pedidos
SELECT cod_cliente, nome_cliente FROM tb_cliente
WHERE cod_cliente NOT IN (SELECT cod_cliente FROM tb_pedido);

SELECT cod_cliente FROM tb_cliente
MINUS
SELECT cod_cliente FROM tb_pedido;

SELECT tb_cliente.cod_cliente, nome_cliente, num_pedido
FROM tb_cliente 
LEFT JOIN tb_pedido
ON tb_cliente.cod_cliente = tb_pedido.cod_cliente
WHERE num_pedido IS NULL;


-- Exemplo 5: Listar o nome do vendedor que não tem pedidos com prazo de entrega em fevereiro/2020.
SELECT tb_vendedor.cod_vendedor, nome_vendedor
FROM tb_vendedor, tb_pedido
WHERE tb_pedido.cod_vendedor = tb_vendedor.cod_vendedor 
AND TO_CHAR(prazo_entrega, 'mm/yyyy') <> '02/2020';

SELECT * FROM tb_vendedor;
SELECT * FROM tb_pedido;

SELECT cod_vendedor, nome_vendedor FROM tb_vendedor
WHERE cod_vendedor NOT IN (SELECT cod_vendedor FROM tb_pedido
                           WHERE TO_CHAR(prazo_entrega,'mm/yyyy') = '02/2020');

-- Para casa verificar lista03

-- Para se filtrar 08 de 2020 podemos usar:
WHERE to_char(prazo_entrega,'mm/yyyy') = '08/2020'

WHERE prazo_entrega BETWEEN '01/08/2020' AND '31/08/2020'

YEAR(prazo_entrega) = 2020 AND MONTH(prazo_entrega) = 08;  --sql server

EXTRACT(YEAR FROM prazo_entrega) = 2020 AND EXTRACT (MONTH FROM prazo_entrega);


-- Exemplo 6: Listar o código do produto que tem o menor preço.
--============================================================
SELECT MIN(valor_unitario), cod_produto FROM produto;  -- Errado não funciona

SELECT cod_produto, valor_unitario FROM produto
WHERE valor_unitario = (SELECT MIN(valor_unitario) FROM produto); 
