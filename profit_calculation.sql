SELECT * FROM clean.customers


SELECT * FROM clean.order_items

SELECT * FROM clean.products


With cte1 AS(
SELECT
	order_id,
	SUM(payment_value) AS sm
FROM clean.order_payments
GROUP by order_id),
cte2 AS (
SELECT
	order_id,
	SUM(price) AS ps,
	SUM(freight_value) AS fv
FROM clean.order_items
GROUP BY order_id
)
SELECT
	cte2.order_id,
	cte2.ps + cte2.fv AS tc,
	cte1.sm
FROM cte1
INNER JOIN cte2 ON cte1.order_id = cte2.order_id

SELECT
	*
FROM clean.order_items
WHERE order_id IN
(SELECT
	order_id
FROM
(SELECT
	order_id,
	COUNT(order_id) AS ct
FROM clean.order_items
GROUP BY order_id
HAVING COUNT(order_id) > 3))


SELECT
	DISTINCT(seller_id)
FROM clean.order_items
WHERE product_id IN (SELECT
	product_id
FROM
(SELECT
	product_id,
	COUNT(product_id) AS ct
FROM clean.order_items
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 2))


SELECT
	*
FROM clean.order_items
WHERE product_id = '99a4788cb24856965c36a24e339b6058'


SELECT * FROM clean.product_category


SELECT
	DISTINCT(payment_type)
FROM clean.order_payments

SELECT
*
FROM clean.order_payments
WHERE order_id IN
(SELECT
	order_id
FROM(
SELECT
	order_id,
	COUNT(order_id)
FROM clean.order_payments
GROUP BY order_id
ORDER BY COUNT(order_id) DESC
LIMIT 1))


SELECT * FROM logical.platform_commission

SELECT * FROM clean.products

/*Calculating Profit*/
SELECT
	c.order_id,
	c.order_item_id,
	c.product_id,
	c.seller_id,
	c.shipping_limit_date,
	c.price + c.freight_value AS total_value,
	(c.price + c.freight_value) * d.commission AS profit
FROM clean.order_items c
LEFT JOIN 
(SELECT
	a.product_id,
	COALESCE(b.platform_commission,0.15) AS commission
FROM clean.products a
LEFT JOIN logical.platform_commission b
ON a.product_category_name  =  b.product_category_name) d
ON c.product_id = d.product_id


/*Profit and Margin*/
WITH cte1 AS
(SELECT
	c.order_id,
	c.order_item_id,
	c.product_id,
	c.seller_id,
	c.shipping_limit_date,
	c.price + c.freight_value AS total_value,
	(c.price + c.freight_value) * d.commission AS profit
FROM clean.order_items c
LEFT JOIN 
(SELECT
	a.product_id,
	COALESCE(b.platform_commission,0.15) AS commission
FROM clean.products a
LEFT JOIN logical.platform_commission b
ON a.product_category_name  =  b.product_category_name) d
ON c.product_id = d.product_id)

SELECT
    b.product_category_name,
    SUM(a.profit) AS profit_categ,
    SUM(a.total_value) AS total_value,
    ROUND((SUM(a.profit) / SUM(a.total_value))::numeric, 2) AS margin
FROM cte1 a
LEFT JOIN clean.products b
ON a.product_id = b.product_id
GROUP BY b.product_category_name;


