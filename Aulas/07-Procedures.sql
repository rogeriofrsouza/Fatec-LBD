-- aula do dia 22-09 PL/SQL
-- Procedimentos no Oracle

DROP TABLE tab_erro;

CREATE TABLE tab_erro ( 
  dataerro DATE,
  mensagem VARCHAR2(50)
);

-------
DECLARE
  V_preco NUMBER(5);

BEGIN
  SELECT valor_unit INTO V_preco
  FROM tb_produto WHERE codproduto = 99;
	
  IF v_preco IS NULL THEN 
	  UPDATE tb_produto
	  SET valor_unit = 100.00 
	  WHERE codproduto = 99;
	END IF ;
  COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tab_erro VALUES(SYSDATE, 'Produto não encontrado');*
END; 
-------

-- ajustando a base de dados para teste, inserir um produto com valor unitario = NULL

INSERT INTO tb_produto VALUES(25, 'mouse gamer', 'UN', NULL);

SELECT * FROM tb_produto;

/*
  Testar das 3 formas a seguir:
  1 - Testar com produto que exista mas o valor_unit seja = NULL
  2 - Testar com um produto que não exista (checar se gravou na tab_erro)
  3 - Testar com um produto que não exista mas comentando o EXCEPTION
*/
SELECT * FROM tab_erro;

SELECT valor_unit, descricao
FROM tb_produto WHERE cod_produto = 15;
 
-- transformando em Stored PROCEDURE

-----------------
CREATE OR REPLACE PROCEDURE SP_AtualizaPreco(Pcod_produto NUMBER) IS
  V_preco NUMBER(7, 2);

  BEGIN
    SELECT valor_unit INTO V_preco
    FROM tb_produto WHERE cod_produto = Pcod_produto;
    
    IF v_preco IS NULL THEN
      UPDATE tb_produto
      SET valor_unit = 100.00 
      WHERE cod_produto = Pcod_produto;
    END IF;
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Produto não encontrado: '||pcod_produto);
  END;
-----------------

EXEC SP_AtualizaPreco(88);

-- preparando a base de dados para teste

UPDATE tb_produto
SET valor_unit = NULL
WHERE codproduto = 25;

EXEC SP_AtualizaPreco(25);

SELECT * FROM tab_erro;
SELECT * FROM tb_produto

SELECT object_name FROM user_objects 
WHERE object_type = 'PROCEDURE';

/*
  1. Criar o campo pco_unit NUMBER(6,2) na tabela de item pedido.

  Escreva uma stored PROCEDURE para inserir um item de pedido. 
  Esta deve receber como parametro o numero do pedido, codproduto e a quantidade. 
  O preço unitario deve ser obtido atraves da tabela produto.

  Para testar: 
  EXEC atualiza_preco(100,15,3)
  SELECT * FROM tb_item_pedido;

  Mais exercícios na Lista de Procedures!!!!
*/
-----------------
CREATE OR REPLACE PROCEDURE SP_InsereItem(Pnum_pedido NUMBER, Pcod_produto NUMBER, Pqtde NUMBER) IS
  Vpreco NUMBER(6,2);

  BEGIN
    SELECT valor_unitario INTO Vpreco 
    FROM tb_produto
    WHERE cod_produto = Pcod_produto;
  
    INSERT INTO tb_item_pedido VALUES(Pnum_pedido, Pcod_produto, Pqtde, Vpreco);
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Produto inexistente: ' ||pcod_produto);
  END;
-----------------

-- SHOW ERRORS

SELECT * FROM tb_item_pedido ORDER BY num_pedido;

EXEC SP_InsereItem(7, 43, 10);
EXEC SP_InsereItem(7, 99, 10)

SELECT * FROM tb_erro;
