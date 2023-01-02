-- Scripts das tabelas do Modelo Paciente - consulta - medico
-- Adaptado Oracle online (2022)
--
DROP TABLE consulta;
DROP TABLE medico;
DROP TABLE paciente;

CREATE TABLE paciente ( 
  cod_paciente NUMBER(4, 0) NOT NULL,
  nome_paciente VARCHAR2(30) NOT NULL,
  data_nascimento DATE,
  sexo CHAR(1) CHECK (sexo IN ('F', 'M')),
  endereco VARCHAR2(25),
  CONSTRAINT pk_cod_paciente PRIMARY KEY (cod_paciente)
);

CREATE TABLE medico ( 
  cod_medico NUMBER(4, 0) NOT NULL,
  nome_medico VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_cod_medico PRIMARY KEY (cod_medico)
);

CREATE TABLE consulta ( 
  cod_consulta NUMBER(3, 0) NOT NULL,
  data_consulta DATE,
  cod_paciente NUMBER(4, 0) NOT NULL, 
  cod_medico NUMBER(4, 0) NOT NULL,
  valor_consulta NUMBER(5, 0) NOT NULL,
  CONSTRAINT pk_cod_consulta PRIMARY KEY (cod_consulta)
);

ALTER TABLE consulta
ADD (CONSTRAINT fk_cod_paciente FOREIGN KEY (cod_paciente)
     REFERENCES paciente (cod_paciente) ON DELETE CASCADE);

ALTER TABLE consulta
ADD (CONSTRAINT fk_cod_medico FOREIGN KEY (cod_medico)
     REFERENCES medico (cod_medico) ON DELETE CASCADE);
 
ALTER TABLE paciente 
ADD cidade_paciente VARCHAR2(15) NOT NULL;

ALTER TABLE paciente 
MODIFY cidade_paciente VARCHAR2(20);

ALTER TABLE paciente 
ADD desconto VARCHAR2(1) 
CHECK (desconto IN ('S', 'N'));

ALTER TABLE consulta 
ADD tipo_consulta CHAR(1) 
CHECK (tipo_consulta IN ('C', 'P'));

ALTER TABLE consulta MODIFY valor_consulta NUMBER(7, 2);

-- Inserindo os pacientes
INSERT INTO paciente VALUES (001, 'Joao da Silva', TO_DATE('01-09-1957', 'DD-MM-YYYY'), 'M', 'Rua das Flores, 301', 'Sorocaba', 'S');
INSERT INTO paciente VALUES (002, 'Henrique Matias', TO_DATE('25-01-1960', 'DD-MM-YYYY'), 'M', 'Av. das Margaridas, 112', 'Sorocaba', 'S');
INSERT INTO paciente VALUES (003, 'Clara das Neves', TO_DATE('20-01-1978', 'DD-MM-YYYY'), 'F', 'Rua Manoel Bandeira, 1100', 'Itu', 'S');
INSERT INTO paciente VALUES (004, 'Joao Pessoa', TO_DATE('15-10-1945', 'DD-MM-YYYY'), 'M', 'Rua Maria Machado, 800', 'Salto', 'N');
INSERT INTO paciente VALUES (005, 'Karla da Cruz', TO_DATE('29-12-1939', 'DD-MM-YYYY'), 'F', 'Av. Brasil, 701', 'Avare', 'S');
INSERT INTO paciente VALUES (006, 'Jandira Gomes', TO_DATE('18-02-1940', 'DD-MM-YYYY'), 'F', 'Rua Jardim Florido, 1152', 'Sorocaba', 'N');
INSERT INTO paciente VALUES (007, 'Ana Maria Faracco', TO_DATE('13-08-1980', 'DD-MM-YYYY'), 'F', 'Rua Jose Vieira, 65', 'Sorocaba', 'S');
INSERT INTO paciente VALUES (008, 'Roberto Faracco', TO_DATE('01-01-1978', 'DD-MM-YYYY'), 'M', 'Rua Jose Vieira, 65', 'Sorocaba', 'S');
INSERT INTO paciente VALUES (009, 'Barbara Moreira', TO_DATE('30-09-1969', 'DD-MM-YYYY'), 'F', 'Rua das Pedras, 127', 'Sao Paulo', 'N');
INSERT INTO paciente VALUES (010, 'Norberto Almeida', TO_DATE('27-11-1937', 'DD-MM-YYYY'), 'M', 'Rua Capitão Pereira, 170', 'Itapetininga', 'S');

-- Inserindo os médicos
INSERT INTO medico VALUES (001, 'Ronaldo Bueno');
INSERT INTO medico VALUES (002, 'Helena Silva');
INSERT INTO medico VALUES (003, 'Paulo Cesar Oliveira');
INSERT INTO medico VALUES (004, 'Roberto Silva');

INSERT INTO medico VALUES (100, 'Dr. Who');
INSERT INTO medico VALUES (101, 'Dr. House');
INSERT INTO medico VALUES (102, 'Dr. Smith');
INSERT INTO medico VALUES (103, 'Dr. X');
INSERT INTO medico VALUES (104, 'Dr. Estranho');

-- Inserindo as consultas
INSERT INTO consulta VALUES (001, '20-JAN-2022', 001, 003,80.00, 'C');
INSERT INTO consulta VALUES (002, '22-FEV-2022', 001, 003,80.00, 'C');
INSERT INTO consulta VALUES (003, '15-OUT-2021', 002, 001,75.50, 'P');
INSERT INTO consulta VALUES (004, '07-DEZ-2021', 003, 002,60.75, 'P');
INSERT INTO consulta VALUES (005, '18-NOV-2021', 004, 004,57.80, 'C');
INSERT INTO consulta VALUES (006, '27-JUN-2021', 005, 001,60.00, 'C');
INSERT INTO consulta VALUES (007, '30-JUL-2020', 005, 001,60.00, 'C');
INSERT INTO consulta VALUES (008, '15-AGO-2022', 006, 003,75.20, 'P');

INSERT INTO consulta VALUES (300, '01-03-2021', 'P', 3, 102, 500.50);
INSERT INTO consulta VALUES (301, '05-02-2021', 'C', 5, 103, 100.50);
INSERT INTO consulta VALUES (302, '01-03-2020', 'P', 2, 102, 600.00);
INSERT INTO consulta VALUES (303, '25-04-2021', 'C', 1, 104, 99.98);
