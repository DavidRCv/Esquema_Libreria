DROP DATABASE IF EXISTS esquema_libreria;
CREATE DATABASE esquema_libreria;
USE esquema_libreria;

CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacimiento DATE,
    nacion VARCHAR(100)
);

CREATE TABLE generos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE patrones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    autor_id INT NOT NULL,
    genero_id INT NOT NULL,

    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

CREATE TABLE reservaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    patron_id INT NOT NULL,
    fecha DATE NOT NULL,

    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (patron_id) REFERENCES patrones(id)
);

-- creating the autores

INSERT INTO autores (nombre, nacimiento, nacion) VALUES
('Gabriel Garcia Marquez', '1927-03-06', 'Colombia'),
('J.K. Rowling', '1965-07-31', 'Reino Unido'),
('George Orwell', '1903-06-25', 'Reino Unido'),
('Mario Vargas Llosa', '1936-03-28', 'Peru'),
('Isabel Allende', '1942-08-02', 'Chile');

-- creating the genrs
INSERT INTO generos (nombre) VALUES
('Realismo Magico'),
('Fantasia'),
('Distopia'),
('Novela'),
('Drama');

-- creating patrones (users) 
INSERT INTO patrones (nombre, email, telefono) VALUES
('Juan Perez', 'juan@email.com', '999111111'),
('Maria Lopez', 'maria@email.com', '999222222'),
('Carlos Ruiz', 'carlos@email.com', '999333333'),
('Ana Torres', 'ana@email.com', '999444444'),
('Luis Gomez', 'luis@email.com', '999555555'),
('Sofia Diaz', 'sofia@email.com', '999666666');

-- creating the libros
INSERT INTO libros (titulo, isbn, autor_id, genero_id) VALUES
('Cien Años de Soledad', '1111111111111', 1, 1),
('El Amor en los Tiempos del Colera', '1111111111112', 1, 4),
('Harry Potter y la piedra filosofal', '2222222222221', 2, 2),
('Harry Potter y la camara de los secretos', '2222222222222', 2, 2),
('1984', '3333333333331', 3, 3),
('Rebelion en la Granja', '3333333333332', 3, 3),
('La Ciudad y los Perros', '4444444444441', 4, 4),
('Conversacion en la Catedral', '4444444444442', 4, 4),
('La Casa de los Espiritus', '5555555555551', 5, 1),
('Eva Luna', '5555555555552', 5, 5);

-- pregunta 6 correccion
INSERT INTO libros (titulo, isbn, autor_id, genero_id) VALUES
('Harry Potter 3', '2222222222223', 2, 2),
('Harry Potter 4', '2222222222224', 2, 2);

-- creating the reservations
INSERT INTO reservaciones (libro_id, patron_id, fecha) VALUES
(1, 1, '2026-04-01'),
(1, 2, '2026-04-02'),
(1, 3, '2026-04-03'),
(2, 1, '2026-04-04'),
(3, 2, '2026-04-01'),
(3, 2, '2026-04-02'),
(3, 2, '2026-04-03'),
(3, 2, '2026-04-04'),
(3, 2, '2026-04-05'),
(3, 2, '2026-04-06'),
(4, 3, '2026-04-01'),
(5, 4, '2026-04-02'),
(5, 4, '2026-04-03'),
(7, 5, '2026-04-01');

-- testtestestetstetst
SELECT * FROM autores;
SELECT * FROM generos;
SELECT * FROM patrones;
SELECT * FROM libros;
SELECT * FROM reservaciones;

-- Querys propuestos

-- Pregunta 1:Obtener todos los libros con su autor y género. 

SELECT libros.titulo, autores.nombre, generos.nombre
FROM libros
INNER JOIN autores -- two inner join's(libros ->autor)(libros->genero)
ON libros.autor_id = autores.id
INNER JOIN generos
ON libros.genero_id = generos.id;

-- Pregunta 2:Listar los libros que nunca han sido reservados. 

SELECT libros.*
FROM libros
LEFT JOIN reservaciones 
ON libros.id = reservaciones.libro_id -- combine rows
WHERE reservaciones.id IS NULL; -- there has to be a id for the reservation, that never happened

-- Pregunta 3:Mostrar los nombres de los usuarios que han hecho al menos una reserva. 

SELECT DISTINCT patrones.nombre
FROM patrones
INNER JOIN reservaciones
ON patrones.id = reservaciones.patron_id;

-- Pregunta 4:Contar cuántos libros hay por género. 

SELECT generos.nombre, COUNT(libros.id) -- keeps count per genre
FROM generos
INNER JOIN libros
ON generos.id = libros.genero_id
GROUP BY generos.nombre;

-- Pregunta 5:Obtener el número total de reservas por libro. 

SELECT libros.titulo, COUNT(reservaciones.id) -- keeps count of the reservs, per book
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo;

-- Pregunta 6:Listar los autores que tienen más de 3 libros registrados. 

SELECT autores.nombre, COUNT(libros.id)
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
GROUP BY autores.nombre
HAVING COUNT(libros.id) > 3; -- filter after grouping

-- Pregunta 7:Mostrar los libros reservados en una fecha específica. 

SELECT libros.titulo
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
WHERE reservaciones.fecha = '2026-04-01';

-- Pregunta 8:Obtener los usuarios que han reservado más de 5 libros.

SELECT patrones.nombre, COUNT(reservaciones.id)
FROM patrones
INNER JOIN reservaciones
ON patrones.id = reservaciones.patron_id
GROUP BY patrones.nombre
HAVING COUNT(reservaciones.id) > 5;

-- Pregunta 9:Listar libros junto con el número de veces que han sido reservados (incluir los que tienen 0). 

SELECT libros.titulo, COUNT(reservaciones.id)
FROM libros
LEFT JOIN reservaciones  -- !includes all the books
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo;

-- Pregunta 10:Obtener el género con más libros registrados.

SELECT generos.nombre, COUNT(libros.id) AS total_libros
FROM generos
INNER JOIN libros
ON generos.id = libros.genero_id
GROUP BY generos.nombre
ORDER BY total_libros DESC
LIMIT 1;

-- Pregunta 11:Obtener el libro más reservado. 

SELECT libros.titulo, COUNT(reservaciones.id) AS total_reservas
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo
ORDER BY total_reservas DESC
LIMIT 1;

-- Pregunta 12:Listar los 3 autores con más reservas acumuladas en sus libros. 

SELECT autores.nombre, COUNT(reservaciones.id) AS total_reservas
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY autores.nombre
ORDER BY total_reservas DESC
LIMIT 3;

-- Pregunta 13:Mostrar los usuarios que nunca han hecho una reserva. 

SELECT patrones.*
FROM patrones
LEFT JOIN reservaciones
ON patrones.id = reservaciones.patron_id
WHERE reservaciones.id IS NULL;

-- Pregunta 14:Obtener los libros cuya cantidad de reservas es mayor al promedio. 

SELECT libros.titulo, COUNT(reservaciones.id) AS total_reservas  -- for each book, get the title and how many reservations there are
FROM libros 
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id -- no resv ignored
GROUP BY libros.titulo -- row per book
HAVING COUNT(reservaciones.id) > -- (>2.33) noly 3,5,6 remain...
(
    SELECT AVG(reservas_por_libro) -- (outerlogic)
    FROM (
        SELECT COUNT(reservaciones.id) AS reservas_por_libro -- resevs per book (inner)
        FROM reservaciones
        GROUP BY reservaciones.libro_id
    ) AS subconsulta
);

-- Test of cuantas reservaciones hay
SELECT COUNT(reservaciones.id)
FROM reservaciones
GROUP BY reservaciones.libro_id;

-- Resultado del average = 2.33 | (results 3,6,2,1) tehrefore < (3,6)
SELECT AVG(reservas_por_libro)
FROM (
    SELECT COUNT(reservaciones.id) AS reservas_por_libro
    FROM reservaciones
    GROUP BY reservaciones.libro_id
) AS subconsulta;

-- Pregunta 15:Listar autores cuyos libros pertenecen a más de un género distinto. 

SELECT autores.nombre
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
GROUP BY autores.nombre
HAVING COUNT(DISTINCT libros.genero_id) > 1;
