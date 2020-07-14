/*
 * ################################
 * #     Занятие 5                #
 * #     Запросы и подзапросы     #
 * ################################
 */

/* +------------------------+
 * | Как работает подзапрос |
 * +------------------------+
 */
-- вывести все заказы продавца по фамилии Ortiz
-- 1/18
 SELECT
	*
from
	db_laba.dbo.orders ord
where
	ord.salesman_id =
	 --employee_id = 61
(
	select --*
		emp.employee_id
		--, emp.email

		from db_laba.dbo.employees emp
	WHERE
		emp.last_name = 'Ortiz');

-- вывести все заказы
-- для продавца, который обслуживал компанию Progressive в 2017 году
-- отсортировать по убывнию даты заказа
-- 2/18
SELECT
	*
from
	db_laba.dbo.orders ord
where
	ord.salesman_id =
	-- salesman_id = 18
(
	SELECT
		--*
 ord0.salesman_id
	from
		db_laba.dbo.orders ord0
	inner join db_laba.dbo.customers cus on
		cus.customer_id = ord0.customer_id
	where
		cus.name = 'Progressive'
		and ord0.salesman_id is NOT NULL )
	and YEAR(ord.order_date) = 2017
order by
	ord.order_date desc;

/*
 * +------------------------------------------------+
 * | Предикаты с подзапросами являются необратимыми |
 * +------------------------------------------------+
 */
-- (ERROR ANSI) вывести все заказы продавца по фамилии Ortiz (не рекомендую так писать)
-- 3/18
 SELECT
	*
from
	db_laba.dbo.orders ord
where
	(
	select
		emp.employee_id
	from
		db_laba.dbo.employees emp
	WHERE
		emp.last_name = 'Ortiz') = ord.salesman_id;

/*
 * +------------------------------------------------+
 * | Использование агрегатных функций в подзапросах |
 * +------------------------------------------------+
 */
-- вывести номер заказа и его стоимость
-- 4/18
 select
	x.order_num,
	x.price
from
	(
	SELECT
		ordi.order_id order_num,
		SUM(ordi.unit_price * ordi.quantity) price
	from
		db_laba.dbo.order_items ordi
	GROUP BY
		ordi.order_id) x;

-- вывести все колоники таблицы заказов и их стоимость
-- для заказов 2-го квартала 2017
-- для продаж выше среднего значения за весь период (по всей таблице)
-- 5/18
SELECT
	o.order_id,
	o.customer_id,
	o.status,
	o.salesman_id,
	o.order_date,
	x.price_per_order
from
	db_laba.dbo.orders o
inner join (
	select
		x0.order_id,
		x0.price_per_order
	from
		(
		SELECT
			ordi.order_id,
			--max(ordi.order_id),
			SUM(ordi.unit_price * ordi.quantity) price_per_order
		from
			db_laba.dbo.order_items ordi
		GROUP BY
			ordi.order_id) as x0) as x on
	x.order_id = o.order_id
where
	x.price_per_order > (
	SELECT
		AVG(ordi.unit_price * ordi.quantity) avg_price
	from
		db_laba.dbo.order_items ordi)
	and o.order_date BETWEEN '2017-04-01' and '2017-06-30'
order by 6 desc;

-- вывести номер заказа и его стоимость, имя и web сайт компании, имя и телефон продавца, дату заказа и их стоимость
-- для заказов 2-го квартала 2017
-- для продаж выше среднего значения за весь период (по всей таблице)
-- 6/18
 SELECT
	o.order_id,
	--o.status,
	cus.name,
	cus.website,
	e.first_name,
	e.phone,
	o.order_date,
	x.price_per_order
from
	db_laba.dbo.orders o
inner join (
	select
		x0.order_id,
		x0.price_per_order
	from
		(
		SELECT
			ordi.order_id,
			SUM(ordi.unit_price * ordi.quantity) price_per_order
		from
			db_laba.dbo.order_items ordi
		GROUP BY
			ordi.order_id) x0 ) x on
	x.order_id = o.order_id
inner join db_laba.dbo.customers cus on
	cus.customer_id = o.customer_id
left join db_laba.dbo.employees e on
	e.employee_id = o.salesman_id
where
	x.price_per_order > (
	SELECT
		AVG(ordi.unit_price * ordi.quantity) avg_price
	from
		db_laba.dbo.order_items ordi)
	and o.order_date BETWEEN '2017-04-01' and '2017-06-30';

--2nd 
-- 7/18
SELECT
	o.order_id,
	--o.status,
 cus.name,
	cus.website,
	e.first_name,
	e.phone,
	o.order_date,
	SUM(oi.unit_price * oi.quantity) price_per_order
	--x.price_per_order
	from db_laba.dbo.orders o
inner join db_laba.dbo.order_items oi on
	oi.order_id = o.order_id
inner join db_laba.dbo.customers cus on
	cus.customer_id = o.customer_id
left join db_laba.dbo.employees e on
	e.employee_id = o.salesman_id
where
	o.order_date BETWEEN '2017-04-01' and '2017-06-30'
group by
	o.order_id,
	cus.name,
	cus.website,
	e.first_name,
	e.phone,
	o.order_date
having
	SUM(oi.unit_price * oi.quantity) > (
	SELECT
		AVG(ordi.unit_price * ordi.quantity) avg_price
	from
		db_laba.dbo.order_items ordi);
	
/*
 * +------------------------------------------------------------------------------+
 * | Использование подзапросов, которые выдают много строк с помощью оператора IN |
 * +------------------------------------------------------------------------------+
 */

-- вывести все заказы
-- для продавца, который обслуживал компанию Raytheon с 2017 году
-- отсортировать по убывнию даты заказа
-- 8/18
 SELECT
	*
from
	db_laba.dbo.orders ord
where
	ord.salesman_id IN --=
(
	SELECT
		ord0.salesman_id--, ord0.order_date
	from
		db_laba.dbo.orders ord0
	inner join db_laba.dbo.customers cus on
		cus.customer_id = ord0.customer_id
	where
		cus.name = 'Raytheon'
		and YEAR(ord0.order_date) >= 2017
		)
	--and YEAR(ord.order_date) >= 2017
order by
	ord.order_date desc;

/*
 * +---------------------------------------+
 * | Использование выражений в подзапросах |
 * +---------------------------------------+
 */
-- пример использования выражений в подзапросах
-- 9/18
SELECT
	*
from
	db_laba.dbo.orders ord
where
	ord.salesman_id in (
	select
		emp.employee_id -10--, emp.employee_id
	from
		db_laba.dbo.employees emp);

/*
 * +---------------------------------+
 * | Подзапросы в предложении having |
 * +---------------------------------+
 */

-- вывести количество клиентов и имя продавца
-- где количестов клиентов болле 20% от количестов клиентов для продавца за 2016 год
-- 10/18
SELECT
	COUNT(DISTINCT o.customer_id) as customer_amount,
	e.first_name
from
	db_laba.dbo.orders o
inner join db_laba.dbo.employees e on
--left join db_laba.dbo.employees e on
	e.employee_id = o.salesman_id
GROUP BY
	e.first_name
having
	COUNT(DISTINCT o.customer_id) > (
	SELECT
		COUNT(DISTINCT o.customer_id) * 0.2 as customer_amount_20/*,
		COUNT(DISTINCT o.customer_id),
		COUNT( o.customer_id)*/
	from
		db_laba.dbo.orders o
	where
		YEAR(o.order_date) = 2016 );
/*
10	Florence
12	Freya
10	Grace
 */
 /* +----------------------------------+
  * | как работает EXISTS и NOT EXISTS |
  * +----------------------------------+
  */
 --
 -- 11/18
  SELECT
 	*
 from
 	--db_laba.dbo.countries c
 	db_laba.dbo.customers
 where
 	EXISTS (
 	SELECT
 		*
 	from
 		db_laba.dbo.countries
 	where
 		country_name = 'France');

 -- NOT EXIST
 -- 12/18
  SELECT
 	*
 from
 	db_laba.dbo.countries c
 where
 	--EXISTS (
 	NOT EXISTS (
 	SELECT
 		*
 	from
 		db_laba.dbo.countries
 	where
 		country_name = 'France222');

 -- вывести заказчиков
 -- которых обслуживали 3 и более продавца
 -- 13/18
  select
 	*
 from
 	customers t0
 where
 	EXISTS (
 	SELECT
 		count(distinct t1.salesman_id),
 		t1.customer_id
 	from
 		db_laba.dbo.orders t1
 	where
 		t0.customer_id = t1.customer_id
 	GROUP by
 		t1.customer_id
 	having
 		count(distinct t1.salesman_id) >= 3);
 --check
 -- 14/18
 select
 	count(DISTINCT o.salesman_id),
 	o.customer_id
 from
 	db_laba.dbo.orders o
 group by
 	o.customer_id
 having
 	count(DISTINCT o.salesman_id) >= 3

 /* +-------------------+
  * | UNION и UNION ALL |
  * +-------------------+
  */
 -- вывести все заказы продавца по фамилии Ortiz
 -- ранжировать вывод по группам
 -- 15/18
  SELECT
 	t1.order_id,
 	SUM(t1.unit_price) price,
 	'0-5000'
 from
 	db_laba.dbo.order_items t1
 group by
 	t1.order_id
 HAVING
 	SUM(t1.unit_price) between 0 and 5000
 union all
 SELECT
 	t1.order_id,
 	SUM(t1.unit_price) price,
 	--1--
 	'5001-10000'
 	--,888
 from
 	db_laba.dbo.order_items t1
 group by
 	t1.order_id
 HAVING
 	SUM(t1.unit_price) between 5001 and 10000
 union all
 SELECT
 	t1.order_id,
 	SUM(t1.unit_price) price,
 	'10001+'
 from
 	db_laba.dbo.order_items t1
 group by
 	t1.order_id
 HAVING
 	SUM(t1.unit_price) > 10000
 order by
 	3,
 	2,
 	1;

 
 -- CASE
 -- 16/18
 SELECT x.order_id,
 	x.price,
 	case when  x.price < 5000 then '0-5000'
 	 when  x.price BETWEEN 5000 and 10000 then '5001-10000'
 	 when  x.price >  10000 then '10000+'
 	end
 	from (
  SELECT
 	t1.order_id,
 	SUM(t1.unit_price) price
 from
 	db_laba.dbo.order_items t1
 group by
 	t1.order_id) x
 	order by 3,2,1;
 
-- with
-- 17/18
 with sum_per_order as (
SELECT
	t1.order_id,
	SUM(t1.unit_price) price
from
	db_laba.dbo.order_items t1
group by
	t1.order_id)
select
	order_id,
	price,
	case
		when price < 5000 then '0-5000'
		when price BETWEEN 5000 and 10000 then '5001-10000'
		when price > 10000 then '10000+' end
	from
		sum_per_order
	order by
		3,
		2,
		1;

 --
 -- 18/18
  select
 	count(x.name)
 from
 	(
 	SELECT
 		--first_name name
 		last_name name
 	from
 		db_laba.dbo.employees
 UNION all
 --union
 	SELECT
 		last_name
 	from
 		db_laba.dbo.employees) x;
