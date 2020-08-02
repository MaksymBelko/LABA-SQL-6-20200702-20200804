/*
 * #################################################
 * #     Занятие 10                                #  
 * #     Настройки пользователей в базе данных     #
 * #################################################
 */
/* +-----------------------------------+
 * | Создание и удаление пользователей |
 * +-----------------------------------+
 */
--
-- вывести список пользователей в БД
SELECT * FROM sys.database_principals where (type='S' or type = 'U');

select name as username,
       create_date,
       modify_date,
       type_desc as type
from sys.database_principals
where type not in ('A', 'G', 'R', 'X')
      and sid is not null
      and name != 'guest'
order by username;

USE [master];
CREATE LOGIN [student_test] WITH PASSWORD=N'student_test',
DEFAULT_DATABASE=[db_laba], CHECK_EXPIRATION=ON, CHECK_POLICY=ON;
-- DROP LOGIN [student_test]
USE [db_laba];
CREATE USER [student_test] FOR LOGIN [student_test] WITH DEFAULT_SCHEMA=[dbo];
--DROP USER [student_test]

/* +------------------------+
 * | Стандартные привилегии |
 * +------------------------+
 */
--https://docs.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-my-permissions-transact-sql?view=sql-server-ver15
--SELECT
--INSERT
--UPDATE
--DELETE
--REFERENCES

SELECT * FROM fn_my_permissions(NULL, 'SERVER'); 
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  
SELECT * FROM fn_my_permissions('dbo.countries', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;   --show for user lector and student
    
SELECT pr.principal_id, pr.name, pr.type_desc,   
    pr.authentication_type_desc, pe.state_desc,   
    pe.permission_name, s.name + '.' + o.name AS ObjectName  
FROM sys.database_principals AS pr  
JOIN sys.database_permissions AS pe  
    ON pe.grantee_principal_id = pr.principal_id  
JOIN sys.objects AS o  
    ON pe.major_id = o.object_id  
JOIN sys.schemas AS s  
    ON o.schema_id = s.schema_id; 
    
   


/* +------------------------+
 * | Команды GRANT и REVOKE |
 * +------------------------+
 */

/*
  GRANT <permission> [ ,...n ] ON   
    [ OBJECT :: ][ schema_name ]. object_name [ ( column [ ,...n ] ) ]  
    TO <database_principal> [ ,...n ]   
    [ WITH GRANT OPTION ]  
    [ AS <database_principal> ]  

 REVOKE [ GRANT OPTION FOR ] <permission> [ ,...n ] ON   
    [ OBJECT :: ][ schema_name ]. object_name [ ( column [ ,...n ] ) ]  
        { FROM | TO } <database_principal> [ ,...n ]   
    [ CASCADE ]  
    [ AS <database_principal> ]  
*/


GRANT SELECT ON OBJECT :: "dbo"."countries" TO "student_test";﻿
REVOKE SELECT ON OBJECT :: "dbo"."countries" FROM "student_test";
GRANT SELECT ON OBJECT :: "dbo"."countries" TO "student_test";

/*
SELECT * from db_laba.dbo.regions_02_mbelko rm;
delete from db_laba.dbo.regions_02_mbelko;
insert into db_laba.dbo.regions_02_mbelko 
select * from db_laba.dbo.regions;
*/

GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT :: "dbo"."countries_02_mbelko" TO "student_test";
REVOKE SELECT, INSERT, UPDATE, DELETE ON OBJECT :: "dbo"."countries_02_mbelko" FROM "student_test";


GRANT REFERENCES ON OBJECT :: "dbo"."countries_02_mbelko"(country_id) TO "student_test";
REVOKE REFERENCES ON OBJECT :: "dbo"."countries_02_mbelko"(country_id) FROM "student_test";

--GRANT INSERT ON OBJECT :: "dbo"."Audit_DDL_Events" TO "student_test";

GRANT SELECT ON OBJECT :: "dbo"."countries_test_03_mbelko" TO "student_test";
REVOKE SELECT ON OBJECT :: "dbo"."countries_test_03_mbelko" FROM "student_test";

GRANT SELECT ON OBJECT :: "dbo"."countries_test_03_mbelko" TO "student_test" WITH GRANT OPTION;
REVOKE SELECT ON OBJECT :: "dbo"."countries_test_03_mbelko" FROM "student_test" CASCADE ;

select * from db_laba.dbo.countries_test_03_mbelko;

-- роли
ALTER ROLE db_ddladmin ADD MEMBER "student_test";
ALTER ROLE db_ddladmin DROP MEMBER "student_test";

GRANT UPDATE ON OBJECT :: "dbo"."countries_test_03_mbelko"(country_name) TO "student_test";
GRANT UPDATE ON OBJECT :: "dbo"."countries_test_03_mbelko" TO "student_test";
REVOKE UPDATE ON OBJECT :: "dbo"."countries_test_03_mbelko" FROM "student_test";

insert into countries_test_03_mbelko
select 0, 'Ukraine' UNION select 1, 'USA'

-- привелегии на схему
GRANT SELECT ON SCHEMA :: DBO TO student_test WITH GRANT OPTION;  
REVOKE SELECT ON SCHEMA :: DBO from student_test CASCADE;


﻿--
/* +-------------------------------------------------------+
 * | Использование представлений для фильтрации привилегий |
 * +-------------------------------------------------------+
 */
GRANT SELECT ON OBJECT :: "dbo"."customers_ny" TO "student_test";
REVOKE SELECT ON OBJECT :: "dbo"."customers_ny" FROM "student_test";
﻿


-- другие системные привелегии
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/grant-database-permissions-transact-sql?view=sql-server-ver15
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-database-permissions-transact-sql?view=sql-server-ver15


SELECT *
FROM  sys.database_permissions dperm;
    
SELECT *
FROM sys.database_principals dprinc
    INNER JOIN sys.database_permissions dperm
    ON dprinc.principal_id = dperm.grantee_principal_id
    WHERE --dprinc.name = 'lector' AND
    dperm.permission_name = 'CONNECT';
