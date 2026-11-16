-- ============================================================
-- Lab 4 - Problem 1 : COMPANY database (DML = our rows)
-- Run:  mysql -u root -p < problem1_DML.sql
-- ============================================================
USE company;

-- 3 departments (managers are filled in later, after the employees exist)
-- Department 3 has NO employees.
INSERT INTO department (Dnumber, Dname, mgr_ssn, mgr_start_date) VALUES
(1, 'Engineering', NULL, NULL),
(2, 'Sales',       NULL, NULL),
(3, 'Research',    NULL, NULL);

-- 7 employees. A supervisor must be inserted BEFORE the people he or she supervises.
-- Ahmed has NO supervisor. Department 1 has 5 employees (more than 2).
INSERT INTO employee (ssn, fname, lname, bdate, address, gender, salary, super_ssn, Dno) VALUES
('111111111', 'Ahmed',   'Hassan', '1985-03-12', 'Alexandria', 'M', 8000.00, NULL,        1),
('222222222', 'Sara',    'Ali',    '1990-07-25', 'Alexandria', 'F', 5500.00, '111111111', 1),
('333333333', 'Omar',    'Khaled', '1992-11-02', 'Alexandria', 'M', 4500.00, '111111111', 1),
('444444444', 'Mona',    'Samir',  '1995-01-18', 'Alexandria', 'F', 2600.00, '222222222', 1),
('555555555', 'Youssef', 'Adel',   '1988-09-30', 'Giza',       'M', 2800.00, '111111111', 2),
('666666666', 'Laila',   'Nabil',  '1993-04-14', 'Cairo',      'F', 3200.00, '555555555', 2),
('777777777', 'Karim',   'Fathy',  '1991-12-05', 'Giza',       'M', 2900.00, '222222222', 1);

-- Now the managers
UPDATE department SET mgr_ssn = '111111111', mgr_start_date = '2020-01-01' WHERE Dnumber = 1;
UPDATE department SET mgr_ssn = '555555555', mgr_start_date = '2021-06-15' WHERE Dnumber = 2;

-- 4 projects. Project 4 has NOBODY working on it.
INSERT INTO project (Pnumber, Pname, Plocation, Dno) VALUES
(1, 'Website',        'Alexandria', 1),
(2, 'Database',       'Cairo',      1),
(3, 'Mobile App',     'Alexandria', 1),
(4, 'Research Study', 'Giza',       3);

-- 8 works_on rows. Sara (222222222) works on TWO projects (1 and 2).
INSERT INTO works_on (essn, Pno, hours) VALUES
('111111111', 1, 10),
('222222222', 1, 15),
('222222222', 2, 12),
('333333333', 2, 20),
('444444444', 3,  5),
('555555555', 3, 10),
('666666666', 1,  6),
('777777777', 2, 30);

-- 4 dependents
INSERT INTO dependent (essn, dependent_name, gender, bdate, relationship) VALUES
('111111111', 'Adam',    'M', '2012-09-01', 'Son'),
('222222222', 'Nour',    'F', '2015-05-10', 'Daughter'),
('333333333', 'Hana',    'F', '2018-01-20', 'Daughter'),
('555555555', 'Mariam',  'F', '2020-03-03', 'Daughter');
