-- Create the database
CREATE DATABASE IF NOT EXISTS company_hierarchy; 
USE company_hierarchy;

-- Create the company table
CREATE TABLE company (
    company_code VARCHAR(10) PRIMARY KEY, 
    company_name VARCHAR(50), 
    founder VARCHAR(100) NOT NULL
);

-- Create the Lead_Manager table
CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR(10) PRIMARY KEY, 
    company_code VARCHAR(10),
    FOREIGN KEY (company_code) REFERENCES company(company_code)
);

-- Create the Senior_Manager table
CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR(10) PRIMARY KEY, 
    lead_manager_code VARCHAR(10), 
    company_code VARCHAR(10),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES company(company_code)
);

-- Create the Manager table
CREATE TABLE Manager (
    manager_code VARCHAR(10) PRIMARY KEY, 
    senior_manager_code VARCHAR(10), 
    lead_manager_code VARCHAR(10), 
    company_code VARCHAR(10),
    FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES company(company_code)
);

-- Create the Employee table
CREATE TABLE Employee (
    employee_code VARCHAR(10) PRIMARY KEY, 
    manager_code VARCHAR(10), 
    senior_manager_code VARCHAR(10), 
    lead_manager_code VARCHAR(10), 
    company_code VARCHAR(10),
    FOREIGN KEY (manager_code) REFERENCES Manager(manager_code), 
    FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES company(company_code)
);

-- Insert records into the company table
INSERT INTO company (company_code, company_name, founder) VALUES  
    ('C1', 'Tech Innovators', 'Bala Swamy'), 
    ('C2', 'Future Solutions', 'Chandu'), 
    ('C3', 'Creative Tech', 'Sabareesh'), 
    ('C4', 'Visionary Enterprises', 'Eswar');

-- Insert records into the Lead_Manager table
INSERT INTO Lead_Manager (lead_manager_code, company_code) VALUES 
    ('LM1', 'C1'),
    ('LM2', 'C2'),
    ('LM3', 'C3'), 
    ('LM4', 'C4');

INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) 
VALUES 
    ('SM1', 'LM1', 'C1'), 
    ('SM2', 'LM1', 'C1'), 
    ('SM3', 'LM2', 'C2'), 
    ('SM4', 'LM3', 'C3'),
    ('SM5', 'LM4', 'C4'); 
SELECT * FROM Senior_Manager;
INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('M1', 'SM1', 'LM1', 'C1'),
('M2', 'SM3', 'LM2', 'C2'),
('M3', 'SM3', 'LM2', 'C2'),
('M4', 'SM4', 'LM3', 'C3'),
('M5', 'SM5', 'LM4', 'C4');
SELECT * FROM Manager;

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES
('E1', 'M1', 'SM1', 'LM1', 'C1'),
('E2', 'M1', 'SM1', 'LM1', 'C1'),
('E3', 'M2', 'SM3', 'LM2', 'C2'),
('E4', 'M3', 'SM3', 'LM2', 'C2'),
('E5', 'M4', 'SM4', 'LM3', 'C3'),
('E6', 'M4', 'SM4', 'LM3', 'C3'),
('E7', 'M5', 'SM5', 'LM4', 'C4');
SELECT * FROM Employee;
SELECT
c.company_code, c.company_name, c.founder,
COUNT(DISTINCT lm.lead_manager_code) AS total_lead_managers, COUNT(DISTINCT sm.senior_manager_code) AS total_senior_managers, COUNT(DISTINCT m.manager_code) AS total_managers, COUNT(DISTINCT e.employee_code) AS total_employees
FROM
company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Employee m ON c.company_code = m.company_code 
LEFT JOIN Employee e ON c.company_code = e.company_code 
GROUP BY
c.company_code, c.founder ORDER BY
c.company_code ASC;
