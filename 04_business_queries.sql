USE retail_bi;

-- Q1: Total sales revenue
SELECT ROUND(SUM(revenue),2) AS total_revenue
FROM vw_sales_lines;

-- Q2: Monthly sales trend
SELECT DATE_FORMAT(order_date,'%Y-%m') AS sales_month,
 ROUND(SUM(revenue),2) AS revenue,
 COUNT(DISTINCT order_id) AS orders
FROM vw_sales_lines
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY sales_month;

-- Q3: Top 5 best-selling products
SELECT product_id, product_name, SUM(quantity) AS units_sold,
 ROUND(SUM(revenue),2) AS revenue
FROM vw_sales_lines
GROUP BY product_id, product_name
ORDER BY units_sold DESC, revenue DESC, product_id
LIMIT 5;

-- Q4: Sales by city
SELECT city, ROUND(SUM(revenue),2) AS revenue,
 COUNT(DISTINCT order_id) AS orders
FROM vw_sales_lines
GROUP BY city ORDER BY revenue DESC;

-- Q5: Customer lifetime value
SELECT c.customer_id, c.customer_name,
 COUNT(t.order_id) AS orders,
 COALESCE(ROUND(SUM(t.order_revenue),2),0) AS lifetime_value
FROM Customers c
LEFT JOIN vw_order_totals t ON t.customer_id=c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC, c.customer_id;

-- Q6: Most profitable category
SELECT category, ROUND(SUM(revenue),2) AS revenue,
 ROUND(SUM(gross_profit),2) AS gross_profit,
 ROUND(100*SUM(gross_profit)/NULLIF(SUM(revenue),0),2)
 AS margin_pct
FROM vw_sales_lines
GROUP BY category ORDER BY gross_profit DESC;

-- Q7: Average order value
SELECT COUNT(*) AS completed_orders,
 ROUND(AVG(order_revenue),2) AS average_order_value
FROM vw_order_totals;

-- Q8: Repeat customers
SELECT c.customer_id, c.customer_name,
 COUNT(t.order_id) AS completed_orders,
 ROUND(SUM(t.order_revenue),2) AS revenue
FROM Customers c JOIN vw_order_totals t
 ON t.customer_id=c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(t.order_id)>1
ORDER BY completed_orders DESC, c.customer_id;

-- Q9: Revenue by store
SELECT s.store_id, s.store_name,
 COUNT(t.order_id) AS orders,
 COALESCE(ROUND(SUM(t.order_revenue),2),0) AS revenue
FROM Stores s LEFT JOIN vw_order_totals t
 ON t.store_id=s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY revenue DESC;

-- Q10: Low stock products
SELECT product_id, product_name, stock_qty, reorder_level
FROM Products WHERE stock_qty<=reorder_level
ORDER BY stock_qty, product_id;