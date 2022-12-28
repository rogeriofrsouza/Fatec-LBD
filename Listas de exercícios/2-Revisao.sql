/*  
  Aula do dia 18-08-2022 LBD diurno
  GABARITO DA LISTA 1 REVISÃO
*/

/* Criação das tabelas para a Lista de Revisão (lista01_lab) */
DROP TABLE autor_livro;
DROP TABLE livro;
DROP TABLE autor;
DROP TABLE assunto;
 
CREATE TABLE autor (
  id_autor NUMBER(5) PRIMARY KEY, 
  nome_autor VARCHAR2(20),
  data_nascimento DATE,
  cidade_nasc VARCHAR2(20),
  sexo CHAR(1)
);
 
CREATE TABLE assunto (
  id_assunto NUMBER(5) PRIMARY KEY,
  descricao VARCHAR2(40),
  desconto_promocao CHAR(1)
);

CREATE TABLE livro (
  id_livro NUMBER(5) PRIMARY KEY,
  titulo VARCHAR2(30),
  editora VARCHAR2(20),
  cidade VARCHAR2(30), 
  data_edicao DATE, 
  versao NUMBER(3),
  id_assunto NUMBER(5),
  preco NUMBER(5, 2),
  data_cadastro	DATE,
  lancamento CHAR(1)
);

CREATE TABLE autor_livro (
  id_livro NUMBER(5) NOT NULL,
  id_autor NUMBER(5) NOT NULL
); 

SELECT * FROM user_constraints;

/* Criar AS chaves que faltam */
ALTER TABLE autor_livro 
ADD CONSTRAINT pk_autor_livro PRIMARY KEY (id_livro, id_autor);

ALTER TABLE autor_livro 
ADD CONSTRAINT fk_id_livro FOREIGN KEY (id_livro) REFERENCES livro(id_livro);

ALTER TABLE autor_livro 
ADD CONSTRAINT fk_id_autor FOREIGN KEY (id_autor) REFERENCES autor(id_autor);

/* Criando FK para assunto */
ALTER TABLE livro 
ADD CONSTRAINT fk_id_assunto FOREIGN KEY (id_assunto) REFERENCES assunto;


/* 3-	Adicionar uma nova coluna de nome Nacionalidade na tabela autor. (Inverti a ordem para já cadastrar a nacionalidade) */
ALTER TABLE autor ADD nacionalidade VARCHAR2(25);


/* 4- Incluir dados nas tabelas */
INSERT INTO assunto VALUES(10, 'LITERATURA', 'N');
INSERT INTO assunto VALUES(20, 'PROGRAMACAO', 'S');
INSERT INTO assunto VALUES(30, 'Estudos Contabilidade', 'S');
INSERT INTO assunto VALUES(40, 'BANCO de DADOS RELACIONAL', 'N');

INSERT INTO autor VALUES(111, 'CLARISSE LISPECTOR', '10/12/1920', 'CHECHELNYK', 'F', 'Ucraniana');
INSERT INTO autor VALUES(222, 'JOEL GRUS', '31/12/1970', 'SEATTLE', 'M', 'Americano');
INSERT INTO autor VALUES(333, 'Marina Souza', TO_DATE('20/01/2000:16:30', 'DD/MM/YYYY:hh24:MI'), 'Sorocaba', 'F', 'Brasileira');
INSERT INTO autor VALUES(444, 'ELMASRI', '04/02/1970', 'NOVA DELHI', 'M', 'Indiano');
INSERT INTO autor VALUES(445, 'NAVATHE', '15/07/1965', 'NOVA DELHI', 'M', 'Indiano');

INSERT INTO livro VALUES(888, 'A HORA DA ESTRELA', 'ROCCO', 'RIO DE JANEIRO', '04/08/1998', '3', 10, 11.9, '21/08/2020', 'L');
INSERT INTO livro VALUES(999, 'DATA SCIENCE DO ZERO', 'ALTA BOOKS', 'RIO DE JANEIRO', '27/06/2016', '1', 20, 43.4, '21/08/2020', 'L');
INSERT INTO livro VALUES(555, 'A HORA DA ESTRELA', 'ROCCO', 'RIO DE JANEIRO', '04/08/1998', '3', 10, 11.9, '21/08/2020', 'L');
INSERT INTO livro VALUES(855, 'INTRODUÇÃO A BANCO DE DADOS', 'MAKRON BOOK', 'RIO DE JANEIRO', '04/09/2003', '4', 40, 100.0, '21/08/2020', 'L');
INSERT INTO livro VALUES(777, 'Contabilidade para ADS', 'Editora OK', 'Sorocaba', '20/01/2011', 1, 30, 25.99, TO_DATE('15/08/1979', 'DD/MM/YYYY'), 'N');
INSERT INTO livro VALUES(1010, 'Contabilidade ADS - Parte II ', 'Editora OK', 'Sorocaba', '20/01/2011', 1, 30, 25.99, TO_DATE('15/08/2018', 'DD/MM/YYYY'), 'N');

INSERT INTO autor_livro VALUES(888, 111);
INSERT INTO autor_livro VALUES(999, 222);
INSERT INTO autor_livro VALUES(777, 333);
INSERT INTO autor_livro VALUES(1010, 333);
INSERT INTO autor_livro VALUES(855, 444);
INSERT INTO autor_livro VALUES(855, 445);
 
/* CHECANDO AS INSERÇÕES */
SELECT * FROM livro;
SELECT * FROM autor_livro;
SELECT * FROM autor;
SELECT * FROM assunto;

/* 4- Alterar a coluna titulo da tabela Livros de 30 para 40 posições. */
ALTER TABLE livro MODIFY titulo VARCHAR2(45);


/* 5- Incluir uma restrição de domínio para a coluna desconto_promocao da tabela assunto de forma a aceitar apenas 'S' ou 'N'. */
ALTER TABLE assunto ADD CHECK(desconto_promocao IN ('S', 'N'));


/* 6- Alterar o campo editora da tabela livros mudando para 'Editora LTC' para o livro de código 777. */
UPDATE livro SET editora = 'Editora LTC' WHERE id_livro = 777;


/* 7- Excluir os livros com id_assunto igual a 10 e ano_edicao menor que 1980. */
DELETE FROM livro WHERE id_assunto = 10 AND TO_CHAR(data_edicao, 'YYYY') < '1980';

DELETE FROM livro WHERE id_assunto = 10 AND TO_CHAR(data_edicao, 'mm/YYYY') < '05/1980';
DELETE FROM livro WHERE id_assunto = 10 AND extract(year FROM data_edicao) < '1999';


/* 8- Listar o título dos livros que possuam a palavra 'BANCO de DADOS' em qualquer posição do título. */
SELECT titulo FROM livro 
WHERE titulo LIKE '%BANCO DE DADOS%';


/* 9-	Listar o nome dos autores que nasceram entre 1950 e 1970 ordenado pelo nome e depois pela data de nascimento. */
SELECT * FROM autor 
WHERE data_nascimento BETWEEN '01/01/1950' AND '31/12/1970' 
ORDER BY cidade_nasc, nome_autor;

SELECT * FROM autor;


/* 10-	Listar a quantidade de livros existentes por assunto. Exibir o código do assunto e a quantidade de livros; */
SELECT * FROM livro ORDER BY id_assunto;

SELECT id_assunto, COUNT(*) AS quantidade 
FROM livro 
GROUP BY id_assunto;


/* 11- Listar o título do livro e a descrição do assunto a qual ele pertence. */
SELECT livro.titulo, assunto.descricao AS descricao_assunto 
FROM livro 
INNER JOIN assunto 
ON livro.id_assunto = assunto.id_assunto;

SELECT livro.titulo, assunto.descricao AS descricao_assunto 
FROM livro, assunto 
WHERE livro.id_assunto = assunto.id_assunto;


/* 12-	Listar o código do livro, título, código e nome dos autores de cada livro */
SELECT l.id_livro, l.titulo, al.id_autor, a.nome_autor 
FROM livro l 
INNER JOIN autor_livro al 
ON l.id_livro = al.id_livro
INNER JOIN autor a 
ON al.id_autor = a.id_autor 
ORDER BY l.id_livro;

SELECT * FROM livro;


/* 13-	Listar o código dos autores que tem >= 2 livros publicados. */
SELECT * FROM autor;
SELECT * FROM autor_livro;

SELECT id_autor, COUNT(*) AS quantidade
FROM autor_livro 
GROUP BY id_autor 
HAVING COUNT(*) >= 2;
