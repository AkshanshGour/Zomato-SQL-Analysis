-- EDA

SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;
SELECT * FROM deliveries;

-- Import Datasets

-- Check if there is any null value in customer table
SELECT COUNT(*) FROM customers
WHERE customer_id IS NULL
	OR
	customer_name IS NULL
    OR
    reg_date IS NULL;

-- Check if there is any null value in restaurants table
SELECT COUNT(*) FROM restaurants
WHERE 
	restaurant_name IS NULL
	OR
	restaurant_id IS NULL
	OR
	city IS NULL
	OR
	opening_hours IS NULL;

-- Check if there is any null value in orders table
SELECT COUNT(*) FROM orders
WHERE 
	order_id IS NULL
	OR
	order_item IS NULL
	OR
	order_date IS NULL
	OR
	order_time IS NULL
	OR
	order_status IS NULL
	OR
	total_amount IS NULL;

-- Check if there is any null value in riders table
SELECT COUNT(*) FROM riders
WHERE rider_id IS NULL
	OR
	rider_name IS NULL
	OR
	sign_up IS NULL;

-- Check if there is any null value in deliveries table
SELECT COUNT(*) FROM deliveries
WHERE delivery_id IS NULL
	OR
 	delivery_status IS NULL
	OR	
	delivery_time IS NULL;



-- delete null values
SELECT * FROM orders
WHERE
	order_item IS NULL
	OR
	order_date IS NULL
	OR
	order_time IS NULL
	OR
	order_status IS NULL
	OR 
	total_amount IS NULL;

	
DELETE FROM orders
WHERE
	order_item IS NULL
	OR
	order_date IS NULL
	OR
	order_time IS NULL
	OR
	order_status IS NULL
	OR 
	total_amount IS NULL;

-- Analysis & Reports

-- Q1. Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in 2023.

-- join customers and orders
-- filter data for last 3 year
-- filter for 'arjun mehta'
-- group by customer id, dishes , and the count of total order

SELECT 
	customer_name,
	dishes,
	total_orders
FROM
(SELECT 
	c.customer_id,
	c.customer_name,
	o.order_item as dishes,
	COUNT(*) as total_orders,
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) as rank
FROM orders as o
JOIN
customers as c 
ON c.customer_id = o.customer_id
WHERE
	EXTRACT(YEAR FROM o.order_date) = 2023
	AND
	c.customer_name = 'Arjun Mehta'

GROUP BY 1,2,3
ORDER BY 1,4 DESC) as t1
WHERE rank <= 5;

-- 2. Popular Time Slots
-- Question: Identify the time slots during which the most orders are placed, based on 2 hour intervals


SELECT 
	FLOOR (EXTRACT(HOUR FROM order_time)/2)*2 as start_time,
	FLOOR (EXTRACT(HOUR FROM order_time)/2)*2 + 2 as end_time,
	COUNT(*) as total_orders
FROM orders
GROUP BY 1,2
ORDER BY 3 DESC;

-- 3. Order Value Analysis
-- Question: Find the average order value per customer who has placed more than 750 orders.
-- Return customer_name, and aov(average order value)

SELECT 
	c.customer_name,
	AVG(o.total_amount) as aov
FROM orders as o
	JOIN customers as c
	ON c.customer_id = o.customer_id
GROUP BY 1
HAVING COUNT(order_id) > 750;



-- 4. High Value Customers
-- Question: list the customers who have spent more than 100k in total on food orders.
-- return customer_name , and customer_id
SELECT 
	c.customer_name,
	SUM(o.total_amount) as total_spent
FROM orders as o
	JOIN customers as c
	ON c.customer_id = o.customer_id
GROUP BY 1
HAVING SUM(o.total_amount) > 100000;

-- 5. Orders without Delivery
-- Question: Write a query to find orders that were placed but not delivered.
-- Return each restaurant name,city and number of not delivered orders

SELECT 
	r.restaurant_name,
	COUNT(o.order_id) as cnt_not_delivered_orders 
FROM orders as o
LEFT JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
LEFT JOIN
deliveries as d
ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY 1
ORDER BY 2 DESC;


-- Q.6
-- Restaurant Revenue Ranking:
-- Rank restaurants by their total revenue from the last three years, including their name
-- total revenue and rank within thier city

WITH ranking_table
AS
(
	SELECT 
		r.city,
		r.restaurant_name,
		SUM(o.total_amount) as revenue,
		RANK() OVER(PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) as rank
	FROM orders as o
	JOIN
	restaurants as r
	ON r.restaurant_id = o.restaurant_id
	WHERE EXTRACT(YEAR FROM o.order_date) = 2023
	GROUP BY 1,2  
)
SELECT
	*
FROM ranking_table
WHERE rank = 1 

-- Q7. 
-- Most Popular Dish by City:
-- Identify the most popular dish in each city based on th number of orders

SELECT *
FROM
(SELECT
	r.city,
	o.order_item as dish,
	count(order_id) as total_orders,
	RANK() OVER(PARTITION BY r.city ORDER BY count(order_id) DESC) as rank 
FROM orders AS o
JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
GROUP BY 1,2
) as t1
WHERE RANK = 1;


-- Q8. Customer Churn:
-- Find customers who placed an order in the first half of 2023 but did not place an order in the second half of 2023.

SELECT DISTINCT customer_id
FROM orders
WHERE order_date >= '2023-01-01'
  AND order_date < '2023-07-01'
  AND customer_id NOT IN
(
    SELECT DISTINCT customer_id
    FROM orders
    WHERE order_date >= '2023-07-01'
      AND order_date < '2024-01-01'
);

-- Q9. Cancellation Rate Comparison:
-- Compare the order cancellation/non-delivery rate for each restaurant between 
-- the first half and second half of 2023.

WITH cancel_ratio_h1 AS
(
    SELECT 
        restaurant_id,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders AS o
    LEFT JOIN deliveries AS d
        ON o.order_id = d.order_id
    WHERE o.order_date >= '2023-01-01'
      AND o.order_date < '2023-07-01'
    GROUP BY 1
),

cancel_ratio_h2 AS
(
    SELECT 
        restaurant_id,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders AS o
    LEFT JOIN deliveries AS d
        ON o.order_id = d.order_id
    WHERE o.order_date >= '2023-07-01'
      AND o.order_date < '2024-01-01'
    GROUP BY 1
)

SELECT 
    h1.restaurant_id,
    
    h1.total_orders AS h1_total_orders,
    h1.not_delivered AS h1_not_delivered,
    ROUND(
        100.0 * h1.not_delivered / NULLIF(h1.total_orders, 0),
        2
    ) AS h1_rate,

    h2.total_orders AS h2_total_orders,
    h2.not_delivered AS h2_not_delivered,
    ROUND(
        100.0 * h2.not_delivered / NULLIF(h2.total_orders, 0),
        2
    ) AS h2_rate

FROM cancel_ratio_h1 AS h1
JOIN cancel_ratio_h2 AS h2
    ON h1.restaurant_id = h2.restaurant_id;

-- Q10. Rider average delivery time:
-- Determine each rider's average delivery time.
SELECT 
	o.order_id,
	o.order_time,
	d.delivery_time,
	rider_id, 
	EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
	CASE WHEN d.delivery_time <  o.order_time THEN INTERVAL '1 day' ELSE
	INTERVAL '0 day' END))/60 as time_difference_inmin   
FROM 
orders as o
JOIN deliveries as d
ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered';

-- 	Q11. Monthly restaurant grwoth ratio:
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining

WITH growth_ratio
AS(
SELECT
	o.restaurant_id,
	TO_CHAR(o.order_date,'mm-yy') as month,
	COUNT(o.order_id) as cr_month_orders,
	LAG(COUNT(o.order_id) ,1) OVER(PARTITION BY o.restaurant_id ORDER BY TO_CHAR(o.order_date,'mm-yy')) as prev_month_orders
FROM orders as o
JOIN
deliveries as d
ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY 1,2
ORDER BY 1,2
)
SELECT
	restaurant_id,
	month,
	prev_month_orders,
	cr_month_orders,
	(cr_month_orders::numeric - prev_month_orders::numeric)/prev_month_orders::numeric * 100
	as growth_ratio
FROM growth_ratio	

-- Q12. Customer Segmentation:
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on their total spending
-- compared to the average order value(AOV). If a customer's total spending exceeds the AOV.
-- label them as 'Gold'; otherwise, label them as 'Silver'. Write a SQL query to determine each segment's
-- total number of orders and total revenue

-- what we need
-- cx total spend
-- aov
-- gold
-- silver
-- each category and total orders and total rev

--SELECT * FROM orders

SELECT
	cx_category as total_revenue,
	SUM(total_orders) as total_orders,
	SUM(total_spend)
FROM
(
SELECT 
	customer_id,
	SUM(total_amount) as total_spend,
	count(order_id) as total_orders,
	CASE WHEN SUM(total_amount) > (SELECT AVG(total_amount) from orders) THEN 'Gold'
		ELSE 'Silver'
	END as cx_category
	FROM orders
GROUP BY 1
) as t1
group by 1

--SELECT AVG(total_amount) from orders  --322.8216 -- as a subquery use kra hai

-- Q13. Rider Monthly Earnings:
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.



SELECT 
	d.rider_id,
	TO_CHAR(o.order_date, 'mm-yy') as month,
	SUM(total_amount) as revenue,
	SUM(total_amount)*0.08 as riders_monthly_earning
FROM orders as o
JOIN deliveries as d
on o.order_id = d.order_id
GROUP BY 1,2
ORDER BY 1,2

-- Q14. Rider Ratings Analysis:
-- Find the number of 5-star,4-star and 3-star ratings each rider has.
-- riders receive this rating based on delivery time.
-- if orders are delivered less than 25 minutes of order received
-- if they deliver 25 and 30 minutes they get 4 star rating
-- if they deliver after 30 minutes they get 3 star rating

SELECT 
	rider_id,
	stars,
	count(*) as total_stars
FROM
(
SELECT 
	rider_id,
	delivery_took_time,
	CASE
		WHEN delivery_took_time < 25 THEN '5 Star'
		WHEN delivery_took_time BETWEEN 25 and 30 THEN '4 Star'
		ELSE '3 Star'
	END as stars
FROM
(
SELECT 
	o.order_id,
	o.order_time,
	d.delivery_time,
	EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
	CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day'
	ELSE INTERVAL '0 day' END
	))/60 as delivery_took_time,
	d.rider_id
FROM orders as o
JOIN deliveries as d
ON o.order_id = d.order_id
WHERE delivery_status = 'Delivered'
) as t1
) as t2
GROUP BY 1,2
ORDER BY 1,3 DESC

-- Q15. Order frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.

SELECT * FROM
(
SELECT 
	r.restaurant_name,
--	o.order_date,
	TO_CHAR(o.order_date,'Day') as day,
	COUNT(o.order_id) as total_orders,
	RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) as rank
FROM orders as o
JOIN
restaurants as r
ON o.restaurant_id = r.restaurant_id
GROUP BY 1,2
ORDER BY 1,3 DESC
) as t1
WHERE rank = 1


-- Q16. Customer Lifetime Value (CLV):
-- Calculate the total revenue generated by each customer over all their orders.

SELECT 
	c.customer_id,
	c.customer_name,
	SUM(o.total_amount) as CLV
FROM 
orders as o
JOIN
customers as c
ON o.customer_id = c.customer_id
GROUP BY 1,2

-- Q17. Monthly Sales Trends:
-- Identify sales trends by comparing each month's total sales to the previous month.

SELECT 
	EXTRACT(YEAR FROM order_date) as year,
	EXTRACT(MONTH FROM order_date) as month,
	SUM(total_amount) as total_sale,
	LAG(SUM(total_amount),1) OVER(ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) as prev_month_sale
FROM orders
GROUP BY 1,2
ORDER BY 1,2

-- Q18. Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest average.

WITH new_table
AS
(
	SELECT 
		d.rider_id as riders_id,
		EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
		CASE WHEN d.delivery_time <  o.order_time THEN INTERVAL '1 day' ELSE
		INTERVAL '0 day' END))/60 as time_deliver
	
	FROM orders as o
	JOIN deliveries as d
	ON o.order_id = d.order_id
	WHERE d.delivery_status = 'Delivered'
),

riders_time
AS

(SELECT 
	riders_id,
	AVG(time_deliver) as avg_time
FROM new_table
GROUP BY 1
)
SELECT 
	MIN(avg_time),
	MAX(avg_time)
FROM riders_time

-- Q.19 Order Item Popularity:
--Track the popularity of specific order items over time and identify seasonal demand spikes.

SELECT
	order_item,
	seasons,
	COUNT(order_id) as total_orders
FROM
(	

SELECT 
	*,
	EXTRACT(MONTH FROM order_date) as month,
	CASE
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN  4 AND 6 THEN'Spring'
		WHEN EXTRACT(MONTH FROM order_date) > 6 AND
		EXTRACT(MONTH FROM order_date) < 9 THEN 'Summer'
		ELSE 'Winter'
		END as seasons
FROM orders
) as t1
GROUP BY 1,2
ORDER BY 1,3 DESC

-- Q20. Rank each city based on the total revenue 

SELECT 
	r.city,
	SUM(total_amount) as total_revenue,
	RANK() OVER(ORDER BY SUM(total_amount) DESC) as city_rank
FROM orders as o
JOIN
restaurants as r
on o.restaurant_id = r.restaurant_id
GROUP BY 1

-- END OF Project

