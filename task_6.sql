/* Увеличиваем цены на капучино на 20% так, чтобы до завершения обновления никто 
   другой не мог вносить изменения в меню. */
BEGIN;

WITH
-- Находим рестораны где продают капучино и цены на него.
cappuccino_restaurants AS (
SELECT 
	name,
	(menu #> '{Кофе}' #> '{Капучино}')::NUMERIC AS price
FROM cafe.restaurants
WHERE menu #> '{Кофе}' ? 'Капучино'
FOR NO KEY UPDATE  -- Блокируем доступ к изменению строк найденых ресторанов.
NOWAIT  -- Выдаст ошибку, если уже наложена блокировка.
)

-- Обновляем цены на капучино.
UPDATE cafe.restaurants AS r 
SET menu = JSONB_SET(menu, '{Кофе, Капучино}', to_jsonb(cr.price * 1.2))
FROM cappuccino_restaurants AS cr
WHERE r.name = cr.name;

COMMIT;
