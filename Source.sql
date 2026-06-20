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

-- Клиенты
INSERT INTO clients
(c_surn, c_name, c_patr, c_birthday, c_gender, c_telephone, c_addr)
VALUES
('Иванов', 'Иван', 'Иванович', '1985-03-12', 'М', '+79991111111', 'г. Москва, ул. Ленина, 10'),
('Петров', 'Пётр', 'Алексеевич', '1990-07-21', 'М', '+79992222222', 'г. Москва, ул. Гагарина, 15'),
('Сидорова', 'Анна', 'Сергеевна', '1995-01-30', 'Ж', '+79993333333', 'г. Москва, ул. Мира, 20'),
('Кузнецов', 'Дмитрий', 'Олегович', '1988-11-14', 'М', '+79994444444', 'г. Москва, ул. Советская, 8'),
('Смирнова', 'Елена', 'Игоревна', '1992-04-19', 'Ж', '+79995555555', 'г. Москва, ул. Парковая, 11'),
('Орлов', 'Максим', 'Викторович', '1980-09-08', 'М', '+79996666666', 'г. Москва, ул. Южная, 17'),
('Фёдорова', 'Мария', 'Андреевна', '1998-06-27', 'Ж', '+79997777777', 'г. Москва, ул. Центральная, 25'),
('Морозов', 'Николай', 'Петрович', '1977-02-16', 'М', '+79998888888', 'г. Москва, ул. Полевая, 4'),
('Волкова', 'Ольга', 'Владимировна', '1989-12-05', 'Ж', '+79999999999', 'г. Москва, ул. Лесная, 30'),
('Зайцев', 'Артём', 'Денисович', '1993-08-22', 'М', '+79990000000', 'г. Москва, ул. Молодёжная, 12');

-- Автомобили
INSERT INTO cars
(a_num, a_mark, a_date, a_gnum, a_mile, a_color, a_fuel, a_desc)
VALUES
('XTA11111111111111', 'Lada Vesta', '2020-05-10', 'А111АА77', 45000, 'Белый', 'Бензин', 'Плановое ТО'),
('XTA22222222222222', 'Kia Rio', '2019-03-15', 'В222ВВ77', 72000, 'Чёрный', 'Бензин', NULL),
('XTA33333333333333', 'Hyundai Solaris', '2021-07-01', 'С333СС77', 30000, 'Серый', 'Бензин', NULL),
('XTA44444444444444', 'Toyota Camry', '2018-10-20', 'Е444ЕЕ77', 90000, 'Белый', 'Бензин', NULL),
('XTA55555555555555', 'Volkswagen Polo', '2022-01-10', 'К555КК77', 15000, 'Синий', 'Бензин', NULL),
('XTA66666666666666', 'Skoda Octavia', '2017-12-12', 'М666ММ77', 120000, 'Серебристый', 'Дизель', NULL),
('XTA77777777777777', 'BMW X5', '2016-04-05', 'Н777НН77', 140000, 'Чёрный', 'Дизель', NULL),
('XTA88888888888888', 'Audi A6', '2019-08-18', 'О888ОО77', 65000, 'Белый', 'Бензин', NULL),
('XTA99999999999999', 'Renault Duster', '2020-11-11', 'Р999РР77', 54000, 'Зелёный', 'Дизель', NULL),
('XTA12345678901234', 'Ford Focus', '2018-06-09', 'Т123ТТ77', 81000, 'Красный', 'Бензин', NULL);

-- Мастерские
INSERT INTO workshops
(w_name, w_addr, w_telephone, w_time, w_cont, w_desc)
VALUES
('АвтоМастер Север', 'Москва, Северная 1', '+74951111111', '08:00-20:00', 'Иван Петров', NULL),
('АвтоМастер Юг', 'Москва, Южная 5', '+74952222222', '08:00-20:00', 'Пётр Иванов', NULL),
('АвтоМастер Запад', 'Москва, Западная 8', '+74953333333', '09:00-21:00', 'Анна Орлова', NULL),
('АвтоМастер Восток', 'Москва, Восточная 12', '+74954444444', '09:00-21:00', 'Сергей Волков', NULL),
('Экспресс Сервис', 'Москва, Лесная 3', '+74955555555', '08:00-22:00', 'Олег Морозов', NULL),
('АвтоПрофи', 'Москва, Полевая 6', '+74956666666', '08:00-20:00', 'Максим Кузнецов', NULL),
('АвтоЛюкс', 'Москва, Парковая 14', '+74957777777', '09:00-20:00', 'Елена Смирнова', NULL),
('ТехЦентр №1', 'Москва, Центральная 18', '+74958888888', '08:00-19:00', 'Николай Орлов', NULL),
('Гараж-Сервис', 'Москва, Молодёжная 7', '+74959999999', '10:00-20:00', 'Дмитрий Сидоров', NULL),
('АвтоДоктор', 'Москва, Гагарина 22', '+74950000000', '08:00-21:00', 'Алексей Фёдоров', NULL);

-- Сотрудники
INSERT INTO employees
(e_name, e_surn, e_patr, e_role, e_spec, e_telephone, e_exp, e_qual)
VALUES
('Алексей', 'Иванов', 'Петрович', 'Слесарь', 'Ремонт двигателей', '+79001111111', 10, 'Высшая'),
('Сергей', 'Петров', 'Игоревич', 'Электрик', 'Автоэлектрика', '+79002222222', 8, 'Первая'),
('Олег', 'Сидоров', 'Алексеевич', 'Маляр', 'Покраска кузова', '+79003333333', 7, 'Первая'),
('Анна', 'Кузнецова', 'Олеговна', 'Приёмщик', 'Работа с клиентами', '+79004444444', 5, 'Высшая'),
('Максим', 'Орлов', 'Викторович', 'Слесарь', 'Ходовая часть', '+79005555555', 12, 'Высшая'),
('Игорь', 'Смирнов', 'Сергеевич', 'Электрик', 'Диагностика', '+79006666666', 9, 'Высшая'),
('Дмитрий', 'Фёдоров', 'Иванович', 'Маляр', 'Локальная покраска', '+79007777777', 6, 'Первая'),
('Елена', 'Волкова', 'Андреевна', 'Приёмщик', 'Оформление заказов', '+79008888888', 4, 'Первая'),
('Павел', 'Морозов', 'Николаевич', 'Слесарь', 'Трансмиссия', '+79009999999', 11, 'Высшая'),
('Николай', 'Зайцев', 'Олегович', 'Электрик', 'ЭБУ и электроника', '+79000000000', 13, 'Высшая');

-- Услуги
INSERT INTO services
(s_name, s_code, s_price, s_time, s_category, s_desc)
VALUES
('Замена масла', 'SRV001', 2500.00, 1, 'ТО', 'Замена моторного масла'),
('Замена колодок', 'SRV002', 4000.00, 2, 'Тормоза', NULL),
('Компьютерная диагностика', 'SRV003', 1500.00, 1, 'Диагностика', NULL),
('Покраска двери', 'SRV004', 12000.00, 8, 'Кузовной ремонт', NULL),
('Замена аккумулятора', 'SRV005', 1000.00, 1, 'Электрика', NULL),
('Ремонт подвески', 'SRV006', 8500.00, 5, 'Ходовая', NULL),
('Замена ремня ГРМ', 'SRV007', 10000.00, 6, 'Двигатель', NULL),
('Шиномонтаж', 'SRV008', 3000.00, 1, 'Шины', NULL),
('Полировка кузова', 'SRV009', 7000.00, 4, 'Кузовной ремонт', NULL),
('Заправка кондиционера', 'SRV010', 3500.00, 2, 'Климат', NULL);

-- Запчасти
INSERT INTO details
(d_name, d_art, d_price)
VALUES
('Масляный фильтр', 'DET001', 500.00),
('Воздушный фильтр', 'DET002', 700.00),
('Тормозные колодки', 'DET003', 2500.00),
('Аккумулятор', 'DET004', 8500.00),
('Свеча зажигания', 'DET005', 400.00),
('Ремень ГРМ', 'DET006', 3500.00),
('Амортизатор', 'DET007', 4200.00),
('Лампа фары', 'DET008', 600.00),
('Радиатор', 'DET009', 9500.00),
('Топливный насос', 'DET010', 7300.00);

-- Поставщики
INSERT INTO suppliers
(su_name, su_telephone)
VALUES
('АвтоДеталь', '+78001000001'),
('АвтоСнаб', '+78001000002'),
('ТехПоставка', '+78001000003'),
('АвтоМир', '+78001000004'),
('ЗапчастьПлюс', '+78001000005'),
('ПрофАвто', '+78001000006'),
('КарСервис', '+78001000007'),
('ДетальТорг', '+78001000008'),
('МегаАвто', '+78001000009'),
('АвтоЛогистик', '+78001000010');

-- Заказы
INSERT INTO orders
(o_employee, o_workshop, o_client, o_car, o_status, o_price, o_date, o_plan)
VALUES
(1,1,1,1,'Завершён',3000.00,'2025-05-01','2025-05-02'),
(2,2,2,2,'В работе',5500.00,'2025-05-03','2025-05-04'),
(3,3,3,3,'Завершён',12000.00,'2025-05-05','2025-05-06'),
(4,4,4,4,'Принят',8000.00,'2025-05-07','2025-05-08'),
(5,5,5,5,'Завершён',9500.00,'2025-05-09','2025-05-10'),
(6,6,6,6,'В работе',7000.00,'2025-05-11','2025-05-12'),
(7,7,7,7,'Принят',14000.00,'2025-05-13','2025-05-14'),
(8,8,8,8,'Завершён',6000.00,'2025-05-15','2025-05-16'),
(9,9,9,9,'В работе',11000.00,'2025-05-17','2025-05-18'),
(10,10,10,10,'Принят',4500.00,'2025-05-19','2025-05-20');

-- Позиции заказа
INSERT INTO order_positions
(p_order, p_service, p_tech, p_estim, p_actual)
VALUES
(1,1,'TECH001',2500.00,3000.00),
(2,2,'TECH002',5000.00,5500.00),
(3,4,'TECH003',11000.00,12000.00),
(4,6,'TECH004',7500.00,8000.00),
(5,7,'TECH005',9000.00,9500.00),
(6,3,'TECH006',6500.00,7000.00),
(7,9,'TECH007',13000.00,14000.00),
(8,8,'TECH008',5500.00,6000.00),
(9,10,'TECH009',10000.00,11000.00),
(10,5,'TECH010',4000.00,4500.00);

-- Остатки по филиалам
INSERT INTO stock_balance
(l_workshop, l_detail, l_count, l_location)
VALUES
(1,1,25,'Склад А1'),
(2,2,18,'Склад А2'),
(3,3,30,'Склад Б1'),
(4,4,12,'Склад Б2'),
(5,5,40,'Склад В1'),
(6,6,15,'Склад В2'),
(7,7,10,'Склад Г1'),
(8,8,50,'Склад Г2'),
(9,9,8,'Склад Д1'),
(10,10,20,'Склад Д2');

-- Использованные запчасти в заказах
INSERT INTO used_details
(u_order, u_detail, u_count, u_price_per)
VALUES
(1,1,1,500.00),
(2,3,1,2500.00),
(3,4,1,8500.00),
(4,7,2,4200.00),
(5,6,1,3500.00),
(6,5,4,400.00),
(7,9,1,9500.00),
(8,8,2,600.00),
(9,10,1,7300.00),
(10,2,1,700.00);

-- Заказы поставщикам
INSERT INTO orders_to_supplier
(ots_supplier, ots_workshop, ots_data, ots_status, ots_price)
VALUES
(1,1,'2025-04-01','Получен',25000.00),
(2,2,'2025-04-02','Получен',18000.00),
(3,3,'2025-04-03','В пути',32000.00),
(4,4,'2025-04-04','Получен',41000.00),
(5,5,'2025-04-05','Оформлен',15000.00),
(6,6,'2025-04-06','В пути',28000.00),
(7,7,'2025-04-07','Получен',35000.00),
(8,8,'2025-04-08','Оформлен',17000.00),
(9,9,'2025-04-09','Получен',26000.00),
(10,10,'2025-04-10','В пути',39000.00);

-- Платежи
INSERT INTO payments
(pay_order, pay_data, pay_sum, pay_way, pay_status)
VALUES
(1,'2025-05-02',3000.00,'Карта','Оплачен'),
(2,'2025-05-04',5500.00,'Наличные','Оплачен'),
(3,'2025-05-06',12000.00,'Карта','Оплачен'),
(4,'2025-05-08',8000.00,'Перевод','Ожидает'),
(5,'2025-05-10',9500.00,'Карта','Оплачен'),
(6,'2025-05-12',7000.00,'Наличные','Оплачен'),
(7,'2025-05-14',14000.00,'Перевод','Ожидает'),
(8,'2025-05-16',6000.00,'Карта','Оплачен'),
(9,'2025-05-18',11000.00,'Наличные','Оплачен'),
(10,'2025-05-20',4500.00,'Карта','Оплачен');







-- ПР№9 Простые запросы на выборку

-- Отсортировать 3 поля из таблицы "машины" от большего к меньшему, по пробегу
SELECT a_mark, a_gnum, a_color, a_mile
FROM cars
ORDER BY a_mile DESC;

-- Выбрать 3 поля из таблицы "клиенты"
SELECT c_surn, c_name, c_patr
FROM clients;

-- Выбрать 3 поля из таблицы "сотрудники", у которых стаж больше 7 лет 
SELECT e_surn, e_name, e_role, e_exp
FROM employees
WHERE e_exp > 7;

-- Выбрать 3 поля из таблицы "машины" у которых пробег от 50000 до 100000 миль
SELECT a_mark, a_gnum, a_mile
FROM cars
WHERE a_mile BETWEEN 50000 AND 100000;

-- Выбераем 2 поля из таблицы "услуги" у которых наименовании услуги начинается на 'Замена'
SELECT s_name, s_price
FROM services
WHERE s_name LIKE 'Замена%';








-- ПР№10 Сложные запросы на выборку

-- FROM/JOIN - откуда куда (JOIN для внешних ключей)
-- WHERE - как фильтруем строки? (Определённое условие выборки)
-- GROUP BY - берём группы строк и обьединяем во что-то одно
-- HAVING - работает как WHERE только нужен для функций таких как: SUM, COUNT, AVG
-- SELECT - выборка полей
-- ORDER BY - сортировка 
-- Аллиасы - это временные наименования запросов. К примеру Someone s, и теперь мы можем обращятся на Someone через s. 
-- AS - временные наименования для полей запросов. К примеру c_id AS "Номер клиента", и теперь в запросе будет писатся не c_id, а "Номер клиента"

-- Список заказов с клиентом и автомобилем
SELECT
    o.o_id AS "Номер_заказа",
    c.c_surn || ' ' || c.c_name AS "Клиент", -- Тут происходит конкатенация строк (сшивание), то-есть мы между строк добавляем пробел
    a.a_mark AS "Автомобиль",
    a.a_gnum AS "Госномер",
    o.o_status AS "Статус",
    o.o_price AS "Стоимость"
FROM orders o
JOIN clients c ON o.o_client = c.c_id -- Используем JOIN что-бы связать в запросе ещё и внешние ключи
JOIN cars a ON o.o_car = a.a_id
ORDER BY o.o_id; -- Сразу сортировка по номеру заказа от меньшего к большему

-- Заказы с сотрудником и мастерской
SELECT
    o.o_id AS "Номер_заказа",
    e.e_surn || ' ' || e.e_name AS "Сотрудник",
    w.w_name AS "Мастерская",
    o.o_date AS "Дата_заказа",
    o.o_status AS "Статус"
FROM orders o
JOIN employees e ON o.o_employee = e.e_id
JOIN workshops w ON o.o_workshop = w.w_id
ORDER BY o.o_date;

-- Количество заказов у каждого клиента
SELECT
    c.c_id AS "Код_клиента",
    c.c_surn || ' ' || c.c_name AS "Клиент",
    COUNT(o.o_id) AS "Количество_заказов"
FROM clients c
LEFT JOIN orders o ON o.o_client = c.c_id
GROUP BY c.c_id, c.c_surn, c.c_name
ORDER BY "Количество_заказов" DESC;

-- Общая сумма заказов по каждому клиенту
SELECT
    c.c_surn || ' ' || c.c_name AS "Клиент",
    SUM(o.o_price) AS "Общая_сумма"
FROM clients c
JOIN orders o ON o.o_client = c.c_id
GROUP BY c.c_surn, c.c_name
ORDER BY "Общая_сумма" DESC;

-- Какие услуги входят в заказы
SELECT
    o.o_id AS "Номер_заказа",
    s.s_name AS "Услуга",
    op.p_actual AS "Стоимость_услуги"
FROM order_positions op
JOIN orders o ON op.p_order = o.o_id
JOIN services s ON op.p_service = s.s_id
ORDER BY o.o_id, s.s_name;

-- Использованные запчасти в заказах
SELECT
    o.o_id AS "Номер_заказа",
    d.d_name AS "Запчасть",
    ud.u_count AS "Количество",
    ud.u_price_per AS "Цена_за_единицу"
FROM used_details ud
JOIN orders o ON ud.u_order = o.o_id
JOIN details d ON ud.u_detail = d.d_id
ORDER BY o.o_id, d.d_name;







-- ПР№11 Создание системы аудита

-- Аудит таблицы EMPLOYEES

-- Для хранения значений об изменении в БД
-- old старые значения
-- new новые данные
-- А также метаданные (Кто и когда)
CREATE TABLE employees_audit(
	audit_id SERIAL PRIMARY KEY,
	operation_type VARCHAR(10) NOT NULL CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE')), -- теперь можно вводить только INSERT/UPDATE/DELETE
	operation_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

	employee_id INTEGER,
    old_name VARCHAR(50),
	old_surn VARCHAR(50),
	old_patr VARCHAR(50),
	old_role VARCHAR(50),
    old_spec VARCHAR(300),
	old_telephone VARCHAR(50),
    old_exp INTEGER,
    old_qual VARCHAR(50),

	new_name VARCHAR(50),
	new_surn VARCHAR(50),
	new_patr VARCHAR(50),
	new_role VARCHAR(50),
    new_spec VARCHAR(300),
	new_telephone VARCHAR(50),
    new_exp INTEGER,
    new_qual VARCHAR(50),

	-- Когда изменили
	changed_by VARCHAR(100) DEFAULT CURRENT_USER,
	-- Название приложения которое изменило
	application_name VARCHAR(100),
	-- IP адресс того кто изменил
	client_address INET
);

-- Тригерная функция
-- Функция привязанна к employees чтобы указать как сохранять в неё данные и куда записывать историю
CREATE OR REPLACE FUNCTION process_employees_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	-- TG_OP спец переменная содержащяя тип операции
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO employees_audit (
            operation_type,
            employee_id,
			
            new_name,
            new_surn,
            new_patr,
            new_role,
            new_spec,
            new_telephone,
            new_exp,
            new_qual,

            application_name,
            client_address
        ) VALUES (
            'INSERT',
            NEW.e_id,
            NEW.e_name,
            NEW.e_surn,
            NEW.e_patr,
            NEW.e_role,
            NEW.e_spec,
            NEW.e_telephone,
            NEW.e_exp,
            NEW.e_qual,
			
            current_setting('application_name', true),
            inet_client_addr()
        );
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN
		-- IS DISTINCT FROM - это проверка действительно ли были изменения. Т.е вернёт ли условие true если старые и новые будут не равны
		-- как оператор != из C++ (a != b || c != d)
        IF (
            OLD.e_name IS DISTINCT FROM NEW.e_name OR
            OLD.e_surn IS DISTINCT FROM NEW.e_surn OR
            OLD.e_patr IS DISTINCT FROM NEW.e_patr OR
            OLD.e_role IS DISTINCT FROM NEW.e_role OR
            OLD.e_spec IS DISTINCT FROM NEW.e_spec OR
            OLD.e_telephone IS DISTINCT FROM NEW.e_telephone OR
            OLD.e_exp IS DISTINCT FROM NEW.e_exp OR
			OLD.e_qual IS DISTINCT FROM NEW.e_qual
        ) THEN
            INSERT INTO employees_audit (
                operation_type,
                employee_id,
                
                old_name,
                old_surn,
                old_patr,
                old_role,
                old_spec,
                old_telephone,
                old_exp,
                old_qual,
                    
                new_name,
                new_surn,
                new_patr,
                new_role,
                new_spec,
                new_telephone,
                new_exp,
                new_qual,

                application_name,
                client_address
            ) VALUES (
                'UPDATE',
                NEW.e_id,
               
                OLD.e_name,
                OLD.e_surn,
                OLD.e_patr,
                OLD.e_role,
                OLD.e_spec,
                OLD.e_telephone,
                OLD.e_exp,
                OLD.e_qual,

                NEW.e_name,
                NEW.e_surn,
                NEW.e_patr,
                NEW.e_role,
                NEW.e_spec,
                NEW.e_telephone,
                NEW.e_exp,
                NEW.e_qual,
                
                current_setting('application_name', true),
                inet_client_addr()
            );
		-- ENF IF -  окончание условия
        END IF;
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO employees_audit (
            operation_type,
            employee_id,

            old_name,
            old_surn,
            old_patr,
            old_role,
            old_spec,
            old_telephone,
            old_exp,
            old_qual,

            application_name,
            client_address
        ) VALUES (
            'DELETE',
            OLD.e_id,
            OLD.e_name,
            OLD.e_surn,
            OLD.e_patr,
            OLD.e_role,
            OLD.e_spec,
            OLD.e_telephone,
            OLD.e_exp,
            OLD.e_qual,

            current_setting('application_name', true),
            inet_client_addr()
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;

-- Тригер функция - чтобы связать функцию process_employees_audit() с таблицей employees

-- CREATE TRIGGER - создания тригера
CREATE TRIGGER trg_employees_audit
-- После операции INSERT или UPDATE или DELEE в таблицу Работники
AFTER INSERT OR UPDATE OR DELETE ON Employees
-- Для кажой строки
FOR EACH ROW
-- Запустить функцию
EXECUTE FUNCTION process_employees_audit();

-- Проверка есть ли триггер
SELECT
 tgname AS trigger_name,
 tgtype::integer & 1 > 0 AS "before",
 tgtype::integer & 2 > 0 AS "insert",
 tgtype::integer & 4 > 0 AS "delete",
 tgtype::integer & 8 > 0 AS "update",
 tgenabled AS enabled
FROM pg_trigger
WHERE tgrelid = 'employees'::regclass;

-- Тест системы аудита

INSERT INTO employees
(e_name, e_surn, e_patr, e_role, e_spec, e_telephone, e_exp, e_qual)
VALUES
('Иван', 'Иванов', 'Иванович', 'Слесарь', 'Ремонт Чего-то', '+79001111111', 15, 'Высшая');

UPDATE employees 
SET e_role = 'Маляр' 
WHERE e_surn = 'Иванов';

DELETE FROM employees 
WHERE e_spec = 'Ремонт Чего-то';

-- Просмотреть таблицу аудита
SELECT * FROM employees_audit;

-- Удалить данные из таблицы аулита
DELETE FROM employees_audit;