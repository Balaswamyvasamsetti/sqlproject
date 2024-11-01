CREATE DATABASE college;
USE college;
CREATE TABLE students ( student_id INT PRIMARY KEY, student_name VARCHAR(50)
);
CREATE TABLE friends ( student_id INT, friend_id INT,
FOREIGN KEY (student_id) REFERENCES students(student_id), FOREIGN KEY (friend_id) REFERENCES students(student_id)
);
CREATE TABLE package ( salary INT,
student_id INT,
FOREIGN KEY (student_id) REFERENCES students(student_id)
);
INSERT INTO students (student_id, student_name) 
VALUES (1, 'Balaswamy'),
(2, 'chandu'),
(3, 'sabareesh'),
(4, 'eswar'),
(5, 'santosh');
SELECT *from students;
INSERT INTO friends (student_id, friend_id) VALUES (1, 2),
(5, 3),
(4, 1),
(3, 4),
(2, 5);
SELECT * FROM friends;
INSERT INTO package (salary, student_id) VALUES (60000, 3),
(90000, 1),
(80000, 5),
(78000, 2),
(85000, 4);
SELECT * FROM package;
SELECT S1.student_name AS Student_Name, S2.student_name AS Best_Friend_Name, P2.salary AS Best_Friend_Salary
FROM students S1
JOIN friends F ON S1.student_id = F.student_id JOIN students S2 ON F.friend_id = S2.student_id JOIN package P1 ON S1.student_id = P1.student_id JOIN package P2 ON S2.student_id = P2.student_id WHERE P2.salary > P1.salary
ORDER BY P2.salary ASC;
