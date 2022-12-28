/* 
  Lista02 – Visões em SQL
  Para esta lista usar o script "Paciente_Consulta" disponivel no Teams
*/

/*1.	Crie uma visão que possua: código do medico, código do paciente e a data da consulta acrescentada em 30 dias (retorno). */
CREATE OR REPLACE VIEW retorno
AS SELECT cod_medico, cod_paciente, data_consulta, (data_consulta + 30) AS data_retorno 
FROM consulta;

SELECT * FROM retorno;


/*2.	Crie uma visão que possua: nome do medico, código da consulta e data da consulta. */
CREATE OR REPLACE VIEW dt_cons
AS SELECT m.nome_medico, c.cod_consulta, c.data_consulta
FROM consulta c
INNER JOIN medico m
ON c.cod_medico = m.cod_medico;

SELECT * FROM dt_cons;


/*3.	Crie uma visão que exiba o código do médico e o valor total de suas consultas. */
CREATE OR REPLACE VIEW tot_cons
AS SELECT m.cod_medico, SUM(c.valor_consulta) AS total_consultas
FROM consulta c
INNER JOIN medico m
ON c.cod_medico = m.cod_medico
GROUP BY m.cod_medico;

SELECT * FROM tot_cons;


/*4.	Crie uma visão que exiba o código do médico, o nome do médico e o valor médio de suas consultas. */
CREATE OR REPLACE VIEW media_cons
AS SELECT m.cod_medico, m.nome_medico, AVG(c.valor_consulta) AS media_consultas
FROM medico m
INNER JOIN consulta c
ON m.cod_medico = c.cod_medico
GROUP BY m.cod_medico, m.nome_medico;

SELECT * FROM media_cons;


/*5.	Listar o nome de todas as visões que tem a string "SOR" no nome. */
SELECT * FROM sys.all_views
WHERE view_name LIKE '%SOR%';

SELECT * FROM sys.all_views
WHERE owner = 'ROGERIOFRSOUZA';
