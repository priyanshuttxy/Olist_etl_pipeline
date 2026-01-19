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