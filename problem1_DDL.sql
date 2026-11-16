-- ============================================================
-- Lab 4 - Problem 1 : COMPANY database (DDL)
-- Run:  mysql -u root -p < problem1_DDL.sql
-- It can be re-run any time (it drops the database first).
-- ============================================================
DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

-- DEPARTMENT is created first, WITHOUT the manager foreign key,
-- because EMPLOYEE does not exist yet (department and employee point to each other).
CREATE TABLE department (
    Dnumber        INT          NOT NULL,
    Dname          VARCHAR(30)  NOT NULL,
    mgr_ssn        CHAR(9)      NULL,          -- may be NULL
    mgr_start_date DATE         NULL,
    PRIMARY KEY (Dnumber),
    UNIQUE (Dname)
) ENGINE=InnoDB;

CREATE TABLE employee (
    ssn        CHAR(9)       NOT NULL,
    fname      VARCHAR(30)   NOT NULL,
    lname      VARCHAR(30)   NOT NULL,
    bdate      DATE          NULL,
    address    VARCHAR(100)  NULL,
    gender     CHAR(1)       NULL,
    salary     DECIMAL(10,2) NULL,
    super_ssn  CHAR(9)       NULL,             -- may be NULL (no supervisor)
    Dno        INT           NULL,
    PRIMARY KEY (ssn),
    FOREIGN KEY (super_ssn) REFERENCES employee (ssn),
    FOREIGN KEY (Dno)       REFERENCES department (Dnumber)
) ENGINE=InnoDB;

-- Now EMPLOYEE exists, so we can add the manager foreign key.
ALTER TABLE department
    ADD CONSTRAINT fk_department_manager
    FOREIGN KEY (mgr_ssn) REFERENCES employee (ssn);

CREATE TABLE project (
    Pnumber   INT          NOT NULL,
    Pname     VARCHAR(30)  NOT NULL,
    Plocation VARCHAR(30)  NULL,
    Dno       INT          NOT NULL,
    PRIMARY KEY (Pnumber),
    FOREIGN KEY (Dno) REFERENCES department (Dnumber)
) ENGINE=InnoDB;

CREATE TABLE works_on (
    essn   CHAR(9)      NOT NULL,
    Pno    INT          NOT NULL,
    hours  DECIMAL(5,1) NOT NULL DEFAULT 0,
    PRIMARY KEY (essn, Pno),                   -- composite primary key
    FOREIGN KEY (essn) REFERENCES employee (ssn),
    FOREIGN KEY (Pno)  REFERENCES project (Pnumber)
) ENGINE=InnoDB;

CREATE TABLE dependent (
    essn            CHAR(9)     NOT NULL,
    dependent_name  VARCHAR(30) NOT NULL,
    gender          CHAR(1)     NULL,
    bdate           DATE        NULL,
    relationship    VARCHAR(20) NULL,
    PRIMARY KEY (essn, dependent_name),        -- composite primary key
    FOREIGN KEY (essn) REFERENCES employee (ssn)
) ENGINE=InnoDB;
