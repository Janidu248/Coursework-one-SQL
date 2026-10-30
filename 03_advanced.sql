USE retail_bi;
-- Advanced task 1: reusable line-grain view for Tableau.
CREATE OR REPLACE VIEW vw_sales_lines AS
SELECT d.order_detail_id, o.order_id, o.order_date,
 c.customer_id, c.customer_name, c.city, c.country,
 c.latitude, c.longitude, s.store_id, s.store_name,
 s.city AS store_city, p.product_id, p.product_name, p.category,
 d.quantity, d.unit_price, d.unit_cost, d.discount_rate,
 ROUND(d.quantity*d.unit_price*(1-d.discount_rate),2) AS revenue,
 ROUND(d.quantity*d.unit_cost,2) AS cost,
 ROUND(d.quantity*(d.unit_price*(1-d.discount_rate)-d.unit_cost),2)
 AS gross_profit
FROM Order_Details d
JOIN Orders o ON o.order_id=d.order_id
JOIN Customers c ON c.customer_id=o.customer_id
JOIN Products p ON p.product_id=d.product_id
JOIN Stores s ON s.store_id=o.store_id
WHERE o.status='Completed';
CREATE OR REPLACE VIEW vw_order_totals AS
SELECT order_id, MIN(order_date) AS order_date,
 MIN(customer_id) AS customer_id, MIN(store_id) AS store_id,
 ROUND(SUM(revenue),2) AS order_revenue,
 ROUND(SUM(gross_profit),2) AS order_gross_profit
FROM vw_sales_lines GROUP BY order_id;
-- Advanced task 2: parameterised report, inclusive dates.
DELIMITER $$
CREATE PROCEDURE sp_sales_summary(IN p_start DATE, IN p_end DATE)
BEGIN
 IF p_start IS NULL OR p_end IS NULL OR p_end < p_start THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid date range';
 END IF;
 SELECT COUNT(*) AS total_orders,
 COALESCE(ROUND(SUM(order_revenue),2),0) AS revenue,
 COALESCE(ROUND(AVG(order_revenue),2),0) AS average_order_value
 FROM vw_order_totals
 WHERE order_date BETWEEN p_start AND p_end;
END$$
-- Advanced task 3: guard stock integrity on insert and update.
-- Stock is a current catalogue balance, not decremented by historical imports.
CREATE TRIGGER trg_stock_insert BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
 IF NEW.stock_qty < 0 OR NEW.reorder_level < 0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Stock cannot be negative';
 END IF;
END$$
CREATE TRIGGER trg_stock_update BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
 IF NEW.stock_qty < 0 OR NEW.reorder_level < 0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Stock cannot be negative';
 END IF;
END$$
DELIMITER ;
