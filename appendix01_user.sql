USE [master]
GO
CREATE LOGIN [student] WITH PASSWORD=N'student' MUST_CHANGE,
DEFAULT_DATABASE=[db_laba], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

USE [db_laba]
GO
CREATE USER [student] FOR LOGIN [student] WITH DEFAULT_SCHEMA=[dbo]
GO



use db_laba
ALTER ROLE db_ddladmin ADD MEMBER student
go

/*
use db_laba
ALTER ROLE db_ddladmin DROP MEMBER student
go
*/

--use db_laba
--SELECT 'GRANT SELECT ON "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "student"' FROM information_schema.tables
--go

use db_laba
GRANT ALTER, EXECUTE, SELECT, INSERT, UPDATE, DELETE, VIEW DEFINITION
ON SCHEMA :: [dbo]
TO student
go

DENY INSERT, delete, update ON OBJECT::dbo.test TO student;
use db_laba
SELECT 'DENY INSERT, delete, update ON OBJECT :: "' + TABLE_SCHEMA + '"."' + TABLE_NAME + '" TO "student";' FROM information_schema.tables
go

DENY INSERT, delete, update ON OBJECT :: "dbo"."regions" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."countries" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."locations" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."warehouses" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."employees" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."product_categories" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."products" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."customers" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."contacts" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."orders" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."order_items" TO "student";
DENY INSERT, delete, update ON OBJECT :: "dbo"."inventories" TO "student";
