/*1. Создайте таблицу для хранения списка книг в библиотеке (пример имени таблицы books_mbelko).
без первичных ключей и ограничений
перечень и имена колонок на ваше усмотрение
вставьте 3 произвольные строки с данными для всех колонок
напишите проверочный скрипт демонстрирующий ваше изменения используя словарь INFORMATION_SCHEMA.COLUMNS
напишите проверочный скрипт на содержание вашего инсерта (5 баллов)*/

drop table if exists db_laba.dbo.books_abogomolov; -- пробовал удалять/создавать таблицу.

create table db_laba.dbo.books_abogomolov(
book_id int,
book_name varchar (100),
book_author varchar (50),
book_genre varchar (50));

insert into db_laba.dbo.books_abogomolov(
    book_id,
    book_name,
    book_author,
	book_genre)
values
(1,'1984','orwell','novel'),
(2,'the son','nesbo','crime novel'),
(3,'the witcher','sapkowski','fantasy');

--проверочный скрипт демонстрирующий изменения
select ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'books_abogomolov';

--проверочный скрипт на содержание инсерта
select * from db_laba.dbo.books_abogomolov;

/*2. В созданную в первом задании таблицу добавьте колонку description с типом данных char(32)
вставьте 3 произвольные строки с данными для всех колонок
напишите проверочный скрипт демонстрирующий ваше изменения используя словарь INFORMATION_SCHEMA.COLUMNS
напишите проверочный скрипт на содержание вашего инсерта (5 баллов)*/

alter table db_laba.dbo.books_abogomolov add description char(32);

insert into db_laba.dbo.books_abogomolov(
    book_id,
    book_name,
    book_author,
	book_genre,
	description)
values
(4,'harry potter','rowling','fantasy','the boy who lived'),
(5,'my autobiography','sir alex ferguson','autobiography','the best coach'),
(6,'anna karenina','tolstoy','novel','panorama of life in Russia');

-- проверочный скрипт демонстрирующий изменения
select ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'books_abogomolov';

--проверочный скрипт на содержание инсерта (общий)
select * from db_laba.dbo.books_abogomolov;
--проверочный скрипт на содержание инсерта (по добавленным строкам)
select * from db_laba.dbo.books_abogomolov
where book_id in (4,5,6);

/*3. В созданную в первом задании таблицу вставить строку с произвольными данными, но для в колонки description вставить следующий текст:
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
(подсказка для этого Вам понадобиться изменить тип данных колонки description)
напишите скрипт для модификации таблицы
напишите проверочный скрипт демонстрирующий Ваше изменения используя словарь INFORMATION_SCHEMA.COLUMNS
напишите проверочный скрипт на содержание вашего инсерта (5 баллов)*/

select len(replace('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', '', '_')) as количество_символов 
/*исходя из подсказки и того, что визуально текст содержит в себе больше 32 символов (которые мы указали для decription в задании 2), становится очевидно, что надо изменить 32 на большее значение.
Просто для себя сделал небольшой запрос выше, чтобы понимать на сколько увеличивать. Вывод: 125 хватает.*/

--хотел использовать MODIFY, но обнаружил, что для MS SQL Server надо использовать alter, чтобы изменить тип данных столбца
alter table db_laba.dbo.books_abogomolov alter column description char(125)

insert into db_laba.dbo.books_abogomolov(
    book_id,
    book_name,
    book_author,
	book_genre,
	description)
values
(7,'sql','bogomolov','textbook','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.')

-- проверочный скрипт демонстрирующий изменения
select ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'books_abogomolov';

--проверочный скрипт на содержание инсерта (общий)
select * from db_laba.dbo.books_abogomolov;
--проверочный скрипт на содержание инсерта (по добавленной строке)
select * from db_laba.dbo.books_abogomolov
where book_id = 7;

/*4. Создайте новую таблицу на основе таблицы из первого задания (со всеми колонками и 7ю строками на текущий момент)
сделайте колонку description с ограничением на длину не менее 3 символа и со значением по умолчанию N/A
напишите скрипт  для модификации таблицы
напишите проверочный скрипт демонстрирующий Ваше изменения используя словарь INFORMATION_SCHEMA.COLUMNS
напишите проверочный скрипт на содержание вашей новой таблицы (5 баллов)*/

drop table if exists db_laba.dbo.books_abogomolov_ver2

create table db_laba.dbo.books_abogomolov_ver2(
book_id int,
book_name varchar (100),
book_author varchar (50),
book_genre varchar (50),
description char (125) check (len(description)>=3) default 'N/A'); --поднимал вопрос в Телеграме. Здесь порядок не играет роли. Ниже запросы проверочные. К тому же в условии задания чётко прописан порядок ограничений.
--description char (125) default 'N/A' check (len(description)>=3))

insert into db_laba.dbo.books_abogomolov_ver2
select 
book_id,
book_name,
book_author,
book_genre,
COALESCE(description, 'N/A') -- здесь лучше использовать COALESCE, т.к. появилось условие, что по умолчанию descriprion принимает значение 'N/A'. Т.е. чтобы не было null и n/a.
from db_laba.dbo.books_abogomolov;

--проверочный скрипт демонстрирующий изменения
select ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'books_abogomolov_ver2';

--проверочный скрипт на содержание инсерта новой таблицы
select * from db_laba.dbo.books_abogomolov_ver2;


/* ниже запрос, которым проверяю, работают ли ограничения на колонку description
insert into db_laba.dbo.books_abogomolov_ver2(
    book_id,
    book_name,
    book_author,
	book_genre,
	description)
values
(8,'test','test','test','te')
выдало ошибку. Ограничение работает.
*/


/*  ниже запрос, которым проверяю, подставиться ли N/A по умолчанию в колонку description
insert into db_laba.dbo.books_abogomolov_ver2(
    book_id,
    book_name,
    book_author,
	book_genre)
values
(8,'test','test','test')

select * from db_laba.dbo.books_abogomolov_ver2;
создалась строка со значением N/A в description

delete from db_laba.dbo.books_abogomolov_ver2
where book_id = 8
*/



