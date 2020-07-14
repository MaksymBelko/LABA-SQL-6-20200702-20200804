/*
 * #############################
 * #     Занятие 4             #  
 * #     Объединение таблиц    #
 * #     Строки и выражения    #
 * #############################
 */

/*
 * +--------------------+
 * | Строки и выражения |
 * +--------------------+
 */

-- вывести имя продукта и маржу по стоимости
-- отсортировать по убыванию маржи и имени продукта по возростанию (4мя способами)
-- 1/11
 SELECT
	prod.product_name as name,
	prod.list_price - prod.standard_cost as margin_test--,
	--prod.list_price, prod.standard_cost
FROM
	db_laba.dbo.products prod
--ORDER BY 2 DESC, 1;
--ORDER BY prod.list_price - prod.standard_cost DESC, 1;
--ORDER BY prod.list_price - prod.standard_cost DESC, prod.product_name;
ORDER BY margin_test DESC, prod.product_name;

-- вывести имя продукта и процент маржи по стоимости (2мя способами)
-- отсортировать по имени продукта по возростанию
-- 2/11
SELECT
	prod.product_name as name,
	--prod.list_price , prod.standard_cost,
   (prod.list_price - prod.standard_cost) / prod.standard_cost * 100 as margin_to_cost
   --,(prod.list_price / prod.standard_cost -1)  * 100 as margin_to_cost_2
   ,CAST(CAST((prod.list_price / prod.standard_cost -1)  * 100 as decimal(10,2) ) as varchar) + '%' as margin_to_cost_3_proc
FROM
	db_laba.dbo.products prod
order by
	1;

/*
 * +-----------------------------------------+
 * | ПОМЕЩЕНИЕ ТЕКСТА В ВАШЕМ ВЫВОДЕ ЗАПРОСА |
 * +-----------------------------------------+
 */

-- вывести имя продукта и маржу по стоимости
-- отсортировать по убыванию маржи и имени продукта по возростанию
-- 3/11
 SELECT
	'For product: ' + prod.product_name as name,
	prod.list_price - prod.standard_cost as margin,
	'USD' as CURENCY
FROM
	db_laba.dbo.products prod
ORDER BY
	2 DESC,
	1; 

/*
 * +-------------------+
 * | Строковые функции |
 * +-------------------+
 */
-- 4/11
SELECT --Bailey
	emp.last_name
	--,LEFT ( emp.last_name, 2 ) last_name_first_2
	--,RIGHT ( emp.last_name, 3 )
	--,SUBSTRING ( emp.last_name , 1 ,3 ) --Richardson
	--,SUBSTRING ( emp.last_name , 3 ,3 )
	--,LEN(emp.last_name) 
	--,LTRIM (emp.last_name)
	--,RTRIM (emp.last_name)
	--,TRIM (emp.last_name)
	--,UPPER (emp.last_name)
	--,LOWER (emp.last_name)
	--,CHARINDEX('e', emp.last_name) --oracle instr
	--,SUBSTRING ( emp.last_name , CHARINDEX('a', emp.last_name), 3 )
	,REPLACE(emp.last_name, 'as','+')
from db_laba.dbo.employees emp
where LEN(emp.last_name) > 7; 
--Rivera

-- 5/11
select  LTRIM (' last name   '),
		RTRIM (' last name   '),
		TRIM  (' last    name   ')
--'last name   '
--' last name'
--'last name'

/*
 * +--------+
 * |  INNER |
 * +--------+
 */
-- вывести объеденение продуктов и категорий (2мя способами)
-- 6/11
 select
	--*
	p.*, '--------', pc.*
from
	db_laba.dbo.products p,
	db_laba.dbo.product_categories pc
where
	p.category_id = pc.category_id;
--alter table products drop column country

-- 7/11
select
	*
from
	db_laba.dbo.products p
inner join db_laba.dbo.product_categories pc on
	p.category_id = pc.category_id;

-- вывести имя продукта, стандартую цену и имя категории
-- для всех категорий кроме CPU
-- отсортировать по имения продукта
-- 8/11
 select
	p.product_name,
	p.standard_cost,
	--p.category_id category_id_prod,
	--pc.category_id category_id_cat,
	pc.category_name
from
	db_laba.dbo.products p
--inner join db_laba.dbo.product_categories pc on
join db_laba.dbo.product_categories pc on
	p.category_id = pc.category_id
where
	pc.category_name != 'CPU' --pc.category_name not in ('CPU') <> 
order by 1;

/*
 * +--------+
 * |  LEFT  |
 * +--------+
 */

-- вывести продавцов и количестов их заказов
-- отсортировать по количеству заказов 
-- 9/11
 SELECT
	--emp.employee_id,
	emp.first_name,
	--emp.last_name,
	--ord.order_id,
	--ord.status
	--emp.job_title
	COUNT(ord.order_id) --select *
from
	db_laba.dbo.employees emp
left join db_laba.dbo.orders ord on emp.employee_id = ord.salesman_id
--left outer join db_laba.dbo.orders ord on emp.employee_id = ord.salesman_id
 --join db_laba.dbo.orders ord on emp.employee_id = ord.salesman_id
where
	emp.job_title LIKE 'Sales%'
	--and ord.salesman_id is not NULL 
	--54 amount 5
	--60  6
GROUP BY
	--emp.employee_id,
	emp.first_name--,
	--emp.last_name
order by 4 desc;

--select * from db_laba.dbo.orders ord where ord.salesman_id = 60
/*
 * +-------------+
 * |  SELF JOIN  |
 * +-------------+
 */
-- 10/11
select * from
	db_laba.dbo.employees emp1;
--
SELECT
	emp1.first_name + ' ' + emp1.last_name as employee,
	--'managed by ',
	emp2.first_name + ' ' + emp2.last_name as manager ,
	COALESCE(emp2.first_name + ' ' + emp2.last_name, 'Tommy Bailey') as manager_2
from
	db_laba.dbo.employees emp1
left join db_laba.dbo.employees emp2 on
--join db_laba.dbo.employees emp2 on
	emp1.manager_id = emp2.employee_id
--	inner lfkgflkgjklfjglk
order by 1,2;

/*
 * +--------------+
 * |  FULL OUTER  |
 * +--------------+
 */

-- вывести идентификаторы всех возможных продавцов и заказов
-- отсортироваить по продавцам. затем заказам
-- 11/11
 SELECT
	emp.employee_id,
	ord.order_id
from
	db_laba.dbo.employees emp
FULL OUTER join db_laba.dbo.orders ord on
	emp.employee_id = ord.salesman_id
where
	emp.job_title LIKE 'Sales%';
