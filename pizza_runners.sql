CREATE SCHEMA pizza_runner;

use pizza_runner;
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', 'null', 'null', '2020-01-01 18:05:02'),
  ('2', '101', '1', 'null', 'null', '2020-01-01 19:00:52'),
  ('3', '102', '1', 'null', 'null', '2020-01-02 23:51:23'),
  ('3', '102', '2','null' , 'null','2020-01-02 23:51:23'),
  ('4', '103', '1', '4', 'null', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', 'null', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', 'null', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', 'null'),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', 'null'),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', 'NULL'),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', 'NULL'),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', 'NULL'),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  -- 1.	How many pizzas were ordered?
  select count(order_id) as no_of_pizzas_ordered 
  from customer_orders;
  
  -- 2.	How many unique customer orders were made?
   select distinct customer_id , count(pizza_id) as orders from customer_orders
   group by customer_id;
   
   -- 3.	How many successful orders were delivered by each runner?
   select  distinct runner_id, order_id , count(cancellation) as succesful_orders
   from runner_orders
   where cancellation != 'Restaurant Cancellation' and
   cancellation != 'Customer Cancellation'
   group by runner_id;
   
   -- 4.	How many of each type of pizza was delivered?
   select count(cancellation) as no_of_pizza_delivered 
   from runner_orders
    where cancellation != 'Restaurant Cancellation' and
   cancellation != 'Customer Cancellation';
   
  -- 5.	How many Vegetarian and Meatlovers were ordered by each customer?
  select c.customer_id, count(c.pizza_id) as pizza_id, pizza_name
  from customer_orders c, pizza_names  p
  where c.pizza_id= p.pizza_id
  group by pizza_name , c.customer_id
  order by c.customer_id;
  
  -- 6.	What was the maximum number of pizzas delivered in a single order?
  select c.order_id , count(pizza_id) as total_pizza from customer_orders c
  join runner_orders r on c.order_id = r.order_id
  group by order_id
  order by total_pizza desc
   limit 1;
   
   -- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,
 CASE WHEN exclusions = 'NULL' AND extras = 'NULL' THEN count(pizza_id)
 END AS no_change_made,
 CASE WHEN exclusions != 'NULL' OR extras != 'NULL' THEN count(pizza_id)
END AS changes_made
FROM CUSTOMER_ORDERS
GROUP BY customer_id;

  -- 8.	How many pizzas were delivered that had both exclusions and extras?
  select count(pizza_id) as no_of_pizza from customer_orders
  where exclusions != 'NULL' or
  extras != 'null';
  
  -- 9.	What was the total volume of pizzas ordered for each hour of the day?
 select hour(order_time) as hours, count(order_id)as total, 
 count(order_id)*100/sum(count(*)) over() as volume from customer_orders
 group by hours
 order by hours;
 
 -- 10.	What was the volume of orders for each day of the week?
 select dayname(order_time) as day, count(order_id)as total, 
 count(order_id)*100/sum(count(*)) over() as volume from customer_orders
 group by day
 order by day;
 
 -- B. Runner and Customer Experience
 -- 1.	How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
 select week(registration_date) as week, count(runner_id) no_of_runners from runners
 where registration_date >= '2021-01-01'
 group by week
 order by week ;
 
 -- 2.	What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select runner_id, avg(minute(time(pickup_time) - time(order_time))) as avg_arrival_time
 from runner_orders r join customer_orders c on
 r.order_id = c.order_id
 where cancellation = 'null'
 group by runner_id;

-- 3.	Is there any relationship between the number of pizzas and how long the order takes to prepare?
select c.order_id, sum(pizza_id), duration
from customer_orders c join runner_orders r
on c.order_id = r.order_id 
where duration != 'null'
group by order_id; 
-- no there is no relationship between number of pizzas and how long the order takes to prepare

-- 4.	What was the average distance travelled for each customer?
select customer_id, avg(distance) as avg_dist
from customer_orders c
join runner_orders r 
on c.order_id = r.order_id
where distance != 'null'
group by customer_id;

-- 5.	What was the difference between the longest and shortest delivery times for all orders?
select max(duration)-min(duration) as difference from runner_orders
where duration != 'null';

-- 6.	What was the average speed for each runner for each delivery and do you notice any trend for these values?
select order_id,runner_id ,round(avg(distance*(duration)),2)as avg_speed from runner_orders
where cancellation = 'null'
group by runner_id, order_id
order by runner_id, order_id;

-- 7.	What is the successful delivery percentage for each runner?
create view delivered as select count(cancellation) as not_cancelled , runner_id  from runner_orders
where cancellation = 'null'
group by runner_id;
select * from delivered;
select r.runner_id, (not_cancelled/count(cancellation))*100 as delievery_percentage
from delivered d
join runner_orders r
on d.runner_id = r.runner_id
group by runner_id;

-- C. Ingredient Optimisation
-- 1.	What are the standard ingredients for each pizza?

WITH cte AS (SELECT topping_name as meat_lovers, topping_id
		FROM pizza_toppings
		WHERE topping_id != 7 AND topping_id !=9 AND topping_id !=11 AND topping_id != 12),
testing AS ( SELECT topping_name as vegeterian, topping_id
		FROM pizza_toppings
		WHERE topping_id != 1 AND topping_id !=2 AND topping_id !=3 AND topping_id!= 5 AND topping_id != 8 AND topping_id !=10)
 SELECT c.meat_lovers, t.vegeterian
 FROM cte c
 left JOIN testing t ON c.topping_id=t.topping_id
 UNION
SELECT c.meat_lovers, t.vegeterian
FROM cte c
RIGHT JOIN testing t ON c.topping_id=t.topping_id;

-- 2.	What was the most commonly added extra?
with extras as (
    select pizza_id, substr(extras,1,1) as extra1,
    substr(extras,4,1) as extra2
    from pizza_runner.customer_orders
    where extras is not Null
),
extras2  as(
    select extra1 as extra from extras
    union all
    select extra2 as extra from extras where extra2 is not Null
)
select b.topping_name, count(a.extra) as counts 
from extras2 a
left join pizza_runner.pizza_toppings b
on a.extra = b.topping_id
where topping_name is not null
group by b.topping_name
order by counts desc
 limit 1;

-- 3.	What was the most common exclusion?
with exclusions as (
    select pizza_id, substr(exclusions,1,1) as exclusion1,
    substr(exclusions,4,1) as exclusion2
    from pizza_runner.customer_orders
    where exclusions is not Null
),
exclusions2 as(
    select exclusion1 as exclusion from exclusions
    union all
    select exclusion2 as exclusion from exclusions where exclusion2 is not Null
)
select b.topping_name, count(a.exclusion) as counts 
from exclusions2 a
left join pizza_runner.pizza_toppings b
on a.exclusion = b.topping_id
where topping_name is not null
group by b.topping_name
order by counts desc
limit 1;

-- 4.	Generate an order item for each record in the customers_orders table in the format of one of the following:
-- o	Meat Lovers
-- o	Meat Lovers - Exclude Beef
-- o	Meat Lovers - Extra Bacon
-- o	Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
select *, 
case when pizza_id = 1 and exclusions = 'null' and extras = 'null' then 'meat_lovers'
when pizza_id = 2 and exclusions = 'null'  and extras = 'null'  then 'vegeterian_lovers'
when pizza_id = 1 and exclusions = '4'and extras = 'null' then 'meat_lovers- exlude_cheese'
when pizza_id = 2 and exclusions  = '4'  and extras = 'null' then 'vegeterian_lovers- exclude_cheese'
when pizza_id = 1 and exclusions= '4' and extras = '1, 5' then 'meat_lovers- exclude_cheese- extra_bacon_chicken'
when pizza_id = 1 and exclusions='2, 6'and extras = '1, 4' then 'meat_lovers- exclude_BBQ_sauce_mushrooms- extra_bacon_cheese'
when pizza_id = 1 and exclusions = 'null'  and extras = 1 then 'meat_lovers- extra_bacon'
when pizza_id = 2 and exclusions = 'null'  and extras = 1 then 'vegeterian_lovers- extra_bacon_chicken'
end as orders
from customer_orders;
 
-- 5.	Generate an alphabetically ordered comma separated ingredient list for 
-- each pizza order from the customer_orders table and 
-- add a 2x in front of any relevant ingredients
SELECT *, 
	CASE WHEN pizza_id= 1 AND exclusions = 'null' AND extras = 'null'THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN  pizza_id=2 AND exclusions = 'null' AND extras = 'null' THEN 'Vegeterian: Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND exclusions= '4' AND extras = 'null'THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND exclusions= '4'AND extras = 'null' THEN 'Vegeterian: Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND extras='1, 5' AND exclusions= '4' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, 2xChicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras='1, 4' AND exclusions='2, 6' THEN 'Meat Lovers: 2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras= '1' AND exclusions = 'null' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND extras= '1' AND exclusions = 'null' THEN 'Vegeterian: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
		END AS orders
FROM customer_orders;

-- 6.	What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
with cte as ( SELECT c.order_id , customer_id, c.pizza_id, 
	CASE WHEN pizza_id= 1 AND exclusions = 'null' AND extras = 'null'THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN  pizza_id=2 AND exclusions = 'null' AND extras = 'null' THEN 'Vegeterian: Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND exclusions= '4' AND extras = 'null'THEN 'Meat Lovers: Bacon, BBQ Sauce, Beef, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND exclusions= '4'AND extras = 'null' THEN 'Vegeterian: Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
	WHEN pizza_id=1 AND extras='1, 5' AND exclusions= '4' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, 2xChicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras='1, 4' AND exclusions='2, 6' THEN 'Meat Lovers: 2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami'
	WHEN pizza_id=1 AND extras= '1' AND exclusions = 'null' THEN 'Meat Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
	WHEN pizza_id=2 AND extras= '1' AND exclusions = 'null' THEN 'Vegeterian: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'
		END AS orders
FROM customer_orders c JOIN runner_orders r ON c.order_id = r.order_id
	WHERE cancellation = 'null'),
 testing AS (
SELECT *,
	CASE WHEN orders LIKE '%2xBacon%' THEN (COUNT(pizza_id)+1)
	     WHEN orders LIKE '%Bacon%' THEN COUNT(pizza_id) END AS bacon,
	CASE WHEN orders LIKE '%BBQ Sauce%' THEN COUNT(pizza_id) END AS bbq_sauce,
	CASE WHEN orders LIKE '%Beef%' THEN COUNT(pizza_id) END AS beef,
	CASE WHEN orders LIKE '%2xCheese%' THEN COUNT(pizza_id)+1
	     WHEN orders LIKE '%Cheese%' THEN COUNT(pizza_id) END AS cheese,
	CASE WHEN orders LIKE '%Chicken%' THEN COUNT(pizza_id) END AS chicken,
	CASE WHEN orders LIKE '%Mushrooms%' THEN COUNT(pizza_id) END AS mushrooms,
	CASE WHEN orders LIKE '%Onions%' THEN COUNT(pizza_id) END AS onions,
	CASE WHEN orders LIKE '%Pepperoni%' THEN COUNT(pizza_id) END AS pepperoni,
	CASE WHEN orders LIKE '%Peppers%' THEN COUNT(pizza_id) END AS peppers,
	CASE WHEN orders LIKE '%Salami%' THEN COUNT(pizza_id) END AS salami,
	CASE WHEN orders LIKE '%Tomatoes%' THEN COUNT(pizza_id) END AS tomatoes,
	CASE WHEN orders LIKE '%Tomato Sauce%' THEN COUNT(pizza_id) end as tomato_sauce
FROM cte
GROUP BY pizza_id)
SELECT 'bacon' ingredients, SUM(bacon) no_of_ingredients FROM testing
UNION ALL 
SELECT 'bbq_sauce' ingredients, SUM(bbq_sauce) no_of_ingredients FROM testing
UNION ALL
SELECT 'beef' ingredients, SUM(beef) no_of_ingredients FROM testing
UNION ALL
SELECT 'cheese' ingredients, SUM(cheese) no_of_ingredients FROM testing
UNION ALL
SELECT 'chicken' ingredients, SUM(chicken) no_of_ingredients FROM testing
UNION ALL
SELECT 'mushrooms' ingredients, SUM(mushrooms) no_of_ingredients FROM testing
UNION ALL
SELECT 'onions' ingredients, SUM(onions) no_of_ingredients FROM testing
UNION ALL
SELECT 'pepperoni' ingredients, SUM(pepperoni) no_of_ingredients FROM testing
UNION ALL
SELECT 'peppers' ingredients, SUM(peppers) no_of_ingredients FROM testing
UNION ALL
SELECT 'salami' ingredients, SUM(salami) no_of_ingredients FROM testing
UNION ALL
SELECT 'tomatoes' ingredients, SUM(tomatoes) no_of_ingredients FROM testing
UNION ALL
SELECT 'tomato_sauce' ingredients, SUM(tomato_sauce) no_of_ingredients FROM testing
ORDER BY no_of_ingredients DESC;

-- D. Pricing and Ratings
-- 1.	If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
-- how much money has Pizza Runner made so far if there are no delivery 
with cte as (
select 
case when pizza_id = 1 then count(pizza_id)*12
     when pizza_id = 2 then count(pizza_id)*10
END AS prices_per_pizza
FROM customer_orders
GROUP BY pizza_id)
SELECT SUM(prices_per_pizza) AS total_sales
FROM cte;

-- 2.	What if there was an additional $1 charge for any pizza extras?
-- o	Add cheese is $1 extra
SELECT *,
	CASE WHEN pizza_id=1 AND extras is NULL THEN (count(pizza_id)*12)
		WHEN pizza_id=1 AND extras LIKE '%,%' THEN ((count(pizza_id)*12)+2)
		WHEN pizza_id=1 AND extras NOT LIKE '%,%' THEN ((count(pizza_id)*12)+1)
		WHEN pizza_id=2 AND extras IS NULL THEN (count(pizza_id)*10)
		WHEN pizza_id=2 AND extras LIKE '%,%' THEN ((count(pizza_id)*10)+2)
		WHEN pizza_id=2 AND extras NOT LIKE '%,%' THEN ((count(pizza_id)*10)+1)
        END AS prices_per_pizza
FROM customer_orders
GROUP BY pizza_id;

-- 3.	The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,
-- how would you design an additional table for this new dataset 
-- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
create schema pizza_runner2;
use pizza_runner2;
CREATE TABLE runner_ratings (
	order_id INT AUTO_INCREMENT primary key,
	runner_id INT,
	ratings INT,
	constraint fk_rId FOREIGN KEY (runner_id) REFERENCES pizza_runner.runners(runner_id) ON DELETE SET NULL);
INSERT INTO runner_ratings (runner_id, ratings)   
VALUES
(1,3),
(1,2),
(1,4),
(2,5),
(3,2),
(3,NULL),
(2,3),
(2,2),
(2,NULL),
(1,5);
SELECT *
FROM runner_ratings;

-- 4.	Using your newly generated table - can you join all of the information together to form a table which has the following information 
-- for successful deliveries?
-- customer_id,order_id,runner_id,order_time,pickup_time,Time between order and pickup,Delivery duration,Average speed,Total number of pizzas
create view new as select pizza_runner.c.order_id, pizza_runner.c.customer_id,pizza_runner2.rr.runner_id,
 pizza_runner.c.order_time, pizza_runner2.rr.ratings,
  pizza_runner.ro.pickup_time,
 pizza_runner.ro.duration
from pizza_runner2.runner_ratings rr join pizza_runner.customer_orders c
on pizza_runner2.rr.order_id = pizza_runner.c.order_id
 join pizza_runner.runner_orders ro 
on pizza_runner.ro.order_id= pizza_runner.c.order_id
  where pickup_time != 'null'
 group by pizza_runner.c.order_id;
select * , timediff(time(ro.pickup_time),time(c.order_time)) time_interval, round(avg(ro.distance*(ro.duration/60)),2)as avg_speed,
count(c.pizza_id) as total_pizza 
from customer_orders c join runner_orders ro
on c.order_id = ro.order_id
where pickup_time != 'null'
 group by c.order_id;
 
 -- 5.	If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled
 -- how much money does Pizza Runner have left over after these deliveries?
create view new2 as
 select distance* 0.30 as distance_cost,
case when pizza_id = 1 then count(pizza_id)*12
     else count(pizza_id)*10
END AS total_sales
FROM customer_orders c join runner_orders ro
on c.order_id = ro.order_id
where distance != 'null'
GROUP BY c.order_id;
 select (sum(total_sales) - sum(distance_cost)) as total_profit from new2;
 
 -- E. Bonus Questions
-- If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
-- Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
insert into pizza_names values ('3' , 'supreme');
insert into pizza_recipes values ('3', '1,2,3,4,5,6,7,8,9,10,11,12');