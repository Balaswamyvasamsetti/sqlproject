create database place; use place;
CREATE TABLE station( id INT PRIMARY KEY,
city varchar(30), state varchar(30), LAT_N FLOAT(30),
LONG_N FLOAT(20)
);
INSERT INTO station(id,city,state,lat_n,long_n) values (1, "Mumbai","Maharashtra", 3423,2367),
(2, "vijyawada","Andhra Pradesh", 3456,5674),
(3, "chennai","Tamil nadu", 4536,5987),
(4, "Kollam","kerala", 4785,5631),
(5, "Bengaluru","karnataka",4795,6743),
(6, "Guwahati","Assam", 3123,3498),
(7, "Hyderabad","Telanagana", 3423,2367),
(8, "New Delhi","New Delhi", 4356,6374); 
select *from station;
SELECT city, length(city) as city_length from station order by length (city) Desc,city limit 1;
SELECT city, length(city) as city_length from station order by length (city) asc,city limit 1;
SELECT city, city_length FROM (
SELECT city, LENGTH(city) AS city_length FROM station
ORDER BY city_length DESC, city LIMIT 1
) AS longest UNION ALL
SELECT city, city_length FROM (
SELECT city, LENGTH(city) AS city_length FROM station
ORDER BY city_length ASC, city LIMIT 1
) AS shortest;
