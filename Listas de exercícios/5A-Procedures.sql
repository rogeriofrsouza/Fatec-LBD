/* Criar IS tabelas abaixo que serão usadas nos exercícios a seguir: */
CREATE TABLE tablog (
  datalog DATE,
  campo1 VARCHAR2(60),
  campo2 VARCHAR2(60)
);

CREATE TABLE tab_erro ( 
  dataerro DATE,
  mensagem VARCHAR2(50)
);

/* 
  1-	Crie um procedimento de nome SP_Atraso que receba como parâmetro o número de um pedido. 
  Obter o prazo de entrega deste pedido. Se o prazo de entrega for anterior a data atual(SYSDATE), 
  obter o nome do vendedor deste pedido e gravar uma linha na TabLog com:

  Em datalog gravar o Prazo de entrega
  Em campo 1 gravar o Nome do vendedor
  Em campo 2 gravar a mensagem 'Pedido em atraso. O vendedor deve avisar ao cliente'
  Utilizar EXCEPTION para controlar erros associados ao SELECT. 
  Em caso de erro gravar na tabela Tab_erro o número do pedido concatenado com a mensagem de erro 'Número do Pedido inexistente'.
*/
SELECT * FROM tb_pedido;

UPDATE tb_pedido
SET prazo_entrega = SYSDATE + 80
WHERE num_pedido IN (7, 8);

-----------------
CREATE OR REPLACE PROCEDURE SP_Atraso(Pnum_pedido NUMBER) IS
  Vprazo_entrega DATE;
  Vnome_vendedor VARCHAR2(30);
  
  BEGIN
    /* obtendo o prazo de entrega */
    SELECT prazo_entrega INTO Vprazo_entrega
    FROM tb_pedido 
    WHERE num_pedido = Pnum_pedido;
    
    /* checando se prazo atrasado */
    IF Vprazo_entrega < SYSDATE THEN
      SELECT nome_vendedor INTO Vnome_vendedor
      FROM tb_vendedor
      WHERE cod_vendedor = (SELECT cod_vendedor FROM tb_pedido
                            WHERE num_pedido = Pnum_pedido);
      
      /* inserindo log */
      INSERT INTO tablog VALUES(Vprazo_entrega, Vnome_vendedor, 'Pedido em atraso. O vendedor deve avisar ao cliente');
    END IF;
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tab_erro VALUES(SYSDATE, 'Número de pedido inexistente: ' ||Pnum_pedido);
  END;
-----------------

EXECUTE SP_Atraso(10);
SELECT * FROM tablog;


/*
  2- Escreva uma Stored PROCEDURE de nome SP_ClientePremium que receba como parâmetro o código de um cliente. 
  Se este possuir mais que 2 pedidos com prazo de entrega nos próximos 2 meses. Gravar na tabela TABLOG:

  Em datalog gravar a data do sistema 
  Em campo1 gravar a mensagem 'Cliente especial - enviar brinde'
  Em campo2 gravar o código do cliente concatenado com o nome do cliente
  Fazer o tratamento de exceções. 
*/
SELECT * FROM tb_pedido;

UPDATE tb_pedido
SET prazo_entrega = SYSDATE + 50
WHERE num_pedido IN (7, 8);

INSERT INTO tb_pedido VALUES(11, '09/12/22', 31, 15);
INSERT INTO tb_pedido VALUES(12, '09/12/22', 31, 25);

-----------------
CREATE OR REPLACE PROCEDURE SP_ClientePremium(Pcod_cliente NUMBER) IS
  Vqtde_pedidos NUMBER;
  Vnome_cliente VARCHAR2(30);
  
  BEGIN
    /* verificando quantidade de pedidos */
    SELECT COUNT(*) INTO Vqtde_pedidos
    FROM tb_pedido
    WHERE cod_cliente = Pcod_cliente
    AND prazo_entrega BETWEEN SYSDATE AND SYSDATE + 60;
    
    /* selecionando cliente com mais de 2 pedidos */
    IF Vqtde_pedidos > 2 THEN
      SELECT nome_cliente INTO Vnome_cliente
      FROM tb_cliente
      WHERE cod_cliente = Pcod_cliente;
      
      /* inserindo dados de log */
      INSERT INTO tablog VALUES(SYSDATE, 'Cliente especial - enviar brinde', Vnome_cliente ||Pcod_cliente);
    END IF;
    
    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tab_erro VALUES(SYSDATE, 'Código de cliente inexistente ' ||Pcod_cliente);
  END;
-----------------

SELECT * FROM tb_cliente;
EXECUTE SP_ClientePremium(31);
SELECT * FROM tablog;
