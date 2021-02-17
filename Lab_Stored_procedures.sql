/** 
Instructions
Write queries, stored procedures to answer the following questions:

In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. 
Use the following query:

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
2. Now keep working on the previous stored procedure to make it more dynamic. 
Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
For eg., it could be action, animation, children, classics, etc.

3. Write a query to check the number of movies released in each movie category. 
Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
Pass that number as an argument in the stored procedure.
**/

drop procedure if exists actionmovies;

delimiter //
create procedure actionmovies()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name  = "Action"
  group by first_name, last_name, email;
  
  end;
//
delimiter ;

call actionmovies();



-- 2

drop procedure if exists movies;

delimiter //
create procedure movies(in param1 char (40))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = param1
  group by first_name, last_name, email;
  
  end;
//
delimiter ;

call movies("children");

-- 3 Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.


select c.name as Category_name, Count(f.title) as Films from category as c
join film_category as fc on fc.category_id = c.category_id
join film as f on f.film_id=fc.film_id
group by c.name;



drop procedure if exists movie_count;

delimiter //
create procedure movie_count (in param1 int)
 begin
  select name, number_films from (select count(f.title) as number_films, c.name from film as f
  join film_category as fc using (film_id)
  join category as c using (category_id)
  group by c.name) as sub1
  where number_films > param1;
  
  end;
  
  // 
  delimiter ;
  
call movie_count (55);




/**
-- doesn't work


drop procedure if exists movie_count;

delimiter //
create procedure movie_count(in param1 int)
begin
select c.name as Category_name, Count(f.title) as Films from category as c
join film_category as fc on fc.category_id = c.category_id
join film as f on f.film_id=fc.film_id
where Films > param1
group by c.name;
end;
//
delimiter ;

call movie_count(25);
**/
