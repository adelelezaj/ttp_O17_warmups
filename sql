-- Did you know you can make multiple CTEs? Here's the syntax
WITH <name> AS (Query)
, <name> AS (Query)
, <name> AS (Query)
SELECT ....


-- Get all actors that have been in the same films as the most popular actor
-- OPTION: Try to get it all in one go, or do this in steps (see HINTS on the repo)


-- 1. Get the actor_id of the most popular actor (ie the actor who as been in the most films)

SELECT actor_id, COUNT(film_id)
FROM film_actor 
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;  -actor_id = 107

-- 2. Using the answer from above (actor_id 107), get a list of all the films that
-- actor has been in.

WITH most_popular_actor as (
    SELECT actor_id, COUNT(film_id)
    FROM film_actor 
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
)
SELECT film_id
FROM most_popular_actor
JOIN film_actor USING (actor_id);

-- 3. USING the list from the previous answer (going to have to use a CTE or subquery),
-- get a list of the names of all the actors that have been in those films 
-- (ie all the actors that have acted with the most popular actor)
-- BONUS: exclude the most popular actor from the list.

WITH most_popular_actor as (
    SELECT actor_id, COUNT(film_id)
    FROM film_actor 
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
),
films_with_most_popular_actor AS (
SELECT film_id
FROM most_popular_actor
JOIN film_actor USING (actor_id))

SELECT distinct(actor_id), a.first_name, a.last_name
FROM film_actor
JOIN actor as a USING (actor_id)
WHERE film_id IN (SELECT film_id FROM films_with_most_popular_actor) 
AND a.actor_id <> (SELECT actor_id FROM most_popular_actor) ;
