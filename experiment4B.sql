create database Interview; use Interview;
CREATE TABLE Contests ( contest_id INT PRIMARY KEY, hacker_id INT,
name VARCHAR(100)
);
CREATE TABLE Colleges ( college_id INT PRIMARY KEY, contest_id INT,
FOREIGN KEY (contest_id) REFERENCES Contests(contest_id)
);
CREATE TABLE Challenges ( challenge_id INT PRIMARY KEY, college_id INT,
FOREIGN KEY (college_id) REFERENCES Colleges(college_id)
);
CREATE TABLE Submission_Stats ( challenge_id INT, total_submissions INT, total_accepted_submissions INT,
FOREIGN KEY (challenge_id) REFERENCES Challenges(challenge_id)
);
CREATE TABLE View_Stats ( challenge_id INT, total_views INT, total_unique_views INT,
FOREIGN KEY (challenge_id) REFERENCES Challenges(challenge_id)
);
INSERT INTO Contests (contest_id, hacker_id, name) VALUES
(1, 3001, 'Hackathon Sprint 1'),
(2, 3002, 'Algorithm Duel 2'),
(3, 3003, 'Data Structures Clash 3');
select *from Contests;
INSERT INTO Colleges (college_id, contest_id) VALUES
(301, 1),
(302, 1),
(303, 2),
(304, 3);
select *from Colleges;
INSERT INTO Challenges (challenge_id, college_id) VALUES
(3001, 301),
(3002, 302),
(3003, 303),
(3004, 304);
select *from Challenges;
INSERT INTO Submission_Stats (challenge_id, total_submissions, total_accepted_submissions) VALUES
(3001, 200, 100),
(3002, 110, 55),
(3003, 140, 70),
(3004, 90, 45);
select *from Submission_Stats;
INSERT INTO View_Stats (challenge_id, total_views, total_unique_views) VALUES
(3001, 600, 400),
(3002, 500, 350),
(3003, 700, 500),
(3004, 450, 300);
select *from View_Stats;
SELECT
c.contest_id, c.hacker_id, c.name,
SUM(s.total_submissions) AS total_submissions, SUM(s.total_accepted_submissions) AS total_accepted_submissions, SUM(v.total_views) AS total_views,
SUM(v.total_unique_views) AS total_unique_views FROM
Contests c JOIN
Colleges col ON c.contest_id = col.contest_id JOIN
Challenges ch ON col.college_id = ch.college_id LEFT JOIN
Submission_Stats s ON ch.challenge_id = s.challenge_id LEFT JOIN
View_Stats v ON ch.challenge_id = v.challenge_id GROUP BY
c.contest_id, c.hacker_id, c.name ORDER BY
c.contest_id;
