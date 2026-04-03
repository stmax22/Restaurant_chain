-- Cоздаем схему для данных сети ресторанов.
CREATE SCHEMA cafe;

-- Создаем пользовательский тип данных с типами ресторанов.
CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

-- Создаем таблицу с информацией о ресторанах.
CREATE TABLE cafe.restaurants (
	restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	name VARCHAR NOT NULL,
	type cafe.restaurant_type NOT NULL,
	menu JSONB NOT NULL,
	CONSTRAINT restaurants_unique UNIQUE (name, type)
);

-- Создаем таблицу с информацией о менеджерах.
CREATE TABLE cafe.managers (
	manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	name VARCHAR NOT NULL,
	phone VARCHAR NOT NULL,
	CONSTRAINT managers_unique UNIQUE (name, phone)
);

-- Создаем таблицу отслеживания времени работы менеджера в ресторане.
CREATE TABLE cafe.restaurant_manager_work_dates (
	restaurant_uuid UUID REFERENCES cafe.restaurants (restaurant_uuid),
	manager_uuid UUID REFERENCES cafe.managers (manager_uuid),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	CONSTRAINT restaurant_manager_work_dates_pk PRIMARY KEY (restaurant_uuid, manager_uuid)
);

-- Создаем таблицу с данными о продажах.
CREATE TABLE cafe.sales (
	date DATE NOT NULL,
	restaurant_uuid UUID REFERENCES cafe.restaurants (restaurant_uuid),
	avg_check NUMERIC(6, 2) NOT NULL,
	CONSTRAINT sales_pk PRIMARY KEY (date, restaurant_uuid)
);
