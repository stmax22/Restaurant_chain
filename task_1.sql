/* Создаем представление, которое покажет топ-3 ресторана
   внутри каждого типа ресторанов по среднему чеку за все даты. */
CREATE VIEW cafe.restauran_top_3 AS
SELECT
	all_data.name AS restauran,
	all_data.type AS type_restauran,
	all_data.average_receipt
FROM (
	SELECT 
		r.name,
		r.type,
		ROUND(AVG(s.avg_check), 2) AS average_receipt,
		ROW_NUMBER() OVER(PARTITION BY r.type ORDER BY ROUND(AVG(s.avg_check), 2) DESC) AS number
	FROM cafe.sales AS s
	INNER JOIN cafe.restaurants AS r USING(restaurant_uuid)
	GROUP BY r.name, r.type
) AS all_data
WHERE all_data.number < 4;
