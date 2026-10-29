SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS degrees;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS students_groups;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS students_subjects;
DROP TABLE IF EXISTS teaching_loads;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE people (
    person_id INT AUTO_INCREMENT,
    dni CHAR(9) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    age TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (person_id)
);


CREATE TABLE professors (
    professor_id INT,
    category VARCHAR(30) NOT NULL,
    PRIMARY KEY (professor_id),
    FOREIGN KEY (professor_id) REFERENCES people(person_id)
);


CREATE TABLE students (
	student_id INT,
   access_method VARCHAR(20) NOT NULL,
   PRIMARY KEY (student_id),
   FOREIGN KEY (student_id) REFERENCES people(person_id)
);

CREATE TABLE degrees (
	degree_id INT AUTO_INCREMENT,
   degree_name VARCHAR(80) NOT NULL,
   duration_years TINYINT NOT NULL,
   PRIMARY KEY (degree_id)
);

CREATE TABLE subjects (
	subject_id INT AUTO_INCREMENT,
   degree_id INT NOT NULL,
   subject_name VARCHAR(120) NOT NULL,
   acronym VARCHAR(12) NOT NULL,
   credits TINYINT NOT NULL,
   course TINYINT NOT NULL,
   subject_type VARCHAR(30) NOT NULL,
   PRIMARY KEY (subject_id),
   FOREIGN KEY (degree_id) REFERENCES degrees(degree_id)
);

CREATE TABLE groups (
	group_id INT AUTO_INCREMENT,
   subject_id INT NOT NULL,
   group_name VARCHAR(40) NOT NULL,
   activity VARCHAR(15) NOT NULL,
   academic_year YEAR NOT NULL,
   PRIMARY KEY (group_id),
   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE students_groups (
	student_group_id INT AUTO_INCREMENT,
   student_id INT NOT NULL,
   group_id INT NOT NULL,
   PRIMARY KEY (student_group_id),
   CONSTRAINT uq_students_groups UNIQUE (student_id, group_id),
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (group_id) REFERENCES groups(group_id)
);

CREATE TABLE grades (
	grade_id INT AUTO_INCREMENT,
   student_id INT NOT NULL,
   group_id INT NOT NULL,
   grade_value DECIMAL(4,2) NOT NULL,
   exam_call VARCHAR(20) NOT NULL,
   with_honors BOOLEAN NOT NULL DEFAULT 0,
   PRIMARY KEY (grade_id),
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (group_id) REFERENCES groups(group_id)
);

CREATE TABLE students_subjects (
	student_subject_id INT AUTO_INCREMENT,
   student_id INT NOT NULL,
   subject_id INT NOT NULL,
   PRIMARY KEY (student_subject_id),
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
   CONSTRAINT uq_students_subjects UNIQUE (student_id, subject_id)
);

CREATE TABLE teaching_loads (
	teaching_load_id INT AUTO_INCREMENT,
   professor_id INT NOT NULL,
   group_id INT NOT NULL,
   credits DECIMAL(4,1) NOT NULL,
   PRIMARY KEY (teaching_load_id),
   FOREIGN KEY (professor_id) REFERENCES professors(professor_id),
   FOREIGN KEY (group_id) REFERENCES groups(group_id),
   CONSTRAINT uq_teaching_loads UNIQUE (professor_id, group_id)
);



-- LABORATORIO 2

-- ALTER TABLE nombre_tabla
--	  ADD CONSTRAINT restriccion1 TIPO (...),
--   ADD CONSTRAINT restriccion2 TIPO (...);

-- CHECK x BETWEEN a AND b

-- CHECK texto REGEXP 'expresion regular'
/* '^' inicio del texto
-- '$' fin del texto
-- '[0-9]' dígito
-- '[0-9]{n}' n dígitos
-- '[A-Za-z]' letra mayúscula o minúscula
*/

-- Convención para nombrar restricciones:
-- CHECK: ck_nombre_tabla_regla_atributo
-- 		tipos de check: UNIQUE, NOT NULL, IN...
-- UNIQUE: uq_nombre_tabla_regla_atributo


ALTER TABLE people
	ADD CONSTRAINT ck_people_rn12_age CHECK (age BETWEEN 16 AND 70),
   ADD CONSTRAINT ck_people_rn14_dni CHECK (dni REGEXP '^[0-9]{8}[A-Za-z]$'),
   ADD CONSTRAINT uq_people_dni UNIQUE (dni),
   ADD CONSTRAINT uq_people_email UNIQUE (email);
   

ALTER TABLE professors
	ADD CONSTRAINT ck_professors_category CHECK (category IN ('Ayudante', 'AyudanteDoctor', 'Titular', 'Catedrático'));

ALTER TABLE students
	ADD CONSTRAINT ck_students_access_method CHECK (access_method IN ('Selectividad', 'Ciclo', 'Mayor', 'Titulado', 'Extranjero'));
