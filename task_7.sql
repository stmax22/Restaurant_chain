/* Делаем единый номер телефона для всех менеджеров. Новый номер — 8-800-2500-***, где 
   порядковый номер менеджера выставляется по алфавиту, начиная с номера 100. Старый и 
   новый номер нужно будет хранить в массиве, где первый элемент массива — новый номер,
   а второй — старый. */
BEGIN;

-- Блокируем таблицу "managers" от изменений в других транцакциях.
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;

-- Создаем дополнительный столбец, где будет храниться массив с номерами телефонов.
ALTER TABLE cafe.managers
ADD COLUMN phones VARCHAR[];

WITH
-- Ранжируем сотрудников в алфавитном порядке.
ranked_employees AS (
	SELECT 
		manager_uuid,
		ROW_NUMBER() OVER(ORDER BY name) AS rank
	FROM cafe.managers
),
-- На основе ранжирования создаем новые номера телефонов.
new_phone AS (
	SELECT 
		manager_uuid,
		'8-800-2500-' || (rank + 100)::VARCHAR AS new_number
	FROM ranked_employees
)

-- Заполняем созданый столбец массивом из нового и старого номера.
UPDATE cafe.managers AS m
SET phones = ARRAY[np.new_number, m.phone]
FROM new_phone AS np
WHERE np.manager_uuid = m.manager_uuid;

-- Удаляем столбец со старым номером телефона (так как он уже есть в массиве).
ALTER TABLE cafe.managers
DROP COLUMN phone;

COMMIT;
