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