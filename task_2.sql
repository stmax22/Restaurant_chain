/* Создаем материализованное представление, которое покажет, как изменяется средний чек
   для каждого ресторана от года к году за все года за исключением 2023 года. */
CREATE MATERIALIZED VIEW cafe.average_receipt_year AS
SELECT
	*,
	LAG(initial_data.avg_current_year) OVER (PARTITION BY initial_data.restaurant_name
		ORDER BY initial_data.year) AS avg_previous_year,
	ROUND((initial_data.avg_current_year - LAG(initial_data.avg_current_year)
		OVER (PARTITION BY initial_data.restaurant_name)) / initial_data.avg_current_year * 100, 2) AS percent
FROM (
	SELECT
		EXTRACT(YEAR FROM s.date) AS year,
		r.name AS restaurant_name,
		r.type AS restaurant_type,
		ROUND(AVG(s.avg_check), 2) AS avg_current_year
	FROM cafe.sales AS s
	INNER JOIN cafe.restaurants AS r USING(restaurant_uuid)
	WHERE EXTRACT(YEAR FROM s.date) < 2023
	GROUP BY EXTRACT(YEAR FROM s.date), r.name, r.type
) AS initial_data;
