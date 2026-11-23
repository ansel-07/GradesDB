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

-- 2. Call with valid data

-- 3. Check the new degree and its subjects

-- 4. Reset data

-- 5. Call with a repeated acronym ('FP')

-- 6. Check the new degree and its subjects


-- =====================================================================
-- Experiment 7: p_insert_degree_subject_transactional
-- =====================================================================

-- 1. Reset data

-- 2. Call with valid data

-- 3. Check the new degree and its subjects

-- 4. Reset data

-- 5. Call with a repeated acronym ('FP')

-- 6. Check the new degree and its subjects

