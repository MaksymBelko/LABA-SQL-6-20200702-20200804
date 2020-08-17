/* 1. Вставьте строку со всеми колонками в таблицу employees_test_student используя перечисление колонок и их конкретные значение.
Напишите запрос для проверки
Примечание: используйте произвольные значение (4 балла)*/

INSERT
	INTO
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
VALUES(999,
N'Антон',
N'Богомолов',
'ab@mail.com',
'777-777-777',
CAST('2019-08-12' as date),
1,
'Analyst',
'a.bogomolov');

--Проверочный запрос
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'


/* Тут я пробовал функию DELETE. После заново делал INSERT
DELETE 
FROM db_laba.dbo.employees_test_student 
WHERE 
student_name = 'a.bogomolov'
*/


/*2. Выведите из таблицы employees все строки для должности Accountant и вставьте результат в таблицу employees_test_student.
Напишите запрос для проверки (4 балла)*/

INSERT
	into
	db_laba.dbo.employees_test_student (employee_id,
	first_name,
	last_name,
	email,
	phone,
	hire_date,
	manager_id,
	job_title,
	student_name)
SELECT
	e.employee_id,
	e.first_name,
	e.last_name,
	e.email,
	e.phone,
	e.hire_date,
	e.manager_id,
	e.job_title,
	'a.bogomolov'
FROM
	db_laba.dbo.employees e
WHERE
	e.job_title = 'Accountant' 

--Проверочный запрос
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov' and t.job_title = 'Accountant'
--Проверочный запрос (все строки. Фильтр только по созданным)
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'

/* Ниже маленький запрос, которым просто проверяю строки для всех Accountant из таблицы employees, которые должны попасть в результат
SELECT *
FROM
db_laba.dbo.employees e
WHERE e.job_title = 'Accountant'
*/

/*3. Поднимите в верхний регистр колонку employees_test_student.first_name.
Напишите запрос для проверки (4 балла) */
UPDATE
	db_laba.dbo.employees_test_student
SET
	first_name = UPPER(first_name)
WHERE student_name = 'a.bogomolov';

--Проверочный запрос 
SELECT t.first_name from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'
--Проверочный запрос (все строки. Фильтр только по созданным)
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'

/*4. Обновите колонку employees_test_student.email таким образом, чтобы остался только домен (пример: sample@cool.com => cool.com) для всех сотрудников длина фамилии которых до 5 символов включительно.
Напишите запрос для проверки (4 балла)*/

UPDATE
	db_laba.dbo.employees_test_student
SET
	email = SUBSTRING(email, CHARINDEX('@', email)+ 1, LEN(email))  
-- здесь с помощью SUBSTRING вырезаю только то, что требуется, используя CHARINDEX для поиска первого символа после разделителя @. А LEN берем, чтобы указать что нужны все символы до конца.
WHERE
	student_name = 'a.bogomolov'
	AND LEN(last_name) <= 5;

--Проверочный запрос
SELECT email, SUBSTRING(email, CHARINDEX('@', email)+ 1, LEN(email)) as domen
FROM
	db_laba.dbo.employees_test_student t
WHERE
	t.student_name = 'a.bogomolov'
	AND LEN(t.last_name) <= 5;
--Проверочный запрос (все строки. Фильтр только по созданным)
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'

/* Ниже маленький запрос, которым проверял строки, которые должны были измениться в результате выполнения задания
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov' AND LEN(last_name) <= 5  --- RYAN Gray и ELLIOT James подходят под такой фильтр
*/

/*5. Удалите строки из таблицы employees_test_student для сотрудников в телефоне которых цифра 2 встречается только два раза напишите запрос для проверки (4 балла)*/

DELETE
FROM
	db_laba.dbo.employees_test_student
WHERE
	student_name = 'a.bogomolov' AND (LEN(phone) - LEN(REPLACE(phone, '2', '')) = 2)

--Проверочный запрос (выдаёт пусто). Значит, строка удалена
SELECT *
FROM
	db_laba.dbo.employees_test_student t
WHERE
	student_name = 'a.bogomolov' AND (LEN(phone) - LEN(REPLACE(phone, '2', '')) = 2)
--Проверочный запрос (все строки. Фильтр только по созданным)
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov'

/* Ниже маленький запрос, которым проверял строки, которые должны были быть удалены в результате выполнения задания
SELECT * from db_laba.dbo.employees_test_student t
WHERE t.student_name = 'a.bogomolov' AND (LEN(phone) - LEN(REPLACE(phone, '2', '')) = 2)  -- TYLER Ramirez подходит под такой фильтр
*/


/*6* Подсчитать количесво букв о в слове молоко*/

SELECT LEN(N'молоко') - LEN(REPLACE(N'молоко', N'о', '')) as количество_букв_о_в_слове_молоко