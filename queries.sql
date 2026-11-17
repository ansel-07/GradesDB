--
-- queries.sql: L3 queries on grades_db
--

USE grades_db;


-- ============================================================================
-- SELECT: La consulta básica
-- ============================================================================

/*
SELECT columnas
FROM tabla
WHERE condicion;
*/

-- Consulta 1: Todas las asignaturas
SELECT * FROM subjects;

-- Consulta 2: Asignatura con acrónimo específico
SELECT * FROM subjects s
WHERE s.acronym = 'IISSI-1';

-- Consulta 3: Columnas específicas
SELECT s.subject_name, s.acronym
FROM subjects s;

-- Consulta 4: Filtrado por tipo
SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';



-- ============================================================================
-- JOIN: Relacionando tablas
-- ============================================================================

/*
SELECT ...
FROM tabla1 t1
JOIN tabla2 t2 ON t1.columna = t2.columna
WHERE ...;
*/

-- Consulta 5: Estudiantes con JOIN
SELECT p.first_name, p.last_name, st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';

-- Consulta 6: Profesores por categoría
SELECT p.first_name, p.last_name, pr.category 
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';



-- ============================================================================
-- Vistas: Simplificando consultas complejas
-- ============================================================================

/*
CREATE OR REPLACE VIEW nombre_vista AS
SELECT ...
FROM ...;


SELECT * FROM nombre_vista WHERE ...;
*/

-- Vista v_professors
CREATE OR REPLACE VIEW v_professors AS
SELECT 
	pr.professor_id, 
   p.dni, 
   p.first_name, 
	p.last_name, 
   p.age, 
   p.email, 
   pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;

-- Vista v_students
CREATE OR REPLACE VIEW v_students AS
SELECT 
	st.student_id, 
   p.dni, 
   p.first_name,
	p.last_name, 
   p.age, 
   p.email, 
   st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id;



-- ============================================================================
-- Funciones agregadas
-- ============================================================================

/*
COUNT(*): cuenta cuántas filas hay
SUM(col): suma los valores de la columna
AVG(col): hace la media de la columna
MAX(col): da el máximo de la columna
MIN(col): da el mínimo de la columna

Alias de columna:
SELECT AVG(s.credits) AS avg_credits
FROM subjects s;

Agrupar por tipos:
SELECT columna, COUNT(*)
FROM tabla
GROUP BY columna;
-- Devuelve una fila por cada valor
-- distinto de la columna
*/

-- Consulta 7: Media de notas
SELECT AVG(g.grade_value) AS avg_grades
FROM grades g
WHERE g.group_id = 1;

-- Consulta 8: Suma de créditos
SELECT SUM(s.credits) AS sum_credits
FROM subjects s
WHERE s.degree_id = 3;

-- Consulta 9: Contar registros
SELECT COUNT(*) AS num_students
FROM students;

-- Consulta 10: Contar con agrupación básica
SELECT g.activity, COUNT(*) AS num_groups
FROM groups g
GROUP BY g.activity;

-- Consulta 11: Valor máximo
SELECT MAX(g.grade_value) AS max_grade
FROM grades g;

-- Consulta 12: Valor mínimo
SELECT MIN(g.grade_value) AS min_grade
FROM grades g;



-- ============================================================================
-- Condiciones múltiples
-- ============================================================================

-- Consulta 13: OR lógico
SELECT *
FROM grades g
WHERE (g.grade_value < 5) OR (g.grade_value > 9);

-- Consulta 14: BETWEEN
SELECT *
FROM grades g
WHERE (g.grade_value BETWEEN 5 AND 7);

-- Consulta 15: IN
SELECT *
FROM subjects s
WHERE (s.credits IN (6, 12));

-- Consulta 16: Rango de edad
SELECT *
FROM people p
WHERE (p.age BETWEEN 20 AND 30);



-- ============================================================================
-- DISTINCT: Eliminación de duplicados
-- ============================================================================

/*
SELECT DISTINCT columnas ...;

ORDER BY columna -- menor a mayor
ORDER BY columna DESC -- mayor a menor
*/

-- Consulta 17: Nombres únicos de grupos
SELECT DISTINCT g.group_name
FROM groups g;

-- Consulta 18: Tipos de asignatura
SELECT DISTINCT s.subject_type
FROM subjects s;

-- Consulta 19: Años académicos
SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC;



-- ============================================================================
-- Subconsultas
-- ============================================================================

/*
Subconsulta que devuelve un solo valor:
SELECT p.first_name, p.age
FROM people p
WHERE p.age > (SELECT AVG(p2.age) FROM people p2);

Subconsulta que devuelve una columna con varios valores:
SELECT s.subject_name
FROM subjects s
WHERE s.degree_id IN (SELECT d.degree_id FROM degrees d WHERE d.duration_years = 4);
*/

-- Consulta 20: Agregado filtrado
SELECT MAX(g.grade_value)
FROM grades g
WHERE g.student_id = 6;

-- Consulta 21: IN con subconsulta
SELECT DISTINCT sg.student_id
FROM students_groups sg
WHERE sg.group_id IN (
	SELECT g.group_id
   FROM groups g
   WHERE g.academic_year = 2024
);

-- Consulta 22: Comparación con agregado
SELECT *
FROM subjects s
WHERE s.credits > (
	SELECT AVG(s2.credits)
   FROM subjects s2
);



-- ============================================================================
-- Patrones con LIKE
-- ============================================================================

/*
'=' compara con un valor exacto.
'LIKE' compara con un patrón:
	-> '%' significa cualquier secuencia de
   	caracteres, incluida la vacía.
      Ej: 'IISSI%'
   -> '_' significa exactamente un carácter
   	cualquiera.
      Ej: '_C'
*/

-- Consulta 23: Terminación de cadena
SELECT first_name, last_name, dni
FROM people
WHERE dni LIKE '%A';

-- Consulta 24: Inicio de cadena
SELECT subject_name
FROM subjects
WHERE subject_name LIKE 'Fundamentos%';

-- Consulta 25: Longitud exacta
SELECT first_name, last_name
FROM people
WHERE first_name LIKE '_____';


-- ============================================================================
-- Filtrado por fechas y años
-- ============================================================================

-- Consulta 26: Filtro por año


-- Consulta 27: Rango de años




-- ============================================================================
-- Vistas complejas
-- ============================================================================

-- Vista v_grades_with_honors


-- Vista v_student_grades


-- Vista v_professor_loads


-- Vista v_degree_students


-- Consulta 28: Uso de vistas


-- Consulta 29: Agregación sobre vista




-- ============================================================================
-- ORDER BY, LIMIT y OFFSET: Control de resultados
-- ============================================================================

-- Consulta 30: Ordenación ascendente


-- Consulta 31: Ordenación descendente


-- Consulta 32: Limitación de resultados


-- Consulta 33: Ordenación múltiple


-- Consulta 34: Paginación básica


-- Consulta 35: Tercera página


-- Consulta 36: Ordenación con criterios mixtos




-- ============================================================================
-- JOIN: Consultas avanzadas con múltiples tablas
-- ============================================================================

-- Consulta 37: JOIN con tabla intermedia


-- Consulta 38: JOIN uno a muchos


-- Consulta 39: JOIN múltiple


-- Consulta 40: JOIN con una vista


-- Consulta 41: DISTINCT con JOIN


-- Consulta 42: LEFT JOIN




-- ============================================================================
-- GROUP BY: Agrupación y agregación
-- ============================================================================

-- Consulta 43: Agregación por grupo


-- Consulta 44: Conteo por categoría


-- Consulta 45: Agregación con JOIN


-- Consulta 46: Conteo por entidad


-- Consulta 47: Promedio por categoría


-- Consulta 48: Agrupación múltiple


-- Consulta 49: COUNT DISTINCT


-- Consulta 50: Suma por grupo




-- ============================================================================
-- HAVING: Filtrado de grupos
-- ============================================================================

-- Consulta 51: Filtro por agregado


-- Consulta 52: Conteo con umbral


-- Consulta 53: Filtro de tamaño de grupo


-- Consulta 54: Promedio con filtro




-- ============================================================================
-- Consultas complejas combinadas
-- ============================================================================

-- Consulta 55: Top N con filtros


-- Consulta 56: Condición especial con agregado


-- Consulta 57: Ranking con múltiples JOIN


-- Consulta 58: Máximo por grupo


-- Consulta 59: Análisis de carga docente


-- Consulta 60: Subconsulta con GROUP BY
