/*Insert product_category*/
INSERT INTO clean.product_category (
	product_category_name,
	product_category_name_english
)
SELECT
	*
FROM
(SELECT
	product_category_name,
	product_category_name_english
FROM 
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY product_category_name) AS rn
FROM product_category_raw)
WHERE rn = 1)
ON CONFLICT (product_category_name)
DO UPDATE SET
	product_category_name_english = EXCLUDED.product_category_name_english;
