CREATE DATABASE IF NOT EXISTS PIAL052_DSD;
USE PIAL052_DSD;

-- Drop the table if it already exists to avoid errors
DROP TABLE IF EXISTS Staff;

CREATE TABLE Staff (
    StaffID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    DOB DATE,
    IsActive BOOLEAN DEFAULT TRUE
);
-- Exercise 1.1: Insert a single record
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');
-- Exercise 1.2: Insert multiple records
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES 
('S002', 'Sarah', 'Johnson', 'Analyst', 30000, '1985-08-20'),
('S003', 'Peter', 'Miller', 'Trainee', 20000, '1995-11-10'),
('S004', 'Emma', 'Davis', 'Developer', 40000, '1988-02-14'),
('S005', 'David', 'Wilson', 'Analyst', 32000, '1990-07-05'),
('S006', 'Linda', 'Taylor', 'Trainee', 22000, '1998-09-30');
-- Exercise 1.3: Insert with NULL values
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S007', 'Michael', 'Brown', 'Intern', NULL, '2000-05-10');
-- Exercise 1.4: Insert with different column order
INSERT INTO Staff (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');
-- Exercise 1.5: Create HighEarners table
DROP TABLE IF EXISTS HighEarners;

CREATE TABLE HighEarners (
    StaffID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    DOB DATE
);

-- Exercise 1.5: Bulk insert using INSERT ... SELECT
INSERT INTO HighEarners (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff
WHERE Salary >= 35000;
-- Exercise 1.6: Create Product table with defaults
DROP TABLE IF EXISTS Product;

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) DEFAULT 0.00,
    StockQuantity INT DEFAULT 0,
    Status VARCHAR(20) DEFAULT 'Available'
);

-- Exercise 1.6: Insert with all specified columns
INSERT INTO Product (ProductID, ProductName, Price, StockQuantity, Status)
VALUES (101, 'Laptop', 1200.50, 50, 'Available');

-- Exercise 1.6: Insert without specifying optional columns (Defaults will be used)
INSERT INTO Product (ProductID, ProductName)
VALUES (102, 'Mouse');
-- Exercise 1.7: Handle duplicate key prevention
-- This will not throw an error. It will safely update the record if S001 already exists.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 46000, '1980-05-15')
ON DUPLICATE KEY UPDATE Salary = 46000;
-- Exercise 1.8: Create Department table
DROP TABLE IF EXISTS Department;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

-- Exercise 1.8: Alter Staff table to add DepartmentID and Foreign Key
ALTER TABLE Staff
ADD DepartmentID INT;

ALTER TABLE Staff
ADD CONSTRAINT FK_Staff_Department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);

-- Exercise 1.8: Insert related records
-- Insert a new department
INSERT INTO Department (DepartmentID, DepartmentName)
VALUES (1, 'IT');

-- Insert a new staff member belonging to the 'IT' department
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DepartmentID)
VALUES ('S009', 'Alice', 'Wonder', 'Developer', 42000, '1993-03-15', 1);
-- Exercise 1.9: Conditional Insert
-- Insert only if the salary is between 20000 and 30000
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S010', 'Robert', 'Downey', 'Junior Analyst', 28000, '1994-04-04'
WHERE 28000 BETWEEN 20000 AND 30000;

-- This insert will be ignored because 50000 is outside the range
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S011', 'Chris', 'Evans', 'Senior Manager', 50000, '1985-06-13'
WHERE 50000 BETWEEN 20000 AND 30000;
-- Exercise 1.10: Performance Comparison (Single vs Bulk Insert)

-- Single Insert
INSERT INTO Product (ProductID, ProductName, Price) VALUES (301, 'Single_Item_1', 15.00);
INSERT INTO Product (ProductID, ProductName, Price) VALUES (302, 'Single_Item_2', 15.00);

-- Bulk Insert (Multiple rows in one statement)
INSERT INTO Product (ProductID, ProductName, Price) VALUES
(303, 'Bulk_Item_1', 15.00),
(304, 'Bulk_Item_2', 15.00),
(305, 'Bulk_Item_3', 15.00),
(306, 'Bulk_Item_4', 15.00);