CW1 MYSQL TABLES AND BUSINESS QUERIES

MySQL 8.0.16+ required. In MySQL Workbench, run these files in order:
1. 01_schema.sql - database and five tables, keys, constraints and indexes.
2. 02_seed.sql - sample records used in the coursework report.
3. 03_advanced.sql - reporting views, stored procedure and triggers.
4. 04_business_queries.sql - all ten required business queries.
5. 05_validation.sql - row counts, version and sample procedure call.

Use a fresh empty retail_bi schema. Existing tables and records are not deleted.
If already imported, do not rerun schema or seed blindly; run the query file once
the reporting views exist. Keep DELIMITER statements when executing advanced SQL.

Queries included:
1. Total sales revenue
2. Monthly sales trend
3. Top 5 best-selling products
4. Sales by city
5. Customer lifetime value (observed spend)
6. Most profitable category
7. Average order value
8. Repeat customers
9. Revenue by store
10. Low stock products

Baseline: completed revenue LKR 3,952,152.50, completed orders 194,
average order value LKR 20,371.92. Cancelled orders are excluded.

These queries depend on the views in 03_advanced.sql; do not omit that file.
Capture query text and actual result grids in MySQL Workbench for your submission.
Query logic was validated in SQLite; native MySQL execution remains unverified her
