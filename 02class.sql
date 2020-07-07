/*
 * ####################################
 * #     Занятие 2                    #
 * #     Работа с командой SELECT     #
 * ####################################
 */


/*
 * +----------------+
 * | Команда SELECT |
 * +----------------+
 */

/*some text
here
*/

-- вывести все данные по продуктам
-- 1/17
select * from db_laba.dbo.products;
select * from db_laba.dbo.product_categories;
-- 2/17
-- вывести все данные по заказам
select * from db_laba.dbo.orders;


-- вывести все данные по странам
-- 3/17
select * from db_laba.dbo.countries;

-- вывести все данные по регионам
-- 4/17
select * from db_laba.dbo.regions;


-- вывести все данные по продуктам перечисляя поля (колонки)
-- 5/17
select product_id, product_name, description, standard_cost, list_price, category_id from db_laba.dbo.products;
/*
select
	product_id, product_name,
	description, standard_cost,
list_price, category_id
from
	db_laba.dbo.products;
*/

--вывести все данные по продуктам перечисляя поля (колонки) - 2й способ с форматированием
-- 6/17
select product_id,
	   product_name,
	   description,
	   standard_cost,
	   list_price,
	   category_id
  from db_laba.dbo.products;
 /*
select --product_id,
	   product_name,
	   --description,
	   --standard_cost,
	   list_price--,
	   --category_id
  from db_laba.dbo.products;*/

-- вывести не все данные по продуктам перечисляя поля (колонки) - 2й способ используя алиас (псевдоним)
-- 7/17
select p.product_id
	   ,p.product_name
	   ,p.description
	   ,p.standard_cost
	   ,p.list_price
	   ,p.standard_cost 
	   ,p.description 
	   --,p.category_id
  from db_laba.dbo.products p;

/*
 * +-------------------+
 * | Оператор DISTINCT |
 * +-------------------+
 */
 -- вывести уникальный список категорий для таблицы продуктов
 -- отсортировать по возрастанию
 -- 8/17
select --p.category_id --
--distinct(p.category_id)
distinct p.category_id
  from db_laba.dbo.products as p
  order by 1;

/*
 * +-----------------------+
 * | Реляционные операторы |
 * +-----------------------+
 */
-- вывести имя продукта, описание и стандартную стоимось по продуктам
-- для продуктов стандартной стоимостью не менее 3000
-- результат отсортировать по имени продукта по убыванию
-- 9/17
select t1.product_name
	   ,t1.description
	   ,t1.standard_cost
  from db_laba.dbo.products t1
 where t1.standard_cost >= 3000
 order by t1.product_name desc;
--[asc | desc]

--SELECT * FROM order_items oi 

/*
 * +------------------+
 * | Булевы операторы |
 * +------------------+
 */
 --AND OR NOT

-- вывести имя продукта, описание и стандартную стоимось
-- по продуктам 1-й и 2-й категории
-- со стандартно стоимостью более 2500
-- 10/17
select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.list_price
	   --,p.category_id
  from db_laba.dbo.products p
 where --(p.category_id = 1 or p.category_id = 2)
 p.category_id in (1, 2)
 and p.standard_cost > 2500;

-- вывести имя продукта, описание, категорию и стандартную стоимость
-- по продуктам 1-й категории
-- или со стандартно стоимостью более 5000
-- результат отсортировать по категории по убыванию и по стандартной стоимости по возрастанию
-- 11/17
select p.product_name
	   ,p.description
	   ,p.category_id
	   ,p.standard_cost
	   --,p.list_price	   
  from db_laba.dbo.products as p
 where p.category_id = 1
 or p.standard_cost > 5000
 order by p.category_id desc, p.standard_cost asc;
/*
 * +------------------+
 * | Оператор between |
 * +------------------+
 */
-- вывести имя продукта, описание и стандартную стоимось по продуктам
-- со стандартной стоимосмью от 500 до 800
-- результат отсортировать по возрастанию стандартной стоимости
-- 12/17
select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.list_price
  from db_laba.dbo.products p
 where p.standard_cost between 500 and 800
 --p.standard_cost >= 500 and p.standard_cost <= 800
 order by p.standard_cost;-- asc;

-- вывести имя продукта, описание и стандартную стоимось по продуктам
-- со стандартной стоимосмью от 500 до 800
-- для всех категории, кроме 1, 2, 3, 4
-- результат отсортировать по убыванию стандартной стоимости
-- 13/17
select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.list_price
	   --,p.category_id
  from db_laba.dbo.products p
 where p.standard_cost between 500 and 800
   and p.category_id not in (1, 2, 3, 4)
   --(category_id <> 1 or category_id <> 2....)
 order by p.standard_cost desc;

/*
 * +---------------+
 * | Оператор LIKE |
 * +---------------+
 */
-- вывести имя продукта, описание и стандартную стоимось по продуктам
-- для продуктов имена которых начинаються на букву K
-- результат отсортировать по имени продукта
-- 14/17
select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.list_price
	   --,p.category_id
  from db_laba.dbo.products p
 where  p.product_name like 'K%'
--(p.product_name like 'K%' or p.product_name like 'N%' or p.product_name like 'M%')
 order by p.product_name desc;

 -- вывести имя продукта, описание и стандартную стоимось по продуктам
 -- для продуктов имена которых третим символом есть буква n
 -- результат отсортировать по имени продукта
 -- 15/17
 select p.product_name
 	   ,p.description
 	   ,p.standard_cost
 	   --,p.list_price
 	   --,p.category_id
   from db_laba.dbo.products p
  where --p.product_name like 'dig%'
  p.product_name like '__n%'
  order by p.product_name desc;


/*
 * +------------------------------------+
 * | Работа с NULL (пустыми значениями) |
 * +------------------------------------+
 */
 -- вывести содержимое таблицы locations
 -- где индекс пустой (null)
 -- 16/17
 SELECT location_id
		,address
		,postal_code
		,city
		,state
		,country_id
  FROM db_laba.dbo.locations
  --where postal_code = 'NULL';
  where postal_code is NULL;

/*
 * +-----------------------------------------------+
 * | Использование NOT со специальными операторами |
 * +-----------------------------------------------+
 */
 -- вывести содержимое таблицы locations
 -- где индекс не пустой
 -- 17/17
 SELECT location_id
		,address
		,postal_code
		,city
		,state
		,country_id
  FROM db_laba.dbo.locations
  where postal_code is not NULL;
  --where not postal_code is NULL
-- таким же способом Вы можете использовать NOT BETWEEN и NOT LIKE.
