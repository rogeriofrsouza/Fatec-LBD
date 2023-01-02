-- Fatec Sorocaba
-- Laboratório de Banco de Dados
-- Nome do aluno: Rogério Ferreira de Souza
--------------------------------------------------------------------------
  
/* 
  1. Chaves e inserts:

  a) A tabela tb_funcproj possui chaves estrangeiras e uma chave primária composta,
  crie estas restrições usando o comando  alter table. (0,9)
*/
ALTER TABLE tb_funcproj
ADD CONSTRAINT pk_codfunc_codprojeto PRIMARY KEY (codfunc, codprojeto);

ALTER TABLE tb_funcproj
ADD CONSTRAINT fk_codfunc FOREIGN KEY (codfunc) REFERENCES tb_func(cod_func);

ALTER TABLE tb_funcproj
ADD CONSTRAINT fk_codprojeto FOREIGN KEY (codprojeto) REFERENCES tb_projeto(codprojeto);


/* b) Insira 4 registros na tabela tb_funcproj (insira um funcionário com 2 projetos).(1,0) */
INSERT INTO tb_funcproj VALUES(111, 100, 2, 630.56);
INSERT INTO tb_funcproj VALUES(111, 200, 1, 352.99);
INSERT INTO tb_funcproj VALUES(222, 300, 1, 100.70);
INSERT INTO tb_funcproj VALUES(333, 100, 5, 10534.87);


/*
  2. Comandos DDL:
  a) Alterar a tabela tb_funcionario adicionando a coluna telefone varchar2(15);
*/
ALTER TABLE tb_funcionario ADD telefone VARCHAR2(15);


/* b) Alterar o campo descricao da tabela tb_projeto para varchar2(40). */
ALTER TABLE tb_projeto MODIFY descricao VARCHAR2(40);


/* c) Excluir o campo cidade da tabela de funcionario. */
ALTER TABLE tb_funcionario DROP COLUMN cidade;


/*
  3. Comandos DML: (1,0 cada)
  a) Para o funcionário de código = 003 atualizar a coluna telefone para '(15) 3238-5266'.
*/
UPDATE tb_funcionario
SET telefone = '(15) 3238-5266'
WHERE codfunc = 003;


/* b)	Excluir todos os funcionários de sexo Masculino lotados no departamento de código 510. */
DELETE FROM tb_funcionario
WHERE sexo = 'M' AND coddepto = 510;


/*
  c) Listar o nome do funcionário, data de admissão e código do departamento do funcionário 
  cujo salário estiver entre 1.000 e 5.000 reais (vc pode mudar este intervalo de valores de acordo com os dados inseridos) 
*/
SELECT nomefunc, dataadmissao, coddepto
FROM tb_funcionario
WHERE salario BETWEEN 1000.00 AND 5000.00;


/* d) Listar todos os atributos dos funcionários admitidos no ano passado (não fixar 2022) */
SELECT * FROM tb_funcionario
WHERE dataadmissao >= ADD_MONTHS(TRUNC(SYSDATE, 'yyyy'), -12) 
AND dataadmissao < TRUNC(SYSDATE, 'yyyy');


/*
  e) Listar todas as colunas da tabela tb_funcproj onde a coluna bonus_salario for diferente de zero, 
  e tempoalocacao maior que 3, ordenado pela coluna tempoalocacao 
*/
SELECT * FROM tb_funcproj
WHERE bonus_salario <> 0 AND tempoalocacao > 3
ORDER BY tempoalocacao;


/*
  f) Listar o codigo do funcionário e o bonus_salario diminuido em 15% para cada funcionário. 
  Exibir como cabeçalho da coluna derivada o texto 'Bonus alterado'.
*/
SELECT codfunc, SUM(bonus_salario) * 0.85 AS bonus_alterado
FROM tb_funcproj
GROUP BY codfunc;


/* g) Listar o codigo do funcionario, nome do funcionario e a descrição dos projetos que ele está alocado. */
SELECT f.codfunc, f.nomefunc, p.descricao
FROM tb_funcionario f
INNER JOIN tb_funcproj fp
ON f.codfunc = fp.codfunc
INNER JOIN tb_projeto p
ON fp.codprojeto = p.codprojeto
ORDER BY codfunc;


/* h) Listar o codigo do projeto com mais de 2 funcionarios alocados */
SELECT codprojeto, COUNT(*)
FROM tb_funcproj
GROUP BY codprojeto
HAVING COUNT(*) > 2;
