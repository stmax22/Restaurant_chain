-- Создаем запрос, чтобы найти пиццерию с самым большим количеством пицц в меню.
WITH 
menu_info AS (
	SELECT 
		name,
		(JSONB_EACH_TEXT(menu #> '{Пицца}')).KEY AS pizza_name
	FROM cafe.restaurants
),
quantity_pizzas AS (
	SELECT
		name AS restaurant_name,
		COUNT(pizza_name) AS quantity,
		DENSE_RANK() OVER (ORDER BY COUNT(pizza_name) DESC) AS rank
	FROM menu_info
	GROUP BY name
)

SELECT
	restaurant_name,
	quantity
FROM quantity_pizzas
WHERE rank = 1;
