/*
 * #############################
 * #     Занятие 6             #
 * #     Функции аналитики     #
 * #############################
 */
--oracle : 			https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions004.htm#SQLRF06174
--ms sql server :	https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql?view=sql-server-2017
/* +---------------------------+
 * | SUM, AVG, MAX, MIN, COUNT |
 * +---------------------------+
 */
-- вывести все детали заказа, используя оконные функции
-- сумму, среднее, к-во, мин и макс значения в разрезе атрибутов деталей заказа
-- 1/8
 select
	o.order_id
	,o.item_id
	,o.quantity
	--* o.unit_price price
	--,SUM(o.quantity) SUM_QTY
	--,SUM(o.quantity) OVER(PARTITION BY o.order_id) AS Total
	--,SUM(o.quantity) OVER(PARTITION BY o.order_id ORDER BY o.item_id) AS Total2
	,AVG(o.quantity)
		OVER(PARTITION BY o.order_id) AS "Avg"
	,AVG(o.quantity) OVER(PARTITION BY o.order_id ORDER BY o.item_id desc) AS "Avg2"
	--,COUNT(o.quantity) OVER(PARTITION BY o.order_id) AS "Count"
	--,COUNT(o.quantity) OVER(PARTITION BY o.order_id ORDER BY o.item_id desc) AS "Count2"
	--,MIN(o.quantity) OVER(PARTITION BY o.order_id) AS "Min"
	--,MIN(o.quantity) OVER(PARTITION BY o.order_id ORDER BY o.item_id desc) AS "Min2"
	--,MAX(o.quantity) OVER(PARTITION BY o.order_id) AS "Max"
	--,MAX(o.quantity) OVER(PARTITION BY o.order_id ORDER BY o.item_id desc) AS "Max2"
from
	db_laba.dbo.order_items o
	where o.order_id in (1, 2)
--group by o.order_id,o.quantity
--ORDER BY 1,2--,o.unit_price
--,o.quantity, o.unit_price
	--,o.item_id,o.quantity, o.unit_price
	;

-- вывести все детали заказа и процент стоимости от общего заказа
-- для заказоа 4 года газад
-- отсортировать по дате заказа, номеру заказа и по проценту
--SELECT YEAR(GETDATE()) -4
-- 2/8
 select
	x.order_id,
	x.item_id,
	x.quantity,
	x.unit_price,
	x.Total,
	x.order_date,
	x.rotation_by_item
from
	(
	select
		o.order_id,
		o.item_id,
		o0.order_date,
		o.quantity,
		o.unit_price,
		o.quantity * o.unit_price price_per_line,
		SUM(o.unit_price * o.quantity)
				OVER(PARTITION BY o.order_id ORDER BY o.quantity desc) AS Total ,
		CAST(o.unit_price * o.quantity /
		     SUM(o.unit_price * o.quantity)
		     	OVER(PARTITION BY o.order_id) * 100 AS DECIMAL(5,2)) AS rotation_by_item
	from
		db_laba.dbo.order_items o
	inner join db_laba.dbo.orders o0 on
		o.order_id = o0.order_id
		and YEAR(o0.order_date) = YEAR(GETDATE()) -4
		--AND o0.order_date BETWEEN '2015-01-01' AND '2015-12-31'
		--order by 1, 8
		) x
order by
	x.order_date,
	x.order_id,
	x.rotation_by_item;

/* +-------------------------------------+
 * | ROW_NUMBER, RANK, DENSE_RANK, NTILE |
 * +-------------------------------------+
 */
-- 3/8
select
	x.sold,
	x.order_date,
	x.first_name,
	x.last_name,
	x.phone ,
	ROW_NUMBER() OVER (ORDER BY x.sold desc, x.order_date) AS Row_Num ,
	NTILE(4) OVER (ORDER BY x.sold desc) AS Quartile
from
	(
	select
		sum(o.unit_price * o.quantity) sold,
		o0.order_date,
		e.first_name,
		e.last_name,
		e.phone
	from
		db_laba.dbo.order_items o
	inner join db_laba.dbo.orders o0 on
		o.order_id = o0.order_id
	inner join db_laba.dbo.employees e on
		e.employee_id = o0.salesman_id
	where
		year(o0.order_date) = 2017
		and o0.salesman_id is not null
	GROUP BY
		o0.order_date,
		e.first_name,
		e.last_name,
		e.phone) x;

-- вывести топ 5 продавцов за 2016 год
-- 4/8
 select
	y.sold,
	--y.order_date,
    y.first_name,
	y.last_name,
	y.phone ,
	y.row_num
from
	(
	select
		x.sold,
		x.order_date,
		x.first_name,
		x.last_name,
		x.phone ,
		ROW_NUMBER() OVER (ORDER BY x.sold desc) AS row_num
	from
		(
		select
			sum(o.unit_price * o.quantity) sold,
			o0.order_date,
			e.first_name,
			e.last_name,
			e.phone
		from
			db_laba.dbo.order_items o
		inner join db_laba.dbo.orders o0 on
			o.order_id = o0.order_id
		inner join db_laba.dbo.employees e on
			e.employee_id = o0.salesman_id
		where
			year(o0.order_date) = 2016
			and o0.salesman_id is not null
		GROUP BY
			o0.order_date,
			e.first_name,
			e.last_name,
			e.phone) x) y
where
	y.row_num <= 5;

-- написать запрос для вывода рейтинга клиентов по кредитному лимиту
-- для лимитов не болле 500
-- 5/8
 select
	c.name,
	c.credit_limit,
	ROW_NUMBER() OVER (ORDER BY c.credit_limit, c.name) AS row_num,
	RANK() OVER (ORDER BY c.credit_limit) AS Rank ,
	DENSE_RANK() OVER (ORDER BY c.credit_limit) AS DENSE_RANK
from
	db_laba.dbo.customers c
where
	c.credit_limit <= 500;

/* +------------------------------------+
 * | LEAD, LAG, FIRST_VALUE, LAST_VALUE |
 * +------------------------------------+
 */

-- вывести id заказчика, дату, id и стоимость заказа, а так же стоимость пердидущего и следующего зкаказа
-- для клиентов у который в имени 2я буква 'o' (латинская буква)
-- 6/8
 SELECT
	o.customer_id,
	o.order_date,
	o.order_id,
	o2.price,
	LAG(o2.price) OVER(PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS prevVal,
	LEAD(o2.price) OVER(PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS nextVal
FROM
	db_laba.dbo.orders o
inner join (
	select
		sum(oi.unit_price * oi.quantity) price,
		oi.order_id
	from
		db_laba.dbo.order_items oi
	group by
		oi.order_id) o2 on
	o.order_id = o2.order_id
WHERE
	o.customer_id in (
	SELECT
		c.customer_id
	from
		db_laba.dbo.customers c
	where
		c.name like '_o%');

-- FIRST_VALUE
-- LAST_VALUE
-- 7/8
 SELECT
	o.customer_id,
	o.order_date,
	o.order_id,
	o2.price,
	FIRST_VALUE(o2.price)
		OVER (PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS val_firstorder,
	LAST_VALUE(o2.price)
		OVER (PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id
			ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS val_lastorder
FROM
	db_laba.dbo.orders o
inner join (
	select
		sum(oi.unit_price * oi.quantity) price,
		oi.order_id
	from
		db_laba.dbo.order_items oi
	group by
		oi.order_id) o2 on
	o.order_id = o2.order_id;


/* +-----------------------------------------------------------+
 * | CUME_DIST, PERCENT_RANK, PERCENTILE_CONT, PERCENTILE_DISC |
 * +-----------------------------------------------------------+
 */
--https://docs.microsoft.com/ru-ru/sql/t-sql/functions/analytic-functions-transact-sql?view=sql-server-2017
--PERCENT_RANK
--Вычисляет относительный ранг строки из группы строк в SQL Server 2017.
--Для вычисления относительного положения значения в секции или результирующем наборе запроса
--используется функция PERCENT_RANK

--CUME_DIST
--Для SQL Server эта функция вычисляет интегральное распределение значений в группе значений
-- 8/8
SELECT
	x.order_id,
	x.FullName,
	x.price,
	PERCENT_RANK() OVER(PARTITION BY x.FullName ORDER BY x.price desc) AS percentrank,
	CUME_DIST() OVER(PARTITION BY x.FullName ORDER BY x.price desc) AS cumedist
from
	(
	select
		o.order_id,
		COALESCE(e.first_name + ' ' + e.last_name, 'N/A') as FullName,
		SUM(oi.unit_price * oi.quantity) price
	from
		db_laba.dbo.order_items oi
	inner join db_laba.dbo.orders o on
		oi.order_id = o.order_id
	left join db_laba.dbo.employees e on
		e.employee_id = o.salesman_id
	GROUP BY
		o.order_id,
		e.first_name + ' ' + e.last_name) x;
