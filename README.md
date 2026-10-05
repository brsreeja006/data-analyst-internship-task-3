# Data Analyst Internship - Task 3: SQL for Data Analysis

## Objective
Use SQL queries to extract and analyze ecommerce data.

## Tool Used
SQLite (free and easy to run locally).

## Dataset
A small self-contained ecommerce dataset was created for this task because the internship instructions allow using an ecommerce SQL database **or any dataset of choice**.

The database contains:
- `customers`
- `products`
- `orders`
- `order_items`

## What Was Completed
The SQL file demonstrates:
1. SELECT and WHERE
2. ORDER BY
3. GROUP BY
4. Aggregate functions such as SUM and AVG
5. INNER JOIN
6. LEFT JOIN
7. SQLite-compatible alternative to RIGHT JOIN
8. Subqueries
9. Average Revenue Per User (ARPU)
10. SQL VIEW
11. NULL handling with COALESCE
12. Index creation and EXPLAIN QUERY PLAN

## Files
- `task3_queries.sql` - complete SQL script
- `ecommerce.db` - SQLite database
- `outputs/` - CSV files containing query results
- `screenshots/` - screenshots of SQL query outputs

## How to Run
### Option 1: DB Browser for SQLite
1. Install/open DB Browser for SQLite.
2. Open `ecommerce.db`.
3. Open the SQL Editor.
4. Open `task3_queries.sql`.
5. Run the queries.
6. View the results in the Results section.

### Option 2: SQLite command line
Run:
```bash
sqlite3 ecommerce.db
.read task3_queries.sql
```

## Interview Questions - Short Answers

### 1. Difference between WHERE and HAVING
`WHERE` filters individual rows before grouping. `HAVING` filters groups after `GROUP BY` and is commonly used with aggregate functions.

### 2. Different types of joins
Common joins are INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN. SQLite commonly uses INNER and LEFT JOIN; RIGHT/FULL support depends on the SQLite version.

### 3. How do you calculate average revenue per user?
Calculate total completed revenue and divide it by the number of distinct users/customers who generated that revenue:
`SUM(revenue) / COUNT(DISTINCT customer_id)`.

### 4. What are subqueries?
A subquery is a query nested inside another SQL query. It can be used in SELECT, FROM, or WHERE/HAVING conditions.

### 5. How do you optimize a SQL query?
Use appropriate indexes, select only required columns, filter early, avoid unnecessary joins, inspect the query plan, and avoid repeated expensive calculations.

### 6. What is a view?
A view is a saved SQL query that behaves like a virtual table. It can simplify repeated analysis and improve readability.

### 7. How would you handle NULL values?
Use functions such as `COALESCE()` to replace NULL with a suitable value, and use `IS NULL` / `IS NOT NULL` when filtering.

## Submission
Upload this complete folder to a new GitHub repository for Task 3.
