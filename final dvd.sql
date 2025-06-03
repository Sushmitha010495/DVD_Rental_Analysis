select * from actor
select * from address
select * from category
select * from city
select * from country
select * from customer
select * from film
select * from film_category
select * from inventory
select * from language
select * from payment
select * from rental
select * from staff
select * from store

--Joining tables to get customer details----
select r.rental_id,c.customer_id,concat(c.first_name,' ',c.last_name) as customer_name,c.active,s.store_id,
a.phone,a.address,a.district,ci.city,co.country
from rental r
left join customer c on r.customer_id=c.customer_id
left join store s on c.store_id=s.store_id
left join address a on c.address_id=a.address_id
left join city ci on a.city_id=ci.city_id
left join country co on ci.country_id=co.country_id
order by r.rental_id;

----joining tables for film details-----
select r.rental_id,f.film_id,f.title as film_title,l.name as language,c.name as category,
f.rental_duration,f.rental_rate,f.replacement_cost,f.rating,
string_agg(distinct concat(a.first_name,'',a.last_name),',')as actor_names,coalesce(p.amount,0)as amount
from rental r
left join payment p on r.rental_id=p.rental_id
left join inventory i on r.inventory_id=i.inventory_id
left join film f on i.film_id=f.film_id
left join language l on f.language_id=l.language_id
left join film_category fc on f.film_id=fc.film_id
left join category c on fc.category_id=c.category_id
left join film_actor fa on f.film_id=fa.film_id
left join actor a on fa.actor_id=a.actor_id
group by r.rental_id,p.amount,f.film_id,f.title,l.name,c.name,f.release_year,
f.rental_duration,f.rental_rate,f.replacement_cost,f.rating;
	
------mean of rental rate-------
select avg(rental_rate) as mean_rental_rate from film;
------Distribution of replacement cost----
select replacement_cost,count(*) as count 
from film
group by replacement_cost
order by replacement_cost;

-----median of rental duration----
with new_films as (
	select rental_duration,row_number() over (order by rental_duration) as row_num,
	count(*) over () as total_rows
	from film
	)
	select avg(rental_duration) as median 
	from new_films
	where row_num in ((total_rows+1)/2,(total_rows+2)/2);

-----variability of rental_rate-----
select
	STDDEV(rental_rate) std_dev,
	VARIANCE(rental_rate) variance
	from film;






