USE [master];
CREATE LOGIN [student_test] WITH PASSWORD=N'student_test',
DEFAULT_DATABASE=[db_laba], CHECK_EXPIRATION=ON, CHECK_POLICY=ON;
-- DROP LOGIN [student_test]
USE [db_laba];
CREATE USER [student_test] FOR LOGIN [student_test] WITH DEFAULT_SCHEMA=[dbo];
USE [db_laba];
DROP USER [student_test]