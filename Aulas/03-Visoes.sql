--Aula do dia 25-08 Revisão de visões
SELECT * FROM paciente;

DROP VIEW pacsor;

CREATE OR REPLACE VIEW pacsor
AS SELECT * FROM paciente 
WHERE cidade_paciente = 'Sorocaba'
WITH CHECK OPTION;

SELECT * FROM pacsor;
SELECT * FROM paciente;
--

INSERT INTO pacsor VALUES (77, 'Roberto souza', SYSDATE, 'M', 'rua', 'Sorocaba', 'S');
INSERT INTO pacsor VALUES (61, 'Maria', SYSDATE, 'F', 'rua x', 'itu', 'S');

UPDATE pacsor
SET nome_paciente = 'Carlos Souza'
WHERE cod_paciente = 3;   -- deleta zero linhas pq o cod_paciente 3 não mora em sorocaba

SELECT * FROM paciente;

UPDATE pacsor
SET nome_paciente = 'DDDD'
WHERE cod_paciente = 61;

DELETE FROM pacsor
WHERE cod_paciente = 77;


-- Visão 2
--===========
CREATE OR REPLACE VIEW pacsor_res
AS SELECT cod_paciente, nome_paciente, data_nascimento, sexo
FROM pacsor;

SELECT * FROM pacsor_res;

INSERT INTO pacsor_res(cod_paciente, nome_paciente, data_nascimento, sexo) 
VALUES (49, 'Ana', SYSDATE, 'F');

UPDATE pacsor_res
SET nome_paciente = 'KKKKK'
WHERE cod_paciente = 77;

SELECT * FROM paciente;

UPDATE pacsor_res
SET cidade_paciente = 'KKKKK'
WHERE cod_paciente = 77;

DELETE FROM pacsor_res
WHERE cod_paciente = 77;


-- Visão 3   => não é atualizável pq tem junção
--===========
CREATE OR REPLACE VIEW consulta_pac
AS SELECT p.cod_paciente, p.nome_paciente, c.cod_consulta
FROM paciente p, consulta c
WHERE c.cod_paciente = p.cod_paciente;

SELECT * FROM consulta_pac;


-- Visão 4   => não é atualizável porque tem campos calculados ou derivados
--==========
SELECT * FROM consulta;

CREATE OR REPLACE VIEW salario_liq
AS SELECT cod_medico, (valor_consulta * 0.75) AS valor_liquido, 'medico bom'  AS avaliacao
FROM consulta;

SELECT * FROM salario_liq;

SELECT valor_liquido FROM salario_liq;

SELECT cod_medico, (valor_consulta * 0.75) FROM consulta;


-- Visão 5          =>  não é atualizável
--============
CREATE OR REPLACE VIEW totalmed
AS SELECT cod_medico, COUNT(*) AS total_consultas
FROM consulta
GROUP BY cod_medico;

SELECT COUNT(*) FROM totalmed;

SELECT * FROM medico;
SELECT * FROM totalmed;

UPDATE pacsor_res
SET data_nascimento = SYSDATE
WHERE cod_paciente = 5;

CREATE OR REPLACE VIEW salario_liq
AS SELECT cod_medico, (valor_consulta * 0.75) AS totliq
FROM consulta;

CREATE OR REPLACE VIEW v_paciente
AS SELECT cod_paciente, nome_paciente FROM paciente;


/* 
  ATENÇÃO:

  Uma visão é atualizável (permite insert, UPDATE e DELETE) se:

  - não tiver junção
  - não tiver GROUP BY, having, funções (sum, COUNT, max, etc..)
  - não tiver campos calculados
*/
