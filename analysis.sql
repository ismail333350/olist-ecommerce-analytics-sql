/* =========================================================
   1. Top customers by total spending
   Calculates total payment value per customer and ranks them
   ========================================================= */
SELECT 
    c.customer_id,
    SUM(op.payment_value) AS total_spending
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
INNER JOIN order_payments op 
    ON o.order_id = op.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;



/* =========================================================
   2. Customer type classification
   Classifies customers as one-time or repeat buyers
   ========================================================= */
SELECT
    c.customer_id,
    CASE 
        WHEN COUNT(o.customer_id) > 1 THEN 'repeat buyers'
        ELSE 'one-time'
    END AS customer_type
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
INNER JOIN order_payments op 
    ON o.order_id = op.order_id
GROUP BY c.customer_id;



/* =========================================================
   3. Average number of orders per customer
   Counts orders per customer, then averages across all customers
   ========================================================= */
WITH nfo AS (
    SELECT 
        c.customer_id AS customer,
        COUNT(o.order_id) AS number_orders
    FROM customers c
    LEFT JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    ROUND(AVG(number_orders), 2) AS avg_orders_per_customer
FROM nfo;



/* =========================================================
   4. Cities with the highest number of active customers
   Counts distinct customers per city
   ========================================================= */
SELECT 
    customer_city,
    COUNT(DISTINCT customer_id) AS active_customers
FROM customers
GROUP BY customer_city
ORDER BY active_customers DESC
LIMIT 10;



/* =========================================================
   5. Average review score by customer state
   Measures customer satisfaction across regions
   ========================================================= */
SELECT 
    c.customer_state,
    ROUND(AVG(ors.review_score), 2) AS avg_review_score
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
INNER JOIN order_reviews ors 
    ON o.order_id = ors.order_id
GROUP BY c.customer_state
ORDER BY avg_review_score DESC;



/* =========================================================
   6. Total sales per month
   Sums item price and freight grouped by purchase month
   ========================================================= */
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS total_sales
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;



/* =========================================================
   7. Revenue by product category
   Identifies top revenue-generating categories
   ========================================================= */
SELECT 
    p.product_category_name,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;



/* =========================================================
   8. Average order value per month
   Calculates monthly AOV including freight
   ========================================================= */
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(AVG(oi.price + oi.freight_value), 4) AS avg_order_value
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;



/* =========================================================
   9. Revenue by payment type
   Shows which payment methods generate most revenue
   ========================================================= */
SELECT 
    op.payment_type,
    SUM(op.payment_value) AS total_revenue
FROM order_payments op
GROUP BY op.payment_type
ORDER BY total_revenue DESC;



/* =========================================================
   10. Top 10 best-selling products by quantity
   Uses order item count as sales volume
   ========================================================= */
SELECT 
    p.product_id,
    COUNT(oi.order_item_id) AS quantity_sold
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY quantity_sold DESC
LIMIT 10;



/* =========================================================
   11. Lowest-rated product categories
   Identifies categories with poor customer satisfaction
   ========================================================= */
SELECT 
    p.product_category_name,
    ROUND(AVG(ors.review_score), 2) AS avg_score
FROM products p
INNER JOIN order_items oi 
    ON p.product_id = oi.product_id
INNER JOIN orders o 
    ON o.order_id = oi.order_id
INNER JOIN order_reviews ors 
    ON o.order_id = ors.order_id
GROUP BY p.product_category_name
ORDER BY avg_score ASC
LIMIT 10;



/* =========================================================
   12. Cancellation rate by product category
   Calculates percentage of canceled orders per category
   ========================================================= */
SELECT 
    p.product_category_name,
    ROUND(
        COUNT(*) FILTER (WHERE o.order_status = 'canceled') * 100.0 / COUNT(*),
        2
    ) AS cancel_rate
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY cancel_rate DESC;



/* =========================================================
   13. Products never sold
   Finds products with no matching order items
   ========================================================= */
SELECT 
    p.product_id,
    p.product_category_name
FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;



/* =========================================================
   14. Frequently bought together products
   Uses self-join to identify product pairs
   ========================================================= */
SELECT 
    oi1.product_id AS product_1,
    oi2.product_id AS product_2,
    COUNT(*) AS freq
FROM order_items oi1
JOIN order_items oi2 
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id
GROUP BY product_1, product_2
ORDER BY freq DESC
LIMIT 10;



/* =========================================================
   15. Top sellers by revenue
   Ranks sellers based on item sales revenue
   ========================================================= */
SELECT 
    s.seller_id,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN sellers s 
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;



/* =========================================================
   16. Average delivery time
   Measures overall delivery performance
   ========================================================= */
SELECT 
    AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_days
FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL;



/* =========================================================
   17. Sellers with fastest delivery times
   Identifies top-performing sellers in logistics
   ========================================================= */
SELECT 
    s.seller_id,
    AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN sellers s 
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY avg_delivery ASC
LIMIT 5;



/* =========================================================
   18. Delivery time vs review score
   Analyzes how delivery duration impacts reviews
   ========================================================= */
SELECT 
    AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery,
    AVG(r.review_score) AS avg_score
FROM orders o
JOIN order_reviews r 
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY o.order_id;



/* =========================================================
   19. Cities with longest delivery times
   Highlights regions with logistics challenges
   ========================================================= */
SELECT 
    c.customer_city,
    AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_days
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_city
ORDER BY avg_delivery_days DESC
LIMIT 10;


/* ============================================================
   1. Customer Lifetime Value (LTV)
   ------------------------------------------------------------
   Calculates the total revenue generated by each customer
   across all their orders, including product price and
   freight cost.
   ============================================================ */
SELECT 
    c.customer_id, 
    SUM(oi.price + oi.freight_value) AS lifetime_value
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC;


/* ============================================================
   2. Customer Cohort Analysis (Monthly)
   ------------------------------------------------------------
   Groups customers into cohorts based on their first
   purchase month and tracks their repeat purchases
   across subsequent months.
   ============================================================ */
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_purchase_timestamp) AS first_order
    FROM olist_orders_dataset
    GROUP BY customer_id
)
SELECT 
    DATE_TRUNC('month', f.first_order) AS cohort_month,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS purchase_month,
    COUNT(DISTINCT o.customer_id) AS customer_count
FROM olist_orders_dataset o
JOIN first_orders f 
    ON o.customer_id = f.customer_id
GROUP BY cohort_month, purchase_month
ORDER BY cohort_month, purchase_month;


/* ============================================================
   3. Top 3 Products by Revenue per Category
   ------------------------------------------------------------
   Identifies the top 3 highest-revenue products within
   each product category using window functions.
   ============================================================ */
SELECT *
FROM (
    SELECT 
        p.product_category_name, 
        p.product_name, 
        SUM(oi.price) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_category_name 
            ORDER BY SUM(oi.price) DESC
        ) AS rank
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p 
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name, p.product_name
) sub
WHERE rank <= 3;


/* ============================================================
   4. Impact of Delivery Timeliness on Review Scores
   ------------------------------------------------------------
   Compares average review scores between on-time and
   late deliveries to measure customer satisfaction.
   ============================================================ */
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
        THEN 'Late' 
        ELSE 'On-time' 
    END AS delivery_status,
    AVG(r.review_score) AS avg_review_score
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r 
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;


/* ============================================================
   5. Monthly Sales Trend with Running Total
   ------------------------------------------------------------
   Calculates monthly sales revenue and a cumulative
   running total to track overall business growth.
   ============================================================ */
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS monthly_sales,
    SUM(SUM(oi.price + oi.freight_value)) 
        OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)) 
        AS running_total
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
