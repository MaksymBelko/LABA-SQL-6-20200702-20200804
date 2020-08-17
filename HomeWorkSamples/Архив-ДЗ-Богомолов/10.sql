/*Напишите DDL/DML операторы
Минимальные требования к хранению данных:
1. Таблица с видами и ценами пиццы. Эта таблица должна быть заполнена всеми данными (минимум 5 видов пиццы).
2. Таблица с клиентами. В ней должна быть возможность хранить ФИО, телефон. Эта таблица должна быть заполнена данными (минимум 10 клиентов).
3. Таблица с адресами для клиентов (у клиента есть возможность заказывать пиццу на разные адреса). Эта таблица должна быть заполнена данными (минимум 15 адресов).
4. Таблица с продавцами. В ней должна быть возможность хранить ФИО, телефон
5. Таблица заказов. Заполнить для 10 заказов
6. Таблица деталей заказов. Заполнить для 10 заказов, некоторые заказы должны включать более одной пиццы
Все таблицы должны содержать ограничения и связи где нужны. */

-- 1) Таблица с видами и ценами пиццы. Эта таблица должна быть заполнена всеми данными (минимум 5 видов пиццы).

DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_products

CREATE TABLE db_laba.dbo.bogomolov_pizza_products
  (
    pzz_id int NOT NULL,
    pzz_name varchar (50) NOT NULL,
    price_byn decimal(5,2) NOT NULL,
    size varchar (1) NOT NULL,
	weight_g decimal (5,2) NOT NULL,
	toppings varchar (300) NOT NULL,
    CONSTRAINT PK_bogomolov_pizza_products_product_id PRIMARY KEY (pzz_id));
 
--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_products');


 Insert into db_laba.dbo.bogomolov_pizza_products (pzz_id,pzz_name,price_byn,size,weight_g,toppings) 
 values 
 (1,'Chicken Pizza',9.99,'S',325.00,'chicken breasts, olive oil, pesto, tomatoes, mozzarella cheese'),
 (2,'Margherita',22.00,'M',520.00,'passata sauce, basil leaves, pepper, olive oil, mozzarella cheese'),
 (3,'Mexican',24.00,'M',545.00,'beans, beaf, cheddar cheese, souce cream, green chiles, tomatoes, black olives'),
 (4,'Hawaiian',28.00,'L',800.00,'pineapple, ham, pizza sauce, mozzarella cheese, olive oil'),
 (5,'Pepperoni',24.50,'M',530.00,'olive oil, pepperoni slices, mozzarella cheese, basil pasta sauce');


  select * 
 from db_laba.dbo.bogomolov_pizza_products


 -- 2) Таблица с клиентами. В ней должна быть возможность хранить ФИО, телефон. Эта таблица должна быть заполнена данными (минимум 10 клиентов).
 
 DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_clients

CREATE TABLE db_laba.dbo.bogomolov_pizza_clients
  (
    client_id int NOT NULL,
    first_name varchar (50) NOT NULL,
	patronymic varchar (50) NOT NULL,
    surname varchar (50) NOT NULL,
    phone_number varchar (50) NOT NULL,
	first_order_date date NOT NULL,
    CONSTRAINT PK_bogomolov_pizza_clients_client_id PRIMARY KEY (client_id));

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_clients');
	 

	 Insert into db_laba.dbo.bogomolov_pizza_clients(client_id,first_name,patronymic,surname,phone_number,first_order_date)
 values 
 (1,'Anton','Igorevich','Bogomolov','+375293364883',CAST('2019-12-15' as date)),
 (2,'Alena','Sergeevna','Nikolaenko','+375296734412',CAST('2020-02-18' as date)),
 (3,'Aleksandr','Vladimirovich','Kolotilo','+375255321987',CAST('2020-05-09' as date)),
 (4,'Victor','Antonovich','Voitehovich','+375443251176',CAST('2019-09-13' as date)),
 (5,'Veronika','Vladimirovna','Arduk','+375446557719',CAST('2019-10-07' as date)),
 (6,'Alexei','Nikolaevich','Evtukh','+375257814566',CAST('2020-03-08' as date)),
 (7,'Gennadiy','Petrovich','Istomin','+375291534469',CAST('2020-01-27' as date)),
 (8,'Olga','Olegovna','Ostrovskaya','+375293322345',CAST('2020-06-11' as date)),
 (9,'Yuriy','Mikhailovich','Gorustovich','+375296789012',CAST('2020-07-07' as date)),
 (10,'Valentina','Petrovna','Kvach','+375443182910',CAST('2020-04-30' as date));
 

	 select * 
 from db_laba.dbo.bogomolov_pizza_clients


-- 3) Таблица с адресами для клиентов (у клиента есть возможность заказывать пиццу на разные адреса). Эта таблица должна быть заполнена данными (минимум 15 адресов).

 DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_client_address

CREATE TABLE db_laba.dbo.bogomolov_pizza_client_address
  (
    address_id int NOT NULL,
	client_id int NOT NULL,
    city varchar (20) default 'N/A',
	address varchar (50) default 'N/A',
    CONSTRAINT PK_bogomolov_pizza_clients_address_address_id PRIMARY KEY (address_id,client_id),
	 CONSTRAINT FK_client_address_clients_bogomolov FOREIGN KEY( client_id )
      REFERENCES db_laba.dbo.bogomolov_pizza_clients ( client_id ) ON DELETE CASCADE);

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_client_address');


 Insert into db_laba.dbo.bogomolov_pizza_client_address (address_id,client_id,city,address)
 values 
 (1,4,'Minsk','ul. Petrusya Brovki, d.19, kv.111'),
 (2,4,'Minsk','ul. V.Horuzhei, d.25, of. 306'),
 (3,1,'Minsk','ul. Avangardnaya, d.49, kv.1'),
 (4,1,'Minsk','ul. Karskogo, d.8, kv.16'),
 (5,2,'Minsk','prosp. Pobediteley, d.119, kv.34'),
 (6,3,'Minsk','ul. Chornogo, d.2, kv.71'),
 (7,5,'Minsk','prosp. Gazety Pravda, d.49, kv.1'),
 (8,6,'Minsk','ul. Timoshenko, d.17, kv.21'),
 (9,7,'Minsk','ul. Bogdanovicha, d.23, kv.189'),
 (10,7,'Minsk','ul. Timiryazeva, d.117, of. 1107'),
 (11,8,'Minsk','blv. Shevchenko, d.1, kv. 10'),
 (12,8,'Minsk','ul. V.Horuzhei, d.25, of. 702'),
 (13,9,'Minsk','ul. Fedorova, d.12, kv. 3'),
 (14,10,'Minsk','ul. Avakyana, d.55, kv. 14'),
 (15,10,'Minsk','prosp. Pushkina, d.7, of. 223');


 select * 
 from db_laba.dbo.bogomolov_pizza_client_address


-- 4) Таблица с продавцами. В ней должна быть возможность хранить ФИО, телефон (минимум 10 продавцов).

 DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_salesmen

CREATE TABLE db_laba.dbo.bogomolov_pizza_salesmen
  (
    salesman_id int NOT NULL,
    first_name varchar (50) NOT NULL,
	patronymic varchar (50) NOT NULL,
    surname varchar (50) NOT NULL,
    phone_number varchar (50) NOT NULL,
	hire_date date NOT NULL,
	age int NOT NULL,
    CONSTRAINT PK_bogomolov_pizza_salesmen_salesman_id PRIMARY KEY (salesman_id));

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_salesmen');

 Insert into db_laba.dbo.bogomolov_pizza_salesmen(salesman_id,first_name,patronymic,surname,phone_number,hire_date,age)
 values 
 (1,'Maksim','Alexeevich','Zubko','+375293332188',CAST('2019-08-01' as date),23),
 (2,'Anatoliy','Valentinovich','Gromov','+375296654334',CAST('2019-08-01' as date),21),
 (3,'Anna','Dmitrievna','Gurinovich','+375255664789',CAST('2019-10-01' as date),19),
 (4,'Anastasiya','Petrovna','Korotkina','+375441214433',CAST('2019-11-15' as date),26),
 (5,'Olga','Sergeevna','Velichko','+375255503890',CAST('2019-12-01' as date),22),
 (6,'Ekaterina','Anatolievna','Minich','+375297503891',CAST('2020-02-01' as date),20),
 (7,'Egor','Valerievich','Maslyakov','+375338819778',CAST('2020-02-01' as date),22),
 (8,'Vladislav','Nikolaevich','Zhukov','+375331135427',CAST('2020-04-15' as date),24),
 (9,'Irina','Olegovna','Malinovksya','+375293363441',CAST('2020-06-01' as date),21),
 (10,'Alena','Vyacheslavovna','Drik','+375441618890',CAST('2020-07-01' as date),23);
 
 select * 
 from db_laba.dbo.bogomolov_pizza_salesmen


 -- 5) Таблица заказов. Заполнить для 10 заказов

 DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_orders

CREATE TABLE db_laba.dbo.bogomolov_pizza_orders
  (
    order_id int NOT NULL,
	order_date date NOT NULL,
	client_id int NOT NULL,
	address_id int NOT NULL,
	salesman_id int NOT NULL,
    status varchar (20) NOT NULL,
	is_paid bit NOT NULL default 0,
	payment_method varchar(10) NOT NULL,
	delivery_type varchar (10) NOT NULL,
	remark varchar (50) default 'N/A',
	CONSTRAINT PK_bogomolov_pizza_orders_order_id PRIMARY KEY (order_id),
	 CONSTRAINT FK_pizza_orders_clients_bogomolov FOREIGN KEY(client_id)
      REFERENCES db_laba.dbo.bogomolov_pizza_clients (client_id),
     CONSTRAINT FK_pizza_orders_client_address_bogomomolov FOREIGN KEY(address_id,client_id)
     REFERENCES db_laba.dbo.bogomolov_pizza_client_address (address_id,client_id),
	 CONSTRAINT FK_pizza_orders_salesmen_bogomomolov FOREIGN KEY(salesman_id)
      REFERENCES db_laba.dbo.bogomolov_pizza_salesmen (salesman_id));

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_orders');


 Insert into db_laba.dbo.bogomolov_pizza_orders(order_id,order_date,client_id,address_id,salesman_id,status,is_paid,payment_method,delivery_type,remark)
 values 
 (1,CAST('2020-06-06' as date),1,4,6,'Completed',1,'Cash','Delivery','2nd floor'),
 (2,CAST('2020-07-13' as date),1,3,5,'Completed',1,'Cash','Delivery','change from 100 byn'),
 (3,CAST('2020-07-13' as date),5,7,1,'Canceled',0,'Cash','Delivery','take a long time to order'),
 (4,CAST('2020-07-15' as date),7,10,2,'Completed',1,'EWallet','Delivery','need a pass at the reception'),
 (5,CAST('2020-07-17' as date),10,14,6,'Completed',1,'Cash','PickUp','picked up from pizzeria number 3'),
 (6,CAST('2020-07-17' as date),8,12,5,'Completed',1,'EWallet','Delivery','need a pass at the reception, 7th floor'),
 (7,CAST('2020-07-23' as date),2,5,9,'Completed',1,'EWallet','Delivery','maybe cash'),
 (8,CAST('2020-07-25' as date),3,6,7,'Canceled',0,'EWallet','Delivery','terminal did not work'),
 (9,CAST('2020-08-01' as date),4,1,3,'Completed',1,'Cash','Delivery','asked as soon as possible'),
 (10,CAST('2020-08-03' as date),6,8,10,'Canceled',0,'Cash','Delivery','refused the order. take a long time to order');
 
 /* Ниже запрос, который показывает, что мы не можем поставить любой address_id к Клиенту, а добавляются только те, которые к нему относятся.
 
 select * 
 from db_laba.dbo.bogomolov_pizza_client_address
 where client_id = 1                         --- здесь мы видим, что только address_id=3 и 4 здесь

 Пробуем поставить 7-ой address_id:

 Insert into db_laba.dbo.bogomolov_pizza_orders(order_id,order_date,client_id,address_id,salesman_id,status,is_paid,payment_method,delivery_type,remark)
 values 
 (11,CAST('2020-08-04' as date),1,7,10,'Canceled',0,'Cash','Delivery','refused the order. take a long time to order')  -- выдаёт ошибку;

 */
 

  select * 
 from db_laba.dbo.bogomolov_pizza_orders

 -- 6) Таблица деталей заказов. Заполнить для 10 заказов, некоторые заказы должны включать более одной пиццы

 
 DROP TABLE IF EXISTS db_laba.dbo.bogomolov_pizza_order_items

CREATE TABLE db_laba.dbo.bogomolov_pizza_order_items
  (
    line_id int NOT NULL,
	order_id int NOT NULL,
	pzz_id int NOT NULL,
	quantity decimal (5,2) NOT NULL,
	CONSTRAINT PK_bogomolov_pizza_order_items_line_id PRIMARY KEY (line_id,order_id),
	 CONSTRAINT FK_pizza_order_items_orders_bogomolov FOREIGN KEY(order_id)
      REFERENCES db_laba.dbo.bogomolov_pizza_orders (order_id) ON DELETE CASCADE,
	 CONSTRAINT FK_pizza_orders_items_products_bogomolov FOREIGN KEY(pzz_id)
      REFERENCES db_laba.dbo.bogomolov_pizza_products (pzz_id));

--check
Select C.*, (Select definition From sys.default_constraints Where object_id = C.object_id) As dk_definition,
(Select definition From sys.check_constraints Where object_id = C.object_id) As ck_definition,
(Select name From sys.objects Where object_id = D.referenced_object_id) As fk_table,
(Select name From sys.columns Where column_id = D.parent_column_id And object_id = D.parent_object_id) As fk_col
From sys.objects As C
Left Join (Select * From sys.foreign_key_columns) As D On D.constraint_object_id = C.object_id 
Where C.parent_object_id = (Select object_id From sys.objects Where type = 'U'
And name = 'bogomolov_pizza_order_items');

 Insert into db_laba.dbo.bogomolov_pizza_order_items(line_id,order_id,pzz_id,quantity)
 values 
 (1,1,2,1.00),
 (2,2,2,2.00),
 (3,2,4,1.00),
 (4,3,1,2.00),
 (5,4,4,3.00),
 (6,5,1,3.00),
 (7,6,2,1.00),
 (8,6,4,1.00),
 (9,6,5,1.00),
 (10,7,3,2.00),
 (11,8,3,1.00),
 (12,9,2,2.00),
 (13,9,3,2.00),
 (14,9,5,2.00),
 (15,10,1,4.00);


 select * 
 from db_laba.dbo.bogomolov_pizza_order_items

-----------------------------------
/*Напишите следующие запросы:
7. Самая популярная пицца
8. Самая не популярная пицца
9. Выведите имя пиццы, количество проданных пиццы, на какую сумму было продано, имя продавца и его телефон за последние 30 дней (подсказка getdate() - 30)
Отсортируйте на ваше усмотрение
10. Выведите дату заказа, номер заказа, количество позиций в заказе, имя клиента, телефон клиента и адрес доставки, имя и телефон продавца для отмененных заказов
Отсортируйте на ваше усмотрение */

-- 7) Самая популярная пицца (в моём понимании это та пицца, которую чаще заказывали в количественном выражении. Т.е. самая ходовая).

SELECT pp.pzz_name most_popular_pizza_name 
FROM db_laba.dbo.bogomolov_pizza_products pp
WHERE pp.pzz_id = (
SELECT
 most_popular_pizza.pzz_id
 FROM 
 (SELECT
 TOP(1)
 pzz_id, sum(oi.quantity) quantity_sum
 FROM db_laba.dbo.bogomolov_pizza_order_items oi
 JOIN db_laba.dbo.bogomolov_pizza_orders o
 ON o.order_id = oi.order_id
 GROUP BY
 oi.pzz_id
ORDER BY
 quantity_sum DESC)most_popular_pizza)
 ORDER BY 1

 -- 8) Самая не популярная пицца.

 SELECT pp.pzz_name most_unpopular_pizza_name 
FROM db_laba.dbo.bogomolov_pizza_products pp
WHERE pp.pzz_id = (
SELECT
 most_unpopular_pizza.pzz_id
 FROM 
 (SELECT
 TOP(1)
 pzz_id, sum(oi.quantity) quantity_sum
 FROM db_laba.dbo.bogomolov_pizza_order_items oi
 JOIN db_laba.dbo.bogomolov_pizza_orders o
 ON o.order_id = oi.order_id
 GROUP BY
 oi.pzz_id
ORDER BY
 quantity_sum ASC)most_unpopular_pizza)
 ORDER BY 1

--- Небольшая проверка (для задания 7 и 8) ниже

 SELECT 
 oi.pzz_id, pp.pzz_name, sum(oi.quantity) quantity_sum
 FROM db_laba.dbo.bogomolov_pizza_order_items oi
 JOIN db_laba.dbo.bogomolov_pizza_products pp
 on oi.pzz_id = pp.pzz_id
 GROUP BY oi.pzz_id, pp.pzz_name


 -- 9) Выведите имя пиццы, количество проданных пиццы, на какую сумму было продано, имя продавца и его телефон за последние 30 дней (подсказка getdate() - 30). Отсортируйте на ваше усмотрение. 

 --здесь я решил еще от себя один фильтр добавить - заказы со статусом 'Completed'. Хоть его в условии нет, но нам нужны проданные пиццы (т.е. с которых мы получили доход).

 SELECT  pp.pzz_name pizza_name, sum(oi.quantity) quantity_sum, sum(oi.quantity * pp.price_byn) total_sum, s.first_name sales_name, s.phone_number sales_phone -- , o.order_id --(выводил для проверки ниже)
 FROM db_laba.dbo.bogomolov_pizza_products pp
 JOIN db_laba.dbo.bogomolov_pizza_order_items oi on pp.pzz_id = oi.pzz_id
 JOIN db_laba.dbo.bogomolov_pizza_orders o on o.order_id = oi.order_id
 JOIN db_laba.dbo.bogomolov_pizza_salesmen s on s.salesman_id = o.salesman_id
 WHERE o.status = 'Completed' and o.order_date >= getdate() - 30
 GROUP BY pp.pzz_name, s.first_name, s.phone_number --,  o.order_id
 ORDER BY 4,3 DESC,2 DESC,1
 

 --- Ниже небольшие проверочные запросы.
   select *
 from db_laba.dbo.bogomolov_pizza_orders
 --where order_id in (2,4,5,6,7,9) -- это те заказы, которые попали в основной запрос. По условиям фильтров подходят
 --where order_id in (1,3,8,10) -- это заказы, которых нет в результате выполнения запроса. Мы видим, что 3 из них отменены и один старше 30 дней. Т.е. их отсутствие логично.

 select *
 from db_laba.dbo.bogomolov_pizza_salesmen
 where salesman_id = 3  -- Анна

  select *
 from db_laba.dbo.bogomolov_pizza_orders
 where salesman_id = 3  -- статус 'Completed' и по дате подходит

 select *
 from db_laba.dbo.bogomolov_pizza_order_items
 where order_id = 9

 select *
 from db_laba.dbo.bogomolov_pizza_products
 where pzz_id in (2,3,5)
 

-- 10. Выведите дату заказа, номер заказа, количество позиций в заказе, имя клиента, телефон клиента и адрес доставки, имя и телефон продавца для отмененных заказов. Отсортируйте на ваше усмотрение.

SELECT o.order_date order_date, o.order_id order_id, COUNT(oi.line_id) AS items, c.first_name client_name, 
c.phone_number client_phone, a.address client_address, s.first_name sales_name, s.phone_number sales_phone
 FROM
    db_laba.dbo.bogomolov_pizza_orders o
JOIN db_laba.dbo.bogomolov_pizza_order_items oi on o.order_id = oi.order_id 
JOIN db_laba.dbo.bogomolov_pizza_clients c on o.client_id = c.client_id 
JOIN db_laba.dbo.bogomolov_pizza_client_address a on o.address_id  = a.address_id
JOIN db_laba.dbo.bogomolov_pizza_salesmen s on s.salesman_id = o.salesman_id
WHERE o.status = 'Completed'
GROUP BY o.order_date, o.order_id, c.first_name, c.phone_number, a.address, s.first_name, s.phone_number 
ORDER BY 1 DESC, 2 ASC


--- Ниже небольшие проверочные запросы.
   select *
 from db_laba.dbo.bogomolov_pizza_orders
 --where order_id in (1,2,4,5,6,7,9) -- это те заказы, которые попали в основной запрос. По условиям фильтров подходят
 --where order_id in (3,8,10) -- это заказы, которых нет в результате выполнения запроса. Все они отменены.

 --на примере заказа №6 пошагово проверяю
 select *
 from db_laba.dbo.bogomolov_pizza_orders
 where order_id = 6 

   select *
 from db_laba.dbo.bogomolov_pizza_order_items
 where order_id = 6  -- действительно три позиции в заказе


 select *
 from db_laba.dbo.bogomolov_pizza_salesmen
 where salesman_id = 5  -- Ольга

 
 select *
 from db_laba.dbo.bogomolov_pizza_clients
 where client_id = 8  -- Клиент тоже Ольга


 select *
 from db_laba.dbo.bogomolov_pizza_client_address
 where client_id = 8  -- address_id 12 действительно относится к этому client_id
