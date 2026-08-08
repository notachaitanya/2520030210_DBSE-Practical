CREATE DATABASE IF NOT EXISTS bookflow_db;
USE bookflow_db;
CREATE TABLE members (
 member_id INT AUTO_INCREMENT PRIMARY KEY,
 full_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE
);
CREATE TABLE books (
 book_id INT AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(255) NOT NULL,
 isbn VARCHAR(13) NOT NULL UNIQUE,
 published_year INT,
 CONSTRAINT chk_published_year CHECK (published_year < 2027)
);
INSERT INTO books (title, isbn, published_year)
VALUES ('Database Management System', '9780133970777', 2023);

INSERT INTO books (title, isbn, published_year)
VALUES ('The Alchemist', '9780061122415', 1988);

INSERT INTO books (title, isbn, published_year)
VALUES ('Harry Potter', '9780747532743', 1997);

INSERT INTO books (title, isbn, published_year)
VALUES ('Atomic Habits', '9780735211292', 2018);

INSERT INTO members (full_name, email)
VALUES ('Chaitanya Kondapalli', 'chaitanya@gmail.com');
INSERT INTO books (title, isbn, published_year)
VALUES ('Another Book', '9780133970777', 2024);
INSERT INTO books (title, isbn, published_year)
VALUES ('Future Book', '1234567890123', 2030);
select * from members;
