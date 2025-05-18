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

SELECT c.customer_id ID, c.first_name Nombre, c.last_name Apellido, COUNT(r.rental_id) Peliculas_Alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_ID, c.first_name, c.last_name
ORDER BY Peliculas_Alquiladas DESC; 

/*11.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
categoría junto con el recuento de alquileres.*/

SELECT COUNT(r.rental_id) Peliculas_Alquiladas, c.name Categoria
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = fc.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY Categoria
ORDER BY Peliculas_Alquiladas DESC;

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración.*/ 

SELECT rating Clasificación, ROUND(AVG(length)) Promedio_Duración 
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

SELECT CONCAT(a.first_name, ' ', a.last_name) Nombre_Actor_Actriz
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- Solución diferente (con subconsulta) para tener una respuesta, ya que la anterior nos da columna vacía.
SELECT EXISTS (  -- Existe una fila que cumpla una condición? Para que nos devuelva un booleano, 1 (true) o 0 (false). 
	SELECT 1
    FROM actor a     -- Unimos todos los actores con sus peliculas.
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
    WHERE fa.film_id IS NULL
) Hay_actores_sin_pelis;

/*16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT title Titulo, release_year Año_lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010
ORDER BY Año_lanzamiento;



/*17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

SELECT f.title Titulo, c.name Categoria
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE c.name = 'Family';

/*18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT CONCAT(a.first_name, ' ', a.last_name) Nombre_Actor_Actriz, COUNT(fa.film_id) Total_películas
FROM film_actor fa
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name 
HAVING COUNT(fa.film_id) > 10 
ORDER BY Total_películas DESC;

/*19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/

SELECT title Titulo, length Duración
FROM film
WHERE rating = 'R' AND length > 120
ORDER BY Duración;

/*20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
minutos y muestra el nombre de la categoría junto con el promedio de duración.*/

SELECT c.name Categoria, ROUND(AVG(f.length)) Promedio_Duración
FROM film_category fc
JOIN category c ON c.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING ROUND(AVG(f.length)) > 120;

-- Con subconsulta: en la subconsulta calculamos el promedio de duración por categoria, y en la principal seleccionamos las que tienen un promedio mayor de 120min:
SELECT categoria, Promedio_Duración
FROM (
	SELECT c.name Categoria, ROUND(AVG(f.length)) Promedio_Duración
	FROM film_category fc
	JOIN category c ON c.category_id = fc.category_id
	JOIN film f ON f.film_id = fc.film_id
	GROUP BY c.name
) Resumen WHERE Promedio_duración > 120;

/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
junto con la cantidad de películas en las que han actuado.*/

SELECT a.first_name, a.last_name, COUNT(fa.film_id) Total_Peliculas
FROM film_actor fa
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5
ORDER BY Total_peliculas;

-- Versión CTE (Common Table Expression). Sirve para reutilizar el total de pelis por actor.

WITH Actores_peliculas AS (
	SELECT a.actor_id ID, CONCAT(a.first_name, ' ', a.last_name) Nombre_actor_actriz, COUNT(fa.film_id) Total_Peliculas
	FROM film_actor fa
	JOIN actor a ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT Nombre_actor_actriz, Total_peliculas
FROM Actores_peliculas
WHERE Total_peliculas >= 5
ORDER BY Total_peliculas;

/*22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para 
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. 
Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)*/

SELECT f.title Titulo, DATEDIFF(r.return_date, r.rental_date) Total_dias_alquiler
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
	SELECT rental_id
    FROM rental 
    WHERE DATEDIFF(return_date, rental_date) > 5
);

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id NOT IN (
	SELECT fa.actor_id
	FROM film_actor fa
	JOIN film_category fc ON fc.film_id = fa.film_id
	JOIN category c ON c.category_id = fc.category_id
	WHERE c.name = 'Horror');
    
-- BONUS
/*24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.*/

SELECT title Titulo, length Duración
FROM film
WHERE length > 180 
AND film_id IN (
	SELECT f.film_id
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON c.category_id = fc.category_id
    WHERE c.name = 'Comedy');

-- Tablas para hacer los ejercicios:
SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_category;
SELECT * FROM film_actor;

SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM rental;



