-- Objective: Classify customers based on their total spending
-- Description: Uses SUM() to calculate each customer's total spending and CASE WHEN to categorize them into 'High Value' or 'Regular' based on defined thresholds
SELECT 
    c.name AS 'Client name',
    SUM(p.price * od.quantity) AS 'Total spent',
    CASE 
        WHEN SUM(p.price * od.quantity) > 1000 THEN 'High Value'
        ELSE 'Regular'
    END AS 'Client Classification'
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id 
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN products p 
    ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY 3 DESC;

-- Objective: Identify the month with the highest total sales
-- Description: Uses SUM() to calculate total sales per month and a subquery with MAX() to find the highest monthly sales value, then compares results to return the best-performing month
SELECT
    MONTHNAME(o.order_date) AS month_name,
    SUM(p.price * od.quantity) AS total_sales
FROM orders o
JOIN order_details od 
	ON o.order_id = od.order_id
JOIN products p 
	ON od.product_id = p.product_id
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
HAVING SUM(p.price * od.quantity) = (
	SELECT MAX(monthly_total)
		FROM (
		SELECT SUM(p.price * od.quantity) AS monthly_total
		FROM orders o
		JOIN order_details od 
			ON o.order_id = od.order_id
		JOIN products p 
			ON od.product_id = p.product_id
		GROUP BY MONTH(o.order_date)
		)
    );

-- Objective: Calculate total sales per month and identify the best-performing month
-- Description: Uses SUM() to calculate total revenue, GROUP BY with MONTH() and MONTHNAME() to aggregate sales by month, and ORDER BY to rank months by total sales (optionally LIMIT to return only the top month)
SELECT
	MONTHNAME(o.order_date) AS 'Month',
	SUM(p.price * od.quantity) AS total_sales
FROM orders o
JOIN order_details od 
	ON o.order_id = od.order_id 
JOIN products p 
	ON od.product_id = p.product_id 
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY total_sales DESC;
-- Uncomment LIMIT 1 to return only the best-performing month
-- LIMIT 1

-- Objective: Identify product categories with an average price greater than 100
-- Description: Uses AVG() to calculate the average price per category, GROUP BY to aggregate results by category, and HAVING to filter only those categories whose average price exceeds 100
SELECT category, AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 100;

-- Objective: Identify categories whose average price is higher than the overall average price of all products
-- Description: Uses AVG() to calculate the average price per category, GROUP BY to aggregate results by category, and a subquery with AVG() to compute the overall average price, which is then used in HAVING to filter categories above that benchmark
SELECT 
	category, 
    AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > (
    SELECT AVG(price)
    FROM products
);

-- Objective: Identify customers whose total spending is above the average spending of all customers
-- Description: Uses SUM() to calculate total spending per customer, GROUP BY to aggregate results by customer, and a subquery with AVG() on aggregated totals to compute the overall average spending, which is then used in HAVING to filter customers above that average
SELECT 
    c.name,
    SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_details od
	ON o.order_id = od.order_id 
JOIN products p 
	ON od.product_id  = p.product_id 
GROUP BY c.customer_id, c.name
HAVING SUM(p.price * od.quantity) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(p.price * od.quantity) AS total_spent
		FROM customers c
		JOIN orders o
			ON c.customer_id = o.customer_id
		JOIN order_details od
			ON o.order_id = od.order_id 
		JOIN products p 
			ON od.product_id  = p.product_id 
		GROUP BY c.customer_id, c.name
) AS avg_spent
);


-- Objective: Classify customers based on total spending
-- Description: Uses SUM() to calculate total spending per customer and CASE WHEN to segment them into High, Medium, and Low value groups
SELECT 
    c.name,
    SUM(p.price * od.quantity) AS total_spent,
    CASE 
        WHEN SUM(p.price * od.quantity) > 1000 THEN 'High Value'
        WHEN SUM(p.price * od.quantity) > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_type
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
JOIN order_details od
	ON o.order_id = od.order_id 
JOIN products p 
	ON od.product_id  = p.product_id 
GROUP BY c.customer_id, c.name;