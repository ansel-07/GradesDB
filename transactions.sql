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
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors) VALUES
    (6, 1, 7, 'Extraordinaria', 0),
    (7, 1, 8, 'Extraordinaria', 0);

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
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors) VALUES
    (6, 1, 7, 'Extraordinaria', 0);
    
SELECT @@in_transaction;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors) VALUES
    (7, 1, 8, 'Extraordinaria', 0);

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
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors) VALUES
    (6, 1, 7, 'Extraordinaria', 0);

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


