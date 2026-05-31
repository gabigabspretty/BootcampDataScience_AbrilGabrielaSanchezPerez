/*Taller #2: SQL Sakila
Realizado por: Abril Gabriela de los Angeles Sanchez Perez 
Bootcamp Data Science - 202604
*/

-- Parte 0: Usar la función USE para conectarse a la base de Datos ¨Sakila¨ para el desarrollo del Taller

USE sakila; 

/* Parte 1 - Usos de SELECT y WHERE
Resultados esperados: 
1. Mostrar nombre y apellido de todos los clientes
2. Peliculas con duracion mayor a 120 minutos
*/

/* 1. USO de SELECT: 
Es necesario saber como se llaman exactamente los campos de la seccion 'customer' que nos traerán los nombres y apellidos de los clientes
En este caso tenemos los campos 'first_name' y 'last_name' por lo que esto seran nuestros rangos de busqueda en la funcion SELECT
mientas que indicamos en la funcion FROM la tabla 'customer' que es donde se encuentran los datos mencionados
*/

SELECT first_name, last_name FROM customer ;

/* 2. USO de WHERE:
-- 2.1: Usar la funcion SELECT y FROM para indicar la fuente de nuestros datos
-- 2.2 Haciendo uso de la funcion WHERE (que funciona como filtro) y el signo > solo mostraremos aquellas que tienen mas de 120 minutos de duracion
*/

SELECT title, length FROM film
WHERE length >120;

/* Parte 2 - Uso de ORDER BY
Resultados esperados: 
3. Ordenar clientes por apellido --> Orden alfabético de la A a la Z
4. Top 5 películas mas largas (Como tip: Uso de la palabra LIMIT)
*/

/* 3. Uso de ORDER BY:
-- 3.1 Usar la funcion SELECT y FROM para indicar la fuente de datos en el orden: last_name > first_name
-- 3.2 Hacer uso de la funcion ORDER BY teniendo como parametro el apellido (last_name) seguido por el parámetro ASC para ordenarlos de forma ASCendente
*/

SELECT last_name, first_name FROM customer
ORDER BY last_name ASC ;

/* 4. Uso de ORDER BY + LIMIT
-- 4.1 Usar la funcion SELECT y FROM para indicar los datos (tabla de uso: film, columnas usadas: title, length)
-- 4.2 Indicar que ordene la duracion de forma DESCendente con el uso de la funcion ORDER BY y el parametro DESC
-- 4.3 Para que muestre el TOP 5 debemos hacer uso de la funcion LIMIT e indicar que solo muestre los primeros 5 resultados obtenidos
*/

SELECT title, length FROM film
ORDER BY length DESC
LIMIT 5;

/* Parte 3 - Uso de INNER JOIN
Resultados esperados: 
5. Mostrar la cantidad pagada y la fecha del pago con nombre y apellido del cliente (Base del JOIN: Payment - Customer)
6. Peliculas alquiladas(JOIN entre Rental - Inventory - Film)
*/

/* 5. Cantidad y Fecha del pago con Nombre y Apellido de Cliente
Llave que une las dos tablas: customer_id
-- 5.1 Como se ha visualizado, debemos hacer uso de la funcion SELECT y de FROM para poder visualizar los datos, nuestra tabla principal payment así que, para poder obtener
tambien los datos de la tabla 'customer' añadiremos un customer. antes de los datos que necesitamos de la misma sin afectar el FROM que será desde payment
-- 5.2 Como mencioné anteriormente, la llave que une estas dos tablas será customer_id, entonces para poder realizar el INNER JOIN con la base de 'customer' 
es necesario indicar esto en el parametro ON y separando las base con un .customer_id (observar linea 58), de no realizar esto obtendremos un resultado ambiguo
*/

SELECT amount, payment_date, customer.first_name, customer.last_name FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id ;

/* 6. Peliculas alquiladas. 
Objetivo: Mostrar unidades rentadas --> Tabla principal: Rental 
-- 6.1: Como solo necesitamos ver las películas rentadas, en el SELECT solo se selecciona el titulo de la pelicula desde la tabla 'film' pero como necesitamos saber
que unidades han sido rentadas, nuestro FROM se hará desde la tabla 'rental'. Como un extra, para que hacer un resumen de cuantas unidades x pelicula tenemos rentadas
se hace uso de la funcion COUNT (*) para contar todas las filas y un AS para que lo muestre en una columna aparte. 
-- 6.2 Procediendo con los INNER JOIN se toma como llaves que unen las tablas las siguientes:
inventory con rental = inventory_id
film con inventory = film.id
Esto permitira consolidar todo. 
-- 6.3 Como hicimos un COUNT es necesario hacer uso de la funcion GROUP BY para que 1. el codigo pueda funcionar y 2. Mostrar la cantidad de unidades alquiladas por cada título de película
*/

SELECT film.title, COUNT(*) AS unidades_alquiladas FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id 
GROUP BY film.title;

/* Parte 4. Uso de LEFT JOIN
Resultados esperados: 
7. Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)
8. Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actore
*/

/* 7. Nombre y Apellido de Clientes sin pagos. 
Llave que une ambas tablas = customer_id
-- 7.1 Realizamos un SELECT y un FROM cuya base es la tabla 'customer', la tabla payment solo la usaremos como referencia por lo que no es necesario mencionarla acá
-- 7.2 en el LEFT JOIN debemos indicar la llave que unirá ambas base
-- 7.3 Para que se nos muestre cuales clientes no han pagado, es necesario usar la funcion IS NULL para que muestre todas las celdas en donde el customer_id esté vacío dentro
de la tabla 'payment', observando el codigo, todos los clientes tienen al menos 1 pago registrado. 
*/

SELECT first_name, last_name FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment_id IS NULL ; 

/* 8. Nombre de Peliculas y Duracion de Titulos sin actores 
PRECAUCION = La tabla que se debe usar para el JOIN debe ser film_actor NO la de actor
Llave que unirá ambas tablas es film_id, los pasos acá usados corresponden a los mismos a los del punto 7 usando como referencia las tablas film y film_actor
*/

SELECT title, length FROM film
LEFT  JOIN film_actor ON film.film_id = film_actor.film_id
WHERE actor_id IS NULL;

/* PARTE 5 - Uso de INSERT, UPDATE, DELETE (Data Definition Language)
Resultados esperados
9. Insertar actor temporal
10. Actualizar actor
11. Eliminar actor
USAR WHERE
*/

/* 9. Insertar Actor Temporal
Base afectada = actor 
Datos usados: 
first_name = Abril
last_name = Sanchez
-- 9.1 Para poder modificar esta tabla es necesario hacer uso de la funcion INSERT INTO, indicando entre paréntesis que valores deseamos modificar
-- 9.2 Para añadir nuevos valores es necesario usar la funcion VALUES
-- 9.3 Para poder visualizar si la adicion podemos usar la funcion SELECT y FROM (En nuestro caso, el actor_id 205)
*/

INSERT INTO actor (first_name, last_name)
VALUES('Abril', 'Sanchez') ;
SELECT * FROM actor ;  

/* 10. Actualizar el registro temporal
Datos a Actualizar: 
actor_id = 205
last_name = Perez
-- 10.1 La actualizacion debe hacer usando la funcion UPDATE, y la base a actualizar sigue siendo 'actor'
-- 10.2 Usando la funcion SET debemos indicar que columna vamos a actualizar y el valor a actualizar
-- 10.3 Para evitar que se modifique cualquier otro valor más alla de nuestro actor_id se usa la funcion WHERE e indicar el id asignado por la tabla (205)
*/

UPDATE actor
SET last_name = 'Perez'
WHERE actor_id = 205 ; 
SELECT * FROM actor ;

/* NOTA PORQUE COMETI UN ERROR: 

Al correr la funcion SELECT, cometí el error de correr todo el codigo nuevamente, por lo que se observa que se ha añadido otro actor con el mismo nombre pero con el ID 206
esto más los registros del 20 de Abril que están repetidos serán eliminados en el siguiente punto :) 

*/

/* 11. Eliminar los registros temporales
Teniendo en cuenta que tenemos registros repetidos más el registro 205 que fue el que actualizamos, haciendo una consulta vi que se puede usar la funcio BETWEEN
esto para poder eliminar varios registros, siendo así:
-- 11.1 Haciendo uso de la funcion DELETE FROM debemos seleccionar la tabla de 'actor' 
-- 11.2 Para asegurarnos que no vaya a borrar toda la tabla, usaremos la funcion WHERE para indicarle que use como parametro los actor_id que le daremos
-- 11.3 En la funcion BETWEEN indicaremos desde y hasta donde deseamos eliminar los registros
*/ 

DELETE FROM actor
WHERE actor_id
BETWEEN 202 AND 206 ;

-- Usando un SELECT * FROM actor podremos ver los cambios realizados

SELECT * FROM actor ;

/* PARTE 6 - Consultas Avanzadas
12. Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
13. Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5
*/ 

/* 12. Top 5 Clientes con Mayor Cantidad de dinero pagado al servicio de rentas
Llave que conecta ambas bases: customer_id
-- 12.1 Como deseamos ver los cantidad pagada por cada cliente, nuestra base para el FROM debe ser la tabla 'payment', mientras que los parámetros de busqueda para el SELECT
serán traídos desde la base customer (es por eso que se coloca como customer. ) y para poder obtener la cantidad pagada por cliente, debemos hacer uso de la formula SUM
trayendo desde la tabla payment la cantidad pagada, esto lo veremos en la nueva columna llamada cantidad_pagada. 
-- 12.2 Para poder unir las tablas haciendo uso de la llave que conecta ambas tablas debemos usar el INNER JOIN
-- 12.3 Agrupamos los nombre y apellidos de cada cliente de la base de customer y...
-- 12.4 Ordenamos por la sumatoria obtenida en cantidad_pagada de forma DESCendente (Mayor a menor)
-- 12.5 Para obtener solo el Top 5, usamos la funcion LIMIT.
*/

SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS cantidad_pagada FROM payment
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.first_name, customer.last_name 
ORDER BY cantidad_pagada DESC
LIMIT 5; 

/* 13. Top 5 Películas mas alquiladas
Para efectos de este ejercicio, usaremos el codigo usado en el punto 6, pero añadiendo en las filas 168 y 169 lo siguiente:
-- 13.1 Para poder hacer un top 5 primero necesitamos saber mediante un ORDER.BY cuales son las peliculas con el mayor numero de unidades alquiladas (DESC)
-- 13.2 Usamos la funcion LIMIT para poder traer los primeros 5 resultados de forma DESCendiente
*/

SELECT film.title, COUNT(*) AS unidades_alquiladas FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id 
GROUP BY film.title 
ORDER BY unidades_alquiladas DESC
LIMIT 5;

-- FIN DEL TALLER