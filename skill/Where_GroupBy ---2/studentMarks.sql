DROP DATABASE IF EXISTS student_marks_db;

CREATE DATABASE student_marks_db;

USE student_marks_db;

DROP TABLE IF EXISTS student_marks;

CREATE TABLE student_marks (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    marks DECIMAL(5,2)
);

INSERT INTO student_marks (roll_no, name, subject, marks) VALUES
(11, 'Chaitanya', 'Mathematics', 87.50),
(12, 'Arnav', 'Mathematics', 94.25),
(13, 'Mehul', 'Mathematics', 76.80),
(14, 'Ishita', 'Mathematics', 89.40),
(15, 'Varun', 'Mathematics', 81.75),
(16, 'Nikhil', 'Cloud Computing', 96.50),
(17, 'Aditya', 'Database Systems', 93.75),
(18, 'Meera', 'English', 97.10),
(19, 'Tanvi', 'Cloud Security', 99.20),
(20, 'Aarav', 'Azure', 83.35);

SELECT * FROM student_marks;

SELECT COUNT(*) AS total_students
FROM student_marks;

SELECT SUM(marks) AS total_marks
FROM student_marks;

SELECT AVG(marks) AS average_marks
FROM student_marks;

SELECT MAX(marks) AS highest_marks
FROM student_marks;

SELECT MIN(marks) AS lowest_marks
FROM student_marks;

SELECT * FROM student_marks
WHERE marks > 85;

SELECT * FROM student_marks
WHERE marks >= 90;

SELECT * FROM student_marks
WHERE marks < 80;

SELECT * FROM student_marks
WHERE marks BETWEEN 80 AND 90;

SELECT * FROM student_marks
WHERE name LIKE 'C%';

SELECT * FROM student_marks
WHERE name IN ('Chaitanya', 'Arnav', 'Varun');

SELECT * FROM student_marks
WHERE marks > 85
AND (subject = 'Mathematics' OR name LIKE 'C%');

UPDATE student_marks
SET marks = 91.00
WHERE roll_no = 13;

UPDATE student_marks
SET subject = 'Remedial Mathematics'
WHERE marks < 80;

DELETE FROM student_marks
WHERE roll_no = 15;

DELETE FROM student_marks
WHERE marks < 75;

SELECT * FROM student_marks
ORDER BY marks ASC;

SELECT * FROM student_marks
ORDER BY marks DESC;

SELECT * FROM student_marks
ORDER BY name ASC;

SELECT * FROM student_marks
ORDER BY name DESC;

SELECT subject, SUM(marks) AS total_marks
FROM student_marks
GROUP BY subject;

SELECT subject, AVG(marks) AS avg_marks
FROM student_marks
GROUP BY subject;

SELECT subject, COUNT(*) AS num_students
FROM student_marks
GROUP BY subject;

SELECT subject, AVG(marks) AS avg_marks
FROM student_marks
GROUP BY subject
HAVING AVG(marks) > 90;

SELECT subject, COUNT(*) AS num_students
FROM student_marks
GROUP BY subject
HAVING COUNT(*) > 1;