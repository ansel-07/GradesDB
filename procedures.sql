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

-- Ejemplo 4: Procedimiento para subir notas de un grupo


-- Ejemplo 5: Procedimiento para asignar matrículas de honor
