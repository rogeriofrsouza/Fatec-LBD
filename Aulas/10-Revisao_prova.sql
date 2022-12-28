CREATE TABLE tb_depto ( 
  codDepto NUMBER(3) PRIMARY KEY,
  nomeDepto VARCHAR2(30)
);

CREATE TABLE tb_projeto ( 
  cod_projeto NUMBER(3) PRIMARY KEY,
  descricao VARCHAR2(30)
);

CREATE TABLE tb_funcionario (  
  codFunc NUMBER(5) PRIMARY KEY,
  nomeFunc VARCHAR2(30),
  sexo CHAR(1),
  dataAdmissao DATE,
  codDepto NUMBER(3) REFERENCES tb_depto,
  salario NUMBER(7,2),
  cidade VARCHAR2(25)
);

CREATE TABLE tb_funcproj (
  CodFunc NUMBER(5),
  cod_projeto NUMBER(3),
  Tempoalocacao NUMBER(3),
  bonus_salario NUMBER(7,2)
);

ALTER TABLE tb_funcproj
ADD CONSTRAINT pk_funcproj PRIMARY KEY (codfunc, cod_projeto);

ALTER TABLE tb_funcproj
ADD CONSTRAINT fk_funcproj_codfunc FOREIGN KEY (codfunc) REFERENCES tb_funcionario;

ALTER TABLE tb_funcproj
ADD CONSTRAINT fk_funcproj_cod_projeto FOREIGN KEY (cod_projeto) REFERENCES tb_projeto;

INSERT INTO tb_depto VALUES(500, 'Depto TI');
INSERT INTO tb_depto VALUES(510, 'Depto de RH');
INSERT INTO tb_depto VALUES(520, 'Depto de Logistica');

INSERT INTO tb_projeto VALUES(100, 'App de Compras');
INSERT INTO tb_projeto VALUES(110, 'Sistema de Logística');
INSERT INTO tb_projeto VALUES(120, 'App de Recrutamento');
INSERT INTO tb_projeto VALUES(130, 'Hackathon');

INSERT INTO tb_funcionario VALUES (1111, 'Maria Silva', 'F', '03/05/2010',510, 6000.00, 'Sorocaba');
INSERT INTO tb_funcionario VALUES(2222, 'Antonio Paulo', 'M', '02/09/2021',500, 2000.00, 'Sorocaba');
INSERT INTO tb_funcionario VALUES (3333, 'Carolina Pereira', 'F', '01/05/2016',520, 850.00, 'Itu');
INSERT INTO tb_funcionario VALUES (4444, 'Felipe Moura', 'M', '01/09/2021',500, 5200.00, 'Campinas');
INSERT INTO tb_funcionario VALUES(5555, 'Carlos Augusto', 'M', '08/05/2011',510, 4000.00, 'Sorocaba');

INSERT INTO tb_funcproj VALUES(1111, 100, 3, 100.00);
INSERT INTO tb_funcproj VALUES(1111, 120, 3, 100.00);
INSERT INTO tb_funcproj VALUES(2222, 120, 3, 100.00);
INSERT INTO tb_funcproj VALUES(2222, 100, 3, 100.00);
INSERT INTO tb_funcproj VALUES(2222, 110, 3, 100.00);
INSERT INTO tb_funcproj VALUES(5555, 100, 3, 100.00);
-----------------------------------------------------

SELECT * FROM tb_funcproj;
SELECT * FROM tb_projeto;

/* 
  1. Listar o  codigo do funcionário, nome do funcionário e a qtde de projetos que ele está alocado, 
  mas só para os funcionários alocados em mais de 2 projetos.
*/
SELECT f.codfunc, f.nomefunc, COUNT(*) AS qtde_projetos
FROM tb_funcionario f
INNER JOIN tb_funcproj fp
ON f.codfunc = fp.codfunc
GROUP BY f.codfunc, f.nomefunc
HAVING COUNT(*) > 2;


/* 2. Alterar o campo bonus_salario para 200.00 para todos os funcionarios que trabalham no projeto de descricao = 'App de Compras' */
UPDATE tb_funcproj
SET bonus_salario = 200.00
WHERE cod_projeto = (SELECT cod_projeto FROM tb_projeto
                    WHERE descricao = 'App de Compras');


/*
  3. Listar  o codigo do projeto que não tem funcionários alocados criando comandos nas 3 formas:
  a) Usando o operador not in
*/
SELECT cod_projeto FROM tb_projeto
WHERE cod_projeto NOT IN (SELECT cod_projeto FROM tb_funcproj);

/* b)	Usando o operador not exists */
SELECT p.cod_projeto FROM tb_projeto p
WHERE NOT EXISTS (SELECT 1 FROM tb_funcproj fp
                  WHERE fp.cod_projeto = p.cod_projeto);

/* c)	Usando o operador Minus (ou except) */
SELECT cod_projeto FROM tb_projeto
MINUS
SELECT cod_projeto FROM tb_funcproj;
