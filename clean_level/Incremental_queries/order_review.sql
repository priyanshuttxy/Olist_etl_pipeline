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