CREATE TABLE logteste (
  nrlog NUMBER PRIMARY KEY, 
  Dttrans DATE NOT NULL,  
  Usuario VARCHAR2(20) NOT NULL,  
  Tabela VARCHAR2(30), 
  Opera CHAR(1) CHECK(opera IN('I', 'A', 'E')), 
  Linhas NUMBER(5) NOT NULL CHECK(linhas >= 0)
);

CREATE SEQUENCE seqlog;

INSERT INTO tb_produto VALUES(6, 'Caneta', 'CX', 5.00, 30);

----------------------------------------
CREATE OR REPLACE TRIGGER Tr_EliminaProduto
BEFORE DELETE ON tb_produto 
FOR EACH ROW 

  BEGIN
    INSERT INTO logteste VALUES(seqlog.nextval, SYSDATE, user, 'produto', 'E', 1); 
  END EliminaProduto; 
----------------------------------------

DELETE FROM tb_produto WHERE cod_produto = 6;

SELECT * FROM logteste;


/* 
  Exemplo 2: Este gatilho não permite que os usuários atualizem ou eliminem registros de pacientes 
  antes das 7:00 da manhã e depois das 14:00
*/ 
CREATE OR REPLACE TRIGGER Tr_ChecaHora 
BEFORE UPDATE OR DELETE ON paciente 

  BEGIN 
    IF TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) NOT BETWEEN 7 AND 9 THEN 
      raise_application_error(-20400, 'Alterações não permitidas'); 
    END IF; 
  END ChecaHora;
---------------------------------------

SELECT * FROM tb_paciente;

UPDATE paciente 
SET nome_paciente = 'xxx' 
WHERE cod_paciente = 4;


-- Exemplo 3 - igual ao exemplo 2 porém identificando se o usuário tentou fazer UPDATE ou DELETE. 
CREATE OR REPLACE TRIGGER Tr_ChecaHora2
BEFORE UPDATE OR DELETE ON paciente 

  BEGIN 
    IF TO_CHAR(SYSDATE, 'HH24') not between 7 AND 9 THEN 
      IF updating THEN	 
        raise_application_error(-20400, 'UPDATE não permitido'); 
      ELSIF deleting THEN
        raise_application_error(-20410,'Delete não permitido'); 
      END IF;
    END IF;
  END ChecaHora2;
---------------------------------------

CREATE OR REPLACE TRIGGER Tr_TrocaData 
BEFORE INSERT ON Tb_pedido 
FOR EACH ROW 

  BEGIN 
    :NEW.prazo_entrega := SYSDATE + 15; 
  END; 
---------------------------------------

INSERT INTO tb_pedido VALUES (999, '30/10/2021', 31, 15);

SELECT * FROM tb_pedido;

/* 1. Alterar o trigger elimina_produto para gravar o codigo do produto que foi excluido. */

-- inserindo um novo produto para teste 
INSERT INTO tb_produto VALUES(6,'Caneta','UN', 5.00, 40);

---------------------------------------
CREATE OR REPLACE TRIGGER Tr_EliminaProduto
BEFORE DELETE ON tb_produto 
FOR EACH ROW 

  BEGIN
    INSERT INTO logteste VALUES(seqlog.nextval, SYSDATE, user, 'produto '||:OLD.cod_produto, 'E', 1);
  END EliminaProduto;
---------------------------------------

DELETE FROM tb_produto
WHERE cod_produto = 6;

SELECT * FROM logteste;


/*
  2. Escreva um trigger que ao alterar o prazo de entrega de um pedido. 
  Grave na tablog o prazo antigo, prazo novo e o nome do cliente. 
*/
CREATE SEQUENCE seqtablog; 

CREATE TABLE tablog2 ( 
  numLog NUMBER PRIMARY KEY, 
  datalog DATE, 
  usuario VARCHAR2(15), 
  tabela VARCHAR2(15), 
  oldcampo VARCHAR2(50), 
  newcampo VARCHAR2(50), 
  campo1 VARCHAR2(30)
);

----------------------------------------
CREATE OR REPLACE TRIGGER Tr_AlteraPrazo
BEFORE UPDATE of prazo_entrega ON tb_pedido
FOR EACH ROW

  DECLARE
  v_nomecli tb_cliente.nome_cliente%TYPE;

  BEGIN
    SELECT nome_cliente into v_nomecli
    FROM tb_cliente WHERE cod_cliente = :NEW.cod_cliente;

    INSERT INTO tablog2 VALUES(seqtablog.nextval, SYSDATE, user, 'pedido', :OLD.prazo_entrega, :NEW.prazo_entrega, v_nomecli);
  END;
----------------------------------------

SELECT * FROM tb_pedido;

UPDATE tb_pedido
SET prazo_entrega = SYSDATE
WHERE num_pedido = 7;

SELECT * FROM tablog;
