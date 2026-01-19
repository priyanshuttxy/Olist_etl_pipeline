/*Cheaking customer table*/
SELECT COUNT(*)
FROM customers_raw
WHERE customer_id IS NULL

SELECT COUNT(*) FROM customers_raw

SELECT DISTINCT() FROM customers_raw

SELECT COUNT(DISTINCT(customer_id)) FROM customers_raw

SELECT COUNT(DISTINCT(customer_unique_id)) FROM customers_raw

SELECT * FROM customers_raw

/*Cheaking geolocation table*/
SELECT COUNT(*) FROM geolocation_raw /*geolocation_zip_code_prefix*/

SELECT * FROM geolocation_raw

SELECT COUNT(DISTINCT(geolocation_zip_code_prefix)) FROM geolocation_raw

/*cleaned geolocation*/
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

SELECT * FROM cte1


/*Cheaking order_items table*/
SELECT * FROM order_items_raw

SELECT COUNT(*) FROM order_items_raw
SELECT COUNT(DISTINCT(order_id)) FROM order_items_raw

SELECT
	COUNT(CONCAT(order_id,' ',order_item_id)) /*order_id and order_item_id together form the primery key*/
FROM order_items_raw

SELECT shipping_limit_date::TIMESTAMP /*No Error*/
FROM order_items_raw;

/*Cheaking order table*/
SELECT * FROM orders_raw

SELECT COUNT(DISTINCT(order_id)) FROM orders_raw /*No Error*/

SELECT *
FROM orders_raw
WHERE order_status = 'invoiced' /*Has null dilevery date*/

SELECT DISTINCT(order_status) /*Category*/
FROM orders_raw

SELECT 
	order_purchase_timestamp::TIMESTAMP,
	order_approved_at ::TIMESTAMP,
	order_delivered_carrier_date ::TIMESTAMP,
	order_delivered_customer_date ::TIMESTAMP,
	order_estimated_delivery_date ::TIMESTAMP/*No Error*/
FROM orders_raw

/*Cheaking order table*/
SELECT order_id,
	COUNT(order_id) AS ct
	FROM order_payments_raw
GROUP BY order_id
HAVING COUNT(order_id) > 2  
	

/*Cheaking order_payments table*/
SELECT *
FROM order_payments_raw
WHERE order_id = '53f5a7f622d498ff3eeb334b8efa7ae7' /*Notes 01*/

/*Cheaking order_rewiew table*/
SELECT *
FROM order_reviews_raw

SELECT DISTINCT(review_score)
FROM order_reviews_raw

SELECT DISTINCT review_id
FROM order_reviews_raw

/*Fix order review*/
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
    review_creation_date,
    review_answer_timestamp,
    review_score
FROM cte2
WHERE rn > 

/*Cheaking seller table*/
SELECT
	*
FROM sellers_raw

SELECT
	DISTINCT(seller_id)
FROM sellers_raw

/*Cheaking product category*/
SELECT *
FROM product_category_raw /*name of category column is not correct*/


/*Cheaking products table*/
SELECT *
FROM products_raw

SELECT DISTINCT(product_id)
FROM products_raw

ALTER TABLE product_category_raw
RENAME COLUMN "ï»¿product_category_name" TO product_category_name;