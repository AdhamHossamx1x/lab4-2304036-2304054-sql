-- ============================================================
-- Lab 4 - Problem 2 : LIBRARY database (DDL)
-- Run:  mysql -u root -p < problem2_DDL.sql
-- It can be re-run any time (it drops the database first).
-- ============================================================
DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

CREATE TABLE author (
    author_id INT          NOT NULL,
    name      VARCHAR(60)  NOT NULL,
    country   VARCHAR(40)  NULL,
    PRIMARY KEY (author_id)
) ENGINE=InnoDB;

CREATE TABLE publisher (
    publisher_id INT          NOT NULL,
    name         VARCHAR(60)  NOT NULL,
    country      VARCHAR(40)  NULL,
    PRIMARY KEY (publisher_id)
) ENGINE=InnoDB;

CREATE TABLE category (
    category_id INT          NOT NULL,
    name        VARCHAR(40)  NOT NULL,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB;

CREATE TABLE book (
    book_id      INT           NOT NULL,
    title        VARCHAR(100)  NOT NULL,
    price        DECIMAL(8,2)  NOT NULL,
    publish_year INT           NULL,
    author_id    INT           NOT NULL,
    publisher_id INT           NOT NULL,
    category_id  INT           NOT NULL,
    PRIMARY KEY (book_id),
    -- when an author is deleted, all the books of that author are deleted too
    FOREIGN KEY (author_id)    REFERENCES author (author_id)       ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id),
    FOREIGN KEY (category_id)  REFERENCES category (category_id)
) ENGINE=InnoDB;

CREATE TABLE member (
    member_id INT          NOT NULL,
    name      VARCHAR(60)  NOT NULL,
    email     VARCHAR(80)  NULL,
    join_date DATE         NULL,
    PRIMARY KEY (member_id)
) ENGINE=InnoDB;

CREATE TABLE loan (
    loan_id     INT   NOT NULL,
    book_id     INT   NOT NULL,
    member_id   INT   NOT NULL,
    loan_date   DATE  NOT NULL,
    return_date DATE  NULL,            -- NULL while the book is still borrowed
    PRIMARY KEY (loan_id),
    -- when a book is deleted, its loans are deleted too
    FOREIGN KEY (book_id)   REFERENCES book (book_id)     ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member (member_id)
) ENGINE=InnoDB;
