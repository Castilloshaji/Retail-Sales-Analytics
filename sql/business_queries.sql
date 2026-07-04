-- Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total Sales
SELECT ROUND(SUM(sales),2) AS total_sales
FROM orders;

-- Total Profit
SELECT ROUND(SUM(profit),2) AS total_profit
FROM orders;

-- Average Order Value
SELECT ROUND(AVG(sales),2) AS average_order_value
FROM orders;

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM orders;

-- Sales by Category
SELECT
    category,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY category
ORDER BY total_sales DESC;

-- Sales by Sub-Category
SELECT
    sub_category,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Top 10 Products by Sales
SELECT
    product_name,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Customers by Sales
SELECT
    customer_name,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Sales by Market
SELECT
    market,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY market
ORDER BY total_sales DESC;

-- Sales by Region
SELECT
    region,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Sales by Customer Segment
SELECT
    segment,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY segment
ORDER BY total_sales DESC;

-- Customers by Segment
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS total_customers
FROM orders
GROUP BY segment
ORDER BY total_customers DESC;

-- Average Sales per Customer
SELECT
    customer_name,
    ROUND(AVG(sales),2) AS average_sales
FROM orders
GROUP BY customer_name
ORDER BY average_sales DESC;

-- Repeat Customers
SELECT
    customer_name,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_name
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;

-- Most Profitable Products
SELECT
    product_name,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Loss Making Products
SELECT
    product_name,
    ROUND(SUM(profit),2) AS total_loss
FROM orders
GROUP BY product_name
ORDER BY total_loss ASC
LIMIT 10;

-- Average Discount by Category
SELECT
    category,
    ROUND(AVG(discount),2) AS avg_discount
FROM orders
GROUP BY category;

-- Top Cities by Sales
SELECT
    city,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- Top States by Sales
SELECT
    state,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY state
ORDER BY total_sales DESC;

-- Profit by Region
SELECT
    region,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_profit DESC;

-- Orders by Ship Mode
SELECT
    ship_mode,
    COUNT(*) AS total_orders
FROM orders
GROUP BY ship_mode
ORDER BY total_orders DESC;

-- Average Shipping Cost
SELECT
    ship_mode,
    ROUND(AVG(shipping_cost),2) AS average_shipping_cost
FROM orders
GROUP BY ship_mode;

-- Orders by Priority
SELECT
    order_priority,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_priority
ORDER BY total_orders DESC;

-- Yearly Sales
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY year
ORDER BY year;

-- Monthly Sales
SELECT
    TO_CHAR(order_date,'YYYY-MM') AS month,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY month
ORDER BY month;

-- Quarterly Sales
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY year, quarter
ORDER BY year, quarter;

-- Rank Products by Sales
SELECT
    product_name,
    ROUND(SUM(sales),2) AS total_sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM orders
GROUP BY product_name;

-- Rank Products by Sales
SELECT
    product_name,
    ROUND(SUM(sales),2) AS total_sales,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM orders
GROUP BY product_name;

-- Dense Rank Customers
SELECT
    customer_name,
    ROUND(SUM(sales),2) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS customer_rank
FROM orders
GROUP BY customer_name;

-- Top Product in Each Category
WITH product_sales AS (
    SELECT
        category,
        product_name,
        ROUND(SUM(sales),2) AS total_sales,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rank_no
    FROM orders
    GROUP BY category, product_name
)

SELECT *
FROM product_sales
WHERE rank_no = 1;

-- Running Sales Total
SELECT
    order_date,
    ROUND(SUM(sales),2) AS daily_sales,
    ROUND(
        SUM(SUM(sales)) OVER (
            ORDER BY order_date
        ),
        2
    ) AS running_total
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- Month-over-Month Sales Growth
WITH monthly_sales AS (
    SELECT
        TO_CHAR(order_date,'YYYY-MM') AS month,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY month
)

SELECT
    month,
    ROUND(total_sales,2),
    ROUND(
        LAG(total_sales) OVER (ORDER BY month),
        2
    ) AS previous_month_sales
FROM monthly_sales;

-- Top Customers in Each Market
WITH customer_sales AS (
    SELECT
        market,
        customer_name,
        ROUND(SUM(sales),2) AS total_sales,
        ROW_NUMBER() OVER(
            PARTITION BY market
            ORDER BY SUM(sales) DESC
        ) AS row_num
    FROM orders
    GROUP BY market, customer_name
)

SELECT *
FROM customer_sales
WHERE row_num <= 5;

-- Profit Margin by Category
SELECT
    category,
    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin
FROM orders
GROUP BY category
ORDER BY profit_margin DESC;

-- Products with Highest Shipping Cost
SELECT
    product_name,
    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost
FROM orders
GROUP BY product_name
ORDER BY avg_shipping_cost DESC
LIMIT 10;

-- Average Delivery Time
SELECT
    ship_mode,
    ROUND(
        AVG(ship_date - order_date),
        2
    ) AS avg_delivery_days
FROM orders
GROUP BY ship_mode;

-- Percentage Contribution of Each Category
SELECT
    category,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(
        SUM(sales) * 100 /
        (SELECT SUM(sales) FROM orders),
        2
    ) AS sales_percentage
FROM orders
GROUP BY category
ORDER BY sales_percentage DESC;

