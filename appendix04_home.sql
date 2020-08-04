/*
4.3
вывести номер, статус и дату заказа (таблица orders), имя заказчика (таблица customers) и его телефон (таблица contacts),
имя ответственного менеджера и его телефон (таблица employees) (если нет данных по менеджеру заменить на 'N/A')
для сентября 2016 (примечание 01.09.2016 - 30.09.2016)
отсортировать по статусу и дате заказа (6 баллов)
*/
SELECT
	t1.order_id order_num ,
	t1.status order_status ,
	t1.order_date ,
	t2.name customer_name ,
	t3.phone customer_phone,
	COALESCE(t4.first_name + ' ' + LEFT(t4.last_name, 1)+ '.', 'N/A') sales_manager_name ,
	COALESCE(t4.phone, 'N/A') sales_manager_phone
FROM
	db_laba.dbo.orders t1 --select * from db_laba.dbo.orders
JOIN db_laba.dbo.customers t2 ON --select * from db_laba.dbo.customers
	t2.customer_id = t1.customer_id
JOIN db_laba.dbo.contacts t3 ON --select * from db_laba.dbo.contacts
	t3.customer_id = t2.customer_id
left JOIN db_laba.dbo.employees t4 ON --select * from db_laba.dbo.employees
	t4.employee_id = t1.salesman_id
WHERE
	t1.order_date BETWEEN '2016-09-01' AND '2016-09-30' --MONTH(t1.order_date)=9 AND YEAR(t1.order_date)=2016
ORDER BY t1.status,
	t1.order_date;

/*
5.4
вывести сумму маржи (примечание: сумма(quantity * list_price) - сума(quantity * standard_cost) ),
имя клиента и год заказа
сгруппировать по имени клиента и году заказа
для клиентов со средним количеством заказанных продуктов более чем среднее
значение заказанных продуктов в 2016 году
отсортировать на Ваше усмотрение (6 баллов)
*/
--v1 incorrect
SELECT
	(SUM(oi.quantity*p.list_price)-SUM(oi.quantity*p.standard_cost)) margin,
	cust.name,
	YEAR(o.order_date) order_year
FROM
	db_laba.dbo.orders o
JOIN db_laba.dbo.order_items oi ON
	oi.order_id = o.order_id
JOIN db_laba.dbo.products p ON
	oi.product_id = p.product_id
JOIN db_laba.dbo.customers cust ON
	o.customer_id = cust.customer_id
GROUP BY
	cust.name,
	YEAR(o.order_date)
HAVING
	AVG(oi.quantity)> (
	SELECT
		AVG(oi.quantity) avg_quant
	FROM
		db_laba.dbo.orders o
	JOIN db_laba.dbo.order_items oi ON
		oi.order_id = o.order_id
	WHERE
		YEAR(o.order_date)= 2016)
ORDER BY
	order_year ASC,
	margin DESC;

--v2 correct
SELECT
	(SUM(prod.list_price*oi.quantity)-SUM(oi.quantity*prod.standard_cost)) margin ,
	cust.name ,
	YEAR(ord.order_date) OrderYear
FROM
	db_laba.dbo.customers cust
INNER JOIN db_laba.dbo.orders ord ON
	ord.customer_id = cust.customer_id
INNER JOIN db_laba.dbo.order_items oi ON
	oi.order_id = ord.order_id
INNER JOIN db_laba.dbo.products prod ON
	prod.product_id = oi.product_id
WHERE
	cust.customer_id IN (
	SELECT
		ord.customer_id
	FROM
		db_laba.dbo.orders ord
	JOIN db_laba.dbo.order_items oi ON
		oi.order_id = ord.order_id
	GROUP BY
		ord.customer_id
	HAVING
		AVG(oi.quantity)> (
		SELECT
			AVG (oi.quantity)
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016) )
GROUP BY
	cust.name ,
	YEAR(ord.order_date)
ORDER BY
	2, 3, 1;



/*
7.4
Обновить колонку employees_test_student.email таким образом,
что бы остался только домен (пример sample@cool.com => cool.com)
для всех сотрудников длина фамилии которых до 5 символов
написать запрос для проверки
*/

UPDATE db_laba.dbo.employees_test_student
    SET email = SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email) - CHARINDEX('@', email))
    WHERE student_name = 'm.belko' AND LEN(last_name) <= 5;

--check
SELECT
	email,
	SUBSTRING(email, CHARINDEX('@', email)+ 1, LEN(email) - CHARINDEX('@', email))
FROM
	db_laba.dbo.employees_test_student t1
WHERE t1.student_name = 'm.belko' AND 
LEN(t1.last_name) <= 5;

	SELECT
	*
FROM
	db_laba.dbo.employees_test_student t1
WHERE t1.student_name = 'm.belko'


/*
8.4.
Создайте новую таблицу на основе таблицы из первого задания (со всеми колонками и 7ю строками на текущий момент)
сделайте колонку description с ограничением на длину не менее 3 символа и со значением по умолчанию N/A
напишите скрипт  для модификации таблицы
напишите проверочный скрипт демонстрирующий Ваше изменения используя словарь INFORMATION_SCHEMA.COLUMNS
напишите проверочный скрипт на содержание вашей новой таблицы (5 баллов)    
*/	
	DROP TABLE IF EXISTS db_laba.dbo.books_mbelko;
    CREATE TABLE db_laba.dbo.books_mbelko (
    book_id int,
    book_name nvarchar(100),
    book_author nvarchar(100),
    info nvarchar(255) NULL,
    date_create datetime,
    publishing_house nvarchar(100),
    publishing_date datetime);
   
    INSERT INTO db_laba.dbo.books_mbelko ( book_id,
    book_name,
    book_author,
    info,
    date_create,
    publishing_house,
    publishing_date)
    select 1, N'тест1', N'тест1', N'тест1', '2000-01-01', N'тест1', '2009-09-09' UNION 
    select 2, N'тест2', N'тест2', N'тест2', '2000-01-01', N'тест2', '2009-09-09' UNION 
    select 3, N'тест3', N'тест3', N'тест3', '2000-01-01', N'тест3', '2009-09-09'
    
    SELECT * from db_laba.dbo.books_mbelko
    
    ALTER TABLE db_laba.dbo.books_mbelko ADD description nchar(32);
   	
   INSERT INTO db_laba.dbo.books_mbelko ( book_id,
    book_name,
    book_author,
    info,
    date_create,
    publishing_house,
    publishing_date,
    description)
    select 4, N'тест4', N'тест4', N'тест4', '2000-01-01', N'тест4', '2009-09-09', N'тест4' UNION 
    select 5, N'тест5', N'тест5', N'тест5', '2000-01-01', N'тест5', '2009-09-09', N'тест5' UNION 
    select 6, N'тест6', N'тест6', N'тест6', '2000-01-01', N'тест6', '2009-09-09', N'тест6'
    
    SELECT * from db_laba.dbo.books_mbelko
    
    alter table db_laba.dbo.books_mbelko alter column description nvarchar(500)
    
   	INSERT INTO db_laba.dbo.books_mbelko ( book_id,
    book_name,
    book_author,
    info,
    date_create,
    publishing_house,
    publishing_date,
    description)
    select 7, N'тест4', N'тест4', N'тест4', '2000-01-01', N'тест4',
    '2009-09-09', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua' 
   
    
   
  	DROP TABLE IF EXISTS db_laba.dbo.books_mbelko_02;
   	CREATE TABLE db_laba.dbo.books_mbelko_02 (
    book_id int,
    book_name nvarchar(100),
    book_author nvarchar(100),
    info nvarchar(255) NULL,
    date_create datetime,
    publishing_house nvarchar(100),
    publishing_date datetime,
    description nvarchar(500) default 'N/A' check (len(description)>=3 ),
   ts datetime);

   
    insert
	into
	db_laba.dbo.books_mbelko_02
select
	book_id,
	book_name,
	book_author,
	info,
	date_create,
	publishing_house,
	publishing_date,
	--description,
	coalesce(description, 'N/A'),
	getdate()
from
	db_laba.dbo.books_mbelko

 select * from db_laba.dbo.books_mbelko_02
	
	
	
   
    insert
	into
	db_laba.dbo.books_mbelko_02(book_id,
	book_name,
	book_author,
	info,
	date_create,
	publishing_house,
	publishing_date,
	ts)
select
	book_id,
	book_name,
	book_author,
	info,
	date_create,
	publishing_house,
	publishing_date,
	getdate()
from
	db_laba.dbo.books_mbelko
