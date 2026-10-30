CREATE DATABASE IF NOT EXISTS retail_bi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE retail_bi;
CREATE TABLE Customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 city VARCHAR(60) NOT NULL,
 country VARCHAR(60) NOT NULL DEFAULT 'Sri Lanka',
 latitude DECIMAL(9,6) NOT NULL,
 longitude DECIMAL(9,6) NOT NULL,
 signup_date DATE NOT NULL
) ENGINE=InnoDB;
CREATE TABLE Products (
 product_id INT PRIMARY KEY,
 product_name VARCHAR(100) NOT NULL,
 category VARCHAR(50) NOT NULL,
 unit_price DECIMAL(12,2) NOT NULL,
 unit_cost DECIMAL(12,2) NOT NULL,
 stock_qty INT NOT NULL,
 reorder_level INT NOT NULL DEFAULT 10,
 CHECK(unit_price >= 0), CHECK(unit_cost >= 0),
 CHECK(stock_qty >= 0), CHECK(reorder_level >= 0)
) ENGINE=InnoDB;
CREATE TABLE Stores (
 store_id INT PRIMARY KEY,
 store_name VARCHAR(80) NOT NULL UNIQUE,
 city VARCHAR(60) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE Orders (
 order_id INT PRIMARY KEY,
 customer_id INT NOT NULL,
 store_id INT NOT NULL,
 order_date DATE NOT NULL,
 status VARCHAR(12) NOT NULL DEFAULT 'Completed',
 CONSTRAINT fk_order_customer FOREIGN KEY(customer_id)
 REFERENCES Customers(customer_id),
 CONSTRAINT fk_order_store FOREIGN KEY(store_id)
 REFERENCES Stores(store_id),
 CHECK(status IN ('Completed','Cancelled')),
 INDEX idx_order_date_status(order_date,status),
 INDEX idx_order_customer(customer_id),
 INDEX idx_order_store(store_id)
) ENGINE=InnoDB;
CREATE TABLE Order_Details (
 order_detail_id INT PRIMARY KEY,
 order_id INT NOT NULL,
 product_id INT NOT NULL,
 quantity INT NOT NULL,
 unit_price DECIMAL(12,2) NOT NULL,
 unit_cost DECIMAL(12,2) NOT NULL,
 discount_rate DECIMAL(5,4) NOT NULL DEFAULT 0,
 CONSTRAINT fk_detail_order FOREIGN KEY(order_id)
 REFERENCES Orders(order_id),
 CONSTRAINT fk_detail_product FOREIGN KEY(product_id)
 REFERENCES Products(product_id),
 CONSTRAINT uq_order_product UNIQUE(order_id,product_id),
 CHECK(quantity > 0), CHECK(unit_price >= 0),
 CHECK(unit_cost >= 0),
 CHECK(discount_rate BETWEEN 0 AND 1),
 INDEX idx_detail_product(product_id)
) ENGINE=InnoDB;
