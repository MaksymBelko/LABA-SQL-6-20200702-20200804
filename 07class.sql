/*
 * #########################################
 * #     Занятие 7                         #
 * #     Команды модификации языка DML     #
 * #########################################
 */
-- test table db_laba.dbo.employees_test_student 

/* +------------------------+
 * | Ввод значений (INSERT) |
 * +------------------------+
 */
--check before insert new row
SELECT * from db_laba.dbo.employees_test_student t
where t.student_name = 'm.belko';

-- 1/22
INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
VALUES(0,
'Иван',
'Иванов',
'test@mail.com',
'111-222-333',
CAST('2015-12-23' as date),
null,
'CEO',
'm.belko');

/* +-----------+
 * | COMMIT;   |
 * | ROLLBACK; |
 * +-----------+
 */

--COMMIT;
--ROLLBACK;
SELECT * from db_laba.dbo.employees_test_student t
where t.student_name = 'm.belko';

-- 2/22
delete from
	db_laba.dbo.employees_test_student
WHERE
	employee_id = 0 and student_name = 'm.belko';

INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
VALUES(0,
N'Иван',
N'Иванов',
'test@mail.com',
'111-222-333',
CAST('2015-12-23' as date),
null,
'CEO',
'm.belko');

SELECT
	*
from
	db_laba.dbo.employees_test_student
where
	employee_id = 0
	and first_name like N'И%' and student_name = 'm.belko';

SELECT
	*
from
	db_laba.dbo.employees_test_student
where
	employee_id = 0
	and first_name like N'и%'
 and student_name = 'm.belko';
-- без перечисления имен колонок

-- 3/22
INSERT
	INTO
	db_laba.dbo.employees_test_student
VALUES(1,
N'Сергей',
N'Круглов',
'test2@mail.com',
'1-333-333',
CAST('2016-10-15' as date),
0,
'CFO',
'm.belko');


SELECT
	*
from
	db_laba.dbo.employees_test_student;

--err There are more columns in the INSERT statement than values specified in the VALUES clause.
--The number of values in the VALUES clause must match the number of columns specified in the INSERT statement.
-- 4/22
 INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,--
	job_title,
	student_name)--
VALUES(0,
N'Иван',
N'Иванов',
'test@mail.com',
'111-222-333',
CAST('2015-12-23' as date),
null,
'm.belko');

--err Violation of PRIMARY KEY constraint 'PK_employee_test'.
--Cannot insert duplicate key in object 'dbo.employees_test_student'. The duplicate key value is (0).
-- 5/22
 INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
VALUES(0,
N'Иван',
N'Иванов',
'test@mail.com',
'111-222-333',
CAST('2015-12-23' as date),
null,
'CEO',
'm.belko');

--err Conversion failed when converting date and/or time from character string.
-- 6/22
 INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
VALUES(2,
N'Иван',
N'Иванов',
'test@mail.com',
'111-222-333',
'wwwww',
null,
'CEO',
'm.belko');

--
-- 7/22
 INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date, 
	student_name)
VALUES(4,
N'Дмитрий',
N'Сергеев',
'test3@mail.com',
'333-00-312',
CAST('2019-11-01' as date),
'm.belko');

--err Cannot insert the value NULL into column 'student_name'
-- 8/22
 INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date)--, 	student_name)
VALUES(5,
N'Дмитрий',
N'Сергеев',
'test3@mail.com',
'333-00-312',
CAST('2019-11-01' as date))--,
--'m.belko');
--
 SELECT
	*
from
	db_laba.dbo.employees_test_student;

/* +-----------------------------+
 * | Вставка результатов запроса |
 * +-----------------------------+
 */
-- 9/22
INSERT
	into
	db_laba.dbo.employees_test_student
SELECT
	*, 'm.belko'
from
	db_laba.dbo.employees e
where
	e.employee_id BETWEEN 11 and 20 ;
--
select
	*
from
	db_laba.dbo.employees_test_student;

-- 10/22
INSERT
	into
	db_laba.dbo.employees_test_student(employee_id,
	first_name,
	last_name,
	student_name)
SELECT
	e.employee_id,
	e.first_name,
	e.last_name,
	'm.belko'
from
	db_laba.dbo.employees e
where
	e.employee_id BETWEEN 31 and 40;

select
	*
from
	db_laba.dbo.employees_test_student;

--err The select list for the INSERT statement contains more items than the insert list.
--The number of SELECT values must match the number of INSERT columns.
-- 11/22
 INSERT
	into
	db_laba.dbo.employees_test_student(employee_id,
	first_name,
	last_name)
SELECT
	e.employee_id,
	e.first_name naaaaa,
	e.last_name,
	e.hire_date
from
	db_laba.dbo.employees e
where
	e.employee_id BETWEEN 31 and 40 ;

/* +----------------------------------+
 * | Изменение значений поля (UPDATE) |
 * +----------------------------------+
 */
-- 12/22
update
	db_laba.dbo.employees_test_student
set
	phone = '111111111'
	--SELECT * from db_laba.dbo.employees_test_student
where student_name = 'm.belko';

-- 13/22
update
	db_laba.dbo.employees_test_student
set
	job_title = 'Programmer'
WHERE
	job_title is null and student_name = 'm.belko';

select
	*
from
	db_laba.dbo.employees_test_student;

/* +------------------------------------+
 * | Команда update для многих столбцов |
 * +------------------------------------+
 */
-- 14/22
update
	db_laba.dbo.employees_test_student
set
	job_title = 'Programmer2' ,
	phone = 333333 -- произошло автопреобразование из числа в текст
WHERE
	job_title = 'Programmer'
and student_name = 'm.belko';
--
-- 15/22
update
	db_laba.dbo.employees_test_student
set
	job_title = job_title + '_new',--'fkjghdfkjghkf'
	phone = SUBSTRING(phone, 1, 3) + '-' + SUBSTRING(phone, 4, 99) --99 length(phone)
where  student_name = 'm.belko';
--
 select
	*
from
	db_laba.dbo.employees_test_student;
--
-- 16/22
update
	db_laba.dbo.employees_test_student
set
	job_title = REPLACE(job_title, '_new', '')
where  student_name = 'm.belko';

/* +------------------------------------+
 * | Использование подзапросов с INSERT |
 * +------------------------------------+
 */
-- 17/22
INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
SELECT
	t.employee_id + 100,
	t.first_name, 
t.last_name,
	t.email,
	t.phone,
	t.hire_date,
	t.manager_id,
	t.job_title,
	'm.belko'
from
	db_laba.dbo.employees_test_student t
UNION
SELECT
	e.employee_id + 1000,
	N'тест',
	N'тест',
	e.email,
	e.phone,
	e.hire_date,
	e.manager_id,
	e.job_title,
	'm.belko'
from
	db_laba.dbo.employees_test_student e
where
	e.phone in (
	select
		i.phone
	from
		db_laba.dbo.employees_test_student i
	where
		i.manager_id = 15);
--
select
	*
from
	db_laba.dbo.employees_test_student;

/* +------------------------------------+
 * | Использование подзапросов с DELETE |
 * +------------------------------------+
 */
-- 18/22
delete
from
	db_laba.dbo.employees_test_student
where
	employee_id in (
	select
		t.employee_id--, *
	from
		db_laba.dbo.employees_test_student t
	where
		(t.hire_date < CAST ('2016-06-30' as date) and t.job_title <> 'CEO' )
		or t.job_title = 'Accountant'
    	and student_name = 'm.belko'
) ;

--
 select
	*
from
	db_laba.dbo.employees_test_student;

/* +------------------------------------+
 * | Использование подзапросов с UPDATE |
 * +------------------------------------+
 */
SELECT getdate()
--
-- 19/22
 update
	db_laba.dbo.employees_test_student
set
	hire_date = getdate()
	--select * from db_laba.dbo.employees_test_student
where
	employee_id not in (
	SELECT
		--salesman_id
		COALESCE(salesman_id, -1)
	from
		db_laba.dbo.orders)
	and hire_date is null
and student_name = 'm.belko';

/* +-----------------------------------+
 * | Использование подзапросов с MERGE |
 * +-----------------------------------+
 */
/*
MERGE <target_table> [AS TARGET]
USING <table_source> [AS SOURCE]
ON <search_condition>
[WHEN MATCHED
   THEN <merge_matched> ]
[WHEN NOT MATCHED [BY TARGET]
   THEN <merge_not_matched> ]
[WHEN NOT MATCHED BY SOURCE
   THEN <merge_matched> ];
*/
--target table db_laba.dbo.products_test_sudent;
SELECT * FROM db_laba.dbo.products_test_sudent; 
delete from db_laba.dbo.products_test_sudent;
--20/22
INSERT
	INTO
	db_laba.dbo.products_test_sudent
VALUES (1, 'Tea', 10.00, getdate(), 'm.belko'),
	   (2, 'Coffee', 20.00, getdate(), 'm.belko'),
	   (3, 'Muffin', 30.00, getdate(), 'm.belko'),
	   (4, 'Biscuit', 40.00, getdate(), 'm.belko');

SELECT * FROM db_laba.dbo.updated_products_test_sudent; 
delete from db_laba.dbo.updated_products_test_sudent;
--Insert records into source table
-- 21/22
 INSERT
	INTO
	db_laba.dbo.updated_products_test_sudent
VALUES (1,'Tea',10.00, getdate(), 'm.belko'),
(2,'Coffee',25.00, getdate(), 'm.belko'),
(3,'Muffin',35.00, getdate(), 'm.belko'),
(5,'Pizza',60.00, getdate(), 'm.belko');

SELECT * FROM db_laba.dbo.products_test_sudent;
SELECT * FROM db_laba.dbo.updated_products_test_sudent;
--
-- 22/22
 MERGE db_laba.dbo.products_test_sudent AS TARGET
	USING db_laba.dbo.updated_products_test_sudent AS SOURCE ON
(TARGET.ProductID = SOURCE.ProductID)
WHEN MATCHED
AND TARGET.ProductName <> SOURCE.ProductName
OR TARGET.Rate <> SOURCE.Rate THEN
UPDATE
SET
	TARGET.ProductName = SOURCE.ProductName,
	TARGET.Rate = SOURCE.Rate,
	TARGET.student_name = SOURCE.student_name,
	TARGET.updated_ts = getdate()
WHEN NOT MATCHED BY TARGET THEN
INSERT
	(ProductID,
	ProductName,
	Rate,
	updated_ts,
	student_name)
VALUES (SOURCE.ProductID,
SOURCE.ProductName,
SOURCE.Rate,
getdate(),
source.student_name);

SELECT * FROM db_laba.dbo.products_test_sudent;
SELECT * FROM db_laba.dbo.updated_products_test_sudent;

ALTER TABLE db_laba.dbo.employees_test_student DROP CONSTRAINT PK_employee_test_student;

