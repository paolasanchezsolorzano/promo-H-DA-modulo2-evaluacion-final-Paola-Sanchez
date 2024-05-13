USE sakila;

--  1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT title
FROM film
GROUP BY film_id;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
FROM film
WHERE rating = "PG-13"
GROUP BY film_id;


-- COMPRUEBO--

SELECT * FROM film WHERE rating = 'PG-13'; 

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description like '%amazing%'
GROUP BY title;

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
SELECT title, length
FROM film
WHERE length > 120
GROUP BY title;

-- Recupera los nombres de todos los actores.

SELECT CONCAT(first_name,' ',last_name)  as nombre_completo
from actor
GROUP BY actor_id;

    -- COMPRUEBO---

SELECT COUNT(FIRST_NAME) FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido

SELECT first_name,last_name
from actor
WHERE last_name LIKE '%Gibson%' -- O TAMBIEN 'Gibson'
GROUP BY actor_id;

-- OTRA FORMA DE HACERLO--

SELECT first_name,last_name
from actor
WHERE last_name = 'Gibson'    
GROUP BY actor_id;

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name,last_name,actor_id
from actor
WHERE actor_id BETWEEN 10 AND 20
GROUP BY actor_id;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación  

SELECT title, rating
FROM film
WHERE rating NOT IN ('R','PG-13')
GROUP BY title;

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
SELECT COUNT(film_id) AS recuento, rating
FROM film
GROUP BY rating;

-- VERIFICO CON UNO AL AZAR--
select count(film_id), rating
from film
where rating = 'PG-13';

/* 10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
 su nombre y apellido junto con la cantidad de películas alquiladas.*/
 
 SELECT COUNT(rental.rental_id), rental.customer_id, customer.first_name, customer.last_name
 FROM rental
 INNER JOIN customer
 ON rental.customer_id = customer.customer_id
 GROUP BY customer.customer_id;
 
 -- COMPRUEBO--
 SELECT * FROM rental WHERE customer_id = 1;   -- Esta correcto--
 
 /* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la 
categoría junto con el recuento de alquileres -- reviso todas las tablas y me doy cuenta que se puede hacer con
4 tablas( rental(inventory_id, rental_id), inventary(inventory_id,film_id), film_category(film_id,category_id),
 category(category_id, name)*/

SELECT count(rental_id),R.inventory_id,CAT.name
FROM rental AS R
LEFT JOIN inventory AS I
ON R.inventory_id = I.inventory_id
LEFT JOIN film_category AS FC
ON I.film_id = FC.film_id
LEFT JOIN category AS CAT
ON CAT.category_id = FC.category_id
GROUP BY CAT.name;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
muestra la clasificación junto con el promedio de duración*/

SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"*/

SELECT first_name,last_name,F.title
FROM actor AS A
LEFT JOIN film_actor AS FA
ON FA.actor_id = A.actor_id
LEFT JOIN film AS F
ON  F.film_id = FA.film_id
WHERE F.title = 'Indian Love';

/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción*/

SELECT title, description
from film
WHERE description like '%dog%' or description like '%cat%' ;

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor*/

SELECT actor_id
FROM actor
WHERE actor_id NOT IN (select actor_id FROM film_actor);

/*16.  Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.---- TODAS SON DEL 2006; SE REVISA LA TABLA */
SELECT title, release_year
from film
WHERE release_year BETWEEN '2005' AND '2010';

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"*/
SELECT F.title ,CAT.name
FROM film AS F
LEFT JOIN film_category AS FC
ON F.film_id = FC.film_id
LEFT JOIN category AS CAT
ON CAT.category_id = FC.category_id
WHERE CAT.name = 'Family';

/*18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas*/

SELECT first_name, last_name, COUNT(film_id) AS movies_num
FROM film_actor
LEFT JOIN actor
ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
HAVING movies_num > 10;

/*19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la 
tabla film -- ENTIENDO QUE SON MINUTOS LO DE LA COLUMNA POR LO QUE PONGO 120 */
 
select title,length,rating
from film 
WHERE rating = 'R' AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 
minutos y muestra el nombre de la categoría junto con el promedio de duración*/

SELECT CAT.name, AVG(F.length) AS promedio_duracion
From film AS F
LEFT JOIN film_category AS FC
ON F.film_id = FC.film_id
LEFT JOIN category AS CAT
ON CAT.category_id = FC.category_id
GROUP BY CAT.name
HAVING AVG(F.length)  > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor 
junto con la cantidad de películas en las que han actuado./*

/*22.  Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una 
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona 
las películas correspondientes.*/

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la 
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
películas de la categoría "Horror" y luego exclúyelos de la lista de actores*/

-- BONUS

/* 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 
minutos en la tabla film*/

/* 25. Encuentra todos los actores que han actuado juntos en al menos una película. La 
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que 
han actuado juntos.*/ 



