/*
Lab | Stored procedures
In this lab, we will continue working on the Sakila database of movie rentals.
Instructions
Write queries, stored procedures to answer the following questions:
*/

use sakila;

# 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
drop procedure if exists client_action;
delimiter //
create procedure client_action()
begin
  select first_name, last_name, email, category.name
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end
//
delimiter ;

call client_action();
  
# 2. Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.
drop procedure if exists client_action_cn;
delimiter $$
create procedure client_action_cn(in cat_nam varchar(40))
begin
  select first_name, last_name, email,category.name
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = cat_nam
  group by first_name, last_name, email;
end $$
delimiter ;

call client_action_cn('Family');

# 3. Write a query to check the number of movies released in each movie category. 
# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
# Pass that number as an argument in the stored procedure.

select fc.category_id, count(f.film_id) from film as f
join film_category as fc on fc.film_id = f.film_id
group by fc.category_id;

select cat.name, count(f.film_id) as number_films from film as f
join film_category as fc on fc.film_id = f.film_id
join category as cat on cat.category_id = fc.category_id
group by cat.name;


drop procedure if exists client_action_nm;

delimiter $$
create procedure client_action_nm(in num_mov int)
begin
  select cat.name, count(f.film_id) as number_films from film as f
	join film_category as fc on fc.film_id = f.film_id
	join category as cat on cat.category_id = fc.category_id
	group by cat.name
    having count(f.film_id) >= num_mov
    order by number_films;
end $$
delimiter ;

call client_action_nm(60);