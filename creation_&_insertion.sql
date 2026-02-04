/****************************************************************************************
 Project: Olist Brazilian E-Commerce Analytics
 Database: PostgreSQL
 Purpose : Create relational schema and load real CSV data for analytical use
 Dataset : Brazilian E-Commerce Public Dataset by Olist (Kaggle)
 Notes   :
   - This schema reflects the original Olist ERD
   - Foreign keys are enforced where source data guarantees integrity
   - Geolocation table intentionally has no PK (duplicate ZIP prefixes exist)
   - CSV files use LATIN1 encoding (real-world data issue handled)
****************************************************************************************/


/* =============================================================================
   GEOLOCATION DIMENSION
   -----------------------------------------------------------------------------
   - Contains latitude/longitude information by ZIP code prefix
   - No PRIMARY KEY due to duplicate ZIP prefixes in source system
   - Joined logically to customers and sellers during analysis
============================================================================= */
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC(10,6),
    geolocation_lng NUMERIC(10,6),
    geolocation_city VARCHAR,
    geolocation_state VARCHAR
);


/* =============================================================================
   CUSTOMERS DIMENSION
   -----------------------------------------------------------------------------
   - Each row represents a unique customer_id (technical identifier)
   - customer_unique_id can represent the same person across multiple accounts
   - ZIP code prefix links customers to geolocation (no FK enforced)
============================================================================= */
CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix INT,
    customer_city VARCHAR,
    customer_state VARCHAR
);


/* =============================================================================
   SELLERS DIMENSION
   -----------------------------------------------------------------------------
   - Represents merchants selling products on the platform
   - ZIP code prefix used for geographical analysis
============================================================================= */
CREATE TABLE sellers (
    seller_id VARCHAR PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR,
    seller_state VARCHAR
);


/* =============================================================================
   PRODUCTS DIMENSION
   -----------------------------------------------------------------------------
   - Stores product attributes and physical characteristics
   - product_category_name is used for category-level analysis
============================================================================= */
CREATE TABLE products (
    product_id VARCHAR PRIMARY KEY,
    product_category_name VARCHAR,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


/* =============================================================================
   ORDERS FACT TABLE
   -----------------------------------------------------------------------------
   - Central transactional table in the schema
   - Each order belongs to one customer
   - Multiple timestamps allow delivery and delay analysis
============================================================================= */
CREATE TABLE orders (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR REFERENCES customers(customer_id),
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);


/* =============================================================================
   ORDER ITEMS FACT DETAIL
   -----------------------------------------------------------------------------
   - Each order can contain multiple products
   - Composite primary key ensures uniqueness per order
   - Connects orders, products, and sellers
============================================================================= */
CREATE TABLE order_items (
    order_id VARCHAR REFERENCES orders(order_id),
    order_item_id INT,
    product_id VARCHAR REFERENCES products(product_id),
    seller_id VARCHAR REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);


/* =============================================================================
   ORDER PAYMENTS FACT
   -----------------------------------------------------------------------------
   - Orders can have multiple payment records (installments, multiple methods)
   - Composite PK reflects payment sequence per order
============================================================================= */
CREATE TABLE order_payments (
    order_id VARCHAR REFERENCES orders(order_id),
    payment_sequential INT,
    payment_type VARCHAR,
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);


/* =============================================================================
   ORDER REVIEWS FACT
   -----------------------------------------------------------------------------
   - Review IDs are NOT unique in the source data
   - Surrogate key (review_pk) added for database integrity
   - Multiple reviews per order may exist due to updates
============================================================================= */
CREATE TABLE order_reviews (
    review_pk SERIAL PRIMARY KEY,
    review_id VARCHAR,
    order_id VARCHAR REFERENCES orders(order_id),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);


/* =============================================================================
   DATA LOADING SECTION
   -----------------------------------------------------------------------------
   - CSV files are loaded using COPY for performance
   - LATIN1 encoding specified due to non-UTF8 source data
============================================================================= */

COPY geolocation
FROM 'D:/Project_sql/Data/olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY customers
FROM 'D:/Project_sql/Data/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY sellers
FROM 'D:/Project_sql/Data/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY products
FROM 'D:/Project_sql/Data/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY orders
FROM 'D:/Project_sql/Data/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY order_items
FROM 'D:/Project_sql/Data/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY order_payments
FROM 'D:/Project_sql/Data/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
FROM 'D:/Project_sql/Data/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';
