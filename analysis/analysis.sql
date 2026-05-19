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



-- Objective: Identify customers whose total spending is higher than the average spending of all customers
-- Description: Uses a CTE (WITH) to calculate total spending per customer with SUM() and GROUP BY. Then, a subquery with AVG() calculates the average customer spending from the CTE results, which is used in the WHERE clause to filter customers who spent above the overall average
WITH customer_spending AS (
	SELECT
		c.customer_id,
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
    )

SELECT *
FROM customer_spending
WHERE total_spent > (
	SELECT AVG(total_spent)
    FROM customer_spending
);



-- Objective: Calculate total sales for each month using a Common Table Expression (CTE)
-- Description: Uses a CTE (WITH) to aggregate monthly sales with SUM(), combining orders, order details, and product data through JOINs. MONTHNAME() is used to display the month name, while GROUP BY organizes the results by month
WITH customer_sales_per_month AS (
	SELECT
	MONTHNAME(o.order_date) AS 'Month',
	SUM(p.price * od.quantity) AS total_sales
FROM orders o
JOIN order_details od 
	ON o.order_id = od.order_id 
JOIN products p 
	ON od.product_id = p.product_id 
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
    )

SELECT *
FROM customer_sales_per_month;



-- Objective: Classify customers based on their total spending using a Common Table Expression (CTE)
-- Description: Uses a CTE (WITH) to calculate total customer spending with SUM() and GROUP BY. CASE WHEN is used to segment customers into categories based on spending amount, while JOINs combine customer, order, and product information
WITH top_customer_classification AS (
	SELECT 
		c.name AS 'Client name',
		SUM(p.price * od.quantity) AS total_spent,
		CASE 
			WHEN SUM(p.price * od.quantity) > 1000 THEN 'High Value'
				ELSE 'Regular'
		END AS customer_type
	FROM customers c
	JOIN orders o 
		ON c.customer_id = o.customer_id 
	JOIN order_details od 
		ON o.order_id = od.order_id
	JOIN products p 
		ON od.product_id = p.product_id
	GROUP BY c.customer_id, c.name
)

SELECT *
FROM top_customer_classification
ORDER BY total_spent DESC;



-- Objective: Identify the best-selling product in each category using a window function
-- Description: Calculates total sales per product with SUM() and organizes the results by category. ROW_NUMBER() ranks products from highest to lowest sales inside each category, making it possible to return only the top-selling product per category
WITH product_sales 
AS (
	SELECT
		p.product_name,
		p.category,
		SUM(p.price * od.quantity) AS total_sales
	FROM order_details od
	JOIN products p ON od.product_id = p.product_id
	GROUP BY p.product_id, p.product_name, p.category
),

ranked_products 
AS (
	SELECT
		product_name,
		category,
		total_sales,
		ROW_NUMBER() OVER (
			PARTITION BY category
			ORDER BY total_sales DESC
		) AS rn 
	FROM product_sales
)

SELECT * 
FROM ranked_products
WHERE rn = 1; 



-- Objective: Identify the most expensive product in each category using a window function
-- Description: Organizes products by category and ranks them from highest to lowest price with ROW_NUMBER(). This makes it possible to return only the most expensive product within each category
WITH ranked_products 
AS (
	SELECT
		p.product_name,
		p.category,
		p.price,
		ROW_NUMBER() OVER (
			PARTITION BY p.category
			ORDER BY p.price DESC
		) AS rn
	FROM products p
)

SELECT
	category,
	product_name,
	price
FROM ranked_products
WHERE rn = 1;



-- Objective: Identify the top 2 customers with the highest total spending
-- Description: Calculates total spending per customer with SUM() and organizes the results using a CTE. ROW_NUMBER() ranks customers from highest to lowest spending, making it possible to return only the top 2 customers
WITH client_spending 
AS (
	SELECT
		c.name,
        c.customer_id,
		SUM(p.price * od.quantity) AS total_spent
    FROM customers c
    JOIN orders o
		ON c.customer_id = o.customer_id 
	JOIN order_details od
		ON o.order_id = od.order_id
    JOIN products p
		ON od.product_id = p.product_id 
	GROUP BY c.customer_id, c.name
),

ranked_clients 
AS (
	SELECT
		customer_id,
        name,
        total_spent,
        ROW_NUMBER() OVER(
			ORDER BY total_spent DESC
		) AS rc
	FROM client_spending
)

SELECT 
	customer_id,
	name,
	total_spent
FROM ranked_clients
WHERE rc <= 2;