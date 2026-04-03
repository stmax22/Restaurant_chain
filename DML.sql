-- Заполняем таблицу с информацией о ресторанах.
INSERT INTO cafe.restaurants (
	name,
	type,
	menu
)
SELECT DISTINCT
	s.cafe_name,
	s.type::cafe.restaurant_type,
	m.menu
FROM raw_data.sales AS s
INNER JOIN raw_data.menu AS m USING(cafe_name);

-- Заполняем таблицу с информацией о менеджерах.
INSERT INTO cafe.managers (
	name,
	phone
)
SELECT DISTINCT 
	manager,
	manager_phone
FROM raw_data.sales;

-- Заполняем таблицу отслеживания времени работы менеджера в ресторане.
INSERT INTO cafe.restaurant_manager_work_dates (
	restaurant_uuid,
	manager_uuid,
	start_date,
	end_date
)
SELECT 
	r.restaurant_uuid,
	m.manager_uuid,
	MIN(s.report_date),
	MAX(s.report_date)
FROM cafe.restaurants AS r
INNER JOIN raw_data.sales AS s ON r.name = s.cafe_name
INNER JOIN cafe.managers AS m ON s.manager = m.name
GROUP BY r.restaurant_uuid, m.manager_uuid;

-- Заполняем таблицу с данными о продажах.
INSERT INTO cafe.sales (
	date,
	restaurant_uuid,
	avg_check
)
SELECT 
	s.report_date,
	r.restaurant_uuid,
	s.avg_check
FROM raw_data.sales AS s
INNER JOIN cafe.restaurants AS r ON s.cafe_name = r.name;
