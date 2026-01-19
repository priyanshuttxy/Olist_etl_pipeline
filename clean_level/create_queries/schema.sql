/*Create Schema for the clean data at the same database, raw data store in the public schema*/
CREATE SCHEMA clean;
/*Will insert all the old table to the cleaned schema*/
/*create geolocation table*/
CREATE TABLE clean.geolocation AS
WITH cte1 AS(
SELECT
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
FROM
(SELECT *,
	ROW_NUMBER() OVER(PARTITION BY geolocation_zip_code_prefix) AS rn
FROM geolocation_raw)
WHERE rn = 1)

SELECT * FROM cte1;

ALTER TABLE clean.geolocation
ADD PRIMARY KEY(geolocation_zip_code_prefix);


/*create customers table*/
CREATE TABLE clean.customers AS
SELECT
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
FROM
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY customer_id) AS rn
FROM customers_raw)
WHERE rn = 1;

/*create order_item table*/
CREATE TABLE clean.order_items AS
WITH cte1 AS(
SELECT
	*,
	CONCAT(order_id,' ',order_item_id) AS ct
FROM order_items_raw)

SELECT
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date :: timestamp,
	price,
	freight_value
FROM
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY ct) AS rn
FROM cte1)
WHERE rn = 1;

SELECT *
FROM clean.order_items

/*create order table*/
CREATE TABLE clean.orders AS
SELECT
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp::TIMESTAMP,
	order_approved_at ::TIMESTAMP,
	order_delivered_carrier_date ::TIMESTAMP,
	order_delivered_customer_date ::TIMESTAMP,
	order_estimated_delivery_date ::TIMESTAMP
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY order_id) AS rn
FROM orders_raw)
WHERE rn = 1;

/*create order_payment table*/
CREATE TABLE clean.order_payments AS
SELECT *
FROM order_payments_raw
WHERE order_id IS NOT NULL;

/*create order_reviews table*/
CREATE TABLE clean.order_reviews AS
WITH cte1 AS (
    SELECT
        review_id,
        ROUND(AVG(review_score), 0) AS review_score
    FROM order_reviews_raw
    GROUP BY review_id
),
cte2 AS (
    SELECT
        a.review_id,
        a.order_id,
        a.review_comment_title,
        a.review_comment_message,
        a.review_creation_date,
        a.review_answer_timestamp,
        b.review_score,
        ROW_NUMBER() OVER (
            PARTITION BY a.review_id
            ORDER BY a.review_creation_date
        ) AS rn
    FROM order_reviews_raw a
    LEFT JOIN cte1 b
        ON a.review_id = b.review_id
)
SELECT
    review_id,
    order_id,
    review_comment_title,
    review_comment_message,
    review_creation_date :: timestamp,
    review_answer_timestamp :: timestamp,
    review_score
FROM cte2
WHERE rn = 1

/*create sellers table*/
CREATE TABLE clean.sellers AS
SELECT
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY seller_id) AS rn
FROM sellers_raw)
WHERE rn = 1;


/*create product_category table*/
CREATE TABLE clean.product_category AS
SELECT
	ï»¿product_category_name,
	product_category_name_english
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY ï»¿product_category_name) AS rn
FROM product_category_raw)
WHERE rn = 1;

/*create products table*/
CREATE TABLE clean.products AS
SELECT
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY product_id) AS rn
FROM products_raw)
WHERE rn = 1;