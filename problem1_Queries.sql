-- ============================================================
-- Lab 4 - Problem 1 : the SQL of Q1.1 - Q1.12
-- This file is used to BUILD problem1_Answers.txt (see README.md):
--   mysql -u root -p --table -vvv --force --comments company < problem1_Queries.sql > problem1_Answers.txt 2>&1
-- (-vvv  = print every statement + its output, --force = keep going after an error)
-- Run problem1_DDL.sql and problem1_DML.sql first.
-- ============================================================
USE company;

-- ################ A. CHANGE THE DATA ################

-- ---------- Q1.1 INSERT ----------
SELECT 'Q1.1  INSERT a new employee and a new project' AS question;
INSERT INTO employee (ssn, fname, lname, bdate, address, gender, salary, super_ssn, Dno)
VALUES ('888888888', 'Hadeer', 'Mostafa', '1996-02-20', 'Alexandria', 'F', 3000.00, '555555555', 2);

INSERT INTO project (Pnumber, Pname, Plocation, Dno)
VALUES (5, 'Marketing Plan', 'Alexandria', 2);

SELECT * FROM employee WHERE ssn = '888888888';
SELECT * FROM project  WHERE Pnumber = 5;

SELECT 'Q1.1  Insert an employee whose Dno does not exist (expected: ERROR 1452)' AS question;
INSERT INTO employee (ssn, fname, lname, bdate, address, gender, salary, super_ssn, Dno)
VALUES ('999999999', 'Test', 'Person', '1999-01-01', 'Cairo', 'M', 3000.00, NULL, 99);
SELECT 'ANSWER: MySQL refuses the row (ERROR 1452, foreign key fails) because department 99 does not exist. Nothing is inserted.' AS answer;

-- ---------- Q1.2 UPDATE ----------
SELECT 'Q1.2 (a) 10% raise for every employee of department 2' AS question;
UPDATE employee SET salary = salary * 1.10 WHERE Dno = 2;
SELECT ssn, fname, lname, salary FROM employee WHERE Dno = 2;

SELECT 'Q1.2 (b) change the location of project 4' AS question;
UPDATE project SET Plocation = 'Cairo' WHERE Pnumber = 4;
SELECT * FROM project WHERE Pnumber = 4;

SELECT 'Q1.2 (c) move an employee to a department that does not exist (expected: ERROR 1452)' AS question;
UPDATE employee SET Dno = 99 WHERE ssn = '666666666';
SELECT 'ANSWER: MySQL refuses the update (ERROR 1452). The employee keeps the old Dno, because a foreign key must point to an existing department.' AS answer;

-- ---------- Q1.3 DELETE ----------
SELECT 'Q1.3 (a) delete one dependent and one works_on row' AS question;
DELETE FROM dependent WHERE essn = '333333333' AND dependent_name = 'Hana';
DELETE FROM works_on  WHERE essn = '666666666' AND Pno = 1;
SELECT * FROM dependent;
SELECT * FROM works_on;

SELECT 'Q1.3 (b) delete department 2 that still has employees (expected: ERROR 1451)' AS question;
DELETE FROM department WHERE Dnumber = 2;
SELECT 'ANSWER: ERROR 1451. The department is still used by employees (and by project 5), so MySQL protects the data.' AS answer;

SELECT 'Q1.3 (b) the right order (done inside a transaction and rolled back, so the data stays for the next questions)' AS question;
START TRANSACTION;
-- 1) the employees of the department must go to another department (or be deleted)
UPDATE employee SET Dno = 1 WHERE Dno = 2;
-- 2) the projects of the department must be deleted (or moved)
DELETE FROM project WHERE Dno = 2;
-- 3) now nothing points to department 2 and it can be deleted
DELETE FROM department WHERE Dnumber = 2;
SELECT * FROM department;
ROLLBACK;
SELECT * FROM department;

SELECT 'Q1.3 (c) DELETE without WHERE inside a transaction, then ROLLBACK' AS question;
START TRANSACTION;
DELETE FROM dependent;
SELECT * FROM dependent;
ROLLBACK;
SELECT * FROM dependent;
SELECT 'ANSWER: DELETE without WHERE removed ALL the rows of dependent (the SELECT inside the transaction is empty). ROLLBACK cancelled it, so all the rows are back.' AS answer;

-- ################ B. SEARCH THE DATA ################

-- ---------- Q1.4 WHERE, DISTINCT ----------
SELECT 'Q1.4 (a) salary between 3000 and 6000, living in Alexandria, highest salary first' AS question;
SELECT fname, lname, salary
FROM employee
WHERE salary BETWEEN 3000 AND 6000
  AND address LIKE '%Alexandria%'
ORDER BY salary DESC;

SELECT 'Q1.4 (b) employees with no supervisor' AS question;
SELECT ssn, fname, lname FROM employee WHERE super_ssn IS NULL;

SELECT 'Q1.4 (c) department numbers that have at least one employee, each once' AS question;
SELECT DISTINCT Dno FROM employee;

-- ---------- Q1.5 Aggregation ----------
SELECT 'Q1.5 count, total, average, smallest and largest salary' AS question;
SELECT COUNT(*)    AS employees,
       SUM(salary) AS total_salary,
       AVG(salary) AS average_salary,
       MIN(salary) AS smallest_salary,
       MAX(salary) AS largest_salary
FROM employee;

-- ---------- Q1.6 GROUP BY ----------
SELECT 'Q1.6 employees and average salary of each department' AS question;
SELECT Dno, COUNT(*) AS employees, AVG(salary) AS average_salary
FROM employee
GROUP BY Dno;

-- ---------- Q1.7 HAVING ----------
SELECT 'Q1.7 (a) departments with more than 2 employees' AS question;
SELECT Dno, COUNT(*) AS employees
FROM employee
GROUP BY Dno
HAVING COUNT(*) > 2;

SELECT 'Q1.7 (b) same, but count only employees with salary above 3000' AS question;
SELECT Dno, COUNT(*) AS employees
FROM employee
WHERE salary > 3000
GROUP BY Dno
HAVING COUNT(*) > 2;
SELECT 'ANSWER: WHERE filters single rows BEFORE grouping (cannot use COUNT/SUM), HAVING filters whole groups AFTER grouping (can use COUNT/SUM).' AS answer;

-- ---------- Q1.8 JOIN ----------
SELECT 'Q1.8 full name of every employee with his or her department name' AS question;
SELECT CONCAT(e.fname, ' ', e.lname) AS full_name, d.Dname
FROM employee e
JOIN department d ON e.Dno = d.Dnumber;

-- ---------- Q1.9 JOIN of three tables ----------
SELECT 'Q1.9 every works_on row: employee last name, project name, hours' AS question;
SELECT e.lname, p.Pname, w.hours
FROM works_on w
JOIN employee e ON w.essn = e.ssn
JOIN project  p ON w.Pno  = p.Pnumber;

-- ---------- Q1.10 LEFT JOIN ----------
SELECT 'Q1.10 (a) every department with its number of employees (also 0)' AS question;
SELECT d.Dnumber, d.Dname, COUNT(e.ssn) AS employees
FROM department d
LEFT JOIN employee e ON e.Dno = d.Dnumber
GROUP BY d.Dnumber, d.Dname;

SELECT 'Q1.10 (b) projects that nobody works on' AS question;
SELECT p.Pnumber, p.Pname
FROM project p
LEFT JOIN works_on w ON w.Pno = p.Pnumber
WHERE w.essn IS NULL;

-- ---------- Q1.11 Self join ----------
SELECT 'Q1.11 every employee with the name of his or her supervisor' AS question;
SELECT CONCAT(e.fname, ' ', e.lname) AS employee,
       CONCAT(s.fname, ' ', s.lname) AS supervisor
FROM employee e
LEFT JOIN employee s ON e.super_ssn = s.ssn;

-- ---------- Q1.12 JOIN + GROUP BY + HAVING ----------
SELECT 'Q1.12 projects with more than 20 total hours, largest first' AS question;
SELECT p.Pname, SUM(w.hours) AS total_hours
FROM project p
JOIN works_on w ON w.Pno = p.Pnumber
GROUP BY p.Pnumber, p.Pname
HAVING SUM(w.hours) > 20
ORDER BY total_hours DESC;
