use db_laba;
DROP TABLE IF EXISTS regions;
CREATE TABLE regions
  (
    region_id int  NOT NULL,
    region_name VARCHAR( 50 ) NOT NULL,
  CONSTRAINT PK_region_id PRIMARY KEY NONCLUSTERED (region_id)
  );

DROP TABLE IF EXISTS countries;
CREATE TABLE countries
  (
    country_id   CHAR( 2 ) PRIMARY KEY  ,
    country_name VARCHAR( 40 ) NOT NULL,
    region_id    int                 , -- fk
    CONSTRAINT fk_countries_regions FOREIGN KEY( region_id )
      REFERENCES regions( region_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS locations;
CREATE TABLE locations
  (
    location_id int   PRIMARY KEY       ,
    address     VARCHAR( 255 ) NOT NULL,
    postal_code VARCHAR( 20 )          ,
    city        VARCHAR( 50 )          ,
    state       VARCHAR( 50 )          ,
    country_id  CHAR( 2 )               , -- fk
    CONSTRAINT fk_locations_countries
      FOREIGN KEY( country_id )
      REFERENCES countries( country_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses
  (
    warehouse_id int PRIMARY KEY,
    warehouse_name VARCHAR( 255 ) ,
    location_id    int, -- fk
    CONSTRAINT fk_warehouses_locations
      FOREIGN KEY( location_id )
      REFERENCES locations( location_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
  (
    employee_id int PRIMARY KEY,
    first_name VARCHAR( 255 ) NOT NULL,
    last_name  VARCHAR( 255 ) NOT NULL,
    email      VARCHAR( 255 ) NOT NULL,
    phone      VARCHAR( 50 ) NOT NULL ,
    hire_date  DATE NOT NULL          ,
    manager_id int        , -- fk
    job_title  VARCHAR( 255 ) NOT NULL,
    CONSTRAINT fk_employees_manager
        FOREIGN KEY( manager_id )
        REFERENCES employees( employee_id )
  );

DROP TABLE IF EXISTS product_categories;
CREATE TABLE product_categories
  (
    category_id int PRIMARY KEY,
    category_name VARCHAR( 255 ) NOT NULL
  );

DROP TABLE IF EXISTS products;
CREATE TABLE products
  (
    product_id int PRIMARY KEY,
    product_name  VARCHAR( 255 ) NOT NULL,
    description   VARCHAR( 2000 )        ,
    standard_cost decimal( 9, 2 )          ,
    list_price    decimal( 9, 2 )          ,
    category_id   int NOT NULL         ,
    CONSTRAINT fk_products_categories
      FOREIGN KEY( category_id )
      REFERENCES product_categories( category_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
  (
    customer_id int PRIMARY KEY,
    name         VARCHAR( 255 ) NOT NULL,
    address      VARCHAR( 255 )         ,
    website      VARCHAR( 255 )         ,
    credit_limit decimal( 8, 2 )
  );

DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts
  (
    contact_id int PRIMARY KEY,
    first_name  VARCHAR( 255 ) NOT NULL,
    last_name   VARCHAR( 255 ) NOT NULL,
    email       VARCHAR( 255 ) NOT NULL,
    phone       VARCHAR( 20 )          ,
    customer_id int                 ,
    CONSTRAINT fk_contacts_customers
      FOREIGN KEY( customer_id )
      REFERENCES customers( customer_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
  (
    order_id int  PRIMARY KEY,
    customer_id int NOT NULL, -- fk
    status      VARCHAR( 20 ) NOT NULL ,
    salesman_id int         , -- fk
    order_date  DATE NOT NULL          ,
    CONSTRAINT fk_orders_customers
      FOREIGN KEY( customer_id )
      REFERENCES customers( customer_id )
      ON DELETE CASCADE,
    CONSTRAINT fk_orders_employees
      FOREIGN KEY( salesman_id )
      REFERENCES employees( employee_id )
      ON DELETE SET NULL
  );

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items
  (
    order_id   int                                , -- fk
    item_id    int                               ,
    product_id int NOT NULL                       , -- fk
    quantity   decimal( 8, 2 ) NOT NULL                        ,
    unit_price decimal( 8, 2 ) NOT NULL                        ,
    CONSTRAINT pk_order_items
      PRIMARY KEY( order_id, item_id ),
    CONSTRAINT fk_order_items_products
      FOREIGN KEY( product_id )
      REFERENCES products( product_id )
      ON DELETE CASCADE,
    CONSTRAINT fk_order_items_orders
      FOREIGN KEY( order_id )
      REFERENCES orders( order_id )
      ON DELETE CASCADE
  );

DROP TABLE IF EXISTS inventories;
CREATE TABLE inventories
  (
    product_id   int        , -- fk
    warehouse_id int        , -- fk
    quantity     int NOT NULL,
    CONSTRAINT pk_inventories
      PRIMARY KEY( product_id, warehouse_id ),
    CONSTRAINT fk_inventories_products
      FOREIGN KEY( product_id )
      REFERENCES products( product_id )
      ON DELETE CASCADE,
    CONSTRAINT fk_inventories_warehouses
      FOREIGN KEY( warehouse_id )
      REFERENCES warehouses( warehouse_id )
        ON DELETE CASCADE);
