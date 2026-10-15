 -- Primero eliminados todos los datos de tabla en el caso de que los hubiese y despu?s insertamos los datos iniciales.
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM people;
DELETE FROM professors;
DELETE FROM students;
DELETE FROM degreess;
DELETE FROM subjects;
SET FOREIGN_KEY_CHECKS = 1;
	
INSERT INTO people (person_id, dni, first_name, last_name, age, email) VALUES
    (1, '00000001A', 'David', 'Ruiz', 50, 'druiz@us.es'),
    (2, '00000002B', 'Inma', 'Hern?ndez', 40, 'inmahernandez@us.es'),
    (3, '00000003C', 'Fernando', 'Sola', 28, 'fsola@us.es'),
    (4, '00000004D', 'Daniel', 'Ayala', 32, 'dayala1@us.es'),
    (5, '00000005E', 'Pepe', 'Calder?n', 43, 'pepecalderon@us.es'),
    (6, '10000006F', 'David', 'Romero', 22, 'david.romero@alum.us.es'),
    (7, '10000007G', 'Luc?a', 'Molina', 21, 'lucia.molina@alum.us.es'),
    (8, '10000008H', 'Hugo', 'Paredes', 20, 'hugo.paredes@alum.us.es'),
    (9, '10000009J', 'Sara', 'Campos', 21, 'sara.campos@alum.us.es'),
    (10, '10000010K', 'Mario', 'Gal?n', 22, 'mario.galan@alum.us.es'),
    (11, '10000011L', 'Elena', 'Torres', 21, 'elena.torres@alum.us.es'),
    (12, '10000012M', 'Rub?n', 'Dur?n', 20, 'ruben.duran@alum.us.es'),
    (13, '10000013N', 'Claudia', 'Soto', 23, 'claudia.soto@alum.us.es'),
    (14, '10000014P', 'Iv?n', 'Cuesta', 22, 'ivan.cuesta@alum.us.es'),
    (15, '10000015Q', 'Noelia', 'Rey', 21, 'noelia.rey@alum.us.es'),
    (16, '10000016R', 'Pablo', 'Vidal', 22, 'pablo.vidal@alum.us.es'),
    (17, '10000017S', 'Alicia', 'Mu?oz', 21, 'alicia.munoz@alum.us.es'),
    (18, '10000018T', 'Sergio', 'Izquierdo', 22, 'sergio.izquierdo@alum.us.es'),
    (19, '10000019U', 'Nerea', 'Saiz', 20, 'nerea.saiz@alum.us.es'),
    (20, '10000020V', '?lvaro', 'Le?n', 23, 'alvaro.leon@alum.us.es'),
    (21, '10000021W', 'Julia', 'Benito', 21, 'julia.benito@alum.us.es'),
    (22, '10000022X', 'Tom?s', 'Rubio', 22, 'tomas.rubio@alum.us.es'),
    (23, '10000023Y', 'Irene', 'Salas', 21, 'irene.salas@alum.us.es'),
    (24, '10000024Z', '?lex', 'Delgado', 22, 'alex.delgado@alum.us.es'),
    (25, '10000025A', 'Paula', 'Bermejo', 21, 'paula.bermejo@alum.us.es');

INSERT INTO professors (professor_id, category) VALUES
    (1, 'Catedr?tico'),
    (2, 'Titular'),
    (3, 'AyudanteDoctor'),
    (4, 'Titular'),
    (5, 'Ayudante');
    

INSERT INTO students (student_id, access_method) VALUES
    (6, 'Selectividad'),
    (7, 'Selectividad'),
    (8, 'Selectividad'),
    (9, 'Selectividad'),
    (10, 'Selectividad'),
    (11, 'Selectividad'),
    (12, 'Selectividad'),
    (13, 'Selectividad'),
    (14, 'Selectividad'),
    (15, 'Selectividad'),
    (16, 'Selectividad'),
    (17, 'Selectividad'),
    (18, 'Selectividad'),
    (19, 'Selectividad'),
    (20, 'Selectividad'),
    (21, 'Selectividad'),
    (22, 'Selectividad'),
    (23, 'Selectividad'),
    (24, 'Selectividad'),
    (25, 'Selectividad');

INSERT INTO degreess (degree_id, degree_name, duration_years) VALUES
        (1, 'Ingenier?a del Software', 4),
        (2, 'Ingenier?a de Computadores', 4),
        (3, 'Tecnolog?as Inform?ticas', 4);


INSERT INTO subjects (
    subject_id,
    degree_id,
    subject_name,
    acronym,
    credits,
    course,
    subject_type
) VALUES
    -- Primer curso (Tecnolog?as Inform?ticas)
    (1, 3, 'Fundamentos de Programaci?n', 'FP', 12, 1, 'Formaci?n B?sica'),
    (2, 3, 'C?lculo Infinitesimal y Num?rico', 'CIN', 6, 1, 'Formaci?n B?sica'),
    (3, 3, 'Circuitos Electr?nicos Digitales', 'CED', 6, 1, 'Formaci?n B?sica'),
    (4, 3, 'Fundamentos F?sicos de la Inform?tica', 'FFI', 6, 1, 'Formaci?n B?sica'),
    (5, 3, 'Introducci?n a la Matem?tica Discreta', 'IMD', 6, 1, 'Formaci?n B?sica'),
    (6, 3, 'Administraci?n de Empresas', 'ADE', 6, 1, 'Formaci?n B?sica'),
    (7, 3, '?lgebra Lineal y Num?rica', 'ALN', 6, 1, 'Formaci?n B?sica'),
    (8, 3, 'Estad?stica', 'EST', 6, 1, 'Formaci?n B?sica'),
    (9, 3, 'Estructura de Computadores', 'EC', 6, 1, 'Formaci?n B?sica'),
    -- Segundo curso (Tecnolog?as Inform?ticas)
    (10, 3, 'An?lisis y Dise?o de Datos y Algoritmos', 'ADDA', 12, 2, 'Obligatoria'),
    (11, 3, 'Introducci?n a la Ingenier?a del Software y los Sistemas de Informaci?n I', 'IISSI-1', 6, 2, 'Obligatoria'),
    (12, 3, 'Matem?tica Discreta', 'MD', 6, 2, 'Obligatoria'),
    (13, 3, 'Redes de Computadores', 'RC', 6, 2, 'Obligatoria'),
    (14, 3, 'Arquitectura de Computadores', 'AC', 6, 2, 'Obligatoria'),
    (15, 3, 'Introducci?n a la Ingenier?a del Software y los Sistemas de Informaci?n II', 'IISSI-2', 6, 2, 'Obligatoria'),
    (16, 3, 'Sistemas Operativos', 'SO', 6, 2, 'Obligatoria'),
    (17, 3, 'Inteligencia Artificial', 'IA', 6, 2, 'Obligatoria');
    
    
SELECT COUNT(*) FROM degreess;
SELECT COUNT(*) FROM subjects;
