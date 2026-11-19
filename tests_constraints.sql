USE grades_db;

/*
Manejador de excepciones:
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	sentencia;
   
Estructura de un test:
1. Manejador de excepciones
2. CALL p_populate();
3. Operación prohibida
4. Anotar FAIL si se llega a este paso sin error.
*/


-- ============================================================================
-- Tabla de resultados: test_results
-- ============================================================================

CREATE OR REPLACE TABLE test_results (
	test_id VARCHAR(20),
   test_name VARCHAR(200) NOT NULL,
   test_message VARCHAR(500) NOT NULL,
   test_status ENUM('PASS', 'FAIL') NOT NULL,
   execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (test_id)
);


-- ============================================================================
-- Procedimiento auxiliar: p_log_test
-- ============================================================================

DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test (
	IN p_test_id VARCHAR(20),
   IN p_message VARCHAR(500),
   IN p_status ENUM('PASS', 'FAIL')
)
BEGIN
	
   INSERT INTO test_results (test_id, test_name, test_message, test_status) VALUES
   	(p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
   
END //
DELIMITER ;



-- ============================================================================
-- Tests de las restricciones declarativas
-- ============================================================================

-- Test RN01: Matrícula de honor
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_mh_requirement()
BEGIN
	DECLARE v_test_id VARCHAR(20) DEFAULT 'RN01';
   DECLARE v_message VARCHAR(500) DEFAULT 'Solo una nota con valor mayor o igual a 9 puede tener matrícula de honor.';
   
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
   
   CALL p_populate();
   
   UPDATE grades g
   SET g.with_honors = 1
   WHERE g.grade_id = 3;
      
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN09: Atributos obligatorios
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn09_not_null_attributes()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN09';
   DECLARE v_message VARCHAR(500) DEFAULT 'Una persona no puede tener atributos nulos.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
   
   CALL p_populate();
   
   INSERT INTO people (dni, first_name, last_name, age, email) VALUES
   	(NULL, NULL, NULL, NULL, NULL);
   
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
END //
DELIMITER ;

-- Test RN10: Créditos de asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn10_subject_credits()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN10';
   DECLARE v_message VARCHAR(500) DEFAULT 'Una asignatura solo puede tener 6 o 12 créditos.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
   INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type) VALUES
   	(1, 'Asignatura de prueba', 'ADP', 2, 1, 'Obligatoria');
      
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN11: Rango de notas
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn11_grade_range()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN11';
   DECLARE v_message VARCHAR(500) DEFAULT 'Una nota no puede tener valor mayor a 10.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
   UPDATE grades g
   SET g.grade_value = 11
   WHERE g.grade_id = 3;
   
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN12: Edad de las personas
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn12_people_age()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN12';
   DECLARE v_message VARCHAR(500) DEFAULT 'Las personas deben tener entre 16 y 70 años.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
   INSERT INTO people (dni, first_name, last_name, age, email) VALUES
   	('12345678A', 'Pepe', 'Macías', 75, 'queeseso@lol.xd');
   
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN13: Años del grado
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn13_degree_years()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN13';
   DECLARE v_message VARCHAR(500) DEFAULT 'Los grados deben tener una duración de entre 3 y 6 años.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
   INSERT INTO degrees (degree_name, duration_years) VALUES
   	('Ingeniería promedio', 8);
    
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN14: Formato del DNI
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn14_dni_format()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN14';
   DECLARE v_message VARCHAR(500) DEFAULT 'El DNI de una persona debe estar compuesto por 8 dígitos y 1 letra.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
   INSERT INTO people (dni, first_name, last_name, age, email) VALUES
   	('123456789', 'Pepe', 'Macías', 40, 'queeseso@lol.xd');
    
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN15: Rango año académico
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn15_academic_year()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN15';
   DECLARE v_message VARCHAR(500) DEFAULT 'El año académico de un grupo debe estar entre el 2000 y el 2100.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
	INSERT INTO groups (subject_id, group_name, activity, academic_year) VALUES
   	(11, 'T1', 'Teoría', 2126);
    
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;

-- Test RN16: Curso de asignatura
DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn16_course_range()
BEGIN
	
   DECLARE v_test_id VARCHAR(20) DEFAULT 'RN16';
   DECLARE v_message VARCHAR(500) DEFAULT 'Una asignatura debe ser de un curso entre el 1 y el 6.';
   
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	CALL p_log_test(v_test_id, CONCAT(v_test_id, ': ', v_message), 'PASS');
      
   CALL p_populate();
   
	INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type) VALUES
   	(1, 'Asignatura de prueba', 'ADP', 6, 10, 'Obligatoria');
    
   CALL p_log_test(v_test_id, CONCAT('ERROR: ', v_message), 'FAIL');
   
END //
DELIMITER ;



-- ============================================================================
-- Orquestador: p_run_tests
-- ============================================================================
DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
	
   DELETE FROM test_results;
   
   CALL p_test_rn01_mh_requirement();
  	CALL p_test_rn09_not_null_attributes();
  	CALL p_test_rn10_subject_credits();
  	CALL p_test_rn11_grade_range();
  	CALL p_test_rn12_people_age();
  	CALL p_test_rn13_degree_years();
  	CALL p_test_rn14_dni_format();
  	CALL p_test_rn15_academic_year();
  	CALL p_test_rn16_course_range();
   
	SELECT * FROM test_results ORDER BY execution_time, test_id;  
   
   SELECT test_status, COUNT(*) AS total
   FROM test_results
   GROUP BY test_status;
END //
DELIMITER ;



-- ============================================================================
-- Ejecución de los tests
-- ============================================================================
CALL p_run_tests();

