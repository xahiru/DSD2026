-- ALL_IN_ONE.sql : Exercise Set 1, every exercise in order (for MySQL Workbench)
-- Student: ANSARI MOHAMMAD ESA | ID: 20243120082

-- ======================================================
-- Exercise Set 1 : Setup
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

-- A dedicated database keeps this work separate from other schemas (e.g. ai_weather).
DROP DATABASE IF EXISTS dsd2026_ex1;
CREATE DATABASE dsd2026_ex1 CHARACTER SET utf8mb4;
USE dsd2026_ex1;
SELECT DATABASE() AS current_database;

-- ======================================================
-- Exercise 1.1 : Insert a single record
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Staff table. StaffID is the primary key; Salary may be NULL (needed in 1.3).
CREATE TABLE Staff (
    StaffID   VARCHAR(10)   NOT NULL,
    FirstName VARCHAR(50)   NOT NULL,
    LastName  VARCHAR(50)   NOT NULL,
    Position  VARCHAR(50)   NOT NULL,
    Salary    DECIMAL(10,2) NULL,
    DOB       DATE          NOT NULL,
    PRIMARY KEY (StaffID)
);

-- Insert John Smith (S001, Manager, 45000, 1980-05-15)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- Verify
SELECT * FROM Staff;

-- ======================================================
-- Exercise 1.2 : Insert multiple records (5 rows, ONE statement)
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- One INSERT with several value lists: one round trip, one statement.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S002', 'Sarah',   'Johnson',  'Analyst',   30000, '1992-03-10'),
    ('S003', 'Michael', 'Brown',    'Developer', 42000, '1988-11-02'),
    ('S004', 'Emily',   'Davis',    'Analyst',   33000, '1993-07-25'),
    ('S005', 'David',   'Wilson',   'Developer', 40000, '1990-01-18'),
    ('S006', 'Lisa',    'Anderson', 'Trainee',   22000, '2000-09-05');

-- Verify: 6 rows expected (S001-S006)
SELECT * FROM Staff ORDER BY StaffID;
SELECT COUNT(*) AS total_staff FROM Staff;

-- ======================================================
-- Exercise 1.3 : Insert with NULL values
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Salary not yet decided -> NULL (explicit). Omitting the column would also give NULL
-- because Salary has no NOT NULL constraint and no DEFAULT.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S007', 'Peter', 'Miller', 'Developer', NULL, '1994-04-12');

-- Verify: NULL needs IS NULL (Salary = NULL never matches)
SELECT * FROM Staff WHERE Salary IS NULL;

-- ======================================================
-- Exercise 1.4 : Insert with a different column order
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Table order: StaffID, FirstName, LastName, Position, Salary, DOB
-- Here: LastName, StaffID, FirstName, Position, Salary, DOB
-- Values must follow the column LIST, not the table definition.
INSERT INTO Staff (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

-- Verify: names must NOT be swapped
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff WHERE StaffID = 'S008';

-- ======================================================
-- Exercise 1.5 : Bulk insert with INSERT ... SELECT
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- New table with the same structure as Staff
CREATE TABLE HighEarners LIKE Staff;

-- Copy everyone earning 35000 or more. NULL salaries are excluded automatically
-- (NULL >= 35000 is UNKNOWN, not TRUE).
INSERT INTO HighEarners (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff
WHERE Salary >= 35000;

-- Verify: expected S001, S003, S005, S008
SELECT * FROM HighEarners ORDER BY Salary DESC;
SELECT COUNT(*) AS high_earners FROM HighEarners;

-- ======================================================
-- Exercise 1.6 : Insert with DEFAULT values
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

CREATE TABLE Product (
    ProductID   INT           NOT NULL AUTO_INCREMENT,
    ProductName VARCHAR(100)  NOT NULL,
    Category    VARCHAR(50)   NOT NULL DEFAULT 'General',
    Price       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Stock       INT           NOT NULL DEFAULT 0,
    CreatedAt   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ProductID)
);

-- (a) Only the required column: every other column uses its DEFAULT
INSERT INTO Product (ProductName) VALUES ('USB Cable');

-- (b) Some optional columns given
INSERT INTO Product (ProductName, Price) VALUES ('Notebook', 12.50);

-- (c) All columns given explicitly
INSERT INTO Product (ProductName, Category, Price, Stock)
VALUES ('Mechanical Keyboard', 'Electronics', 89.90, 25);

-- (d) The DEFAULT keyword used explicitly inside VALUES
INSERT INTO Product (ProductName, Category, Price, Stock)
VALUES ('Desk Lamp', DEFAULT, 24.00, DEFAULT);

-- Verify: compare which values came from DEFAULT
SELECT * FROM Product;

-- ======================================================
-- Exercise 1.7 : Insert safely and prevent duplicates
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- A plain duplicate fails with: Error 1062 Duplicate entry 'S001' for key 'staff.PRIMARY'
--   INSERT INTO Staff VALUES ('S001','X','Y','Manager',1,'2000-01-01');   -- (not run: stops the script)

-- Method 1: check first, insert only if the key is absent (portable; works in any SQL DBMS).
-- S009 is new -> 1 row inserted.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Daniel', 'Lee', 'Developer', 36000, '1989-12-01'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');
SELECT ROW_COUNT() AS method1_first_run_rows;   -- expected 1

-- Same statement again -> S009 exists, 0 rows inserted, no error.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Daniel', 'Lee', 'Developer', 36000, '1989-12-01'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');
SELECT ROW_COUNT() AS method1_second_run_rows;  -- expected 0

-- Method 2: INSERT IGNORE - duplicate is skipped and reported as a WARNING, not an error.
-- Caution: IGNORE also hides other errors (e.g. truncated data), so use it carefully.
INSERT IGNORE INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'Duplicate', 'Person', 'Manager', 1, '2000-01-01');
SHOW WARNINGS;                                   -- Duplicate entry 'S001'
SELECT StaffID, FirstName, LastName FROM Staff WHERE StaffID = 'S001';  -- still John Smith

-- Method 3: ON DUPLICATE KEY UPDATE (upsert) - insert if new, otherwise update the existing row.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S009', 'Daniel', 'Lee', 'Developer', 36000, '1989-12-01')
ON DUPLICATE KEY UPDATE Salary = 37000;
-- MySQL reports ROW_COUNT() = 2 when an existing row was updated.
SELECT StaffID, FirstName, LastName, Salary FROM Staff WHERE StaffID = 'S009';   -- Salary 37000

-- Verify: no duplicate IDs anywhere
SELECT StaffID, COUNT(*) AS times FROM Staff GROUP BY StaffID HAVING COUNT(*) > 1;  -- expected: empty
SELECT COUNT(*) AS total_staff FROM Staff;                                          -- expected: 9

-- ======================================================
-- Exercise 1.8 : Multi-table insert (related records, referential integrity)
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Parent table first
CREATE TABLE Department (
    DeptID   VARCHAR(5)  NOT NULL,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50) NULL,
    PRIMARY KEY (DeptID),
    UNIQUE (DeptName)
);

-- Link Staff (child) to Department (parent) with a foreign key
ALTER TABLE Staff
    ADD COLUMN DeptID VARCHAR(5) NULL,
    ADD CONSTRAINT fk_staff_dept FOREIGN KEY (DeptID) REFERENCES Department (DeptID);

-- Rule: PARENT row must exist before the CHILD row.
INSERT INTO Department (DeptID, DeptName, Location) VALUES
    ('D01', 'Management',  'Building A'),
    ('D02', 'Engineering', 'Building B'),
    ('D03', 'Support',     'Building C');

-- New staff member referencing an existing department
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
VALUES ('S010', 'Wei', 'Chen', 'Developer', 39000, '1995-09-12', 'D02');

-- Verify with a JOIN
SELECT s.StaffID, s.FirstName, s.LastName, d.DeptName
FROM Staff s JOIN Department d ON s.DeptID = d.DeptID;

-- Referential integrity in action (not run, would stop the script):
--   INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
--   VALUES ('S099', 'Test', 'User', 'Analyst', 30000, '1999-01-01', 'D99');
--   -> Error 1452: Cannot add or update a child row: a foreign key constraint fails

-- ======================================================
-- Exercise 1.9 : Conditional insert based on business logic
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Business rules for a new hire:
--   R1: salary between 20000 and 100000
--   R2: a Manager must earn at least 40000
--   R3: StaffID must not already exist
-- Technique: INSERT ... SELECT ... WHERE <rules>. If any rule fails, 0 rows are inserted.

-- Candidate 1: Olivia Martin, Analyst, 34000  -> passes -> inserted
SET @id='S011', @fn='Olivia', @ln='Martin', @pos='Analyst', @sal=34000, @dob='1994-02-11';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate1_rows;   -- expected 1

-- Candidate 2: Tom Baker, Developer, 150000 -> violates R1 -> rejected
SET @id='S012', @fn='Tom', @ln='Baker', @pos='Developer', @sal=150000, @dob='1991-08-30';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate2_rows;   -- expected 0

-- Candidate 3: Rachel Green, Manager, 30000 -> violates R2 -> rejected
SET @id='S013', @fn='Rachel', @ln='Green', @pos='Manager', @sal=30000, @dob='1985-05-05';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate3_rows;   -- expected 0

-- Verify: only S011 was added
SELECT StaffID, FirstName, LastName, Position, Salary
FROM Staff WHERE StaffID IN ('S011','S012','S013');   -- expected: S011 only

-- ======================================================
-- Exercise 1.10 : Performance - single inserts vs bulk insert
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

CREATE TABLE Perf_Single  (id INT PRIMARY KEY, val VARCHAR(40));
CREATE TABLE Perf_Bulk    (id INT PRIMARY KEY, val VARCHAR(40));
CREATE TABLE Perf_Results (method VARCHAR(40), rows_inserted INT, seconds DECIMAL(12,6));

-- ---------- Approach A: 2000 separate INSERT statements (each auto-committed) ----------
DROP PROCEDURE IF EXISTS load_single;
DELIMITER $$
CREATE PROCEDURE load_single(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        INSERT INTO Perf_Single (id, val) VALUES (i, CONCAT('row_', i));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

SET autocommit = 1;                 -- every INSERT is its own transaction
SET @t0 = NOW(6);
CALL load_single(2000);
SET @single_sec = TIMESTAMPDIFF(MICROSECOND, @t0, NOW(6)) / 1000000;

-- ---------- Approach B: ONE bulk INSERT ... SELECT generating 2000 rows ----------
SET SESSION cte_max_recursion_depth = 10000;
SET @t1 = NOW(6);
INSERT INTO Perf_Bulk (id, val)
WITH RECURSIVE seq (n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 2000
)
SELECT n, CONCAT('row_', n) FROM seq;
SET @bulk_sec = TIMESTAMPDIFF(MICROSECOND, @t1, NOW(6)) / 1000000;

-- ---------- Results ----------
INSERT INTO Perf_Results VALUES
    ('2000 single INSERTs', (SELECT COUNT(*) FROM Perf_Single), @single_sec),
    ('1 bulk INSERT',       (SELECT COUNT(*) FROM Perf_Bulk),   @bulk_sec);

SELECT method, rows_inserted, seconds FROM Perf_Results;
SELECT ROUND(@single_sec / @bulk_sec, 1) AS bulk_is_x_times_faster;

-- Why: each single INSERT is parsed, executed and committed (flushed to the redo log) separately.
-- A bulk INSERT does one parse and one commit for all rows.

