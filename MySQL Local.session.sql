-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS company_hierarchy;

-- Use the created database
USE company_hierarchy;

-- Create the company table
CREATE TABLE company (
    company_code VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(20),
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

-- Insert sample data into the company table
INSERT INTO company (company_code, company_name, founder) VALUES 
('C1', 'Microsoft', 'Durga Reddy'),
('C2', 'Google', 'Sharma'),
('C10', 'J P Morgan', 'Pankaj'),
('C9', 'Netflix', 'Manishankar');

-- Select all records from the company table to verify
SELECT * FROM company;
