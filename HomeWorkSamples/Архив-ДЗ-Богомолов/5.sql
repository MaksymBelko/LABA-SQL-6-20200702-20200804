/* 1. Выведите все заказы для продавцов, которые были наняты на работу в первом квартале 2016 года
выведите колонки и отсортируйте на ваше усмотрение (4 балла)*/

SELECT *
FROM db_laba.dbo.orders ord
WHERE ord.salesman_id in -- IN, т.к. много значений
    (SELECT emp.employee_id
     FROM db_laba.dbo.employees emp
     WHERE emp.hire_date BETWEEN '2016-01-01' AND '2016-03-31')
	 ORDER BY 4,3,5;
	
	/*
	SELECT * --emp.manager_id
	FROM db_laba.dbo.employees emp
	WHERE emp.hire_date BETWEEN '2016-01-01' and '2016-03-31'
	AND emp.job_title like 'Sales%'   -- здесь я проверяю какие продавцы были наняты в 1-ом квартале

	SELECT *
	FROM db_laba.dbo.orders ord
	WHERE ord.salesman_id in (47,48,50,51,52,54,57,58,60,64,65,66,67,69,70,71,72,73,76,77,80)  -- здесь я проверяю заказы по найденным выше продавцам. Здесь как раз видно, что не по всем были заказы.
	*/ 


/*2. Выведите ID и статус заказа, имя продавца и его телефон
для всех заказов, которые сделал самый лучший продавец 2016 года (продал больше всего товара в денежном эквиваленте)
Отсортируйте на ваше усмотрение (5 баллов)*/

 SELECT
	ord.order_id ord_id,
	ord.status ord_status ,
	emp.first_name sales_name,
	emp.phone sales_phone
FROM
	db_laba.dbo.orders ord
LEFT JOIN db_laba.dbo.employees emp ON
	ord.salesman_id = emp.employee_id
WHERE   -- теперь нам надо получить ID лучшего продавца 2016 года
	ord.salesman_id = (
	SELECT
		top1.salesman_id
	FROM
		(
		SELECT
			TOP (1) 
			ord.salesman_id , SUM(oi.quantity*oi.unit_price) order_sum
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			ord.salesman_id IS NOT NULL -- не по всем заказам есть продавцы. А нам надо имя!
			AND ord.order_date BETWEEN '2016-01-01' AND '2016-12-31'
		GROUP BY
			ord.salesman_id
		ORDER BY
			order_sum DESC) top1)
ORDER BY
	1;

	
	/*
	Проверка
	SELECT  
	TOP (1) SUM(oi.quantity*oi.unit_price) order_sum,
	oi.order_id
			FROM db_laba.dbo.order_items oi
			WHERE oi.order_id in
    (SELECT ord.order_id
     FROM db_laba.dbo.orders ord
     WHERE ord.order_date BETWEEN '2016-01-01' AND '2016-12-31'
	and ord.salesman_id IS NOT NULL) -- для второй проверки
	 GROUP BY oi.order_id
	 ORDER BY
	order_sum DESC;
	
	
	проверка 1
	select *
	FROM db_laba.dbo.orders ord
	WHERE ord.order_id = 68   -- здесь видно, что лучший заказ в этом периоде без продавца
	
	проверка 2
	select *
	FROM db_laba.dbo.orders ord
	WHERE ord.order_id = 39   -- здесь получаем salesman_id. Важно, что повторений нет. Т.е. на такую сумму только один менеджер продал. Это важно для постановки = или In в главном запросе.

	select *
	FROM db_laba.dbo.employees emp
	WHERE emp.employee_id = 62  -- Находим Freya = то, что выдал подзапрос
	*/



	/*3. Выведите ID заказа, имя и фамилию продавца одной колонкой,  телефон продавца, а также компанию заказчика
для всех заказов, которые сделал самый худший продавец 2015 года (продал меньше всего товара в количественном эквиваленте)
для всех отправленных заказов
Отсортируйте на ваше усмотрение (5 баллов) */

SELECT
	ord.order_id ord_id,
	emp.first_name + ' ' + emp.last_name as sales_name,
	emp.phone sales_phone,
	cust.name cust_name
FROM
	db_laba.dbo.orders ord
LEFT JOIN db_laba.dbo.employees emp ON
ord.salesman_id = emp.employee_id
JOIN db_laba.dbo.customers cust ON
ord.customer_id = cust.customer_id
	WHERE   -- теперь нам надо получить ID худшего продавца 2015 года
	ord.salesman_id = (
	SELECT
		worse.salesman_id
	FROM
		(
		SELECT
			TOP (1) 
			ord.salesman_id , SUM(oi.quantity) quantity_sum
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			ord.salesman_id IS NOT NULL 
			AND ord.order_date BETWEEN '2015-01-01' AND '2015-12-31'
		GROUP BY
			ord.salesman_id
		ORDER BY
			quantity_sum ASC) worse)
		and ord.status = 'Shipped'
ORDER BY
	1;

   /*Вариант проверки

	SELECT SUM(oi.quantity) quantity_sum, ord.salesman_id
	FROM db_laba.dbo.order_items oi
	JOIN db_laba.dbo.orders ord on ord.order_id = oi.order_id
	WHERE ord.order_date BETWEEN '2015-01-01' AND '2015-12-31' 
	GROUP BY ord.salesman_id
	ORDER BY
	quantity_sum ASC -- здесь мы выясняем, что 57-ой продавец был худшим в 2015 по кол-ву проданного товара из известных (не NULL)

	select *
	FROM db_laba.dbo.employees emp
	WHERE emp.employee_id = 57  -- Находим Scarlett = то, что выдал подзапрос
	*/



	/*4. Выведите сумму маржи (подсказка: sum(quantity * list_price) - sum(quantity * standard_cost) ), имя клиента и год заказа
Сгруппируйте по имени клиента и году заказа
для клиентов со средним количеством заказанных продуктов более чем среднее значение заказанных продуктов в 2016 году
Отсортируйте на ваше усмотрение (6 баллов)*/

SELECT 
(sum(oi.quantity * p.list_price) - sum (oi.quantity * p.standard_cost)) margin,
cust.name cust_name,
YEAR(ord.order_date) order_year
FROM
db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id -- методом проб выяснил, что неважно в каком порядке тут join`ы делать. Но в этой задаче так логически более правильно. Верно?
WHERE   -- теперь нам надо получить ID клиентов, которые подходят под условие
	cust.customer_id in (
	SELECT ord.customer_id
	FROM
		db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		GROUP BY ord.customer_id
		HAVING
		AVG(oi.quantity)> (
		SELECT
			AVG (oi.quantity) avg_quantity
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016))
GROUP BY
cust.name, YEAR(ord.order_date)
ORDER BY
	2,3,1;

	/* Небольшая проверка

			SELECT --oi.quantity
			AVG (oi.quantity) avg_quantity, ord.customer_id
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016
			GROUP BY ord.customer_id

			SELECT
			AVG (oi.quantity) avg_quantity
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016

			SELECT *
			FROM db_laba.dbo.customers cust 
			WHERE customer_id = 7

			-- выполнив сразу три запроса, я посмотрел на примере customer_id 7 (Alcoa), правильно ли отфильтровал подзапрос

--------------------------------------------------------------------------------------------------------------------------------

ниже мой второй вариант. Но, в процессе я понял, что он неверный.
Во-первых...выдаёт 42 строки вместо 50. 
Закралось сомнение. Видимо, что-то отсекается. 
Ведь я использовал только HAVING, а он фильтрует группы..а не строки (в отличии от WHERE).
Сам запрос ниже. Еще ниже кусочек проверочный. Я это оставил для того, чтобы получить от Вас обратную связь ))) верно ли я всё понял.
		
SELECT
	(sum(oi.quantity*p.list_price)-sum(oi.quantity*p.standard_cost)) margin,
	cust.name cust_name,
	YEAR(ord.order_date) order_year
FROM
	db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id
GROUP BY
	cust.name,
	YEAR(ord.order_date)
HAVING
	AVG(oi.quantity)> (
	SELECT
		AVG(oi.quantity) avg_quantity
	FROM
		db_laba.dbo.orders ord
	JOIN db_laba.dbo.order_items oi ON
		oi.order_id = ord.order_id
	WHERE
		YEAR(ord.order_date)= 2016)  ---- здесь смотрим нашу среднюю 87.568027
ORDER BY
	2,3,1;
-------------------------------------------------
	SELECT 
(sum(oi.quantity * p.list_price) - sum (oi.quantity * p.standard_cost)) margin,
cust.name cust_name,
YEAR(ord.order_date) order_year,
AVG (oi.quantity) avg_quantity
FROM
db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id
GROUP BY
cust.name, YEAR(ord.order_date)
ORDER BY
	2;    -------------- тут я убеждаюсь на примере клиента AbbVie, что в 2015 и 2016 год средняя была ниже общей средней (87.568027), поэтому, при запуске запроса основного у AbbVie остаётся строка только с 2017 годом.
	*/

