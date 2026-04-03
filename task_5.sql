-- Создаем запрос, чтобы найти самую дорогую пиццу для каждой пиццерии.
WITH 
all_info AS (
SELECT 
	name AS restauran_name,
	'Пицца' AS type_dish,
	(JSONB_EACH_TEXT(menu #> '{Пицца}')).KEY AS pizza_name,
	(JSONB_EACH_TEXT(menu #> '{Пицца}')).VALUE::SMALLINT AS price
FROM cafe.restaurants
),
ranked_info AS (
SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY restauran_name ORDER BY price DESC) AS rank
FROM all_info
)

SELECT
	restauran_name,
	type_dish,
	pizza_name,
	price
FROM ranked_info
WHERE rank = 1
ORDER BY price DESC;
