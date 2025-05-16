-- Evaluación Final Modulo 2. 
USE sakila;

/*1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/

SELECT DISTINCT title
FROM film;

/*2.Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT title Titulo, rating Clasificación
FROM film
WHERE rating = 'PG-13'
ORDER BY title;

/*3.Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en
su descripción.*/
-- En este ejercicio seria válido también utilizar WHERE description REGEXP 'amazing';

SELECT title AS Titulo, description AS Descripción
FROM film
WHERE description LIKE '%amazing%';

/*4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT title Titulo, length Duración
FROM film
WHERE length > '120'
ORDER BY length;

/*5.Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.*/

SELECT CONCAT(first_name, ' ', last_name) Nombre_Actor_Actriz
FROM actor
ORDER BY Nombre_Actor_Actriz;

/*6.Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT first_name Nombre, last_name Apellido
FROM actor
WHERE last_name LIKE 'Gibson';

/*7.Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT first_name Nombre, last_name Apellido, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/*8.Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".*/

SELECT title Titulo, rating Clasificación
FROM film
WHERE rating NOT IN ('PG-13', 'R')
ORDER BY Clasificación;

/*9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.*/

SELECT COUNT(title) Total_peliculas, rating Clasificación
FROM film
GROUP BY rating;

/*10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT c.customer_id ID, c.first_name Nombre, c.last_name Apellido, COUNT(r.rental_id) Peliculas_Alquiladas -- El rental id nos dice cuantas pelis ha alquilado cada cliente
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_ID, c.first_name, c.last_name
ORDER BY Peliculas_Alquiladas DESC;   -- Para ver el orden segun quien alquila mas (cliente mas fiel)

/*11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
categoría junto con el recuento de alquileres.*/

SELECT COUNT(r.rental_id) Peliculas_Alquiladas, c.name Categoria
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY Categoria
ORDER BY Peliculas_Alquiladas DESC;  -- Así vemos que categoria es la mas alquilada, en este caso SPORTS con 1179 pelis.

-- Es importante entender cual es la unión de cada tabla para que nos dé el resultado que buscamos.

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/ -- Necesito una subconsulta.

SELECT rating Clasificación, ROUND(AVG(length)) Promedio_Duración   -- El ROUND sirve para que no salgan decimales. 
FROM film
GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"*/

SELECT CONCAT(a.first_name, ' ', a.last_name) Nombre_Actor_Actriz, f.title Pelicula
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE title LIKE 'Indian Love'
ORDER BY Nombre_Actor_Actriz;

/*14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT title Título, description Descripción
FROM film
WHERE description LIKE '%dog%' OR '%cat%';

/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/

/*16.


SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;
