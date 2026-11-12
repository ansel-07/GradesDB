--
-- queries.sql: L3 queries on grades_db
--

USE grades_db;

-- Consultas básicas

/*
SELECT columnas
FROM tabla
WHERE condicion;
*/

-- Consulta 1
SELECT * FROM subjects;

-- Consulta 2
SELECT * FROM subjects s WHERE s.acronym LIKE 'IISSI-1';

-- Consulta 3
SELECT s.subject_name, s.acronym FROM subjects s;

-- Consulta 4
SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type LIKE 'Formación Basica';

-- Consulta 5


-- Consulta 6


-- Consulta 7


-- Consulta 8


