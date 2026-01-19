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
	