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