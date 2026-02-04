# 🛒 Olist E-Commerce SQL Data Analysis Project

## 📌 Project Overview
This is an **end-to-end SQL data analysis project** using the **Olist Brazilian E-Commerce Dataset**.

The project covers the **full data workflow**:
1. Loading raw CSV files into PostgreSQL
2. Designing and populating relational tables
3. Writing SQL queries to answer real business questions
4. Extracting insights related to customers, sales, products, sellers, and delivery performance

This project demonstrates **production-ready SQL skills** commonly required for data analyst and BI roles.

---

## 📂 Dataset Description
The Olist dataset contains anonymized data from a Brazilian e-commerce marketplace and includes:

- Customers
- Orders
- Order items
- Payments
- Reviews
- Products
- Sellers

Each table is linked using primary and foreign keys, enabling realistic relational analysis.

---

## 🛠 Tools & Technologies
- **Database:** PostgreSQL  
- **Language:** SQL  
- **Data Source:** CSV files  
- **SQL Concepts Used:**
  - Table creation & data loading
  - INNER JOIN / LEFT JOIN
  - GROUP BY & aggregations
  - Common Table Expressions (CTEs)
  - CASE statements
  - Date & time functions
  - Business KPI calculations

---

## 🔄 Data Ingestion (CSV → PostgreSQL)
Raw CSV files were loaded into PostgreSQL using SQL scripts.

### Steps performed:
1. Created database tables matching CSV schemas
2. Cleaned column data types (dates, numeric fields)
3. Imported CSV files using `COPY`
4. Verified row counts and referential integrity

### Example:
sql
COPY customers
FROM '/path/customers.csv'
DELIMITER ','
CSV HEADER;

## 🎯 Business Questions Answered
This project answers **25 real business questions**, including:

### Customer Analysis
- Who are the top customers by total spending?
- What percentage of customers are repeat buyers?
- What is the average number of orders per customer?
- Which cities have the highest number of active customers?

### Sales & Revenue Analysis
- Monthly total sales trend
- Average order value over time
- Revenue by product category
- Revenue distribution by payment method

### Product & Seller Performance
- Top-selling products
- Product categories with lowest review scores
- Sellers with highest revenue
- Sellers with fastest delivery times

### Delivery & Review Insights
- Average delivery time overall
- Delivery time by city
- Relationship between delivery time and review score
- Cancellation rate by product category

### Advanced Analysis
- Products never sold
- Frequently bought-together product pairs

---

## 🧠 Key Insights
Some insights that can be derived from this analysis:
- Most customers place only **one order**, explaining why the average orders per customer is close to 1.
- Certain cities dominate customer activity.
- Delivery time has a noticeable impact on customer review scores.
- A small number of customers and sellers generate a large portion of total revenue.

├── sql/
│   ├── 01_creation_and_insertion.sql   -- Table creation & CSV data loading
│   ├── 02_analysis.sql                 -- Business analysis SQL queries
├── data/
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── order_payments.csv
│   ├── order_reviews.csv
│   ├── products.csv
│   ├── sellers.csv
├── README.md

