-- Создаем запрос, чтобы узнать топ-3 ресторана, где чаще всего менялся менеджер за весь период.
SELECT 
	r.name AS restaurant_name,
	COUNT(rmwd.manager_uuid) AS staff_change 
FROM cafe.restaurant_manager_work_dates AS rmwd
INNER JOIN cafe.restaurants AS r USING(restaurant_uuid)
GROUP BY r.name
ORDER BY staff_change DESC
LIMIT 3;
