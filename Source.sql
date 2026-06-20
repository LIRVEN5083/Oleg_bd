-- ПР№6 Создание таблиц БД с помощью SQL.

-- Основные типы данных:
-- INTEGER - целочисленный тип данных
-- VARCHAR - строка
-- CHAR - символ
-- SERIAL - авто инкремент. Автоматический первичный ключ
-- DECIMAL - число с плавающей точкой. (5,2134)
-- DATE - дата

-- Таблица Клиенты
CREATE TABLE clients (
    c_id SERIAL PRIMARY KEY,
    c_surn VARCHAR(150) NOT NULL,
    c_name VARCHAR(50) NOT NULL,
    c_patr VARCHAR(50) NOT NULL,
    c_birthday DATE NOT NULL,
    c_gender CHAR(1) NOT NULL
        CHECK (c_gender IN ('М', 'Ж')), -- Проверка для c_gender чтобы вводимые данные чётко соотвествовали существующим полам М/Ж
    c_telephone VARCHAR(20) NOT NULL,
    c_addr VARCHAR(250) NOT NULL
);

-- Таблица Автомобили
CREATE TABLE cars (
    a_id SERIAL PRIMARY KEY,
    a_num VARCHAR(17) NOT NULL,
    a_mark VARCHAR(50) NOT NULL,
    a_date DATE NOT NULL,
    a_gnum VARCHAR(15) NOT NULL,
    a_mile INTEGER NOT NULL,
    a_color VARCHAR(30) NOT NULL,
    a_fuel VARCHAR(20) NOT NULL,
    a_desc VARCHAR(300)
);

-- Таблица Мастерские
CREATE TABLE workshops (
    w_id SERIAL PRIMARY KEY,
    w_name VARCHAR(100) NOT NULL,
    w_addr VARCHAR(250) NOT NULL,
    w_telephone VARCHAR(50) NOT NULL,
    w_time VARCHAR(30) NOT NULL,
    w_cont VARCHAR(50) NOT NULL,
    w_desc VARCHAR(300)
);

-- Таблица Сотрудники
CREATE TABLE employees (
    e_id SERIAL PRIMARY KEY,
    e_name VARCHAR(50) NOT NULL,
    e_surn VARCHAR(50) NOT NULL,
    e_patr VARCHAR(50) NOT NULL,
    e_role VARCHAR(50) NOT NULL 
        CHECK (e_role IN ('Слесарь', 'Электрик', 'Маляр', 'Приёмщик')), -- Проверка для e_role чтобы вводимые данные чётко соотвествовали существующим ролям
    e_spec VARCHAR(300) NOT NULL,
    e_telephone VARCHAR(50) NOT NULL,
    e_exp INTEGER NOT NULL,
    e_qual VARCHAR(50) NOT NULL
);

-- Таблица Услуги
CREATE TABLE services (
    s_id SERIAL PRIMARY KEY,
    s_name VARCHAR(150) NOT NULL,
    s_code VARCHAR(20) NOT NULL UNIQUE,
    s_price DECIMAL(10,2) NOT NULL,
    s_time INTEGER NOT NULL,
    s_category VARCHAR(50) NOT NULL,
    s_desc VARCHAR(300)
);

-- Таблица Заказ
CREATE TABLE orders (
    o_id SERIAL PRIMARY KEY,
    o_employee INTEGER NOT NULL, -- Хранит внешний ключ на мастеров
    o_workshop INTEGER NOT NULL, -- Хранит внешний ключ на мастерские
    o_client INTEGER NOT NULL, -- Хранит внешний ключ на клиентов
    o_car INTEGER NOT NULL, -- Хранит внешний ключ на автомобиль
    o_status VARCHAR(20) NOT NULL,
    o_price DECIMAL(10,2) NOT NULL,
    o_date DATE NOT NULL,
    o_plan DATE NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (o_employee) REFERENCES employees(e_id),
    FOREIGN KEY (o_workshop) REFERENCES workshops(w_id),
    FOREIGN KEY (o_client) REFERENCES clients(c_id),
    FOREIGN KEY (o_car) REFERENCES cars(a_id)
);

-- Таблица Позиции заказа
CREATE TABLE order_positions (
    p_id SERIAL PRIMARY KEY,
    p_order INTEGER NOT NULL, -- Хранит внешний ключ на заказ
    p_service INTEGER NOT NULL, -- Хранит внешний ключ на услугу
    p_tech VARCHAR(50) NOT NULL,
    p_estim DECIMAL(10,2) NOT NULL,
    p_actual DECIMAL(10,2) NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (p_order) REFERENCES orders(o_id),
    FOREIGN KEY (p_service) REFERENCES services(s_id)
);

-- Таблица Запчасти
CREATE TABLE details (
    d_id SERIAL PRIMARY KEY,
    d_name VARCHAR(150) NOT NULL,
    d_art VARCHAR(50) NOT NULL,
    d_price DECIMAL(10,2) NOT NULL
);

-- Таблица Остатки по филиалам
CREATE TABLE stock_balance (
    l_id SERIAL PRIMARY KEY,
    l_workshop INTEGER NOT NULL, -- Хранит внешний ключ на мастерскую
    l_detail INTEGER NOT NULL, -- Хранит внешний ключ на запчасти
    l_count INTEGER NOT NULL,
    l_location VARCHAR(50) NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (l_workshop) REFERENCES workshops(w_id),
    FOREIGN KEY (l_detail) REFERENCES details(d_id)
);

-- Таблица Использование запчастей в заказе
CREATE TABLE used_details (
    u_id SERIAL PRIMARY KEY,
    u_order INTEGER NOT NULL, -- Хранит внешний ключ на заказ
    u_detail INTEGER NOT NULL, -- Хранит внешний ключ на запчасть
    u_count INTEGER NOT NULL,
    u_price_per DECIMAL(10,2) NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (u_order) REFERENCES orders(o_id),
    FOREIGN KEY (u_detail) REFERENCES details(d_id)
);

-- Таблица Поставщики
CREATE TABLE suppliers (
    su_id SERIAL PRIMARY KEY,
    su_name VARCHAR(150) NOT NULL,
    su_telephone VARCHAR(50) NOT NULL
);

-- Таблица Заказы поставщику
CREATE TABLE orders_to_supplier (
    ots_id SERIAL PRIMARY KEY,
    ots_supplier INTEGER NOT NULL, -- Хранит внешний ключ на поставщика
    ots_workshop INTEGER NOT NULL, -- Хранит внешний ключ на мастерскую
    ots_data DATE NOT NULL,
    ots_status VARCHAR(20) NOT NULL,
    ots_price DECIMAL(10,2) NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (ots_supplier) REFERENCES suppliers(su_id),
    FOREIGN KEY (ots_workshop) REFERENCES workshops(w_id)
);

-- Таблица Платежи
CREATE TABLE payments (
    pay_id SERIAL PRIMARY KEY,
    pay_order INTEGER NOT NULL, -- Хранит внешний ключ на заказ
    pay_data DATE NOT NULL,
    pay_sum DECIMAL(10,2) NOT NULL,
    pay_way VARCHAR(20) NOT NULL,
    pay_status VARCHAR(20) NOT NULL,

    -- Привязка внешних ключей
    FOREIGN KEY (pay_order) REFERENCES orders(o_id)
);

-- ПР№7 Изменение таблиц в SQL.

-- Для примера мы будем работать с адрессом поставщика

SELECT * FROM suppliers; -- Выбрать все существующие поля из сущности

ALTER TABLE suppliers ADD COLUMN addr VARCHAR(200); -- Добавить поле

ALTER TABLE suppliers RENAME COLUMN addr TO addr2; -- Переименовать поле

ALTER TABLE suppliers DROP COLUMN addr2; -- Удалить поле

ALTER TABLE suppliers ADD CONSTRAINT unique_ADDR UNIQUE (su_name); -- Добавляем ограничение на уникальность значений в поле (Название ограничения unique_ADDR)

ALTER TABLE suppliers ALTER COLUMN su_name DROP NOT NULL; -- Убираем ограничение на поле

ALTER TABLE suppliers ALTER COLUMN su_name SET NOT NULL; -- Возвращаем наше ограничение обратно 

ALTER TABLE suppliers DROP CONSTRAINT unique_ADDR; -- Убираем ограничение на уникальность Название ограничения unique_COLOR

-- ПР№8 Добавление данных в таблицы БД

-- Синтаксис на заполнение таблицы такой:
-- INSERT INTO <название таблицы> (<Поле таблицы 1>, <Поле таблицы 2>) VALUES {<Данные 1>, <Данные 2>}

