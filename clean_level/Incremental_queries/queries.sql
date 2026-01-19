

/*Insert geolocation*/
INSERT INTO clean.geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
	geolocation_city,
	geolocation_state
)
SELECT
	*
FROM
(WITH cte1 AS(
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

SELECT * FROM cte1)
ON CONFLICT (geolocation_zip_code_prefix)
DO UPDATE SET
	geolocation_lat = EXCLUDED.geolocation_lat,
	geolocation_lng = EXCLUDED.geolocation_lng,
	geolocation_city = EXCLUDED.geolocation_city,
	geolocation_state = EXCLUDED.geolocation_state;

/*Insert Customers*/
INSERT INTO clean.customers (
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
SELECT
	*
FROM
(SELECT
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
WHERE rn = 1)
ON CONFLICT (customer_id)
DO UPDATE SET
	customer_unique_id = EXCLUDED.customer_unique_id,
	customer_zip_code_prefix = EXCLUDED.customer_zip_code_prefix,
	customer_city = EXCLUDED.customer_city,
	customer_state = EXCLUDED.customer_state;

/*Insert Order_items*/
INSERT INTO clean.order_items (
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
SELECT
	*
FROM
(WITH cte1 AS(
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
WHERE rn = 1)
ON CONFLICT (order_id,order_item_id)
DO UPDATE SET
	product_id = EXCLUDED.product_id,
	seller_id = EXCLUDED.seller_id,
	shipping_limit_date = EXCLUDED.shipping_limit_date,
	price = EXCLUDED.price,
	freight_value = EXCLUDED.freight_value;

/*Insert Order_payments*/
INSERT INTO clean.order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
WITH cte1 AS(
SELECT
	*,
	CONCAT(order_id,payment_sequential,payment_type,payment_installments,payment_value) AS rt
FROM
(SELECT *
FROM order_payments_raw
WHERE order_id IS NOT NULL)),
cte2 AS
(SELECT
	*,
	CONCAT(order_id,payment_sequential,payment_type,payment_installments,payment_value) AS rt
FROM
clean.order_payments)

SELECT
	cte1.order_id,
	cte1.payment_sequential,
	cte1.payment_type,
	cte1.payment_installments,
	cte1.payment_value
FROM cte1
LEFT JOIN cte2
ON cte1.rt = cte2.rt
WHERE cte2.rt IS NULL

/*Insert Order_reviews*/
INSERT INTO clean.order_reviews (
	review_id,
	order_id,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp,
	review_score
)
SELECT
	*
FROM
(WITH cte1 AS (
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
WHERE rn = 1)
ON CONFLICT (review_id)
DO UPDATE SET
	order_id = EXCLUDED.order_id,
	review_comment_title = EXCLUDED.review_comment_title,
	review_comment_message = EXCLUDED.review_comment_message,
	review_creation_date = EXCLUDED.review_creation_date,
	review_answer_timestamp = EXCLUDED.review_answer_timestamp,
	review_score = EXCLUDED.review_score;

/*Insert Orders*/
INSERT INTO clean.orders (
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
)
SELECT
	*
FROM
(SELECT
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
WHERE rn = 1)
ON CONFLICT (order_id)
DO UPDATE SET
	customer_id = EXCLUDED.customer_id,
	order_status = EXCLUDED.order_status,
	order_purchase_timestamp = EXCLUDED.order_purchase_timestamp,
	order_approved_at = EXCLUDED.order_approved_at,
	order_delivered_carrier_date = EXCLUDED.order_delivered_carrier_date,
	order_delivered_customer_date = EXCLUDED.order_delivered_customer_date,
	order_estimated_delivery_date = EXCLUDED.order_estimated_delivery_date;

/*Insert product_category*/
INSERT INTO clean.product_category (
	product_category_name,
	product_category_name_english
)
SELECT
	*
FROM
(SELECT
	ï»¿product_category_name AS product_category_name,
	product_category_name_english
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY ï»¿product_category_name) AS rn
FROM product_category_raw)
WHERE rn = 1)
ON CONFLICT (product_category_name)
DO UPDATE SET
	product_category_name_english = EXCLUDED.product_category_name_english;

/*Insert products*/
INSERT INTO clean.products (
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
SELECT
	*
FROM
(SELECT
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
WHERE rn = 1)
ON CONFLICT (product_id)
DO UPDATE SET
	product_category_name = EXCLUDED.product_category_name,
	product_name_lenght = EXCLUDED.product_name_lenght,
	product_description_lenght = EXCLUDED.product_description_lenght,
	product_photos_qty = EXCLUDED.product_photos_qty,
	product_weight_g = EXCLUDED.product_weight_g,
	product_length_cm = EXCLUDED.product_length_cm,
	product_height_cm = EXCLUDED.product_height_cm,
	product_width_cm = EXCLUDED.product_width_cm;	

/*Insert sellers*/
INSERT INTO clean.sellers (
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
SELECT
	*
FROM
(SELECT
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY seller_id) AS rn
FROM sellers_raw)
WHERE rn = 1)
ON CONFLICT (seller_id)
DO UPDATE SET
	seller_zip_code_prefix = EXCLUDED.seller_zip_code_prefix,
	seller_city = EXCLUDED.seller_city,
	seller_state = EXCLUDED.seller_state;
	









