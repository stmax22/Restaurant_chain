# Сеть ресторанов

## Задачи проекта
Необходимо на основе [Dump.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/Dump.sql) загрузить сырые данные в БД, распределить их по отдельным таблицам и построить представление, материализованное представление и аналитические запросы.

## Описание [Dump.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/Dump.sql)

### Схема raw_data
Схема хранит необработанные данные. В дампе содержится информация по продажам и меню ресторанов.

### Таблица sales
Таблица, хранящая необработанные данные о продажах.
| Поле | Тип | Описание |
| --- | --- | --- |
| `report_date` | `date` | Дата продажи |
| `cafe_name` | `varchar` | Название ресторана |
| `type` | `varchar` | Тип ресторана |
| `avg_check` | `numeric(6, 2)` | Средний чек за день |
| `manager` | `varchar` | Ф.И.О менеджера |
| `manager_phone` | `varchar` | Телефон менеджера |

### Таблица menu
Таблица, хранящая необработанные данные о меню ресторанов.
| Поле | Тип | Описание |
| --- | --- | --- |
| `cafe_name` | `varchar` | Название ресторана |
| `menu` | `jsonb` | Меню |

## Создание схемы и таблиц
Создание схемы и таблиц для сети ресторанов находится в файле [DDL.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/DDL.sql).

### Схема cafe
Схема хранит обработанные данные о сети ресторанов.

![](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/Diagram.png)

### Таблица restaurants
Таблица, хранящая в себе информацию о ресторанах.
| Поле | Тип | Описание |
| --- | --- | --- |
| `restaurant_uuid` | `uuid` | ID ресторана, первичный ключ |
| `name` | `varchar` | Название ресторана |
| `type` | `cafe.restaurant_type` | Тип ресторана |
| `menu` | `jsonb` | Меню |

*cafe.restaurant_type — тип enum, созданный для типа ресторанов (coffee_shop, restaurant, bar, pizzeria).*

### Таблица managers
Таблица, хранящая в себе информацию о менеджерах.
| Поле | Тип | Описание |
| --- | --- | --- |
| `manager_uuid` | `uuid` | ID менеджера, первичный ключ |
| `name` | `varchar` | Ф.И.О. менеджера |
| `phone` | `varchar` | Номер телефона менеджера |

### Таблица restaurant_manager_work_dates
Таблица, хранящая в себе информацию о сроках работы менеджеров в ресторанах.
| Поле | Тип | Описание |
| --- | --- | --- |
| `restaurant_uuid` | `uuid` | ID ресторана, внешний ключ на таблицу restaurants(restaurant_uuid) |
| `manager_uuid` | `uuid` | ID менеджера, внешний ключ на таблицу managers(manager_uuid) |
| `start_date` | `date` | Дата начала работы |
| `end_date` | `date` | Дата окончания работы |

*Первичный ключ для данной таблицы является составным из полей restaurant_uuid и manager_uuid.*

### Таблица sales
Таблица, хранящая в себе информацию о продажах.
| Поле | Тип | Описание |
| --- | --- | --- |
| `date` | `date` | Дата продажи |
| `restaurant_uuid` | `uuid` | ID ресторана, внешний ключ на таблицу restaurants(restaurant_uuid) |
| `avg_check` | `numeric(6, 2)` | Средний чек за день |

*Первичный ключ для данной таблицы является составным из полей date и restaurant_uuid.*

## Заполнение таблиц данными
Заполнение таблиц находится в файле [DML.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/DML.sql).

## Задания
- В файле [task_1.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_1.sql) находится создание представления, которое покажет топ-3 ресторана внутри каждого типа ресторанов по среднему чеку за все даты.
- В файле [task_2.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_2.sql) находится создание материализованного представления, которое покажет, как изменяется средний чек для каждого ресторана от года к году за все года за исключением 2023 года.
- В файле [task_3.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_3.sql) находится запрос, чтобы узнать топ-3 ресторана, где чаще всего менялся менеджер за весь период.
- В файле [task_4.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_4.sql) находится запрос, чтобы найти пиццерию с самым большим количеством пицц в меню.
- В файле [task_5.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_5.sql) находится запрос, чтобы найти самую дорогую пиццу для каждой пиццерии.
- В файле [task_6.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_6.sql) находится транзакция, которая увеличивает цены на капучино на 20% так, чтобы до завершения обновления никто другой не мог вносить изменения в меню.
- В файле [task_7.sql](https://github.com/stmax22/Restaurant_chain/blob/e20c1b67a44aadd62431873e7ebd9af87483f4e7/task_7.sql) находится транзакция, которая делает новый единый номер телефона для всех менеджеров и сохраняет старый и новый номер в массиве, где первый элемент массива — новый номер, а второй — старый.
