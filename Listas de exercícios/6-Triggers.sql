/* 
  1. Sobre o modelo do item_pedido, escreva um trigger que ao inserir um item do pedido 
  verifique se o cliente já possui mais de 2 pedidos com entrega no mês atual.
  Se sim, aplicar um desconto de 15% ao preço do item que está sendo cadastrado.
*/
SELECT * FROM tb_item_pedido;
SELECT * FROM tb_pedido;
SELECT * FROM tb_produto;

ALTER TABLE tb_item_pedido ADD pco_unit NUMBER(6, 2);

-------------------------------------
CREATE OR REPLACE TRIGGER tr_Insere_Item
BEFORE INSERT ON tb_item_pedido
FOR EACH ROW

  DECLARE
    vcliente tb_cliente.cod_cliente%TYPE;
    vtotal NUMBER;

  BEGIN
    /* descobrindo o cliente */
    SELECT cod_cliente INTO vcliente
    FROM tb_pedido
    WHERE num_pedido = :NEW.num_pedido;

    /* contando quantos pedidos o cliente tem */
    SELECT COUNT(*) INTO vtotal 
    FROM tb_pedido
    WHERE cod_cliente = vcliente;
    /* and EXTRACT(MONTH FROM prazo_entrega) = EXTRACT(MONTH FROM SYSDATE); */

    /* aplicando o desconto */
    IF (vtotal > 2) THEN
      :NEW.pco_unit := :NEW.pco_unit * 0.85;
    END IF;
  END;
------------------------------------------

INSERT INTO tb_item_pedido VALUES(11, 40, 1, 100.00);
SELECT * FROM tb_item_pedido;


/*
  2. Crie um trigger que ao ser alterado o campo endereço da tabela de cliente, 
  faça a inserção de uma linha na tabela de log com a mensagem:
  "Observar mudança de endereço" <codigo do cliente> <endereço velho><endereço novo>  Tablog (datalog,campo1,campo2)
*/
CREATE OR REPLACE TRIGGER tr_alteraEndereco
BEFORE UPDATE OF endereco ON tb_cliente
FOR EACH ROW

  BEGIN
    INSERT INTO tablog2 VALUES(seqlog.nextval, SYSDATE, user, 'cliente', 
                              :OLD.endereco, :NEW.endereco, 'Observar mudança de endereço '||:NEW.cod_cliente);
  END;
--------------------------------------

UPDATE tb_cliente
SET endereco = 'Rua Nova, 31'
WHERE cod_cliente = 37;

SELECT * FROM tb_cliente;
SELECT * FROM tablog2;
