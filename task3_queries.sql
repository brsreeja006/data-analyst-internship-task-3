-- DATA ANALYST INTERNSHIP - TASK 3
-- SQL for Data Analysis
-- Tool: SQLite
-- Dataset: Ecommerce sample database
-- This file creates the database, inserts sample data, and performs analysis.

PRAGMA foreign_keys = ON;

-- Drop old objects so the script can be re-run safely
DROP VIEW IF EXISTS customer_revenue;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- =========================
-- TABLES
-- =========================

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    city TEXT,
    country TEXT,
    signup_date TEXT
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    price REAL NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    status TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- SAMPLE DATA
-- =========================

INSERT INTO customers VALUES
(1,'Ananya','Hyderabad','India','2025-01-10'),
(2,'Rahul','Bengaluru','India','2025-01-15'),
(3,'Sreeja','Hyderabad','India','2025-02-01'),
(4,'Priya','Chennai','India','2025-02-12'),
(5,'Arjun','Mumbai','India','2025-03-03'),
(6,'Meena','Pune','India','2025-03-18'),
(7,'Kiran','Delhi','India','2025-04-05'),
(8,'Neha','Kolkata','India','2025-04-21');

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000),
(102,'Wireless Mouse','Electronics',1200),
(103,'Keyboard','Electronics',1800),
(104,'Headphones','Electronics',2500),
(105,'Backpack','Accessories',2200),
(106,'Smart Watch','Wearables',4500),
(107,'USB Cable','Accessories',500),
(108,'Webcam','Electronics',3200);

INSERT INTO orders VALUES
(1001,1,'2025-05-01','Completed'),
(1002,2,'2025-05-02','Completed'),
(1003,3,'2025-05-03','Completed'),
(1004,1,'2025-05-04','Completed'),
(1005,4,'2025-05-05','Cancelled'),
(1006,5,'2025-05-06','Completed'),
(1007,6,'2025-05-07','Completed'),
(1008,7,'2025-05-08','Completed'),
(1009,3,'2025-05-09','Completed'),
(1010,8,'2025-05-10','Completed'),
(1011,2,'2025-05-11','Completed'),
(1012,5,'2025-05-12','Completed');

INSERT INTO order_items VALUES
(1,1001,101,1,60000),
(2,1001,102,1,1200),
(3,1002,103,2,1800),
(4,1002,104,1,2500),
(5,1003,105,1,2200),
(6,1003,106,1,4500),
(7,1004,108,1,3200),
(8,1004,107,2,500),
(9,1005,101,1,60000),
(10,1006,101,1,60000),
(11,1006,104,2,2500),
(12,1007,106,2,4500),
(13,1007,105,1,2200),
(14,1008,102,3,1200),
(15,1008,107,2,500),
(16,1009,104,1,2500),
(17,1009,108,1,3200),
(18,1010,105,2,2200),
(19,1010,107,3,500),
(20,1011,101,1,60000),
(21,1011,102,1,1200),
(22,1012,106,1,4500),
(23,1012,103,1,1800);

-- =========================
-- TASK 3 QUERIES
-- =========================

-- 1. SELECT + WHERE
SELECT *
FROM products
WHERE price > 3000;

-- 2. ORDER BY
SELECT product_name, category, price
FROM products
ORDER BY price DESC;

-- 3. GROUP BY + SUM
SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;

-- 4. GROUP BY + AVG
SELECT p.category,
       ROUND(AVG(oi.unit_price), 2) AS average_selling_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY average_selling_price DESC;

-- 5. INNER JOIN
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- 6. LEFT JOIN
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC, c.customer_id;

-- 7. RIGHT JOIN alternative
-- SQLite does not support RIGHT JOIN in older/common versions.
-- Equivalent LEFT JOIN:
SELECT c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_name;

-- 8. Aggregate revenue by customer
SELECT c.customer_id,
       c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC;

-- 9. Subquery: products priced above the average product price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 10. Subquery: customers with at least 2 orders
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
);

-- 11. Average Revenue Per User (ARPU)
SELECT ROUND(
    SUM(oi.quantity * oi.unit_price) /
    COUNT(DISTINCT o.customer_id), 2
) AS average_revenue_per_user
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

-- 12. View for analysis
DROP VIEW IF EXISTS customer_revenue;
CREATE VIEW customer_revenue AS
SELECT c.customer_id,
       c.customer_name,
       ROUND(SUM(
           CASE WHEN o.status = 'Completed'
                THEN oi.quantity * oi.unit_price
                ELSE 0 END
       ), 2) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;

SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC;

-- 13. NULL handling with COALESCE
SELECT c.customer_name,
       COALESCE(cr.total_revenue, 0) AS revenue
FROM customers c
LEFT JOIN customer_revenue cr ON c.customer_id = cr.customer_id;

-- 14. Query optimization: indexes
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
ON order_items(product_id);

-- Check the query plan after indexing
EXPLAIN QUERY PLAN
SELECT c.customer_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC;

-- END OF TASK 3
