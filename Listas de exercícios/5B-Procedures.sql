/* 
  1. Crie uma stored procedure que calcule o percentual de comissão para um vendedor cujo código é passado como parâmetro e realize:

  a) Encontre a somatória do valor de todos os pedidos por vendedor.
  b) Se a somatória for:
    > 0 e < 100.00 atribua a este vendedor um percentual de comissão de 10%
    >=100.00 e <=1.000,00 atribua um percentual de 15%
    > 1.000,00 atribua um percentual de 20%.
  c) Se o vendedor não tiver nenhum pedido (=0) atribua um percentual de 0% e atualizar este percentual na tabela de vendedor.
  Fazer o tratamento de erros.
*/
CREATE OR REPLACE PROCEDURE SP_Calcula_Comissao(Pcod_vendedor NUMBER) IS
  Vpedidos NUMBER(2);
  Vsoma NUMBER(6, 2);
  Vcomissao NUMBER(4, 2);
  
  BEGIN
    /* encontrando número de pedidos do vendedor */
    SELECT COUNT(cod_vendedor) INTO Vpedidos
    FROM tb_pedido p
    WHERE p.cod_vendedor = Pcod_vendedor;
    
    IF Vpedidos = 0 THEN
      Vcomissao := 0;
    ELSE
      /* somatória do valor de todos os pedidos do vendedor */
      SELECT SUM(ip.quantidade * prod.valor_unitario) INTO Vsoma
      FROM tb_item_pedido ip
      INNER JOIN tb_produto prod
      ON ip.cod_produto = prod.cod_produto
      INNER JOIN tb_pedido ped
      ON ip.num_pedido = ped.num_pedido
      WHERE ped.cod_vendedor = Pcod_vendedor
      GROUP BY ped.cod_vendedor;
  
      /* atribuindo comissão dependendo do somatório */
      IF Vsoma > 0 AND Vsoma < 100.00 THEN
        Vcomissao := 10;
      ELSIF Vsoma BETWEEN 100.00 AND 1000.00 THEN
        Vcomissao := 15;
      ELSIF Vsoma > 1000.00 THEN
        Vcomissao := 20;
      END IF;
    END IF;
    
    /* atualizando faixa_comissao na tabela do vendedor */
    UPDATE tb_vendedor
    SET faixa_comissao = Vcomissao
    WHERE cod_vendedor = Pcod_vendedor;

    COMMIT;
  
  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Código de vendedor não existente: '||Pcod_vendedor);
  END;


/* 
  2- Crie um procedimento que receba como parâmetro um código de produto e verifique se existem pedidos para ele.
  Se não existirem pedidos para este produto, excluir o produto da tabela de produto. 
  Antes da exclusão, gravar tabela TabLog com as informações: data da exclusão, código do produto, descrição do produto, id do usuário que excluiu.

  Utilizar exceptions para controlar erros associados ao select caso o codigo do produto não exista.
  Em caso de exception gravar na tabela Tab_erro o código do produto e a mensagem de erro 'Código do produto inexistente'.
*/
CREATE OR REPLACE PROCEDURE SP_Verifica_Pedidos(Pcod_produto NUMBER) IS
  Vpedidos NUMBER(2);
  Vdescricao VARCHAR2(30);

  BEGIN
    /* verificando se existem pedidos */
    SELECT COUNT(*) INTO Vpedidos
    FROM tb_item_pedido
    WHERE cod_produto = Pcod_produto;
    
    IF Vpedidos = 0 THEN
      /* gravando log */
      SELECT descricao INTO Vdescricao
      FROM tb_produto
      WHERE cod_produto = Pcod_produto;
      
      INSERT INTO tb_log VALUES(SYSDATE, 'Código produto: '||Pcod_produto, ''||Vdescricao);
      
      /* excluindo produto da tabela */
      DELETE FROM tb_produto
      WHERE cod_produto = Pcod_produto;
    END IF;

    COMMIT;

  EXCEPTION
    WHEN no_data_found THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Código do produto inexistente: '||Pcod_produto);
  END;


/* 
  3- Usando exceções pré-definidas pelo usuário.
  Crie um procedimento que receba como parâmetro um código de produto e verifique se existem pedidos para ele.
  Se não existirem pedidos, excluir o produto da tabela de produto. 
  Antes da exclusão, gravar uma linha na tabela Tab_erro com as informações: data da exclusão, código do produto, descrição do produto.

  Tratar as exceções da forma:
  Criar uma exceção para tratar o erro em caso solicitação de exclusão de produtos que tenham pedido. Neste caso, emitir mensagem “Erro, produto com pedidos associados” concatenado com o código do produto e encerrar o procedimento.
  Em caso de Produto inexistente, gravar na tabela Tab_Erro a mensagem de erro 'Código do produto inexistente' e o código do produto.
*/
CREATE OR REPLACE PROCEDURE SP_Verifica_Pedidos2(Pcod_produto NUMBER) IS
  Vpedidos NUMBER(2);
  Vdescricao VARCHAR2(30);
  E_exclusao EXCEPTION;

  BEGIN
    /* verificando se existem pedidos */
    SELECT COUNT(*) INTO Vpedidos
    FROM tb_item_pedido
    WHERE cod_produto = Pcod_produto;
    
    IF Vpedidos = 0 THEN
      /* gravando log */
      SELECT descricao INTO Vdescricao
      FROM tb_produto
      WHERE cod_produto = Pcod_produto;
      
      INSERT INTO tb_log VALUES(SYSDATE, 'Código produto: '||Pcod_produto, ''||Vdescricao);
      
      /* excluindo produto da tabela */
      DELETE FROM tb_produto
      WHERE cod_produto = Pcod_produto;
    ELSE
      RAISE E_exclusao;
    END IF;

    COMMIT;

  EXCEPTION
    WHEN E_exclusao THEN
      raise_application_error(-20500, 'Erro, produto com pedidos associados '||Pcod_produto);
    
    WHEN no_data_found THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Código do produto inexistente: '||Pcod_produto);
  END;


/*
  4. Escreva uma Stored Procedure que receba como parâmetro a unidade de venda de um produto (KG por exemplo) e altere em mais 10% o preço de todos os produtos com a unidade igual à passada como parâmetro. Gravar na tabela de log as informações:

  Datalog: colocar sysdate
  Campo 1: a mensagem ‘PRODUTOS com preço modificado= ‘
  Campo2: o número de linhas que sofreram update
*/
CREATE OR REPLACE PROCEDURE SP_Atualiza_Preco(Punidade CHAR) IS
  Vlinhas NUMBER(3);
  Vcont NUMBER(3);
  E_cont EXCEPTION;

  BEGIN
    /* contando produtos */
    SELECT COUNT(*) INTO Vcont
    FROM tb_produto
    WHERE unidade = Punidade;
    
    IF Vcont > 0 THEN
      /* atualizando valor_unitario */
      UPDATE tb_produto
      SET valor_unitario = valor_unitario * 1.1
      WHERE unidade = Punidade;
      
      /* número de linhas atualizadas */
      Vlinhas := SQL%ROWCOUNT;
      
      INSERT INTO tb_log VALUES(SYSDATE, 'Produtos com preço modificado: '||Vcont, 'Linhas que sofreram update: '||Vlinhas);
    ELSE
      RAISE E_cont;
    END IF;
    
    COMMIT;

  EXCEPTION
    WHEN E_cont THEN
      INSERT INTO tb_erro VALUES(SYSDATE, 'Não há produtos com a unidade informada');
  END;
