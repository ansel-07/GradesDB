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
WHERE subject_name LIKE 'Fundamentos %';

-- Consulta 25: Longitud exacta
SELECT first_name, last_name
FROM people
WHERE first_name LIKE '_____';


-- ============================================================================
-- Filtrado por fechas y años
-- ============================================================================

-- Consulta 26: Filtro por año
SELECT group_id, group_name, activity, academic_year
FROM groups
WHERE academic_year = 2024;

-- Consulta 27: Rango de años
SELECT group_id, group_name, activity, academic_year
FROM groups
WHERE academic_year BETWEEN 2020 AND 2023
ORDER BY academic_year;



-- ============================================================================
-- Vistas complejas
-- ============================================================================

-- Vista v_grades_with_honors
CREATE OR REPLACE VIEW v_grades_with_honors AS
SELECT 
	grade_id, 
   student_id, 
   group_id,
   grade_value,
   exam_call
FROM grades
WHERE with_honors = 1;

-- Vista v_student_grades
CREATE OR REPLACE VIEW v_student_grades AS
SELECT
	p.person_id,
   p.first_name,
   p.last_name,
   p.dni,
   g.grade_value,
   g.exam_call,
   g.with_honors,
   gr.group_name,
   gr.activity,
   gr.academic_year,
   s.subject_name,
   s.acronym,
   s.credits
FROM students st
JOIN people p ON st.student_id = p.person_id
JOIN grades g ON st.student_id = g.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista v_professor_loads
CREATE OR REPLACE VIEW v_professor_loads AS
SELECT
	p.person_id,
   p.first_name,
   p.last_name,
   pr.category,
   tl.credits AS teaching_credits,
   gr.group_name,
   gr.activity,
   gr.academic_year,
   s.subject_name,
   s.acronym
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista v_degree_students
CREATE OR REPLACE VIEW v_degree_students AS
SELECT DISTINCT
	d.degree_id,
   d.degree_name,
   p.person_id,
   p.first_name,
   p.last_name,
   st.access_method,
   gr.academic_year
FROM students st
JOIN people p ON st.student_id = p.person_id
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN groups gr ON sg.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
JOIN degrees d ON s.degree_id = d.degree_id;

-- Consulta 28: Uso de vistas
SELECT COUNT(*) AS total_honors
FROM v_grades_with_honors;

-- Consulta 29: Agregación sobre vista
SELECT
	stg.first_name, 
   stg.last_name, 
   AVG(stg.grade_value) AS average_grade
FROM v_student_grades stg
GROUP BY stg.first_name, stg.last_name, stg.person_id;


-- ============================================================================
-- ORDER BY, LIMIT y OFFSET: Control de resultados
-- ============================================================================

/*
Ordenar por varios criterios:
ORDER BY p.age DESC, p.last_name ASC

Devolver un número limitado de filas
o saltarse filas:
ORDER BY ...
LIMIT n -- devuelve las n primeras filas
LIMIT n OFFSET k -- se salta las k primeras 
						y devuelve las n siguientes

El orden entre filas con el mismo valor en todas
las columnas del ORDER BY queda sin definir,
puede devolver cualquier orden. Por tanto,
podría cortar en medio de un empate.
*/

-- Consulta 30: Ordenación ascendente
SELECT grade_id, student_id, grade_value, exam_call
FROM grades
ORDER BY grade_value;

-- Consulta 31: Ordenación descendente
SELECT grade_id, student_id, grade_value, exam_call
FROM grades
ORDER BY grade_value DESC;

-- Consulta 32: Limitación de resultados
SELECT grade_id, student_id, grade_value, exam_call
FROM grades
ORDER BY grade_value DESC
LIMIT 5;

-- Consulta 33: Ordenación múltiple
SELECT st.first_name, st.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN v_students st ON st.student_id = g.student_id
WHERE g.grade_value >= 5
ORDER BY st.last_name, st.first_name;

-- Consulta 34: Paginación básica
SELECT grade_id, student_id, grade_value
FROM grades
ORDER BY grade_value DESC
LIMIT 5 OFFSET 5;

-- Consulta 35: Tercera página
SELECT grade_id, student_id, grade_value
FROM grades
ORDER BY grade_value DESC
LIMIT 5 OFFSET 10;

-- Consulta 36: Ordenación con criterios mixtos
SELECT group_name, activity, academic_year
FROM groups
ORDER BY academic_year DESC, group_name ASC;



-- ============================================================================
-- JOIN: Consultas avanzadas con múltiples tablas
-- ============================================================================

/*
SELECT s.subject_name, gr.group_name
FROM subjects s
LEFT JOIN groups gr ON s.subject_id = gr.subject_id;

Las asignaturas que tienen grupos aparecen una vez por cada
grupo, y las asignaturas que no tienen grupo aparecen una
vez, con group_name = NULL.
*/

-- Consulta 37: JOIN con tabla intermedia
SELECT 
	st.first_name, 
   st.last_name, 
   gr.group_name, 
   gr.activity, 
   gr.academic_year
FROM v_students st
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN groups gr ON sg.group_id = gr.group_id;

-- Consulta 38: JOIN uno a muchos
SELECT
	d.degree_name,
   s.subject_name,
   s.acronym,
   s.credits,
   s.course,
   s.subject_type
FROM subjects s
JOIN degrees d ON s.degree_id = d.degree_id
ORDER BY d.degree_name, s.course;

-- Consulta 39: JOIN múltiple
SELECT
	st.first_name,
   st.last_name,
   s.subject_name,
   s.acronym,
   g.grade_value,
   g.exam_call,
   gr.academic_year
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Consulta 40: JOIN con una vista
SELECT
	pr.first_name,
   pr.last_name,
   pr.category,
   s.subject_name,
   gr.group_name,
   gr.activity,
   tl.credits AS teaching_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Consulta 41: DISTINCT con JOIN
SELECT DISTINCT
	st.first_name,
   st.last_name,
   s.subject_name,
   s.acronym,
   gr.academic_year
FROM v_students st
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN groups gr ON sg.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
ORDER BY st.last_name, s.subject_name;

-- Consulta 42: LEFT JOIN
SELECT
	st.first_name,
   st.last_name,
   g.grade_value,
   g.exam_call
FROM v_students st
LEFT JOIN grades g ON st.student_id = g.student_id;



-- ============================================================================
-- GROUP BY: Agrupación y agregación
-- ============================================================================

/*
Orden de ejecución de una consulta:
1. FROM, JOIN
2. WHERE
3. GROUP BY
4. Funciones agregadas (una vez por grupo)
5. SELECT
6. ORDER BY, LIMIT
*/

-- Consulta 43: Agregación por grupo
SELECT
	st.first_name,
   st.last_name,
   AVG(g.grade_value) AS average_grade,
   COUNT(*) AS total_grades
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name;

-- Consulta 44: Conteo por categoría
SELECT
	st.access_method,
   COUNT(*) AS total_students
FROM students st
GROUP BY st.access_method;

-- Consulta 45: Agregación con JOIN
SELECT
	d.degree_name,
   COUNT(*) AS total_subjects
FROM subjects s
JOIN degrees d ON s.degree_id = d.degree_id
GROUP BY d.degree_id, d.degree_name;

-- Consulta 46: Conteo por entidad
SELECT
	s.subject_name,
   s.acronym,
   COUNT(*) AS total_groups
FROM groups gr
JOIN subjects s ON gr.subject_id = s.subject_id
GROUP BY s.subject_id, s.subject_name, s.acronym;

-- Consulta 47: Promedio por categoría
SELECT
	g.exam_call,
   AVG(g.grade_value) AS average_grade,
   COUNT(*) AS total_grades
FROM grades g
GROUP BY g.exam_call;

-- Consulta 48: Agrupación múltiple
SELECT
	s.subject_name,
   g.exam_call,
   AVG(g.grade_value) AS average_grade,
   COUNT(*) AS total_grades
FROM grades g
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
GROUP BY g.exam_call, s.subject_name
ORDER BY s.subject_name, g.exam_call;

-- Consulta 49: COUNT DISTINCT
SELECT
	gr.academic_year,
   COUNT(DISTINCT st.student_id) AS total_students
FROM students st
JOIN students_groups sg ON st.student_id = sg.student_id
JOIN groups gr ON sg.group_id = gr.group_id
GROUP BY gr.academic_year
ORDER BY gr.academic_year DESC;

-- Consulta 50: Suma por grupo
SELECT
	pr.first_name,
   pr.last_name,
   pr.category,
   SUM(tl.credits) AS total_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
GROUP BY pr.professor_id, pr.first_name, pr.last_name, pr.category;



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
