DROP DATABASE IF EXISTS joins_set_db;

CREATE DATABASE joins_set_db;

USE joins_set_db;

CREATE TABLE student_class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE student_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO student_class VALUES
(11,'Chaitanya'),
(12,'Arjun'),
(14,'Karthik');

INSERT INTO student_info VALUES
(11,'HYDERABAD'),
(12,'BENGALURU'),
(13,'PUNE');

SELECT *
FROM student_class
CROSS JOIN student_info;

DROP TABLE student_class;
DROP TABLE student_info;

CREATE TABLE student_class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE student_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO student_class VALUES
(11,'Chaitanya'),
(12,'Arjun'),
(13,'Karthik'),
(14,'Rohan');

INSERT INTO student_info VALUES
(11,'HYDERABAD'),
(12,'BENGALURU'),
(13,'PUNE');

SELECT *
FROM student_class
INNER JOIN student_info
ON student_class.id = student_info.id;

SELECT student_class.name,
       student_info.address
FROM student_class
INNER JOIN student_info
ON student_class.id = student_info.id;

SELECT *
FROM student_class
NATURAL JOIN student_info;

INSERT INTO student_class VALUES
(15,'Varun');

INSERT INTO student_info VALUES
(17,'CHENNAI'),
(18,'MYSORE');

SELECT *
FROM student_class
LEFT OUTER JOIN student_info
ON student_class.id = student_info.id;

SELECT *
FROM student_class
LEFT JOIN student_info
ON student_class.id = student_info.id
WHERE student_info.id IS NULL;

SELECT *
FROM student_class
RIGHT OUTER JOIN student_info
ON student_class.id = student_info.id;

SELECT *
FROM student_class
RIGHT JOIN student_info
ON student_class.id = student_info.id
WHERE student_class.id IS NULL;

SELECT *
FROM student_class
LEFT JOIN student_info
ON student_class.id = student_info.id

UNION

SELECT *
FROM student_class
RIGHT JOIN student_info
ON student_class.id = student_info.id;

SELECT *
FROM student_class
LEFT JOIN student_info
ON student_class.id = student_info.id
WHERE student_info.id IS NULL

UNION

SELECT *
FROM student_class
RIGHT JOIN student_info
ON student_class.id = student_info.id
WHERE student_class.id IS NULL;

CREATE TABLE first_group (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE second_group (
    id INT,
    name VARCHAR(30)
);

INSERT INTO first_group VALUES
(21,'Neha'),
(22,'Rahul');

INSERT INTO second_group VALUES
(22,'Rahul'),
(23,'Sanjay');

SELECT * FROM first_group
UNION
SELECT * FROM second_group;

SELECT name FROM first_group
UNION
SELECT name FROM second_group;

SELECT * FROM first_group
UNION ALL
SELECT * FROM second_group;

SELECT COUNT(*)
FROM
(
    SELECT * FROM first_group
    UNION ALL
    SELECT * FROM second_group
) AS A;

SELECT * FROM first_group
WHERE (id, name) IN (
    SELECT id, name FROM second_group
);

SELECT name FROM first_group
WHERE name IN (
    SELECT name FROM second_group
);

SELECT * FROM first_group
WHERE (id, name) NOT IN (
    SELECT id, name FROM second_group
);

SELECT name FROM first_group
WHERE name NOT IN (
    SELECT name FROM second_group
);

SELECT sc.id,
       sc.name,
       si.address
FROM student_class sc
INNER JOIN student_info si
ON sc.id = si.id;

SELECT sc.id,
       sc.name,
       CASE
           WHEN si.address IS NULL
           THEN 'Address Missing'
           ELSE 'Address Available'
       END AS Status
FROM student_class sc
LEFT JOIN student_info si
ON sc.id = si.id;