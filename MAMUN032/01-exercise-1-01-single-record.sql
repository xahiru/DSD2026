-- Exercise 1.1: Create a table and insert one staff member
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

CREATE DATABASE IF NOT EXISTS exercise_set_1;
USE exercise_set_1;

-- Create the table only if it does not already exist
CREATE TABLE IF NOT EXISTS Staff (
    StaffID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50),
    Salary DECIMAL(10, 2),
    DOB DATE
);

INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES
    ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- Show the saved records
SELECT * FROM Staff ORDER BY StaffID;
