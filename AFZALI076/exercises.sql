-- DSD2026 - MySQL exercises
-- Exercise Set 1: Basic INSERT Operations
-- Student: <YOUR NAME / FOLDER>

CREATE DATABASE IF NOT EXISTS dsd_exercises;
USE dsd_exercises;
SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS PerfTest, HighEarners, Product, Staff, Department;
DROP PROCEDURE IF EXISTS perf_single;


-- ===== SET 1: INSERT =====

-- 1.1 create Staff table and insert one staff member
CREATE TABLE Staff (
    StaffID   VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Position  VARCHAR(50) NOT NULL,
    Salary    DECIMAL(10,2),
    DOB       DATE NOT NULL
);

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- 1.2 insert 5 staff in one statement
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S002', 'Sarah',   'Johnson', 'Analyst',   32000, '1988-03-22'),
       ('S003', 'Michael', 'Brown',   'Developer', 42000, '1985-11-09'),
       ('S004', 'Emily',   'Davis',   'Analyst',   22000, '1993-07-30'),
       ('S005', 'David',   'Wilson',  'Trainee',   22000, '1999-01-14'),
       ('S006', 'Laura',   'Garcia',  'Developer', 40000, '1990-09-02');

-- 1.3 insert with NULL salary
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S007', 'Peter', 'Miller', 'Trainee', NULL, '2000-12-05');

-- 1.4 different column order (values follow the column list)
INSERT INTO Staff (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

SELECT * FROM Staff;

-- 1.5 copy staff earning 35000 or more into HighEarners
CREATE TABLE HighEarners (
    StaffID   VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName  VARCHAR(50),
    Position  VARCHAR(50),
    Salary    DECIMAL(10,2)
);

INSERT INTO HighEarners (StaffID, FirstName, LastName, Position, Salary)
SELECT StaffID, FirstName, LastName, Position, Salary
FROM Staff
WHERE Salary >= 35000;

SELECT * FROM HighEarners;

-- 1.6 Product table with default values
CREATE TABLE Product (
    ProductID   INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category    VARCHAR(50)   DEFAULT 'General',
    Price       DECIMAL(10,2) DEFAULT 0.00,
    Stock       INT           DEFAULT 0
);

INSERT INTO Product (ProductName) VALUES ('Notebook');                 -- all defaults
INSERT INTO Product (ProductName, Price) VALUES ('Pen', 1.50);         -- some defaults
INSERT INTO Product (ProductName, Category, Price, Stock)
VALUES ('Laptop', 'Electronics', 899.99, 15);                          -- no defaults

SELECT * FROM Product;

-- 1.7 avoid duplicate keys
-- INSERT IGNORE skips the row if the key already exists
INSERT IGNORE INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- insert only if the ID does not exist yet (run twice, 2nd time inserts nothing)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Anna', 'Chen', 'Analyst', 33000, '1993-02-11'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');

-- insert or update if it exists
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S009', 'Anna', 'Chen', 'Analyst', 33500, '1993-02-11')
ON DUPLICATE KEY UPDATE Salary = VALUES(Salary);

-- 1.8 Department table + foreign key (parent first, then child)
CREATE TABLE Department (
    DeptID   INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL UNIQUE
);

ALTER TABLE Staff
    ADD COLUMN DeptID INT,
    ADD FOREIGN KEY (DeptID) REFERENCES Department (DeptID);

INSERT INTO Department VALUES (1, 'Management'), (2, 'Analytics'), (3, 'Engineering');

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
VALUES ('S010', 'Ryan', 'Taylor', 'Developer', 41000, '1989-04-18', 3);

SELECT s.StaffID, s.FirstName, d.DeptName
FROM Staff s JOIN Department d ON s.DeptID = d.DeptID;

-- 1.9 insert only if the salary is between 20000 and 100000
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S011', 'Tom', 'Baker', 'Developer', 36000, '1992-09-03'
FROM DUAL
WHERE 36000 BETWEEN 20000 AND 100000;      -- ok, inserted

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S012', 'Nina', 'Park', 'Developer', 5000, '1994-03-27'
FROM DUAL
WHERE 5000 BETWEEN 20000 AND 100000;       -- too low, 0 rows inserted

-- 1.10 single inserts vs bulk insert (5000 rows each)
CREATE TABLE PerfTest (
    ID  INT AUTO_INCREMENT PRIMARY KEY,
    Val INT
);

DELIMITER $$
CREATE PROCEDURE perf_single(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < n DO
        INSERT INTO PerfTest (Val) VALUES (i);
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

-- one insert per row
SET @t0 = NOW(6);
CALL perf_single(5000);
SELECT TIMESTAMPDIFF(MICROSECOND, @t0, NOW(6)) / 1000 AS single_ms;

TRUNCATE TABLE PerfTest;

-- one insert for all rows
SET SESSION cte_max_recursion_depth = 10000;
SET @t0 = NOW(6);
INSERT INTO PerfTest (Val)
WITH RECURSIVE seq AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 5000
)
SELECT n FROM seq;
SELECT TIMESTAMPDIFF(MICROSECOND, @t0, NOW(6)) / 1000 AS bulk_ms;
-- bulk is much faster
