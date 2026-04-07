# Sistema de Biblioteca en SQL (MySQL)

Este proyecto consiste en el diseño de una base de datos relacional para una biblioteca, junto con la resolución de 15 consultas SQL orientadas al análisis de la información almacenada.

-----

## Desarrollo de las 15 consultas

### 1. Libros con su autor y género

Se combinaron las tablas libros, autores y géneros mediante `INNER JOIN` para mostrar la información completa de cada libro.

SELECT libros.titulo, autores.nombre, generos.nombre
FROM libros
INNER JOIN autores -- two inner join's(libros ->autor)(libros->genero)
ON libros.autor_id = autores.id
INNER JOIN generos
ON libros.genero_id = generos.id;

---

### 2. Libros nunca reservados

Se utilizó `LEFT JOIN` entre libros y reservaciones, filtrando los valores `NULL` para identificar los libros sin reservas.

SELECT libros.*
FROM libros
LEFT JOIN reservaciones 
ON libros.id = reservaciones.libro_id -- combine rows
WHERE reservaciones.id IS NULL;

---

### 3. Usuarios con al menos una reserva

Se realizó un `INNER JOIN` entre patrones y reservaciones para obtener únicamente los usuarios que han realizado reservas.

SELECT DISTINCT patrones.nombre
FROM patrones
INNER JOIN reservaciones
ON patrones.id = reservaciones.patron_id;

---

### 4. Cantidad de libros por género

Se utilizó `COUNT()` junto con `GROUP BY` para contar cuántos libros pertenecen a cada género.

SELECT generos.nombre, COUNT(libros.id) -- keeps count per genre
FROM generos
INNER JOIN libros
ON generos.id = libros.genero_id
GROUP BY generos.nombre;

---

### 5. Total de reservas por libro

Se contaron las reservaciones por cada libro usando `COUNT()` y agrupación.

SELECT libros.titulo, COUNT(reservaciones.id) -- keeps count of the reservs, per book
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo;

---

### 6. Autores con más de 3 libros

Se agruparon los libros por autor y se filtraron con `HAVING` aquellos que superan las 3 publicaciones.

SELECT autores.nombre, COUNT(libros.id)
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
GROUP BY autores.nombre
HAVING COUNT(libros.id) > 3; 

---

### 7. Libros reservados en una fecha específica

Se filtraron las reservaciones por fecha con `WHERE` y se relacionaron con los libros.

SELECT libros.titulo
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
WHERE reservaciones.fecha = '2026-04-01';
---

### 8. Usuarios con más de 5 reservas

Se contaron las reservaciones por usuario y se utilizó `HAVING` para filtrar los que superan ese límite.

SELECT patrones.nombre, COUNT(reservaciones.id)
FROM patrones
INNER JOIN reservaciones
ON patrones.id = reservaciones.patron_id
GROUP BY patrones.nombre
HAVING COUNT(reservaciones.id) > 5;

---

### 9. Libros con número de reservas (incluyendo 0)

Se aplicó `LEFT JOIN` para incluir todos los libros, incluso aquellos sin reservas, combinándolo con `COUNT()`.

SELECT libros.titulo, COUNT(reservaciones.id)
FROM libros
LEFT JOIN reservaciones  -- !includes all the books
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo;
---

### 10. Género con más libros

Se agruparon los libros por género, se ordenaron de mayor a menor y se seleccionó el primero con `LIMIT`.

SELECT generos.nombre, COUNT(libros.id) AS total_libros
FROM generos
INNER JOIN libros
ON generos.id = libros.genero_id
GROUP BY generos.nombre
ORDER BY total_libros DESC
LIMIT 1;

---

### 11. Libro más reservado

Se contaron las reservas por libro, se ordenaron en forma descendente y se obtuvo el primero.

SELECT libros.titulo, COUNT(reservaciones.id) AS total_reservas
FROM libros
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY libros.titulo
ORDER BY total_reservas DESC
LIMIT 1;
---

### 12. Top 3 autores con más reservas

Se relacionaron autores, libros y reservaciones, sumando las reservas por autor y limitando el resultado a los 3 primeros.

SELECT autores.nombre, COUNT(reservaciones.id) AS total_reservas
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
INNER JOIN reservaciones
ON libros.id = reservaciones.libro_id
GROUP BY autores.nombre
ORDER BY total_reservas DESC
LIMIT 3;
---

### 13. Usuarios sin reservas

Se utilizó `LEFT JOIN` entre patrones y reservaciones, filtrando los valores `NULL` para identificar usuarios sin actividad.

SELECT patrones.*
FROM patrones
LEFT JOIN reservaciones
ON patrones.id = reservaciones.patron_id
WHERE reservaciones.id IS NULL;
---

### 14. Libros con reservas superiores al promedio

Se calculó el promedio de reservas por libro mediante una subconsulta y se comparó con el total de cada libro usando `HAVING`.

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
---

### 15. Autores con libros en más de un género

Se contó la cantidad de géneros distintos por autor utilizando `COUNT(DISTINCT ...)` y se filtraron aquellos con más de uno.

SELECT autores.nombre
FROM autores
INNER JOIN libros
ON autores.id = libros.autor_id
GROUP BY autores.nombre
HAVING COUNT(DISTINCT libros.genero_id) > 1;

---
