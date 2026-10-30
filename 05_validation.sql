USE retail_bi;
SELECT VERSION() AS engine_version;
SELECT 'Customers' AS entity, COUNT(*) AS rows_loaded FROM Customers
UNION ALL SELECT 'Products',COUNT(*) FROM Products
UNION ALL SELECT 'Stores',COUNT(*) FROM Stores
UNION ALL SELECT 'Orders',COUNT(*) FROM Orders
UNION ALL SELECT 'Order_Details',COUNT(*) FROM Order_Details;
CALL sp_sales_summary('2025-01-01','2025-12-31');
-- Expected to fail. Run each negative test separately.
-- UPDATE Products SET stock_qty=-1 WHERE product_id=1;
-- CALL sp_sales_summary('2025-12-31','2025-01-01');
-- INSERT INTO Orders VALUES (99999,99999,1,'2025-12-01','Completed');
