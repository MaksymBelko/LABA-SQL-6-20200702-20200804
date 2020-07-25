/*
 * #########################################
 * #     Занятие 8                         #  
 * #     Создание и модификации таблиц     #
 * #########################################
 */
drop table if exists db_laba.dbo.countries_test_mbelko;
drop table if exists db_laba.dbo.countries_test_02_mbelko;
drop table if exists db_laba.dbo.Salespeople_02_mbelko;
drop table if exists db_laba.dbo.Salespeople_01_mbelko;
drop table if exists db_laba.dbo.Salespeople_mbelko;
drop table if exists db_laba.dbo.Namefield_mbelko;
drop table if exists db_laba.dbo.TransactionHistory_01_mbelko;
drop table if exists db_laba.dbo.TransactionHistory_mbelko;
drop table if exists db_laba.dbo.customers_mbelko; 
drop table if exists db_laba.dbo.employees_test_01_mbelko;
drop table if exists db_laba.dbo.countries_test_03_mbelko;


/* +----------------------------+
 * | Создание и удалени таблицы |
 * +----------------------------+
 */

--https://docs.microsoft.com/ru-ru/sql/relational-databases/tables/tables?view=sql-server-2017
--https://docs.oracle.com/cd/B28359_01/server.111/b28310/tables003.htm#ADMIN11004
--https://www.postgresql.org/docs/9.1/sql-createtable.html
-- создать таблицу стран
-- 1/31
drop table if exists db_laba.dbo.countries_test_mbelko;
CREATE TABLE db_laba.dbo.countries_test_mbelko (
	id int,
	name varchar(100)
);

-- 2/31
insert
	into
	db_laba.dbo.countries_test_mbelko
select
	0,
	'Ukraine'
UNION all
select
	1,
	'USA';

SELECT
	*
from
	db_laba.dbo.countries_test_mbelko;


sp_help countries_test_mbelko;

--Oracle 
--create table temp AS select.....

/* +---------+
 * | Индексы |
 * +---------+
 */
--https://docs.microsoft.com/ru-ru/sql/relational-databases/indexes/indexes?view=sql-server-2017
--https://docs.microsoft.com/ru-ru/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-2017
--https://docs.oracle.com/cd/E11882_01/server.112/e40540/indexiot.htm#CNCPT811
--https://habr.com/ru/post/247373/
-- 3/31
SELECT name, type_desc, is_unique, is_primary_key--,*
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.countries_test_mbelko');

-- 4/31
CREATE UNIQUE INDEX UQ_countries_test_mbelko ON db_laba.dbo.countries_test_mbelko (name);

--Cannot insert duplicate key row in object 'dbo.countries_test_mbelko' with unique index 'UQ_countries_test_mbelko'.
-- 5/31
insert
	into
	db_laba.dbo.countries_test_mbelko
select
	0,
	'Ukraine';
--
/* +----------------------------------+
 * | Изменение таблицы после создания |
 * +----------------------------------+
 */
--
-- 6/31
alter table db_laba.dbo.countries_test_mbelko add abbreviated char(2);
SELECT * from db_laba.dbo.countries_test_mbelko;

-- 7/31
alter table db_laba.dbo.countries_test_mbelko drop COLUMN abbreviated;
SELECT * from db_laba.dbo.countries_test_mbelko;

SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'countries_test_mbelko';

/* +-----------------------------------+
 * | Ограничение значений ваших данных |
 * +-----------------------------------+
 */

--типичная таблица с первичным ключем на ID и именем
-- 8/31
drop table db_laba.dbo.countries_test_02_mbelko;
drop table if exists db_laba.dbo.countries_test_02_mbelko;
CREATE TABLE db_laba.dbo.countries_test_02_mbelko (
	id int PRIMARY KEY,
	name varchar(100)
);

SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'countries_test_02_mbelko';

SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.countries_test_02_mbelko');

--с длинными и читабельными именами
-- 9/31
drop table if exists db_laba.dbo.countries_test_03_mbelko;
CREATE TABLE db_laba.dbo.countries_test_03_mbelko (
	country_id int PRIMARY KEY,
	country_name varchar(100)
);

select * from db_laba.dbo.countries_test_03_mbelko;

SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.countries_test_03_mbelko');

SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'countries_test_03_mbelko';

-- создать таблицу сотрудников
-- Cyrillic_General_CS_AS_KS
-- https://docs.microsoft.com/ru-ru/sql/t-sql/statements/collations?view=sql-server-2017
-- https://database.guide/full-list-of-collations-supported-in-sql-server-2017/
-- 10/31
drop table if exists db_laba.dbo.employees_test_01_mbelko;

CREATE TABLE db_laba.dbo.employees_test_01_mbelko ( employee_id int NOT NULL,
first_name varchar(255) COLLATE Cyrillic_General_CS_AS_KS NULL,
last_name varchar(255) COLLATE Cyrillic_General_CS_AS_KS NULL,
email varchar(255) COLLATE Cyrillic_General_CI_AS_KS NULL,
phone varchar(50) COLLATE Cyrillic_General_CI_AS_KS NULL,
hire_date date NULL,
manager_id int NULL,
job_title varchar(255) COLLATE Cyrillic_General_CS_AS_KS NULL,
CONSTRAINT PK_employees_test_01_mbelko PRIMARY KEY (employee_id) );


--CREATE INDEX
-- 11/31
CREATE INDEX IX_employees_test_01_mbelko_01 ON
db_laba.dbo.employees_test_01_mbelko (first_name,
last_name,
email);

--check
SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees_test_01_mbelko';

--check
SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.employees_test_01_mbelko');

--DROP INDEX
-- 12/31
DROP INDEX IX_employees_test_01_mbelko_01 ON
db_laba.dbo.employees_test_01_mbelko;

--check
SELECT CONSTRAINT_NAME, *
FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_NAME = 'Customers'
--
/* +--------------------------------------------------------------------+
 * | Использование ограничений для исключения пустых (NULL) показателей |
 * +--------------------------------------------------------------------+
 */
--
-- 13/31
drop table if exists db_laba.dbo.customers_mbelko; 

CREATE TABLE db_laba.dbo.customers_mbelko (
	customer_id int NOT NULL,
	name varchar(255) NOT NULL,
	address varchar(255),
	website varchar(255),
	credit_limit decimal(8,2) ,
	PRIMARY KEY (customer_id)
);

SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
       , IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers_mbelko';

--check
SELECT name, type_desc, is_unique, is_primary_key, *
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.customers_mbelko');


/* +-----------------------------------+
 * | Убедитесь, что значения уникальны |
 * +-----------------------------------+
 */
--
-- 14/31
insert into db_laba.dbo.employees_test_01_mbelko 
select * from db_laba.dbo.employees;

-- 15/31
select count(distinct job_title),  count(job_title) from db_laba.dbo.employees;

/* +----------------------------------------------------+
 * | Уникальность как ограничение столбца и/или таблицы |
 * +----------------------------------------------------+
 */
--
-- ALTER TABLE db_laba.dbo.employees   
-- err he CREATE UNIQUE INDEX statement terminated because a duplicate key was found
-- 16/31
ALTER TABLE db_laba.dbo.employees   
ADD CONSTRAINT UQ_employees UNIQUE (job_title);

-- 17/31
drop table if exists db_laba.dbo.TransactionHistory_mbelko;
CREATE TABLE db_laba.dbo.TransactionHistory_mbelko
 (  
   TransactionID int NOT NULL,   
   description varchar(255),
   created_ts datetime,
   CONSTRAINT UQ_TransactionID UNIQUE(TransactionID)   
); 
--check
SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TransactionHistory_mbelko';

--check
SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.TransactionHistory_mbelko');

-- 18/31
ALTER TABLE db_laba.dbo.TransactionHistory_mbelko   
ADD CONSTRAINT UQ_TransactionHistory_mbelko UNIQUE (description, created_ts);   

-- 19/31
ALTER TABLE db_laba.dbo.TransactionHistory_mbelko   
DROP CONSTRAINT UQ_TransactionHistory_mbelko;

-- 20/31
drop table if exists db_laba.dbo.TransactionHistory_01_mbelko;
CREATE TABLE db_laba.dbo.TransactionHistory_01_mbelko
 (  
   TransactionID int NOT NULL,   
   description varchar(255),
   created_ts datetime,
    UNIQUE(description,created_ts )   
);
--check
SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TransactionHistory_01_mbelko';

--check
SELECT name, type_desc, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.TransactionHistory_01_mbelko');

/* +------------------------------+
 * | Ограничение первичных ключей |
 * +------------------------------+
 */
--
--первичные ключи не могут позволять значений NULL.
--Это означает что, подобно полям в ограничении UNIQUE,
--любое поле, используемое в ограничении PRIMARY KEY, должно уже быть обьявлено NOT NULL.
/* +---------------------------------------+
 * | Первичные ключи более чем одного поля |
 * +---------------------------------------+
 */
--
-- 21/31
drop table if exists db_laba.dbo.Namefield_mbelko;
CREATE TABLE db_laba.dbo.Namefield_mbelko (firstname char (10) NOT NULL,
lastname char (10) NOT NULL,
city char (10),
PRIMARY KEY (firstname, lastname));

-- 22/31
insert into db_laba.dbo.Namefield_mbelko (firstname, lastname, city)
values ('max', 'belko', 'kyiv');
select * from db_laba.dbo.Namefield_mbelko;
--select LEN(lastname) from db_laba.dbo.Namefield_mbelko;

-- 23/31
insert into db_laba.dbo.Namefield_mbelko (firstname, lastname, city)
values ('max', 'belko1', 'kyiv');

-- err 
--Violation of PRIMARY KEY constraint 'PK__Namefiel__CD886A14A9A50504'.
--Cannot insert duplicate key in object 'dbo.Namefield_mbelko'.
--The duplicate key value is (max       , belko     ).
-- 24/31
insert into db_laba.dbo.Namefield_mbelko (firstname, lastname, city)
values ('max', 'belko', 'kyiv');


/* +------------------------------------------------------------------------+
 * | Использование CHECK, чтобы предопределять допустимое вводимое значение |
 * +------------------------------------------------------------------------+
 */
--
-- 25/31
drop table if exists db_laba.dbo.Salespeople_mbelko;
CREATE TABLE db_laba.dbo.Salespeople_mbelko 
(snum integer NOT NULL PRIMARY KEY,
sname char(10) NOT NULL UNIQUE,
city char(10),
comm decimal CHECK (comm < 1));
--err
--The INSERT statement conflicted with the CHECK constraint

-- 26/31
insert into db_laba.dbo.Salespeople_mbelko values (1,'test01', 'Paris', 0.2); 
insert into db_laba.dbo.Salespeople_mbelko values (2,'test02', 'Paris', 2); --comm should be less than 1

-- 27/31
drop table if exists db_laba.dbo.Salespeople_01_mbelko;
CREATE TABLE db_laba.dbo.Salespeople_01_mbelko 
(snum integer NOT NULL UNIQUE,
sname char(10) NOT NULL UNIQUE,
city char(10) CHECK (city IN ('London',
'New York',
'San Jose',
'Barselona')),
comm decimal CHECK (comm<1));

--err The INSERT statement conflicted with the CHECK constraint "CK__Salespeopl__city__0C50D423". T
-- 29/31
insert into db_laba.dbo.Salespeople_01_mbelko(snum,sname,city,comm) VALUES(1,'test02','Kyiv',0.2 );

/* +---------------------------------+
 * | Установка значений по умолчанию |
 * +---------------------------------+
 */
--
-- 30/31
drop table if exists db_laba.dbo.Salespeople_02_mbelko;
CREATE TABLE db_laba.dbo.Salespeople_02_mbelko (snum integer NOT NULL UNIQUE,
sname char(10) NOT NULL UNIQUE,
city char(10) DEFAULT  'New York',
comm decimal CHECK (comm < 1));

-- 31/31
insert
	into
	db_laba.dbo.Salespeople_02_mbelko
	(snum,
	sname,
	comm)
VALUES(1,
'test02',
0.2 );

select * from db_laba.dbo.Salespeople_02_mbelko;
