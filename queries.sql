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
SELECT p.first_name, p.last_name, s.access_method
FROM students s
JOIN people p ON s.student_id = p.person_id
WHERE s.access_method = 'Selectividad';

-- Consulta 6: Profesores por categoría
SELECT p.first_name, p.last_name, prof.category 
FROM professors prof
JOIN people p ON prof.professor_id = p.person_id
WHERE prof.category = 'Catedrático';



-- ============================================================================
-- Vistas: Simplificando consultas complejas
-- ============================================================================

-- Vista v_professors


-- Vista v_students




-- ============================================================================
-- Funciones agregadas
-- ============================================================================

-- Consulta 7: Media de notas


-- Consulta 8: Suma de créditos


-- Consulta 9: Contar registros


-- Consulta 10: Contar con agrupación básica


-- Consulta 11: Valor máximo


-- Consulta 12: Valor mínimo




-- ============================================================================
-- Condiciones múltiples
-- ============================================================================

-- Consulta 13: OR lógico


-- Consulta 14: BETWEEN


-- Consulta 15: IN


-- Consulta 16: Rango de edad




-- ============================================================================
-- DISTINCT: Eliminación de duplicados
-- ============================================================================

-- Consulta 17: Nombres únicos de grupos


-- Consulta 18: Tipos de asignatura


-- Consulta 19: Años académicos




-- ============================================================================
-- Subconsultas
-- ============================================================================

-- Consulta 20: Agregado filtrado


-- Consulta 21: IN con subconsulta


-- Consulta 22: Comparación con agregado




-- ============================================================================
-- Patrones con LIKE
-- ============================================================================

-- Consulta 23: Terminación de cadena


-- Consulta 24: Inicio de cadena


-- Consulta 25: Longitud exacta




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
