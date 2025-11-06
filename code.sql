/*CREATE DATABASE FACEBOOK; 
USE FACEBOOK;

CREATE TABLE Usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    U_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(70) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    email_verified BOOL,
    register_date DATETIME DEFAULT CURRENT_TIMESTAMP  
);

CREATE TABLE U_profile (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    id_Usuario INT NOT NULL,
    profile_name VARCHAR(250) NOT NULL,
    presentation VARCHAR(120),
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_Usuario) REFERENCES Usuario(id)
);

CREATE TABLE type_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_detail VARCHAR(50) NOT NULL
);

CREATE TABLE details_profile (
    details_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    type_details_id INT NOT NULL,
    detail_value VARCHAR(100),
    FOREIGN KEY (profile_id) REFERENCES U_profile(profile_id),
    FOREIGN KEY (type_details_id) REFERENCES type_details(id)
);

CREATE TABLE Media (
    Media_id INT PRIMARY KEY AUTO_INCREMENT,
    type_media VARCHAR(40) NOT NULL,
    Size INT NOT NULL DEFAULT 0
);

CREATE TABLE type_post (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_post VARCHAR(50) NOT NULL
);

CREATE TABLE posts (
    posts_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    Text_content VARCHAR(500),
    post_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    visibility VARCHAR(20) NOT NULL DEFAULT 'public',
    Media_id INT,
    id_type_post INT,
    FOREIGN KEY (profile_id) REFERENCES U_profile(profile_id),
    FOREIGN KEY (Media_id) REFERENCES Media(Media_id),
    FOREIGN KEY (id_type_post) REFERENCES type_post(id)
);

CREATE TABLE F_groups (
    id_groups INT PRIMARY KEY AUTO_INCREMENT,
    name_group VARCHAR(200) NOT NULL,
    group_description VARCHAR(500),
    Privacy VARCHAR(20) NOT NULL DEFAULT 'public',
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    rules VARCHAR(200)
);

CREATE TABLE group_members (
    id_group_members INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    id_groups INT NOT NULL,
    g_role VARCHAR(250),
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES U_profile(profile_id),
    FOREIGN KEY (id_groups) REFERENCES F_groups(id_groups)
);

CREATE TABLE friendship (
    id_friendship INT PRIMARY KEY AUTO_INCREMENT,
    profile1 INT NOT NULL,
    profile2 INT NOT NULL,
    messages VARCHAR(3000),
    Friendship_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile1) REFERENCES U_profile(profile_id),
    FOREIGN KEY (profile2) REFERENCES U_profile(profile_id)
);

CREATE TABLE comments (
    id_comment INT PRIMARY KEY AUTO_INCREMENT,
    posts_id INT NOT NULL,
    profile_id INT NOT NULL,
    C_description VARCHAR(1000) NOT NULL,
    C_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (posts_id) REFERENCES posts(posts_id),
    FOREIGN KEY (profile_id) REFERENCES U_profile(profile_id)
);

CREATE TABLE Type_Notification (
    id_Type_N INT PRIMARY KEY AUTO_INCREMENT,
    Type_Notification VARCHAR(250) NOT NULL
);

CREATE TABLE notification (
    id_notification INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    N_Description VARCHAR(250) NOT NULL,
    N_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_Type_N INT NOT NULL,
    N_View BOOL NOT NULL DEFAULT FALSE,
    FOREIGN KEY (profile_id) REFERENCES U_profile(profile_id),
    FOREIGN KEY (id_Type_N) REFERENCES Type_Notification(id_Type_N)
);

-- PROCEDIMIENTOS ALMACENADOS PARA GENERAR DATOS ALEATORIOS

DELIMITER $$

-- Procedimiento para generar usuarios aleatorios
CREATE PROCEDURE GenerarUsuarios(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE nombre VARCHAR(50);
    DECLARE apellido VARCHAR(70);
    DECLARE genero VARCHAR(20);
    
    WHILE i <= cantidad DO
        -- Generar nombre aleatorio
        SET nombre = ELT(FLOOR(1 + RAND() * 50), 
            'Juan', 'María', 'Carlos', 'Ana', 'Luis', 'Sofia', 'Diego', 'Laura', 
            'Miguel', 'Valentina', 'Andrés', 'Isabella', 'Sebastián', 'Camila', 'Felipe',
            'Daniela', 'Mateo', 'Martina', 'Nicolás', 'Lucía', 'Santiago', 'Emma',
            'Joaquín', 'Gabriela', 'Tomás', 'Victoria', 'Manuel', 'Valeria', 'Lucas',
            'Catalina', 'Pablo', 'Julieta', 'Emilio', 'Renata', 'Bruno', 'Antonella',
            'Maximiliano', 'Mariana', 'Ignacio', 'Elena', 'Agustín', 'Paulina', 'Ricardo',
            'Adriana', 'Eduardo', 'Natalia', 'Álvaro', 'Carolina', 'Rodrigo', 'Fernanda');
        
        -- Generar apellido aleatorio
        SET apellido = ELT(FLOOR(1 + RAND() * 50),
            'Pérez', 'González', 'Rodríguez', 'Martínez', 'López', 'García', 'Hernández',
            'Jiménez', 'Torres', 'Ramírez', 'Sánchez', 'Castro', 'Moreno', 'Ortiz', 'Ruiz',
            'Díaz', 'Vargas', 'Romero', 'Silva', 'Mendoza', 'Gutiérrez', 'Pardo', 'Reyes',
            'Campos', 'Cruz', 'Flores', 'Ramos', 'Medina', 'Navarro', 'Vega', 'Aguilar',
            'Rojas', 'Cortés', 'Herrera', 'Delgado', 'Molina', 'Peña', 'Salazar', 'León',
            'Cabrera', 'Miranda', 'Fuentes', 'Ibarra', 'Guerrero', 'Castillo', 'Muñoz',
            'Núñez', 'Prieto', 'Sandoval', 'Arias');
        
        -- Generar género aleatorio
        SET genero = IF(RAND() > 0.5, 'Masculino', 'Femenino');
        
        INSERT INTO Usuario (U_name, last_name, email, phone_number, gender, birth_date, email_verified)
        VALUES (
            nombre,
            apellido,
            CONCAT(LOWER(nombre), '.', LOWER(apellido), i, '@email.com'),
            CONCAT('30', LPAD(FLOOR(RAND() * 100000000), 8, '0')),
            genero,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 40) YEAR),
            RAND() > 0.3
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar perfiles
CREATE PROCEDURE GenerarPerfiles(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE profesion VARCHAR(120);
    
    WHILE i <= cantidad DO
        SET profesion = ELT(FLOOR(1 + RAND() * 30),
            'Amante de la tecnología ☕', 'Desarrollador Full Stack | Viajero', 'Fotógrafo profesional 📷',
            'Estudiante de Ingeniería', 'Gamer y streamer 🎮', 'Diseñador gráfico creativo',
            'Médico general', 'Escritor y poeta', 'Chef profesional 🍳', 'Arquitecto',
            'Músico y compositor', 'Abogado', 'Ingeniero civil', 'Marketing digital',
            'Contador público', 'Bailarín profesional', 'Desarrollador de videojuegos',
            'Nutricionista', 'Empresario', 'Profesor de inglés', 'Piloto comercial',
            'Veterinario', 'Periodista', 'Psicólogo clínico', 'Electricista',
            'Estilista profesional', 'Carpintero', 'Biólogo marino', 'Entrenador personal',
            'Cantante profesional');
        
        INSERT INTO U_profile (id_Usuario, profile_name, presentation)
        SELECT id, CONCAT(U_name, ' ', last_name), profesion
        FROM Usuario WHERE id = i;
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar tipos de detalles
CREATE PROCEDURE GenerarTypeDetails()
BEGIN
    INSERT INTO type_details (name_detail) VALUES
    ('Ciudad'), ('Trabajo'), ('Universidad'), ('Relación'), ('Teléfono'),
    ('Sitio web'), ('Idiomas'), ('Hobby'), ('Estado civil'), ('Mascota');
END$$

-- Procedimiento para generar detalles de perfil
CREATE PROCEDURE GenerarDetailsProfile(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE profile INT;
    DECLARE type_detail INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    
    WHILE i <= cantidad DO
        SET profile = FLOOR(1 + RAND() * max_profiles);
        SET type_detail = FLOOR(1 + RAND() * 10);
        
        INSERT INTO details_profile (profile_id, type_details_id, detail_value)
        VALUES (
            profile,
            type_detail,
            CASE type_detail
                WHEN 1 THEN ELT(FLOOR(1 + RAND() * 10), 'Bogotá', 'Medellín', 'Cali', 'Pasto', 
                    'Cartagena', 'Barranquilla', 'Bucaramanga', 'Pereira', 'Manizales', 'Santa Marta')
                WHEN 2 THEN CONCAT('Empresa ', FLOOR(1 + RAND() * 100))
                WHEN 3 THEN ELT(FLOOR(1 + RAND() * 5), 'Universidad Nacional', 'Universidad de Antioquia',
                    'Universidad del Valle', 'Universidad de Nariño', 'Universidad de los Andes')
                WHEN 4 THEN ELT(FLOOR(1 + RAND() * 3), 'Soltero', 'Casado', 'En relación')
                WHEN 5 THEN CONCAT('30', LPAD(FLOOR(RAND() * 100000000), 8, '0'))
                WHEN 6 THEN CONCAT('www.sitio', FLOOR(1 + RAND() * 100), '.com')
                WHEN 7 THEN ELT(FLOOR(1 + RAND() * 5), 'Español', 'Inglés', 'Francés', 'Alemán', 'Italiano')
                WHEN 8 THEN ELT(FLOOR(1 + RAND() * 10), 'Deportes', 'Lectura', 'Música', 'Cine', 
                    'Viajes', 'Fotografía', 'Cocina', 'Gaming', 'Arte', 'Tecnología')
                WHEN 9 THEN ELT(FLOOR(1 + RAND() * 3), 'Soltero', 'Casado', 'Divorciado')
                WHEN 10 THEN ELT(FLOOR(1 + RAND() * 5), 'Perro', 'Gato', 'Pájaro', 'Pez', 'Conejo')
            END
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar media
CREATE PROCEDURE GenerarMedia(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= cantidad DO
        INSERT INTO Media (type_media, Size)
        VALUES (
            ELT(FLOOR(1 + RAND() * 5), 'image/jpeg', 'image/png', 'video/mp4', 'image/gif', 'video/avi'),
            FLOOR(500 + RAND() * 20000)
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar tipos de post
CREATE PROCEDURE GenerarTypePost()
BEGIN
    INSERT INTO type_post (type_post) VALUES
    ('Texto'), ('Foto'), ('Video'), ('Compartido'), ('Historia'), ('Encuesta');
END$$

-- Procedimiento para generar posts
CREATE PROCEDURE GenerarPosts(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE max_media INT;
    DECLARE profile INT;
    DECLARE media INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    SELECT COUNT(*) INTO max_media FROM Media;
    
    WHILE i <= cantidad DO
        SET profile = FLOOR(1 + RAND() * max_profiles);
        SET media = IF(RAND() > 0.3, FLOOR(1 + RAND() * max_media), NULL);
        
        INSERT INTO posts (profile_id, Text_content, post_date, visibility, Media_id, id_type_post)
        VALUES (
            profile,
            ELT(FLOOR(1 + RAND() * 20),
                '¡Hoy es un gran día!', 'Compartiendo momentos especiales', 'Nueva aventura',
                'Trabajando en nuevos proyectos', '¡Feliz día a todos!', 'Aprendiendo cosas nuevas',
                'Disfrutando el momento', 'Gracias por su apoyo', 'Nueva publicación',
                'Compartiendo conocimiento', 'Momentos únicos', '¡Increíble experiencia!',
                'Seguimos creciendo', 'Nuevas metas', 'Agradecido por todo', 'Día productivo',
                'Inspiración del día', 'Compartiendo amor', 'Nuevos desafíos', 'Reflexión del día'),
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
            ELT(FLOOR(1 + RAND() * 3), 'public', 'friends', 'private'),
            media,
            FLOOR(1 + RAND() * 6)
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar grupos
CREATE PROCEDURE GenerarGrupos(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= cantidad DO
        INSERT INTO F_groups (name_group, group_description, Privacy, rules)
        VALUES (
            CONCAT('Grupo ', ELT(FLOOR(1 + RAND() * 20),
                'Desarrolladores', 'Fotógrafos', 'Gamers', 'Estudiantes', 'Deportistas',
                'Músicos', 'Viajeros', 'Emprendedores', 'Lectores', 'Artistas',
                'Cocineros', 'Tecnología', 'Fitness', 'Cine', 'Series',
                'Mascotas', 'Naturaleza', 'Ciencia', 'Historia', 'Idiomas'), ' ', i),
            CONCAT('Descripción del grupo ', i),
            ELT(FLOOR(1 + RAND() * 2), 'public', 'private'),
            'Respeto y cordialidad entre miembros'
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar miembros de grupos
CREATE PROCEDURE GenerarGroupMembers(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE max_groups INT;
    DECLARE profile INT;
    DECLARE grupo INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    SELECT COUNT(*) INTO max_groups FROM F_groups;
    
    WHILE i <= cantidad DO
        SET profile = FLOOR(1 + RAND() * max_profiles);
        SET grupo = FLOOR(1 + RAND() * max_groups);
        
        INSERT IGNORE INTO group_members (profile_id, id_groups, g_role, join_date)
        VALUES (
            profile,
            grupo,
            ELT(FLOOR(1 + RAND() * 3), 'admin', 'moderator', 'member'),
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY)
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar amistades
CREATE PROCEDURE GenerarFriendship(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE profile1 INT;
    DECLARE profile2 INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    
    WHILE i <= cantidad DO
        SET profile1 = FLOOR(1 + RAND() * max_profiles);
        SET profile2 = FLOOR(1 + RAND() * max_profiles);
        
        IF profile1 != profile2 THEN
            INSERT IGNORE INTO friendship (profile1, profile2, messages, Friendship_date)
            VALUES (
                LEAST(profile1, profile2),
                GREATEST(profile1, profile2),
                ELT(FLOOR(1 + RAND() * 10),
                    '¡Hola! ¿Cómo estás?', 'Conectemos', 'Gracias por aceptar',
                    '¡Qué bueno conocerte!', 'Saludos', '¡Hola amigo!',
                    '¿Cómo te va?', 'Un gusto', '¡Bienvenido!', 'Encantado'),
                DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY)
            );
            SET i = i + 1;
        END IF;
    END WHILE;
END$$

-- Procedimiento para generar comentarios
CREATE PROCEDURE GenerarComments(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE max_posts INT;
    DECLARE profile INT;
    DECLARE post INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    SELECT COUNT(*) INTO max_posts FROM posts;
    
    WHILE i <= cantidad DO
        SET profile = FLOOR(1 + RAND() * max_profiles);
        SET post = FLOOR(1 + RAND() * max_posts);
        
        INSERT INTO comments (posts_id, profile_id, C_description, C_date)
        VALUES (
            post,
            profile,
            ELT(FLOOR(1 + RAND() * 25),
                '¡Excelente publicación!', 'Me encanta', '¡Totalmente de acuerdo!',
                'Muy interesante', 'Gracias por compartir', '¡Increíble!',
                'Qué bonito', '¡Felicidades!', 'Muy bien', 'Me inspira',
                '¡Genial!', 'Sigue así', 'Hermoso', 'Impresionante',
                '¡Wow!', 'Me gusta mucho', 'Excelente contenido', '¡Bravo!',
                'Muy creativo', 'Fantástico', '¡Súper!', 'Asombroso',
                'Espectacular', 'Maravilloso', 'Extraordinario'),
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 180) DAY)
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Procedimiento para generar tipos de notificación
CREATE PROCEDURE GenerarTypeNotification()
BEGIN
    INSERT INTO Type_Notification (Type_Notification) VALUES
    ('Nuevo comentario'), ('Nueva amistad'), ('Invitación a grupo'),
    ('Me gusta'), ('Mención'), ('Compartido'), ('Mensaje nuevo'),
    ('Actualización de grupo'), ('Cumpleaños'), ('Evento próximo');
END$$

-- Procedimiento para generar notificaciones
CREATE PROCEDURE GenerarNotifications(IN cantidad INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_profiles INT;
    DECLARE profile INT;
    
    SELECT COUNT(*) INTO max_profiles FROM U_profile;
    
    WHILE i <= cantidad DO
        SET profile = FLOOR(1 + RAND() * max_profiles);
        
        INSERT INTO notification (profile_id, N_Description, id_Type_N, N_View, N_Date)
        VALUES (
            profile,
            CONCAT('Notificación número ', i),
            FLOOR(1 + RAND() * 10),
            RAND() > 0.5,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY)
        );
        
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
*/
-- EJECUTAR PROCEDIMIENTOS PARA GENERAR MÁS DE 100 REGISTROS POR TABLA
CALL GenerarUsuarios(120);
CALL GenerarPerfiles(120);
CALL GenerarTypeDetails();
CALL GenerarDetailsProfile(150);
CALL GenerarMedia(120);
CALL GenerarTypePost();
CALL GenerarPosts(200);
CALL GenerarGrupos(110);
CALL GenerarGroupMembers(250);
CALL GenerarFriendship(180);
CALL GenerarComments(300);
CALL GenerarTypeNotification();
CALL GenerarNotifications(200);

-- CONSULTAS ORIGINALES
SELECT u.U_name, u.last_name, p.profile_name, p.presentation
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario;

SELECT u.U_name, p.profile_name, p.presentation
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
WHERE u.U_name = 'Juan';

SELECT u.U_name, u.last_name, p.profile_name, g.name_group, gm.g_role
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
JOIN group_members gm ON p.profile_id = gm.profile_id
JOIN F_groups g ON gm.id_groups = g.id_groups;

SELECT u.U_name, u.last_name, p.profile_name, g.name_group, gm.g_role, po.Text_content, po.visibility
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
JOIN group_members gm ON p.profile_id = gm.profile_id
JOIN F_groups g ON gm.id_groups = g.id_groups
JOIN posts po ON p.profile_id = po.profile_id;

SELECT u.U_name, u.last_name, u.gender, p.profile_name
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
WHERE u.gender = "Masculino"

/*SELECT * FROM Usuario;

SELECT u.U_name, u.last_name, p.profile_name, g.name_group, gm.g_role, po.Text_content, po.visibility
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
JOIN group_members gm ON p.profile_id = gm.profile_id
JOIN F_groups g ON gm.id_groups = g.id_groups
JOIN posts po ON p.profile_id = po.profile_id;

SELECT u.U_name, u.last_name, u.gender, p.profile_name
FROM Usuario u
JOIN U_profile p ON u.id = p.id_Usuario
WHERE u.gender = "Masculino";
*/
SELECT row_number() over () as row_num, u.U_name, u.last_name, u.gender, p.profile_name, g.name_group, gm.g_role
FROM Usuario U
JOIN U_profile p ON u.id = p.id_Usuario
JOIN group_members gm ON gm.profile_id = p.profile_id
JOIN F_groups g ON gm.id_groups = g.id_groups
WHERE u.gender = "Femenino" AND gm.g_role="admin";
     
     