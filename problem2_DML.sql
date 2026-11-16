-- ============================================================
-- Lab 4 - Problem 2 : LIBRARY database (seed data)
-- Run:  mysql -u root -p < problem2_DML.sql
-- ============================================================
USE library;

-- 5 authors: two from Egypt, two from the UK, and author 5 has NO books
INSERT INTO author (author_id, name, country) VALUES
(1, 'Naguib Mahfouz',      'Egypt'),
(2, 'Ahmed Khaled Tawfik', 'Egypt'),
(3, 'Jane Austen',         'UK'),
(4, 'George Orwell',       'UK'),
(5, 'Haruki Murakami',     'Japan');

-- 3 publishers: Dar Al Shorouk (Egypt) and Penguin Books (UK) have the same country as some authors
INSERT INTO publisher (publisher_id, name, country) VALUES
(1, 'Dar Al Shorouk', 'Egypt'),
(2, 'Penguin Books',  'UK'),
(3, 'Vintage',        'USA');

-- 3 categories
INSERT INTO category (category_id, name) VALUES
(1, 'Novel'),
(2, 'Science Fiction'),
(3, 'History');

-- 10 books. Book 2 (17.00) and book 6 (18.00) are priced between 15 and 20.
-- Book 10 is NEVER borrowed. Mahfouz wrote 3 books, Orwell 3, Tawfik 2.
INSERT INTO book (book_id, title, price, publish_year, author_id, publisher_id, category_id) VALUES
(1,  'Cairo Trilogy',            22.50, 1956, 1, 1, 1),
(2,  'Children of the Alley',    17.00, 1959, 1, 1, 1),
(3,  'Midaq Alley',              12.00, 1947, 1, 1, 1),
(4,  'Utopia',                   14.00, 2008, 2, 1, 2),
(5,  'Pride and Prejudice',       9.50, 1813, 3, 2, 1),
(6,  'Emma',                     18.00, 1815, 3, 2, 1),
(7,  'Nineteen Eighty-Four',     13.00, 1949, 4, 2, 2),
(8,  'Animal Farm',               8.00, 1945, 4, 3, 1),
(9,  'The History of Egypt',     25.00, 2001, 2, 1, 3),
(10, 'The Road to Wigan Pier',   10.00, 1937, 4, 3, 3);

-- 5 members. Member 5 has NO loans.
INSERT INTO member (member_id, name, email, join_date) VALUES
(1, 'Mona Samir',   'mona@example.com',   '2026-01-10'),
(2, 'Karim Fathy',  'karim@example.com',  '2026-02-15'),
(3, 'Sara Ali',     'sara@example.com',   '2026-03-20'),
(4, 'Omar Khaled',  'omar@example.com',   '2026-04-05'),
(5, 'Laila Nabil',  'laila@example.com',  '2026-05-12');

-- 12 loans. Loans 8 and 10 are NOT returned yet (return_date is NULL).
INSERT INTO loan (loan_id, book_id, member_id, loan_date, return_date) VALUES
(1,  1, 1, '2026-09-01', '2026-09-10'),
(2,  1, 2, '2026-09-05', '2026-09-15'),
(3,  2, 1, '2026-09-12', '2026-09-20'),
(4,  3, 3, '2026-09-14', '2026-09-25'),
(5,  1, 3, '2026-10-01', '2026-10-08'),
(6,  4, 2, '2026-10-03', '2026-10-12'),
(7,  5, 4, '2026-10-05', '2026-10-14'),
(8,  7, 1, '2026-10-10', NULL),
(9,  7, 4, '2026-10-15', '2026-10-22'),
(10, 8, 2, '2026-10-20', NULL),
(11, 9, 3, '2026-10-25', '2026-11-02'),
(12, 2, 1, '2026-11-01', '2026-11-09');
