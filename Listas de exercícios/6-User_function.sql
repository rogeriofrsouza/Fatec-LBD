/* 
  1. Escreva uma função FN_verHora que receba como parâmetro uma data no formato dd/mm/yyyy 
  e devolva-a no formato dd/mm/yyyy:HH24:mi:ss em VARCHAR2.
*/
CREATE OR REPLACE FUNCTION fn_verHora(pdata date) RETURN VARCHAR2 AS
  Vdata VARCHAR2(40);

  BEGIN
    Vdata := TO_CHAR(pdata, 'dd/mm/yyyy:HH24:mi:ss');
    RETURN Vdata;
  END;


/* 
  2. Escreva uma função que receba como parâmetro um código de Paciente (modelo Paciente-consulta) 
  e devolva “IDOSO” se o paciente tiver mais de 65 anos. Caso contrário devolva “NÃO IDOSO”. 
*/
CREATE OR REPLACE FUNCTION fn_checaIdade(pcod_paciente paciente.cod_paciente%TYPE) 
RETURN VARCHAR2 
AS
  Vidade NUMBER(3);

  BEGIN
    SELECT ((SYSDATE - data_nascimento) / 365.25) INTO Vidade
    FROM paciente
    WHERE cod_paciente = pcod_paciente;
    
    IF Vidade >= 65 THEN
      RETURN 'IDOSO';
    ELSE
      RETURN 'NÃO IDOSO';
    END IF;
  END;


/*
  3. Crie uma função chamada FN_ConsultaEstoque que retorna a qtde corrente em estoque de determinado produto.
  
  a) Passe para a função o código do produto
  b) Crie o campo QTDE_estoque na tabela de produto.
  c) Crie uma forma de executar a função criada.
*/
CREATE OR REPLACE FUNCTION fn_ConsultaEstoque(pcod_produto tb_produto.cod_produto%TYPE) 
RETURN NUMBER 
IS
  Vqtde NUMBER(4);
    
  BEGIN
    SELECT qtde_estoque into Vqtde
    FROM tb_produto
    WHERE cod_produto = pcod_produto;
    
    RETURN vqtde;
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
CREATE OR REPLACE FUNCTION fn_ContaPedidos(p_cod_cliente tb_cliente.cod_cliente%TYPE) 
RETURN VARCHAR2 
AS
  v_qtde NUMBER(2);
  v_nome tb_cliente.nome_cliente%TYPE;
  v_res VARCHAR2(30);
    
  BEGIN
    SELECT COUNT(*) INTO v_qtde
    FROM tb_pedido
    WHERE cod_cliente = p_cod_cliente;
    
    SELECT nome_cliente INTO v_nome
    FROM tb_cliente
    WHERE cod_cliente = p_cod_cliente;
    
    IF v_qtde > 3 THEN
      v_res := 'Cliente preferencial '|| p_cod_cliente;   
    ELSIF v_qtde >= 1 THEN   
      v_res := 'Cliente normal '|| p_cod_cliente || v_nome;
    ELSE
      v_res := 'Cliente inativo '|| p_cod_cliente || v_nome;
    END IF;
      
    RETURN v_res;
  
  EXCEPTION
    WHEN no_data_found THEN
      raise_application_error(-20500, 'Erro, cliente não existente '||P_cod_cliente);
  END;
  