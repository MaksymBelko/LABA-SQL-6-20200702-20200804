/*
 * ########################################
 * #     Занятие 9                        #  
 * #     Поддержка целостности данных     #
 * ########################################
 */
--
/* +-------------------------+
 * | Ограничение FOREIGN KEY |
 * +-------------------------+
 */
﻿
DROP TABLE IF EXISTS db_laba.dbo.regions_01_mbelko;
DROP TABLE IF EXISTS db_laba.dbo.regions_02_mbelko;
DROP TABLE IF EXISTS db_laba.dbo.countries_01_mbelko;
DROP TABLE IF EXISTS db_laba.dbo.countries_02_mbelko;


--
-- 1/25
DROP TABLE IF EXISTS db_laba.dbo.regions_01_mbelko;

CREATE TABLE db_laba.dbo.regions_01_mbelko 
( region_id int NOT NULL,
region_name VARCHAR(50) NOT NULL,
CONSTRAINT PK_regions_01_mbelko_region_id PRIMARY KEY (region_id) );

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'regions_01_mbelko');

-- 2/25
delete
from
	db_laba.dbo.regions_01_mbelko;

Insert
	into
	db_laba.dbo.regions_01_mbelko
select
	*
from
	db_laba.dbo.regions;

SELECT
	*
from
	db_laba.dbo.regions_01_mbelko;

-- 3/25
DROP TABLE IF EXISTS db_laba.dbo.countries_01_mbelko;

CREATE TABLE db_laba.dbo.countries_01_mbelko 
( country_id CHAR(2) PRIMARY KEY ,
country_name VARCHAR(40) NOT NULL,
region_id int ,
CONSTRAINT fk_countries_regions_01_mbelko FOREIGN KEY(region_id) 
REFERENCES db_laba.dbo.regions_01_mbelko(region_id) );

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'countries_01_mbelko');

-- 4/25
delete
from
	db_laba.dbo.countries_01_mbelko;

Insert
	into
	db_laba.dbo.countries_01_mbelko
select
	*
from
	db_laba.dbo.countries;

SELECT
	*
from
	db_laba.dbo.countries_01_mbelko;

﻿
--
/* +-----------------------------------------------------+
 * | Внешний ключ как ограничение таблицы и/или столбцов |
 * +-----------------------------------------------------+
 */
--err The INSERT statement conflicted with the FOREIGN KEY constraint 
-- 5/25
 Insert
	into
	db_laba.dbo.countries_01_mbelko
	(COUNTRY_ID,
	COUNTRY_NAME,
	REGION_ID)
values 
('UA',
'Ukraine',
9);


-- 6/25
 Insert
	into
	db_laba.dbo.countries_01_mbelko (COUNTRY_ID,
	COUNTRY_NAME,
	REGION_ID)
values ('UA',
'Ukraine',
2);

SELECT * FROM db_laba.dbo.countries_01_mbelko WHERE COUNTRY_ID = 'UA'

-- err The DELETE statement conflicted with the REFERENCE constraint 
-- 7/25
 delete
from
	db_laba.dbo.regions_01_mbelko
where
	region_id = 1;

﻿--err DROP TABLE IF EXISTS db_laba.dbo.regions_01_mbelko;
-- 8/25
DROP TABLE IF EXISTS db_laba.dbo.regions_01_mbelko;

﻿--
/* +----------------------------+
 * | Включение описаний таблицы |
 * +----------------------------+
 */
--https://www.techonthenet.com/sql_server/foreign_keys/foreign_delete.php
-- 9/25
DROP TABLE IF EXISTS db_laba.dbo.regions_02_mbelko;

CREATE TABLE db_laba.dbo.regions_02_mbelko 
( region_id int NOT NULL,
region_name VARCHAR(50) NOT NULL,
CONSTRAINT PK_regions_02_mbelko_region_id PRIMARY KEY (region_id) );

-- 10/25
delete
from
	db_laba.dbo.regions_02_mbelko;

Insert
	into
	db_laba.dbo.regions_02_mbelko
select
	*
from
	db_laba.dbo.regions;

SELECT
	*
from
	db_laba.dbo.regions_02_mbelko;

-- 11/25
DROP TABLE IF EXISTS db_laba.dbo.countries_02_mbelko;

CREATE TABLE db_laba.dbo.countries_02_mbelko 
( country_id CHAR(2) PRIMARY KEY ,
country_name VARCHAR(40) NOT NULL,
region_id int ,
CONSTRAINT fk_countries_regions_02_mbelko FOREIGN KEY(region_id)
REFERENCES db_laba.dbo.regions_02_mbelko(region_id) ON
DELETE --UPDATE
	CASCADE );

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'countries_02_mbelko');

-- 12/25
delete
from
	db_laba.dbo.countries_02_mbelko;

Insert
	into
	db_laba.dbo.countries_02_mbelko
select
	*
from
	db_laba.dbo.countries;

SELECT
	*
from
	db_laba.dbo.countries_02_mbelko;-- where region_id = 3;

select *  from db_laba.dbo.countries_02_mbelko where country_name = 'Australia';

-- 13/25
DELETE from db_laba.dbo.countries_02_mbelko where country_name = 'Australia';
select *  from db_laba.dbo.countries_02_mbelko where country_name = 'Australia';

SELECT
	*
from
	db_laba.dbo.regions_02_mbelko;

-- 14/25
delete
from
	db_laba.dbo.regions_02_mbelko where region_id = 3;
--
/* +--------------------------------------------------------------------+
 * | Внешние ключи, которые ссылаются обратно к их подчиненным таблицам |
 * +--------------------------------------------------------------------+
 */

-- 15/25
DROP TABLE IF EXISTS db_laba.dbo.employees_03_mbelko;

CREATE TABLE db_laba.dbo.employees_03_mbelko (
	employee_id int NOT NULL,
	first_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	last_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	phone varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	hire_date date NOT NULL,
	manager_id int NULL,
	job_title varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_employees_03_mbelko PRIMARY KEY (employee_id),
	CONSTRAINT fk_employees_03_mbelko_employees_manager FOREIGN KEY (manager_id) 
	REFERENCES db_laba.dbo.employees_03_mbelko(employee_id)
);

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'employees_03_mbelko');

-- 16/25
insert into db_laba.dbo.employees_03_mbelko 
select * from db_laba.dbo.employees;

-- 17/25
INSERT INTO db_laba.dbo.employees_03_mbelko
(employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title)
VALUES(999, 'test', 'test', 'test', 'test', getdate(), 1, 'test');

select * from db_laba.dbo.employees_03_mbelko where employee_id between 1 and 10 or employee_id = 1000;

-- 18/25
select min(employee_id) from db_laba.dbo.employees_03_mbelko

-- 19/25
INSERT INTO db_laba.dbo.employees_03_mbelko
(employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title)
VALUES(1000, 'test', 'test', 'test', 'test', getdate(), (select min(employee_id) from db_laba.dbo.employees_03_mbelko), 'test');

--err INSERT INTO db_laba.dbo.employees_03_mbelko
-- 20/25
INSERT INTO db_laba.dbo.employees_03_mbelko
(employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title)
VALUES(1001, 'test', 'test', 'test', 'test', getdate(), (select min(employee_id) -1 from db_laba.dbo.employees_03_mbelko), 'test');

--err INSERT INTO db_laba.dbo.employees_03_mbelko
-- 21/25
INSERT INTO db_laba.dbo.employees_03_mbelko
(employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title)
VALUES(1002, 'test', 'test', 'test', 'test', getdate(), 0, 'test');

﻿--
/* +--------------------------+
 * | Что такое представление? |
 * +--------------------------+
 */
﻿--https://docs.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15
-- 22/25
CREATE VIEW dbo.customers_ny
AS  
SELECT *  
from db_laba.dbo.customers
where RIGHT(address, 2) = 'NY';

select * from dbo.customers_ny;

--
/* +-------------------------------+
 * | Модифицирование представлений |
 * +-------------------------------+
 */
-- 23/25
ALTER VIEW dbo.customers_ny
AS  
SELECT customer_id, name--*  
from db_laba.dbo.customers
where RIGHT(address, 2) = 'NY' and credit_limit >= 1500;
--
/* +-----------------------------------+
 * | Что не могут делать представления |
 * +-----------------------------------+
 */
--﻿УПОРЯДОЧЕНИЕ ПО (ORDER BY) 
-- 24/25
create VIEW dbo.customers_ny2
AS  
SELECT customer_id, name
from db_laba.dbo.customers
where RIGHT(address, 2) = 'NY'
order by name;


select * from customers_ny_mi;
select * from dbo.customers_ny order by name;

--
/* +------------------------+
 * | Удаление представлений |
 * +------------------------+
 */
﻿-- 25/25
DROP VIEW  IF EXISTS dbo.customers_ny;  
DROP VIEW  IF EXISTS dbo.customers_ny2;  
--

