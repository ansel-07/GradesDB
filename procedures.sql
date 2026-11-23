USE grades_db;

/*
DELIMITER //
CREATE OR REPLACE PROCEDURE p_nombre(
	IN p_param1 INT,
   OUT p_result DECIMAL(4,2)
)
BEGIN
	-- sentencias
END //
DELIMITER ;

CALL p_nombre(6, @x);
*/

-- Ejemplo 1: Procedimiento para borrar notas de un alumno (RF02)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_delete_student_grades(
	IN p_student_dni CHAR(9)
)
BEGIN
	DECLARE v_student_id INT;
   
   SELECT student_id INTO v_student_id 
   FROM v_students WHERE dni = p_student_dni;
   
   DELETE FROM grades 
   WHERE student_id = v_student_id;
END //
DELIMITER ;

-- Ejemplo 2: Procedimiento para borrar todos los datos
DELIMITER //
CREATE OR REPLACE PROCEDURE p_delete_all_data()
BEGIN
	DELETE FROM teaching_loads;
	DELETE FROM students_groups;
	DELETE FROM grades;
	DELETE FROM groups;
	DELETE FROM students_subjects;
	DELETE FROM professors;
	DELETE FROM students;
	DELETE FROM subjects;
	DELETE FROM people;
	DELETE FROM degrees;
END //
DELIMITER ;

-- Ejemplo 3: Procedimiento para calcular el promedio de notas con parámetro OUT
DELIMITER //
CREATE OR REPLACE PROCEDURE p_student_average(
	IN p_student_id INT,
   OUT p_average DECIMAL(4,2)
)
BEGIN
	SELECT AVG(g.grade_value) INTO p_average
   FROM students st
   JOIN grades g ON st.student_id = g.student_id
   WHERE st.student_id = p_student_id;
END //
DELIMITER ;

/*
Cambiar valores de filas existentes:
UPDATE tabla
SET columna1 = expresion1, columna2 = expresion2
WHERE condicion;

Nuevas funciones:
LEAST(a, b): devuelve el mínimo entre a y b.
FLOOR(x): redondea hacia abajo.
ROW_COUNT(): dice cuántas filas cambió la última
				sentencia INSERT, UPDATE o DELETE.
CONCAT(a, b, ...): une textos.

Condicionales dentro de un procedimiento:
IF condicion THEN
	-- sentencias si se cumple
ELSE
	-- sentencias si no se cumple
END IF;
*/
-- Ejemplo 4: Procedimiento para subir notas de un grupo
DELIMITER //
CREATE OR REPLACE PROCEDURE p_boost_group_grades(
	IN p_group_id INT,
   IN p_exam_call VARCHAR(20)
)
BEGIN
	UPDATE grades
   SET grade_value = LEAST(10, grade_value * 1.15)
   WHERE group_id = p_group_id 
   		AND grade_value BETWEEN 4.5 AND 8
         AND exam_call = p_exam_call;
         
   SELECT
   	group_name,
   	ROW_COUNT() AS updated_grades
   FROM groups
   WHERE group_id = p_group_id;
   
END //
DELIMITER ;

-- Ejemplo 5: Procedimiento para asignar matrículas de honor
DELIMITER //
CREATE OR REPLACE PROCEDURE p_assign_honors(
	IN p_group_id INT,
   IN p_exam_call VARCHAR(20)
)
BEGIN
	DECLARE v_enrolled INT;
	DECLARE v_honors INT;
   
   SELECT COUNT(*) INTO v_enrolled
   FROM students_groups sg
   WHERE sg.group_id = p_group_id;
   
   SET v_honors = FLOOR(0.05 * v_enrolled);
   
   IF v_honors > 0 THEN
   
   	UPDATE grades
      SET with_honors = 0
      WHERE group_id = p_group_id
      		AND exam_call = p_exam_call;
      
         
      UPDATE grades g
      SET g.with_honors = 1
      WHERE g.grade_value >= 9.0
      		AND grade_id IN (
      			SELECT t.grade_id
         		FROM (SELECT g2.grade_id 
         			FROM grades g2
         			WHERE g2.group_id = p_group_id
         					AND g2.exam_call = p_exam_call
         			ORDER BY g2.grade_value DESC
         			LIMIT v_honors) 
               	AS t
      );
   	
      
      
   ELSE
   	SELECT CONCAT('El 5% de ', v_enrolled, ' alumnos es 0.')
      			AS mensaje;
   END IF;
   
END //
DELIMITER ;










-- =====================================================================
-- L7: transactions
-- =====================================================================

-- p_insert_degree_subject: inserts a degree and one subject of that degree (no transaction)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_degree_subject (
	IN p_degree_name VARCHAR(80),
   IN p_degree_years TINYINT,
   IN p_subject_name VARCHAR(120),
   IN p_subject_acronym VARCHAR(12),
   IN p_subject_credits TINYINT,
   IN p_subject_course TINYINT,
   IN p_subject_type VARCHAR(30)
)
BEGIN
   INSERT INTO degrees (degree_name, duration_years) VALUES
   	(p_degree_name, p_degree_years);
      
   INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type) VALUES
   	(LAST_INSERT_ID(), p_subject_name, p_subject_acronym, p_subject_credits, p_subject_course, p_subject_type);
END //
DELIMITER ;

-- p_insert_degree_subject_transactional: same insertions, atomic (EXIT handler + transaction + CALL)
DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_degree_subject_transactional (
	IN p_degree_name VARCHAR(80),
	IN p_degree_years TINYINT,
	IN p_subject_name VARCHAR(120),
	IN p_subject_acronym VARCHAR(12),
	IN p_subject_credits TINYINT,
	IN p_subject_course TINYINT,
	IN p_subject_type VARCHAR(30)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
   	ROLLBACK;
      RESIGNAL;   		
   END;
      
	START TRANSACTION;
   
   CALL p_insert_degree_subject(p_degree_name, p_degree_years, p_subject_name, p_subject_acronym, p_subject_credits, p_subject_course, p_subject_type);
   
   COMMIT;
   
END //
DELIMITER ;








-- p_transfer_student: moves a student from one group to another (DELETE old + INSERT new), atomic

