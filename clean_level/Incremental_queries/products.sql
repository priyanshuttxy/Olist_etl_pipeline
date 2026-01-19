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
