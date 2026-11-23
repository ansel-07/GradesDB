-- transactions.sql: transaction control experiments (L7)

USE grades_db;

-- =====================================================================
-- Experiment 1: autocommit on
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Check @@autocommit
SELECT @@autocommit;

-- 3. Open a transaction and check @@in_transaction
START TRANSACTION;
SELECT @@in_transaction;

-- 4. Insert two 'Extraordinaria' grades in group 1 (student 6: 7, student 7: 8)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (6, 1, 7, 'Extraordinaria'),
    (7, 1, 8, 'Extraordinaria');

-- 5. Undo the transaction and check @@in_transaction
ROLLBACK;
SELECT @@in_transaction;

-- 6. Check 'Extraordinaria' grades of students 6 and 7
SELECT * 
FROM grades 
WHERE exam_call = 'Extraordinaria'
		AND student_id IN (6, 7);

-- =====================================================================
-- Experiment 2: autocommit off
-- =====================================================================

-- 1. Reset data (autocommit still on)
CALL p_populate();

-- 2. Disable autocommit
SET autocommit = 0;

-- 3. Insert the same two grades (no START TRANSACTION); check @@in_transaction after the first INSERT
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (6, 1, 7, 'Extraordinaria');
    
SELECT @@in_transaction;

INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (7, 1, 8, 'Extraordinaria');

-- 4. Undo the changes
ROLLBACK;

-- 5. Check 'Extraordinaria' grades of students 6 and 7
SELECT * 
FROM grades 
WHERE exam_call = 'Extraordinaria'
		AND student_id IN (6, 7);

-- =====================================================================
-- Experiment 3: START TRANSACTION commits the open transaction
-- =====================================================================

-- 1. Reset data (autocommit still off)
CALL p_populate();

-- 2. Insert the 'Extraordinaria' grade of student 6 (group 1: 7)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (6, 1, 7, 'Extraordinaria');

-- 3. START TRANSACTION
START TRANSACTION;

-- 4. Undo the changes
ROLLBACK;

-- 5. Check 'Extraordinaria' grades of student 6
SELECT * 
FROM grades 
WHERE exam_call = 'Extraordinaria'
		AND student_id = 6;

-- 6. Re-enable autocommit
SET autocommit = 1;


-- =====================================================================
-- Experiment 4: errors inside a transaction (non-atomic script)
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Open a transaction
START TRANSACTION;

-- 3. Insert three 'Extraordinaria' grades in group 1, one INSERT each (student 6: 7, student 7: 8, student 8: -1)
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (6, 1, 7, 'Extraordinaria');
    
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (7, 1, 8, 'Extraordinaria');
    
INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    (8, 1, -1, 'Extraordinaria');

-- 4. Confirm the transaction
COMMIT;

-- 5. Check 'Extraordinaria' grades of students 6, 7 and 8
SELECT * 
FROM grades 
WHERE exam_call = 'Extraordinaria'
		AND student_id IN (6, 7, 8);

-- =====================================================================
-- Experiment 5: atomic insertion with an anonymous block
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Anonymous block: EXIT handler (ROLLBACK + RESIGNAL), transaction, the same three INSERTs, COMMIT
DELIMITER //
BEGIN NOT ATOMIC
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
   	ROLLBACK;
      RESIGNAL;
   END;
   
   START TRANSACTION;
   
   INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    	(6, 1, 7, 'Extraordinaria');
    
	INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    	(7, 1, 8, 'Extraordinaria');
    
	INSERT INTO grades (student_id, group_id, grade_value, exam_call) VALUES
    	(8, 1, -1, 'Extraordinaria');
      
   COMMIT;
   
END //
DELIMITER ;

-- 3. Check 'Extraordinaria' grades of students 6, 7 and 8
SELECT * 
FROM grades 
WHERE exam_call = 'Extraordinaria'
		AND student_id IN (6, 7, 8);




-- =====================================================================
-- Experiment 6: p_insert_degree_subject (non-transactional)
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Call with valid data
CALL p_insert_degree_subject('Grado en Inteligencia Artificial', 4, 'Aprendizaje Automático', 'AA', 6, 3, 'Obligatoria');

-- 3. Check the new degree and its subjects
SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE subject_name = 'Aprendizaje Automático';

-- 4. Reset data
CALL p_populate();

-- 5. Call with a repeated acronym ('FP')
CALL p_insert_degree_subject('Grado en Inteligencia Artificial', 4, 'Aprendizaje Automático', 'FP', 6, 3, 'Obligatoria');

-- 6. Check the new degree and its subjects
SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE subject_name = 'Aprendizaje Automático';

-- =====================================================================
-- Experiment 7: p_insert_degree_subject_transactional
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Call with valid data
CALL p_insert_degree_subject_transactional('Grado en Inteligencia Artificial', 4, 'Aprendizaje Automático', 'AA', 6, 3, 'Obligatoria');

-- 3. Check the new degree and its subjects
SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE subject_name = 'Aprendizaje Automático';

-- 4. Reset data
CALL p_populate();

-- 5. Call with a repeated acronym ('FP')
CALL p_insert_degree_subject_transactional('Grado en Inteligencia Artificial', 4, 'Aprendizaje Automático', 'FP', 6, 3, 'Obligatoria');

-- 6. Check the new degree and its subjects
SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE subject_name = 'Aprendizaje Automático';


-- =====================================================================
-- Experiment 8: concurrency with REPEATABLE READ (two HeidiSQL connections: A and B)
-- =====================================================================

-- 1. (A) Reset data
CALL p_populate();

-- 2. (A and B) Check the connection id (must differ)
SELECT CONNECTION_ID();

-- 3. (B) Set the isolation level to REPEATABLE READ and open a transaction
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

-- 4. (B) Read grade 3
SELECT * FROM grades WHERE grade_id = 3;

-- 5. (A) Add 1 to grade 3
UPDATE grades g
SET g.grade_value = g.grade_value + 1
WHERE g.grade_id = 3;

-- 6. (B) Read grade 3
SELECT * FROM grades WHERE grade_id = 3;

-- 7. (B) Confirm the transaction and read grade 3
COMMIT;
SELECT * FROM grades WHERE grade_id = 3;


-- =====================================================================
-- Experiment 9: concurrency with READ COMMITTED
-- =====================================================================

-- 1. (A) Reset data
CALL p_populate();

-- 2. (B) Set the isolation level to READ COMMITTED and open a transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

-- 3. (B) Read grade 3
SELECT * FROM grades WHERE grade_id = 3;

-- 4. (A) Add 1 to grade 3
UPDATE grades g
SET g.grade_value = g.grade_value + 1
WHERE g.grade_id = 3;

-- 5. (B) Read grade 3
SELECT * FROM grades WHERE grade_id = 3;

-- 6. (B) Confirm the transaction and read grade 3
COMMIT;
SELECT * FROM grades WHERE grade_id = 3;


-- =====================================================================
-- Exercise 1: p_transfer_student
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Move student 6 from group 2 to group 3
CALL p_transfer_student(6, 2, 3);

-- 3. Check the groups of student 6
SELECT * FROM students_groups WHERE student_id = 6;

-- 4. Reset data
CALL p_populate();

-- 5. Move student 6 from group 2 to group 1 (already in group 1)
CALL p_transfer_student(6, 2, 1);

-- 6. Check the groups of student 6
SELECT * FROM students_groups WHERE student_id = 6;




-- =====================================================================
-- Exercise 2: p_update_grade_with_history
-- =====================================================================

-- 1. Reset data
CALL p_populate();

-- 2. Change grade 3 to 6.5
CALL p_update_grade_with_history(3, 6.5);

-- 3. Check grade 3 and its history
SELECT * FROM grades WHERE grade_id = 3;
SELECT * FROM grade_history WHERE grade_id = 3;

-- 4. Reset data
CALL p_populate();

-- 5. Change grade 3 to 11 (breaks RN11)
CALL p_update_grade_with_history(3, 11);

-- 6. Check grade 3 and its history
SELECT * FROM grades WHERE grade_id = 3;
SELECT * FROM grade_history WHERE grade_id = 3;



-- =====================================================================
-- Exercise 3: predict and check what B reads (two connections: A and B)
-- Run it twice: first with REPEATABLE READ, then with READ COMMITTED
-- =====================================================================

-- 1. (A) Reset data
CALL p_populate();

-- 2. (B) Set the isolation level
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 3. (B) Open a transaction
START TRANSACTION;

-- 4. (A) Open a transaction
START TRANSACTION;

-- 5. (A) Set grade 1 to 9
UPDATE grades g
SET g.grade_value = 9
WHERE g.grade_id = 1;

-- 6. (B) Read grade 1 -> (a)
SELECT * FROM grades WHERE grade_id = 1;

-- 7. (A) Confirm the transaction
COMMIT;

-- 8. (B) Read grade 1 -> (b)
SELECT * FROM grades WHERE grade_id = 1;

-- 9. (B) Confirm the transaction
COMMIT;

-- 10. (B) Read grade 1 -> (c)
SELECT * FROM grades WHERE grade_id = 1;

-- Results:
-- REPEATABLE READ: (a) = 9.8  (b) = 9.8  (c) = 9.0
-- READ COMMITTED:  (a) = 9.8  (b) = 9.0  (c) = 9.0
/*
In REPEATABLE READ, connection B still sees the
old value until they commit themselves.
In READ COMMITTED, connection B receives the
new value as soon as connection A commits.
*/
