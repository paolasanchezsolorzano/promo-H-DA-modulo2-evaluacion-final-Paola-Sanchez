USE sakila;

--  1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT  DISTINCT title																	     --  SELECT title FROM film
FROM film
GROUP BY film_id;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title                                                                                 --  SELECT title, (rating) description FROM film
FROM film
WHERE rating = "PG-13"
GROUP BY film_id;


-- COMPRUEBO--

SELECT * FROM film WHERE rating = 'PG-13'; 

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. PUEDO USAR LIKE O '='*/

SELECT title, description 																	 --  SELECT title, description FROM film
FROM film
WHERE description like '%amazing%'
GROUP BY title;

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos

SELECT title																	 			 --  SELECT title, (length) FROM film
FROM film
WHERE length > 120
GROUP BY title;

-- 5. Recupera los nombres de todos los actores.

SELECT CONCAT(first_name,' ',last_name)  as nombres_completo                                         --  SELECT first_name,last_name FROM actor
from actor
GROUP BY actor_id;

    -- COMPRUEBO---

SELECT COUNT(FIRST_NAME) FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido

SELECT first_name,last_name																		--  SELECT first_name,last_name FROM actor
from actor
WHERE last_name LIKE '%Gibson%' 
GROUP BY actor_id;

-- OTRA FORMA DE HACERLO--

SELECT first_name,last_name																		
FROM actor
WHERE last_name = 'Gibson'    
GROUP BY actor_id;

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name,last_name,actor_id															-- SELECT first_name,last_name,actor_id FROM actor
FROM actor
WHERE actor_id BETWEEN 10 AND 20
GROUP BY actor_id;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación  

SELECT title, rating																			-- SELECT title, rating FROM film
FROM film
WHERE rating NOT IN ('R','PG-13')
GROUP BY title;

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento

SELECT COUNT(film_id) AS recuento, rating                                                       -- SELECT film_id, rating  FROM film
FROM film
GROUP BY rating;

-- VERIFICO CON UNO AL AZAR--
select count(film_id), rating
from film
where rating = 'PG-13';

/* 10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
 su nombre y apellido junto con la cantidad de películas alquiladas.*/
 
 SELECT COUNT(rental.rental_id), rental.customer_id, customer.first_name, customer.last_name     -- SELECT first_name, last_name,(customer_id) FROM customer
 FROM rental
 INNER JOIN customer																			 -- SELECT rental_id, (customer_id)
 ON rental.customer_id = customer.customer_id
 GROUP BY customer.customer_id;
 
 -- COMPRUEBO--
 SELECT * FROM rental WHERE customer_id = 1;   -- Esta correcto--
 
 /* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la 
categoría junto con el recuento de alquileres --REVISO todas las tablas y me doy cuenta que se puede hacer con
4 tablas
 LEFT JOIN --> CASTACADA*/

SELECT count(rental_id),R.inventory_id,CAT.name                                                   -- SELECT (inventory_id), rental_id FROM rental
FROM rental AS R
LEFT JOIN inventory AS I																		  -- SELECT (inventory_id),(film_id) FROM inventory
ON R.inventory_id = I.inventory_id
LEFT JOIN film_category AS FC																	  -- SELECT (film_id),(category_id) FROM  film_category
ON I.film_id = FC.film_id
LEFT JOIN category AS CAT                                                                         -- SELECT (category_id), name FROM category
ON CAT.category_id = FC.category_id
GROUP BY CAT.name;


/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
muestra la clasificación junto con el promedio de duración*/

SELECT rating, AVG(length) AS promedio_duracion													     -- SELECT rating, length FROM film
FROM film
GROUP BY rating;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"*/

SELECT first_name,last_name,F.title																     -- SELECT first_name,last_name,(actor_id) FROM actor 
FROM actor AS A
LEFT JOIN film_actor AS FA																			 -- SELECT (actor_id),(film_id) FROM film_actor
ON FA.actor_id = A.actor_id
LEFT JOIN film AS F																					 -- SELECT (film_id), title FROM film
ON  F.film_id = FA.film_id
WHERE F.title = 'Indian Love';

/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción*/

SELECT title, description																			 -- SELECT title, description FROM film
from film
WHERE description like '%dog%' or description like '%cat%' ;

/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor*/

SELECT actor_id                                                                                      -- SELECT actor_id FROM actor
FROM actor
WHERE actor_id NOT IN (select actor_id 
					   FROM film_actor);

/*16.  Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.---- TODAS SON DEL 2006; SE REVISA LA TABLA */

SELECT title, release_year                                                                           -- SELECT title, release_year FROM film
from film
WHERE release_year BETWEEN '2005' AND '2010';

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family", AGREGO LA CATEGORIA PARA COMPROBAR*/

SELECT F.title ,CAT.name																			 --  SELECT title,(film_id) FROM film 
FROM film AS F
LEFT JOIN film_category AS FC																		 -- SELECT (film_id),(category_id) FROM film_category
ON F.film_id = FC.film_id
LEFT JOIN category AS CAT																			 -- SELECT (category_id),name FROM category
ON CAT.category_id = FC.category_id
WHERE CAT.name = 'Family';

/*18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas*/

SELECT A.first_name, A.last_name, COUNT(F.film_id) AS movies_num 									 -- SELECT film_id,(actor_id) FROM film_actor						
FROM film_actor AS F
LEFT JOIN actor	AS A																				 -- SELECT  first_name, last_name,(actror_id) FROM actor
ON F.actor_id = A.actor_id
GROUP BY F.actor_id
HAVING movies_num > 10;

/*19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la 
tabla film -- ENTIENDO QUE SON MINUTOS LO DE LA COLUMNA POR LO QUE PONGO 120 */
 
select title,length,rating																			 -- SELECT title,length,rating FROM film 
from film 
WHERE rating = 'R' AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 
minutos y muestra el nombre de la categoría junto con el promedio de duración-- REDONDEO A DOS LOS DECIMALES/*/

SELECT CAT.name, ROUND(AVG(F.length),2) AS promedio_duracion													   -- SELECT (film_id),lenght FROM film
From film AS F
LEFT JOIN film_category AS FC																		   -- SELECT (film_id),(category_id) FROM film_category
ON F.film_id = FC.film_id
LEFT JOIN category AS CAT																			   -- SELECT (category_id), name FROM film_category
ON CAT.category_id = FC.category_id
GROUP BY CAT.name
HAVING AVG(F.length)  > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor 
junto con la cantidad de películas en las que han actuado.*/

SELECT actor.first_name, COUNT(film_actor.film_id) AS movies_cant                                        -- SELECT first_name,(film_id),actor_id FROM folm_actor
FROM film_actor
LEFT JOIN actor																					  		 -- SELECT actor_id , first_name
ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(film_actor.film_id) >=  5;

/*22.  Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una 
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona 
las películas correspondientes.*/

SELECT title, rental_duration                                          							    -- SELECT title, rental_duration FROM film 
FROM film
WHERE film_id IN (SELECT film_id																	-- SELECT (rental_id) FROM rental
				  FROM rental
                  GROUP BY film_id
                  HAVING film.rental_duration > 5
                  ORDER BY title);
                  
   -- ---------------------------- return_date and rental_date-------------------------- --       
   
SELECT F.title, DATEDIFF(R.return_date, R.rental_date) AS dias_rentados, R.rental_id
FROM film AS F
LEFT JOIN inventory AS I 
ON F.film_id = I.film_id                                                                        -- SELECT DATEDIFF(return_date, rental_date) AS dias_diferencia
LEFT JOIN rental AS R																			-- 	FROM sakila.rental
ON I.inventory_id = R.inventory_id
WHERE DATEDIFF(R.return_date, R.rental_date) > 5
GROUP BY R.rental_id, dias_rentados
ORDER BY F.title;
                  
	

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la 
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
películas de la categoría "Horror" y luego exclúyelos de la lista de actores -- BUSCO RELACION*/

SELECT ACT.first_name, ACT.last_name                                          						-- SELECT (actor_id), first_name,last_name 
FROM actor AS ACT	                                                    
WHERE ACT.actor_id NOT IN ( SELECT FACT.actor_id
							FROM film_category AS FCG												-- SELECT (film_id),(category_id)  FROM film_category
							INNER JOIN film_actor AS FACT                    						-- SELECT (actor_id, (film_id) FROM film_actor 
							ON FCG.film_id = FACT.film_id
							INNER JOIN category AS CAT                       						 -- SELECT name, (category_id) FROM category
							ON FCG.category_id = CAT.category_id
							WHERE CAT.name = 'HORROR');



-- BONUS

/* 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 
minutos en la tabla film ..... */

SELECT title                                 					 							 -- SELECT title,(film_id),length FROM film
FROM film AS F                                                       
LEFT JOIN film_category AS FCAT                                   							 -- SELECT (film_id), category_id FROM film_category
ON  F.film_id = FCAT.film_id
LEFT JOIN category AS CAT                                         							 -- SELECT (category_id), name FROM category
ON FCAT.category_id = CAT.category_id
WHERE CAT.name = 'comedy' AND  F.length > 180;

--           COMPRUEBO/ con otro genero e imprimiendo la duracion y la categoria     -----

SELECT title,length , CAT.name                                   							 -- SELECT title,(film_id),length FROM film
FROM film AS F                                                       
LEFT JOIN film_category AS FCAT                                   							 -- SELECT (film_id), category_id FROM film_category
ON  F.film_id = FCAT.film_id
LEFT JOIN category AS CAT                                        							 -- SELECT (category_id), name FROM category
ON FCAT.category_id = CAT.category_id
WHERE CAT.name = 'action' AND  F.length > 180;



/* 25. Encuentra todos los actores que han actuado juntos en al menos una película. La 
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que 
han actuado juntos.*/

-- ------------------------------------------------------------------ --
SELECT CONCAT(A1.first_name, " ", A1.last_name) AS Actor1,
       CONCAT(A2.first_name, " ", A2.last_name) AS Actor2, 
       COUNT(DISTINCT F_ACT1.film_id) AS numero_peliculas_juntos
FROM film_actor AS F_ACT1
INNER JOIN actor AS A1 ON F_ACT1.actor_id = A1.actor_id
INNER JOIN film_actor AS F_ACT2 ON F_ACT1.film_id = F_ACT2.film_id 
AND F_ACT1.actor_id < F_ACT2.actor_id
INNER JOIN actor AS A2 ON F_ACT2.actor_id = A2.actor_id
GROUP BY A1.actor_id, A2.actor_id
HAVING numero_peliculas_juntos >= 1;