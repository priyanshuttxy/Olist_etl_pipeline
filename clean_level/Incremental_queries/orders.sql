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