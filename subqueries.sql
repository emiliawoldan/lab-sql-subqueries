-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film_id, count(inventory_id) as number_of_versions FROM sakila.inventory
WHERE film_id in (
	SELECT film_id FROM sakila.film
    WHERE title = 'Hunchback Impossible' 
    )
 GROUP BY film_id;
 
 -- 2. List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film
WHERE length > (
	SELECT AVG(length) FROM sakila.film)
ORDER BY length ASC;
	
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.actor
WHERE actor_id IN (
	SELECT actor_id FROM (
		SELECT actor_id FROM sakila.film
		JOIN sakila.film_actor USING (film_id)
		WHERE title = 'Alone Trip'
        )sub1
	);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT * FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM(
		SELECT film_id, category_id, name FROM sakila.film_category
        JOIN sakila.category USING (category_id)
		WHERE name = 'Family'
        ) sub1
	);
    
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
	-- version 1
SELECT CONCAT(first_name, ' ', last_name) as customer_name, email FROM sakila.customer
JOIN sakila.address USING (address_id)
JOIN sakila.city USING (city_id)
JOIN sakila.country USING (country_id)
WHERE country = 'Canada';

-- version 2
SELECT * FROM sakila.customer
WHERE address_id in (
	SELECT address_id FROM (
		SELECT address_id FROM sakila.address
        JOIN sakila.city USING (city_id)
		JOIN sakila.country USING (country_id)
        WHERE country = 'Canada'
        ) sub1
	);

/*	
6. Which are films starred by the most prolific actor? 
Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
*/    
SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM (
		SELECT film_id, count(actor_id) AS prolific_actor FROM sakila.film_actor
		GROUP BY film_id
		ORDER BY count(actor_id) DESC
        LIMIT 5
		)sub1
	);
    
-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM (
			SELECT film_id, customer_id, sum(amount) AS profit FROM sakila.payment
            JOIN sakila.rental USING (customer_id)
            JOIN sakila.inventory USING (inventory_id)
			GROUP BY film_id, customer_id
			ORDER BY sum(amount) DESC
            LIMIT 15
			)sub1
		);

-- 8. Customers who spent more than the average payments.
SELECT customer_id, sum(amount) AS sum  FROM sakila.payment
GROUP BY customer_id
HAVING sum > (SELECT AVG(sum) FROM (
	SELECT customer_id, sum(amount) AS sum FROM sakila.payment 
	GROUP BY customer_id
    ) sub2
);
		