-- functions.sql: auxiliary functions for the business rules of grades_db (L5)

USE grades_db;

-- f_student_average: average grade of a student (0 if the student has no grades)
DELIMITER //
CREATE OR REPLACE FUNCTION f_student_average (
	p_student_id INT
)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_average DECIMAL(4,2) DEFAULT 0;
   DECLARE v_count_grades INT;
   
   SELECT COUNT(*) INTO v_count_grades
   FROM grades
   WHERE student_id = p_student_id;
   
   IF v_count_grades > 0 THEN
   	SELECT AVG(grade_value) INTO v_average
   	FROM grades
   	WHERE student_id = p_student_id;
   END IF;
   
   RETURN v_average;
END //
DELIMITER ;

-- f_is_student_enrolled: TRUE if the student is enrolled in the subject
DELIMITER //
CREATE OR REPLACE FUNCTION f_is_student_enrolled (
	p_student_id INT,
   p_subject_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_enrolled BOOLEAN DEFAULT 0;
   
   SELECT COUNT(*) > 0 INTO v_enrolled
   FROM students_subjects ss
   WHERE ss.student_id = p_student_id
   		AND ss.subject_id = p_subject_id;
         
   RETURN v_enrolled;
END //
DELIMITER ;

-- f_subject_group_limit_reached: TRUE if the subject already has the maximum number of groups
-- of that activity in that academic year (Teoría: 1, Laboratorio: 2)
DELIMITER //
CREATE OR REPLACE FUNCTION f_subject_group_limit_reached (
	p_subject_id INT,
   p_activity VARCHAR(15),
   p_academic_year YEAR
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_count_groups INT;
   DECLARE v_max_groups INT DEFAULT 1;
   
   IF p_activity = 'Laboratorio' THEN
   	SET v_max_groups = 2;
   END IF;
   
   SELECT COUNT(*) INTO v_count_groups
   FROM groups gr
   WHERE gr.subject_id = p_subject_id
   		AND gr.activity = p_activity
         AND gr.academic_year = p_academic_year;
   
   RETURN v_count_groups >= v_max_groups;
END //
DELIMITER ;

-- f_student_group_limit: TRUE if the student already belongs to a group of that activity
-- in that subject (maximum: 1)
DELIMITER //
CREATE OR REPLACE FUNCTION f_student_group_limit (
	p_student_id INT,
   p_subject_id INT,
   p_activity VARCHAR(15)
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_enrolled_groups INT DEFAULT 0;
   
   SELECT COUNT(*) INTO v_enrolled_groups
   FROM students_groups sg
   JOIN groups gr ON sg.group_id = gr.group_id
   WHERE sg.student_id = p_student_id
   		AND gr.subject_id = p_subject_id
         AND gr.activity = p_activity;
         
   RETURN v_enrolled_groups >= 1;
END //
DELIMITER ;

-- =====================================================================
-- Checks (run after populate_db.sql and populate_db2.sql)
-- =====================================================================

-- Average of students 6, 16 and 99
SELECT f_student_average(6) AS average;
SELECT f_student_average(16) AS average;
SELECT f_student_average(99) AS average;

-- Is student 6 enrolled in subjects 1 and 3?
SELECT f_is_student_enrolled(6, 1) AS enrolled;
SELECT f_is_student_enrolled(6, 3) AS enrolled;

-- Group limit reached: subject 1, Teoría 2024 / Laboratorio 2024 / Laboratorio 2023 / Teoría 2025
SELECT f_subject_group_limit_reached(1, 'Teoría', 2024) AS limit_reached;
SELECT f_subject_group_limit_reached(1, 'Laboratorio', 2024) AS limit_reached;
SELECT f_subject_group_limit_reached(1, 'Laboratorio', 2023) AS limit_reached;
SELECT f_subject_group_limit_reached(1, 'Teoría', 2025) AS limit_reached;

-- Student group limit: student 6, subject 1, Teoría / student 11, subject 1, Laboratorio
SELECT f_student_group_limit(6, 1, 'Teoría') AS group_limit;
SELECT f_student_group_limit(11, 1, 'Laboratorio') AS group_limit;

