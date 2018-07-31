use sakila;
-- 1a
select first_name,last_name from actor;

-- 1b
set sql_safe_updates = 0;
alter table actor add column Actor_Name varchar(50);
update actor set Actor_Name = concat(first_name, ',', last_name);
set sql_safe_updates = 1;
select Actor_Name from actor;

-- 2a
select actor_id,first_name,last_name from actor
where first_name = 'Joe';

-- 2b
select actor_id,first_name,last_name from actor
where last_name like '%GEN%';

-- 2c
select actor_id, first_name, last_name from actor
where last_name like '%LI%'
order by last_name ASC, first_name;

-- 2d
select country_id, country from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
select * from actor;
alter table actor ADD Column description BLOB;

-- 3b
alter table actor drop column description;
select * from actor;

-- 4a
select last_name, count(last_name) from actor 
group by last_name;

-- 4b
select last_name, count(last_name) from actor 
group by last_name
having count(last_name)>1;

-- 4c
set sql_safe_updates = 0;
update actor
set first_name = "HARPO" 
where first_name = 'GROUCHO'and last_name = 'WILLIAMS';
set sql_safe_updates = 1;

-- 4d
set sql_safe_updates = 0;
update actor
set first_name = "HARPO"
where first_name = 'GROUCHO';
set sql_safe_updates = 1;

-- 5a
show create table address;

-- 6a
select staff.first_name, staff.last_name, address.address from staff
join address on staff.address_id = address.address_id;

-- 6b
select * from payment;
select staff.first_name, staff.last_name, sum(payment.amount) from staff
join payment on payment.staff_id = staff.staff_id
where payment.payment_date like '2005-08%'
group by first_name;

-- 6c
select * from film;
select film.title, count(film_actor.actor_id) from film	
join film_actor on film_actor.film_id = film.film_id
group by title;

-- 6d
select * from film;
select film.title, count(inventory.film_id) from inventory
join film on inventory.film_id = film.film_id
where film.title = 'Hunchback Impossible';

-- 6e
select * from customer;
select customer.first_name, customer.last_name, sum(payment.amount) from customer
join payment on customer.customer_id = payment.customer_id
group by last_name asc;

-- 7a
select * from film;
select f.title from film f,language l
where f.title like 'Q%' or f.title like'K%' and l.name = 
(select name from language
where language_id = 1)
group by title;

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
    )
);

-- 7c
SELECT first_name, last_name, email 
FROM customer
JOIN address
ON (customer.address_id = address.address_id)
JOIN city 
ON (address.city_id=city.city_id)
JOIN country 
ON (city.country_id=country.country_id);


-- 7d
select * from category;

select film.title from film
where film_id in
(
select film_id from film_category
where category_id in
(
select category_id from category
where name like 'Family'
));

-- 7e
select * from inventory;
select film.title, count(rental.inventory_id) from rental
join inventory ON (inventory.inventory_id = rental.inventory_id)
join film ON
(film.film_id = inventory.film_id)
group by title
order by count(rental.inventory_id) DESC;

-- 7f
select * from store;
select store.store_id, sum(payment.amount) from payment
join customer 
on (payment.customer_id = customer.customer_id)
join store
on (customer.store_id = store.store_id)
group by store_id;

-- 7g
select * from city;
select store.store_id, city.city, country.country from store
join address on
(store.address_id = address.address_id)
join city on
(city.city_id = address.city_id)
join country on 
(country.country_id = city.country_id);

-- 7h
select * from payment;
select category.name, sum(payment.amount) from category
join film_category on 
(film_category.category_id = category.category_id)
join inventory on
(inventory.film_id = film_category.film_id)
join rental on
(rental.inventory_id = inventory.inventory_id)
join payment on 
(rental.rental_id = payment.rental_id)
group by name
order by sum(payment.amount) DESC
limit 5;

-- 8a 
CREATE VIEW Top_5_Genres_Gross_Rev AS
select category.name, sum(payment.amount) from category
join film_category on 
(film_category.category_id = category.category_id)
join inventory on
(inventory.film_id = film_category.film_id)
join rental on
(rental.inventory_id = inventory.inventory_id)
join payment on 
(rental.rental_id = payment.rental_id)
group by name
order by sum(payment.amount) DESC
limit 5;

-- 8b
select * from Top_5_Genres_Gross_Rev;


-- 8c
drop view Top_5_Genres_Gross_Rev;


