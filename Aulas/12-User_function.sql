-- Aula do dia 10-11 diurno LBD
-- User Functions

/* Exemplo 1: Função que calcula o dobro de um número. */
CREATE OR REPLACE FUNCTION CalcDobro(p1 IN NUMBER) 
RETURN NUMBER 
IS
  p2 NUMBER;

  BEGIN
    p2 := p1 * 2;
    RETURN p2;
  END;
---------------

SELECT codproduto, valor_unit, CalcDobro(valor_unit) FROM tb_produto;

--------------------------
CREATE OR REPLACE FUNCTION Fn_Devolve_Descricao(P_codprod tb_produto.codproduto%TYPE) 
RETURN VARCHAR2 
IS
  V_desc tb_produto.descricao%TYPE;

  BEGIN
    SELECT descricao INTO V_desc
    FROM tb_produto
    WHERE codproduto = P_codprod;
    RETURN (V_desc);
  END Fn_Devolve_Descricao;
-------------------------
 
-- Para evocar uma função:

-- 1a. Forma:
SELECT numpedido, codproduto, Fn_Devolve_Descricao(codproduto) "Descrição"
FROM tb_item_pedido;

-- 2a. Forma
VARIABLE resultado VARCHAR2(20);
EXECUTE :resultado := Fn_Devolve_Descricao (11);
PRINT :resultado

SELECT numpedido, codproduto, SUBSTR(Fn_Devolve_Descricao(codproduto), 1, 15) AS descricao, pco_unit 
FROM tb_item_pedido;


--------------
-- Exercícios:

/* 
  1. Escreva uma função FN_verHora que receba como parâmetro uma data no formato dd/mm/yyyy 
  e devolva-a no formato dd/mm/yyyy:HH24:mi:ss em VARCHAR2.
*/
SELECT SYSDATE FROM dual;

CREATE OR REPLACE FUNCTION Fn_VerHora(P_data DATE) 
RETURN VARCHAR2 
IS
  V_data VARCHAR2(40);

  BEGIN
    V_data := to_char(P_data, 'dd/mm/yyyy:HH24:mi:ss');
    RETURN V_data;
  END;
---------------

SELECT Fn_VerHora(SYSDATE) FROM dual;


/* 
  2. Escreva uma função que receba como parâmetro um código de Paciente (modelo Paciente-consulta) 
  e devolva “IDOSO” se o paciente tiver mais de 65 anos. Caso contrário devolva “NÃO IDOSO”. 
*/
CREATE OR REPLACE FUNCTION Fn_ChecaIdade(P_codpaciente tb_paciente.codpaciente%TYPE) 
RETURN VARCHAR2 
IS
  V_idade NUMBER(3);

  BEGIN
    SELECT ((SYSDATE - datanasc) / 365.25) INTO V_idade
    FROM tb_paciente
    WHERE codpaciente = P_codpaciente;
    
    IF V_idade >= 65 THEN
      RETURN 'IDOSO';
    ELSE
      RETURN 'NÃO IDOSO';
    END IF;
  END;
---------------------------

SELECT nompaciente, datanasc, Fn_ChecaIdade(codpaciente) 
FROM tb_paciente;


/*
  3. Crie uma função chamada FN_ConsultaEstoque que retorna a qtde corrente em estoque de determinado produto.
  
  a) Passe para a função o código do produto
  b) Crie o campo QTDE_estoque na tabela de produto.
  c) Crie uma forma de executar a função criada.
*/
SELECT * FROM tb_produto;

CREATE OR REPLACE FUNCTION Fn_ConsultaEstoque(codproduto tb_produto%TYPE) 
RETURN NUMBER 
IS
  BEGIN
    ALTER TABLE tb_produto
    ADD qtde_estoque NUMBER;
  END;


/*
  4. Escreva uma função que receba como parâmetro um número de telefone não formatado (só números) 
  e exiba este número no formato: (xx)xxxx-xxxx
*/
CREATE OR REPLACE FUNCTION Fn_FormataTelefone(p_telefone NUMBER) 
RETURN VARCHAR2 
IS
  BEGIN
    RETURN '(' || SUBSTR(p_telefone, 1, 2) || ')' ||
           SUBSTR(p_telefone, 3, 4) || '-' || SUBSTR(p_telefone, 7, 4);
  END;


/*
  5- Escreva uma função que receba como parâmetro o código do cliente e conte quantos pedidos ele tem.

  Se ele tiver mais de 3 pedidos devolver mensagem: 'Cliente preferencial' concatenado com o código e nome do cliente.
  Se tiver entre 1 e 3 devolver mensagem 'Cliente Normal' concatenado com o código e nome do cliente
  Se não tiver pedidos 'Cliente Inativo' concatenado com o código e nome do cliente;

  Testar se o cliente existe, caso contrário emitir mensagem de erro.
*/
CREATE OR REPLACE FUNCTION Fn_ContaPedidos(P_cod_cliente tb_cliente.cod_cliente%TYPE) 
RETURN VARCHAR2 
IS
  V_qtde NUMBER(2);
  V_nome tb_cliente.nome_cliente%TYPE;
  V_res VARCHAR2(30);
    
  BEGIN
    SELECT COUNT(*) INTO V_qtde
    FROM tb_pedido
    WHERE cod_cliente = P_cod_cliente;
    
    SELECT nome_cliente INTO V_nome
    FROM tb_cliente
    WHERE cod_cliente = P_cod_cliente;
    
    IF V_qtde > 3 THEN
      V_res := 'Cliente preferencial '|| P_cod_cliente;   
    ELSIF V_qtde >= 1 THEN   
      V_res := 'Cliente normal '|| P_cod_cliente || V_nome;
    ELSE
      V_res := 'Cliente inativo '|| P_cod_cliente || V_nome;
    END IF;
      
    RETURN V_res;
  
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20500, 'Erro, cliente não existente '||P_cod_cliente);
  END;
  