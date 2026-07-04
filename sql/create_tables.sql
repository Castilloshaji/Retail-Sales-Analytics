DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    row_id INTEGER PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(30),
    category VARCHAR(30),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales DECIMAL(12,2),
    quantity INTEGER,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),
    shipping_cost DECIMAL(12,2),
    order_priority VARCHAR(20)
);