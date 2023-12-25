-- Создаем базу данных My_test

drop database if exists my_test;
create database if not exists my_test;
use my_test;

-- Создаем таблицу client_info

create table if not exists client_info
(
id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
age int not null,
phone varchar(16) not null,
email varchar(50) not null,
sex varchar(1) check (sex in ('F', 'M')),
bad_habits varchar(150) not null
);

-- Создаем таблицу dop_info, связанную с client_info
-- Не забываем указать on delete cascade в  foreign key, для возвожного каскадного удаления

create table if not exists dop_info
(
id int primary key auto_increment,
dop_first_name varchar(50) not null,
dop_last_name varchar(50) not null,
dop_phone varchar(16) not null,
children varchar(1) check (children in ('Y', 'N')),
number_of_children int,
dop_info_id int,
foreign key (dop_info_id) references client_info(id) on delete cascade
);

-- Заполняем таблицы client_info и dop_info

INSERT INTO client_info(first_name, last_name, age, phone, email, sex, bad_habits) VALUES
('Андрей', 'Иванов', 30, '+7 999 888-77-22', 'aivanov@yandex.ru', 'M', 'Фывапри йцукен ячсмит'),
('Анна', 'Петрова', 24, '+7 999 777-88-22', 'apetrova@yandex.ru', 'F', 'Фывапри йцукен ячсмит'),
('Иван', 'Андреев', 22, '+7 999 666-77-33', 'ianreev@yandex.ru', 'M', 'Фывапри йцукен ячсмит'),
('Петр', 'Сидоров', 44, '+7 999 876-22-77', 'psidorov@yandex.ru', 'M', 'Фывапри йцукен ячсмит'),
('Наталья', 'Антонова', 38, '+7 999 555-67-44', 'nantonova@yandex.ru', 'F', 'Фывапри йцукен ячсмит');

INSERT INTO dop_info(dop_first_name, dop_last_name, dop_phone, children, number_of_children, dop_info_id) VALUES
('Андрей', 'Иванов', '+7 999 888-77-22', 'Y', 2, 1),
('Анна', 'Петрова', '+7 999 777-88-22', 'N', 0, 2),
('Иван', 'Андреев', '+7 999 666-77-33', 'N', 0, 3),
('Петр', 'Сидоров', '+7 999 876-22-77', 'Y', 1, 4),
('Наталья', 'Антонова', '+7 999 555-67-44', 'Y', 2, 5);

-- Выводим информацию из client_info и dop_info для мужчин (sex = 'M')

SELECT first_name, last_name, bad_habits, phone, children, number_of_children 
FROM client_info JOIN dop_info
ON client_info.id = dop_info.dop_info_id
WHERE sex = 'M';

-- Меняем номер телефона по номеру id

UPDATE client_info, dop_info 
SET client_info.phone = '+7 988 687-22-76', dop_info.dop_phone = '+7 988 687-22-76'
WHERE client_info.id = 4 and dop_info.id = 4;

-- Добавляем значение address со значением по умолчанию "Не указан"

ALTER TABLE client_info
ADD address varchar(200) NOT NULL DEFAULT 'Не указан';

-- Находим минимальное значение возраста

SELECT client_info.id, client_info.first_name, client_info.last_name, client_info.age FROM client_info WHERE age=(SELECT min(age) FROM client_info);

-- Удаляем строку во всех таблицах

DELETE client_info FROM client_info WHERE age=22;

-- Выводим объединенную таблицу client_info и dop_info с сортировкой по возрасту в порядке убывания (DESC).

SELECT * FROM client_info LEFT JOIN dop_info
ON client_info.id=dop_info.dop_info_id
ORDER BY age DESC;

-- Удаляем таблицы dop_info и client_info

DROP table dop_info, client_info;

-- Проверяем удаление через меню Database\Reverse Engineer
-- или командой из строки

SELECT * FROM my_test.client_info, my_test.dop_info;

-- Таблицы удалены