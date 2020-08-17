/*1. Выведите все детали заказа и процент количества проданных продуктов от общего заказа для заказов 2016 года (5 баллов)*/

 select
	x.order_id ord_id,
	x.item_id item_id,
	x.quantity QTY,
	x.order_date ord_date, 
	--x.total TOTAL, --- просто для вывода общего TOTAL по заказу. Для самопроверки использовал
	x.percentage_of_total_qty percentage_of_total_qty
from
	(
	select
		oi.order_id,
		oi.item_id,
		o.order_date,
		oi.quantity,
	--SUM(oi.quantity)
		--OVER(PARTITION BY oi.order_id) AS total ,  --- аналогично строке 8 кода
		CAST(oi.quantity /
		     SUM(oi.quantity)
		     	OVER(PARTITION BY oi.order_id) * 100 AS DECIMAL(5,2)) AS percentage_of_total_qty
	from
		db_laba.dbo.order_items oi
	join db_laba.dbo.orders o on
		oi.order_id = o.order_id
		and YEAR(o.order_date) = 2016
		) x
order by
	4,
	1,
	5;

/*ниже два небольших запроса на самопроверку. 
1-ый на примере заказа 103 (правильно ли отразились item_id, quantity)

select *
     from
		db_laba.dbo.order_items oi 
		where oi.order_id = 103

2-ой на проверку количества строк (294 как и в основном запросе)

select o.order_id,
       oi.item_id
	from
		db_laba.dbo.orders o 
		inner join db_laba.dbo.order_items oi on
		o.order_id = oi.order_id
		where o.order_date BETWEEN '2016-01-01' AND '2016-12-31'
		*/


/*2. Выведите 5 первых четных продавцов (примечание: 2, 4, 6, 8 и 10) сортируя по количеству проданных продуктов за все время, но только четные места  (5 баллов)*/

select
	y.first_name sales_name,
	y.last_name sales_surname,
	y.phone sales_phone,
	y.total_qty,
	y.row_num
from
	(
	select
		x.first_name,
		x.last_name,
		x.phone,
		x.total_qty,
		row_number () over (order by x.total_qty desc) as row_num -- так рейтингуем от лучшего к худшему
	from
		(
		select
			e.first_name, e.last_name, e.phone, sum (oi.quantity) total_qty
		from
			db_laba.dbo.order_items oi
		join db_laba.dbo.orders o on
			o.order_id = oi.order_id
		join db_laba.dbo.employees e on
			e.employee_id = o.salesman_id
		group by
			e.first_name, e.last_name, e.phone) x) y
where
	y.row_num <= 10  -- оставляем строки исходя из условия
	and y.row_num % 2 = 0; -- воспользовался Вашей подсказкой с лекции по поводу деления на 2. Нашел такой вариант в сети Интернет. Здесь "% 2 = 0" значит, чтобы число в строки row_num делилось на 2 без остатка.

	/* Данные запрос проверяет, сколько продавцов имеют данные по общему кол-ву продаж. Видим, что только 9 человек. 
	Т.е. исходя из условия задачи, 10-го продавца тут нет, а результат должен содержать  данные только по 2,4,6,8.
	select
			e.first_name, e.last_name, e.phone, sum(oi.quantity) as total_qty
		from
			db_laba.dbo.order_items oi
		join db_laba.dbo.orders o on
			o.order_id = oi.order_id
		left join db_laba.dbo.employees e on
			e.employee_id = o.salesman_id
			group by
			e.first_name, e.last_name, e.phone
		*/


/* 3. Выведите ID заказчика, дату заказа, ID заказа и стоимость заказа, а так же стоимость предыдущего заказа со смещением в 3 строки (подсказка: LAG с аргументом) (5 баллов) */

 SELECT
	o.customer_id cust_id,
	o.order_date ord_date,
	o.order_id ord_id,
	o2.price ord_price,
	LAG(o2.price,3,0) OVER(PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS prevVal_offset3 
	/*в доке (https://docs.microsoft.com/en-us/sql/t-sql/functions/lag-transact-sql?view=sql-server-ver15) прочитал, что LAG имеет три параметра. Два последних необязательны: 1) шаг/сдвиг (примечание: не может быть отрицательным); 2)значение по умолчанию (т.е., если NULL возвращается)
	По умолчанию в LAG второй параметр равен 1, т.е. смещение на 1 строку. Собственно, надо подставить 3. В третий параметр прописал 0, т.к. NULL немного режет глаз (но это уже кому как. В условии просто не было)
	*/
FROM
	db_laba.dbo.orders o
join (
	select
		sum(oi.unit_price * oi.quantity) price,
		oi.order_id
	from
		db_laba.dbo.order_items oi
	group by
		oi.order_id) o2 on
	o.order_id = o2.order_id


/* 4.Сформулируйте требования для запроса (5 баллов)

Вывести id клиента, дату, id и стоимость заказа, а также: 
1) разницу между стоимостью текущего заказа и стоимостью первого заказа клиента; 
2) разницу между стоимостью текущего заказа и стоимостью последнего заказа клиента*/

SELECT
o.customer_id,
o.order_date,
o.order_id,
o2.price,
o2.price - FIRST_VALUE(o2.price) 
OVER(PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id) AS val_firstorder,
o2.price - LAST_VALUE(o2.price) 
OVER(PARTITION BY o.customer_id ORDER BY o.order_date, o.order_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS val_lastorder
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

/*Примечание: 
Если в запросе закомментировать часть строки с расчётом разницы и просто вывести первое и последнее значение, то увидим, что FIRST и LAST VALUE берутся по дате заказа клиента. Исходя из этого, ручным методом можно проверить правильный ли понят вывод в столбцах val_firstorder и val_lastorder.
Попробовал покопать глубже здесь. Из найденного на просторах Интернета: в фунцкях FIRST_VALUE и LAST_VALUE смещение указывается не относительно текущей строки, а относительно массива (его начала и конца). 
"ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING" из запроса обозначает, что первая строка в окне изменяется с изменением текущей строки и границы чётко заданы.
Если оставить по умолчанию (т.е. убрать параметр), то в столбце val_lastorder просто продублируется price, т.к. текущая строка будет здесь последней.
Тут, конечно, надо еще глубже погружаться. Но ответ по этой задаче найден.
*/

