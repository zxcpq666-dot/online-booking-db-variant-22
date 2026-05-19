DROP DATABASE IF EXISTS carwash_booking_22;

CREATE DATABASE carwash_booking_22
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE carwash_booking_22;

-- =========================================
-- КЛИЕНТЫ
-- =========================================

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,

    full_name VARCHAR(100) NOT NULL,

    phone VARCHAR(20) NOT NULL UNIQUE,

    email VARCHAR(100) UNIQUE
);

-- =========================================
-- ПОСТЫ АВТОМОЙКИ
-- =========================================

CREATE TABLE wash_posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,

    post_name VARCHAR(50) NOT NULL UNIQUE,

    status ENUM(
        'свободен',
        'занят',
        'на обслуживании'
    ) DEFAULT 'свободен'
);

-- =========================================
-- УСЛУГИ МОЙКИ
-- =========================================

CREATE TABLE wash_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,

    service_name VARCHAR(100) NOT NULL,

    wash_type ENUM(
        'контактная',
        'бесконтактная',
        'полировка'
    ) NOT NULL,

    duration_minutes INT NOT NULL
        CHECK (duration_minutes BETWEEN 15 AND 300),

    price DECIMAL(10,2) NOT NULL
        CHECK (price > 0)
);

-- =========================================
-- БРОНИРОВАНИЯ
-- =========================================

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    service_id INT NOT NULL,

    post_id INT NOT NULL,

    booking_datetime DATETIME NOT NULL,

    end_datetime DATETIME NOT NULL,

    status ENUM(
        'новая',
        'подтверждена',
        'выполнена',
        'отменена'
    ) DEFAULT 'новая',

    created_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (service_id)
        REFERENCES wash_services(service_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (post_id)
        REFERENCES wash_posts(post_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================
-- ИНДЕКСЫ
-- =========================================

CREATE INDEX idx_booking_datetime
ON bookings(booking_datetime);

CREATE INDEX idx_post
ON bookings(post_id);

-- =========================================
-- ТРИГГЕР
-- Запрет пересечения времени на одном посту
-- =========================================

DELIMITER $$

CREATE TRIGGER check_booking_overlap
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN

    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM bookings
    WHERE post_id = NEW.post_id
    AND (
        NEW.booking_datetime
        BETWEEN booking_datetime
        AND end_datetime

        OR

        NEW.end_datetime
        BETWEEN booking_datetime
        AND end_datetime
    );

    IF booking_count > 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Данный пост уже забронирован на это время';

    END IF;

END$$

DELIMITER ;

-- =========================================
-- ТЕСТОВЫЕ ДАННЫЕ
-- =========================================

INSERT INTO clients
(full_name, phone, email)
VALUES
(
    'Иван Иванов',
    '+79990001111',
    'ivanov@mail.ru'
),
(
    'Петр Петров',
    '+79990002222',
    'petrov@mail.ru'
),
(
    'Мария Сидорова',
    '+79990003333',
    'sidorova@mail.ru'
);

-- =========================================

INSERT INTO wash_posts
(post_name, status)
VALUES
('Пост 1', 'свободен'),
('Пост 2', 'свободен'),
('Пост 3', 'свободен');

-- =========================================

INSERT INTO wash_services
(
    service_name,
    wash_type,
    duration_minutes,
    price
)
VALUES
(
    'Базовая мойка',
    'контактная',
    40,
    1200
),
(
    'Премиум мойка',
    'полировка',
    90,
    4500
),
(
    'Экспресс мойка',
    'бесконтактная',
    25,
    800
);

-- =========================================

INSERT INTO bookings
(
    client_id,
    service_id,
    post_id,
    booking_datetime,
    end_datetime,
    status
)
VALUES
(
    1,
    1,
    1,
    '2026-05-20 10:00:00',
    '2026-05-20 10:40:00',
    'подтверждена'
),
(
    2,
    2,
    2,
    '2026-05-20 12:00:00',
    '2026-05-20 13:30:00',
    'новая'
);

-- =========================================
-- ЗАПРОС 1
-- Все бронирования
-- =========================================

SELECT
    b.booking_id,

    c.full_name,

    ws.service_name,

    ws.wash_type,

    wp.post_name,

    b.booking_datetime,

    b.end_datetime,

    b.status

FROM bookings b

JOIN clients c
ON b.client_id = c.client_id

JOIN wash_services ws
ON b.service_id = ws.service_id

JOIN wash_posts wp
ON b.post_id = wp.post_id

ORDER BY b.booking_datetime;

-- =========================================
-- ЗАПРОС 2
-- Количество услуг по типам
-- =========================================

SELECT
    wash_type,

    COUNT(service_id)
    AS total_services

FROM wash_services

GROUP BY wash_type

ORDER BY total_services DESC;

-- =========================================
-- ЗАПРОС 3
-- Средняя стоимость услуг
-- =========================================

SELECT
    AVG(price)
    AS average_price
FROM wash_services;

-- =========================================
-- ПРОВЕРКА UNIQUE / TRIGGER
-- =========================================

/*
INSERT INTO bookings
(
    client_id,
    service_id,
    post_id,
    booking_datetime,
    end_datetime
)
VALUES
(
    3,
    3,
    1,
    '2026-05-20 10:10:00',
    '2026-05-20 10:30:00'
);
*/

-- =========================================
-- ПРОВЕРКА FOREIGN KEY
-- =========================================

/*
DELETE FROM wash_posts
WHERE post_id = 1;
*/

-- =========================================
-- ПРОВЕРКА CHECK
-- =========================================

/*
INSERT INTO wash_services
(
    service_name,
    wash_type,
    duration_minutes,
    price
)
VALUES
(
    'Тест',
    'контактная',
    20,
    -500
);
*/
