# 🛒 Olist E-Commerce Data Analysis Project (SQL + Power BI)

## 📌 Project Overview

This is an end-to-end data analytics project built on the **Olist Brazilian E-Commerce Dataset**. It covers the complete analytics workflow — from raw data ingestion through to business-ready dashboards — and demonstrates the skills expected of a data analyst / BI-focused analytics professional.

The project is delivered in two parts:

1. **SQL Analysis (PostgreSQL)** — loading, modeling, and querying the raw dataset to answer 25 real business questions.
2. **Power BI Dashboard** — a fully interactive, multi-page report built on top of the same dataset, covering Sales, Customer, Product & Seller, and Delivery performance.

---

## 📂 Dataset Description

The Olist dataset contains anonymized data from a Brazilian e-commerce marketplace, including customers, orders, order items, payments, reviews, products, and sellers. Each table is linked through primary and foreign keys, enabling realistic relational analysis.

**Source:** [Olist Brazilian E-Commerce Dataset (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

## 🛠 Tools & Technologies

| Category | Tools |
|---|---|
| Database | PostgreSQL |
| Query Language | SQL |
| BI & Visualization | Power BI (Power Query, Data Modeling, DAX) |
| Data Source | CSV files |

**SQL concepts used:** table creation & data loading, INNER/LEFT JOIN, GROUP BY & aggregations, CTEs, CASE statements, date & time functions, business KPI calculations.

**Power BI concepts used:** star/galaxy schema modeling, Power Query transformations, DAX measures and calculated columns, filter context handling, interactive report design, geo-mapping.

---

## 🔄 Part 1 — SQL Analysis (PostgreSQL)

### Data Ingestion (CSV → PostgreSQL)

Raw CSV files were loaded into PostgreSQL using SQL scripts:

1. Created database tables matching the CSV schemas.
2. Cleaned column data types (dates, numeric fields).
3. Imported CSV files using `COPY`.
4. Verified row counts and referential integrity.

```sql
COPY customers FROM '/path/customers.csv' DELIMITER ',' CSV HEADER;
```

### Business Questions Answered

This project answers **25 real business questions** (see `business_questions.txt`), including:

**Customer Analysis**
- Who are the top customers by total spending?
- What percentage of customers are repeat buyers?
- What is the average number of orders per customer?
- Which cities have the highest number of active customers?

**Sales & Revenue Analysis**
- Monthly total sales trend
- Average order value over time
- Revenue by product category
- Revenue distribution by payment method

**Product & Seller Performance**
- Top-selling products
- Product categories with lowest review scores
- Sellers with highest revenue
- Sellers with fastest delivery times

**Delivery & Review Insights**
- Average delivery time overall
- Delivery time by city
- Relationship between delivery time and review score
- Cancellation rate by product category

**Advanced Analysis**
- Products never sold
- Frequently bought-together product pairs

### How to Run

1. Load the Olist dataset into a PostgreSQL database.
2. Open your SQL editor (pgAdmin / DBeaver / DataGrip).
3. Run `insertion_&_creation.sql`, then run `analysis.sql` sequentially.
4. Review query results and interpret insights.

---

## 📊 Part 2 — Power BI Dashboard

Building on the SQL analysis, the same dataset was modeled and visualized in Power BI as a four-page interactive report, designed to give stakeholders a full view of the business: overall performance, customer behavior, product/category economics, and delivery/logistics health.

### Data Model

- Galaxy (multi-fact) schema with dedicated fact tables for orders, order items, payments, and reviews, linked to shared customer, product, seller, and date dimensions via a bridge table.
- Custom DAX measures and calculated columns for KPIs, time intelligence, and filter-context logic (`CALCULATE`, `ALL`, `ALLSELECTED`, `ALLEXCEPT`, `USERELATIONSHIP`).

### Page 1 — Sales Overview

![Sales Overview](./screenshots/1_sales_overview.png)

KPI cards for **Total Revenue (15.42M)**, **Average Order Value ($156.31)**, **On-Time Delivery %**, **Total Orders (99K)**, and **Average Review Score (4.09)**, paired with:
- A revenue trend line from late 2016 through mid-2018
- A world map plotting order geography
- A payment type breakdown (Credit Card dominates at ~74%)
- Top 5 revenue-generating categories

### Page 2 — Customer Analysis

![Customer Analysis](./screenshots/2_customer_analysis.png)

KPI cards for **Total Customers (96K)**, **Average CLV ($141.44)**, **Avg Orders per Customer (1.03)**, and **Avg Review Score (4.09)**, paired with:
- A customer growth trend by year, highlighting a sharp Black Friday-style spike in late 2017
- Customer population by city (São Paulo leads with 10K+ customers)
- Top 10 states by customer share, led by São Paulo (SP) at ~46%

### Page 3 — Product & Seller Performance

![Product Performance](./screenshots/3_product_performance.png)

KPI cards for **Freight Cost Ratio (14.21%)**, **Avg Freight Cost ($19.99)**, **Avg Product Price ($145.30)**, **Total Orders (99K)**, and **High Freight Order % (35.62%)**, paired with:
- Total orders and freight cost by category (combo chart)
- Total weight by category (treemap)
- A bubble chart comparing avg price, avg review score, and order volume by category
- Total revenue ranked by category (Health & Beauty leads at 1.42M)

### Page 4 — Delivery & Logistics Performance

![Delivery Performance](./screenshots/4_delivery_performance.png)

KPI cards for **Active Sellers (3K)**, **On-Time Delivery % (20.89%)**, **Avg Delivery Time (12.43 days)**, **Delayed Orders (7K)**, and **Top Delay Route (BA → MA)**, paired with:
- Average delivery time trend by year and month
- A geo-map sizing average delay duration and order volume by state
- Average delay duration ranked by state (AP has the highest average delay)
- A seller-level performance table with total orders, average review score, and average delay

### Key Insights

- Most customers place only one order, which is why the average orders-per-customer figure sits close to 1.
- Revenue and customer activity are heavily concentrated in São Paulo and a handful of major southeastern cities/states.
- Delivery time has a measurable impact on customer review scores, and delay severity varies significantly by state.
- A small number of high-freight-ratio categories (e.g., Furniture, Bed Bath Table) disproportionately drive shipping costs relative to order volume.

---

## 📈 Skills Demonstrated

- Translating business questions into SQL queries and DAX measures
- Relational and dimensional (star/galaxy schema) data modeling
- Power Query data transformation and cleaning
- Writing clean, optimized SQL using CTEs and window functions
- Building interactive, stakeholder-ready Power BI dashboards
- End-to-end analytics workflow: ingestion → modeling → analysis → visualization

---

## 🚀 Future Improvements

- Add drill-through pages for seller- and product-level deep dives
- Extend DAX time intelligence (YoY, MoM, rolling averages)
- Add row-level security for role-based report access
- Optimize the PostgreSQL model with indexing for larger-scale queries

---

## 👤 Author

**Ismail Mahmoud**
Data Analyst | SQL & BI Enthusiast

---

## ⭐ If You Like This Project

Feel free to star the repo or fork it for your own analysis!
