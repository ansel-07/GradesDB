-- triggers.sql: triggers for the business rules of grades_db (L5)

USE grades_db;

-- t_biu_students_rn08: RN08, a student accessing through 'Selectividad' must be at least 16
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_students_rn08
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN
	DECLARE v_age INT;
   
   SELECT age INTO v_age
   FROM people
   WHERE person_id = NEW.student_id;
   
   IF NEW.access_method = 'Selectividad'
   	AND v_age < 16 THEN
   
   	SIGNAL SQLSTATE '45000'
      	SET MESSAGE_TEXT = 'RN08: A student accessing through Selectividad must be at least 16.';
   END IF;
END //
DELIMITER ;


-- t_biu_grades_rn02: RN02, a student can only have grades in groups they belong to
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_grades_rn02
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
	DECLARE v_enrolled BOOLEAN;
   
   SELECT COUNT(*) > 0 INTO v_enrolled
   FROM students_groups
   WHERE student_id = NEW.student_id
   		AND group_id = NEW.group_id;
         
   IF v_enrolled = 0 THEN
   	SIGNAL SQLSTATE '45000'
      	SET MESSAGE_TEXT = 'RN02: A student can only have grades in groups they belong to.';
   END IF;
END //
DELIMITER ;

-- t_biu_grades_rn17: RN17, only one grade per student, subject, exam call and academic year
DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_grades_rn17
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
	DECLARE v_count_grades INT;
   DECLARE v_subject_id INT;
   DECLARE v_academic_year YEAR;
   
   SELECT subject_id, academic_year
   INTO v_subject_id, v_academic_year
   FROM groups
   WHERE group_id = NEW.group_id;
   
   SELECT COUNT(*) INTO v_count_grades
   FROM grades g
   JOIN groups gr ON g.group_id = gr.group_id
   WHERE g.student_id = NEW.student_id
   		AND gr.subject_id = v_subject_id
         AND g.exam_call = NEW.exam_call
         AND gr.academic_year = v_academic_year
         AND g.grade_id <> NEW.grade_id;
         
   IF v_count_grades > 0 THEN
   	SIGNAL SQLSTATE '45000'
      	SET MESSAGE_TEXT = 'RN17: There can only be one grade per student, subject, exam call and academic year.';
   END IF;
END //
DELIMITER ;

-- t_bu_grades_rn05: RN05, a grade cannot change by more than 4 points
DELIMITER //
CREATE OR REPLACE TRIGGER t_bu_grades_rn05
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
	DECLARE v_difference DECIMAL(4,2);
   
   SET v_difference = ABS(NEW.grade_value - OLD.grade_value);
   
   IF v_difference > 4 THEN
   	SIGNAL SQLSTATE '45000'
      	SET MESSAGE_TEXT = 'RN05: A grade cannot change by more than 4 points.';
   END IF;
END //
DELIMITER ;

-- =====================================================================
-- Checks (run after populate_db.sql and populate_db2.sql, one by one)
-- =====================================================================

-- RN08: new person 26 (age 18) as a 'Selectividad' student (must work)
INSERT INTO people (person_id, dni, first_name, last_name, age, email) VALUES
	(26, '12345678Z', 'Pepe', 'Pepe Pepe', 18, 'pepe@pepe.pepe');

INSERT INTO students (student_id, access_method) VALUES
	(26, 'Selectividad');
   
-- RN02: grade for student 6 in group 3 (must fail)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
	(6, 3, 5, 'Extraordinaria');

-- RN02: 'Segunda' grade for student 6 in group 5 (must work)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
	(6, 5, 5, 'Segunda');

-- RN17: 'Primera' grade for student 6 in group 2 (must fail)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
	(6, 2, 5, 'Primera');

-- RN05: change grade 3 to 9.5 (must fail)
UPDATE grades g
SET g.grade_value = 9.5
WHERE g.grade_id = 3;

-- RN05: change grade 3 to 9.4 (must work)
UPDATE grades g
SET g.grade_value = 9.4
WHERE g.grade_id = 3;

