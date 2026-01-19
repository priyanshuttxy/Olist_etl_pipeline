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