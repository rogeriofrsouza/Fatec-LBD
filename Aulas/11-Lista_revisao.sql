-- aula do dia 03-11-2022

/* 7. Listar todos os atributos dos funcionário admitidos no ano passado (não fixar 2022) */
SELECT * FROM tb_funcionario
WHERE TO_CHAR(dataadmissao, 'yyyy') = TO_CHAR(SYSDATE, 'yyyy') - 1;

SELECT * FROM tb_funcionario
WHERE EXTRACT(YEAR FROM dataadmissao) = EXTRACT(YEAR FROM SYSDATE) - 1;


/* 11. Listar o código do projeto com mais de 2 funcionarios alocados */
SELECT * FROM tb_funcproj;

SELECT cod_projeto, COUNT(*) 
FROM tb_funcproj
GROUP BY cod_projeto
HAVING COUNT(*) > 2;

/* extra: listar o codigo do projeto, a descricao do projeto e a qtde para os projetos com mais de 2 funcionários alocados */
SELECT fp.cod_projeto, p.descricao, COUNT(*) 
FROM tb_funcproj fp
INNER JOIN tb_projeto p
ON fp.cod_projeto = p.cod_projeto
GROUP BY fp.cod_projeto, p.descricao
HAVING COUNT(*) > 2;


/* 
  8. Listar todas AS colunas da tabela TB_FuncProj onde a coluna Bonus_salario for diferente de zero, 
  e tempo_alocacao maior que 3, ordenado pela coluna TempoAlocacaoo 
*/
SELECT * FROM tb_funcproj
WHERE bonus_salario <> 0 AND tempoalocacao > 2
ORDER BY tempoalocacao;

SELECT * FROM tb_funcproj;

------------------------------------------------------------------------------------------------------

-- Continuação ao estudo de procedures
SELECT * FROM tb_pedido WHERE numpedido = 99;

DELETE FROM tb_pedido WHERE numpedido = 99;

CREATE OR REPLACE PROCEDURE SP_Excluir_Cliente(P_codCliente NUMBER) AS
  BEGIN
    INSERT INTO tab_erro VALUES(SYSDATE, '1-Pedido de exclusão do cliente '||P_codCliente);

    DELETE FROM TB_cliente
    WHERE cod_cliente = P_codCliente;

    IF SQL%rowcount = 0 THEN
      INSERT INTO tab_erro VALUES(SYSDATE, '2-Cliente a ser excluído não existe '||P_codCliente); 
    ELSE
      INSERT INTO tab_erro VALUES(SYSDATE, '3- Cliente excluído com sucesso '||P_codCliente);
    END IF;
    COMMIT;
  END;

-- testar com cliente que não existe
EXEC excluir_cliente(99);
 
SELECT * FROM tab_erro;
 
-- testar com cliente que existe mas não tem pedido
SELECT * FROM Tb_cliente
SELECT * FROM tb_pedido

-- preparando a base de dados para os testes: incluindo cliente sem pedidos
 
INSERT INTO tb_cliente VALUES(40,'Maria','Rua x','Sorocaba', '12222-1','SP');

EXEC excluir_cliente(40);
 
SELECT * FROM tab_erro;

EXEC excluir_cliente(31);
 
 
/*
  Exemplo 3: Procedure excluir_cliente alterada para tratar a integridade referencial. 
  Excluir um cliente mas antes testar se não existem pedidos para ele.

  Foram incluindos alguns inserts na tab_erro apenas para rastrear o fluxo de execução realizado pelo SGBD, para efeito didático.
*/
ALTER TABLE tab_erro MODIFY mensagem VARCHAR2(100);

CREATE OR REPLACE PROCEDURE excluir_cliente_FK(pcodcli NUMBER) AS
  vtotal NUMBER;
  vcod tb_cliente.cod_cliente%TYPE;

  BEGIN
    INSERT INTO tab_erro VALUES(SYSDATE, '1-Pedido de exclusão do cliente '|| pcodcli);

    SELECT codcliente INTO vcod 
    FROM tb_cliente WHERE codcliente = pcodcli;

    SELECT COUNT(*) INTO vtotal 
    FROM tb_pedido WHERE codcliente = pcodcli;

    IF vtotal > 0 THEN
      INSERT INTO tab_erro VALUES(SYSDATE, '4- Cliente possui pedido, não pode ser excluído '|| pcodcli);
    ELSE
      DELETE FROM TB_cliente
      WHERE codcliente = pcodcli;

      INSERT INTO tab_erro VALUES(SYSDATE, '3- Cliente excluído com sucesso '|| pcodcli);
    END IF;
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tab_erro VALUES(SYSDATE, '2-Cliente a ser excluído não existe' || pcodcli); 
    -- rollback;
  END;

-- Testando
EXEC excluir_cliente_FK(31);  -- testar com cliente que existe e tem pedidos e verificar na tabela de erros se o resultado é o esperado.

SELECT * FROM tab_erro;

EXEC excluir_cliente_FK(99);  -- testar com cliente que nãO existe 

SELECT * FROM tab_erro;

INSERT INTO tb_cliente VALUES(40, 'Maria', 'Rua x', 'Sorocaba', '12222-1', 'SP');

EXEC excluir_cliente_FK(40);  -- testar com cliente que existe, mas não tem pedidos

SELECT * FROM tab_erro;
