-- =====================================================================
-- DSD2026 - Practice Exercises 06: INSERT, UPDATE, DELETE, Transactions
-- Student : Rahimi Mohammad Mirwais        Folder / branch: RAHIMI086
-- =====================================================================
-- How to use this file
--  * Every exercise set starts with a fresh copy of the tables, so each
--    set can be run on its own. Inside a set, the exercises run one after
--    another on the same data (for example, raises add up).
--  * The statements are standard SQL. I tested the whole file on SQLite.
--    They are written to be portable to MySQL and PostgreSQL as well;
--    where those systems differ, a comment explains how (not tested there).
--  * Exercise 5.3 only has a title in the exercise sheet, so its task is
--    my own interpretation and is explained in the comments.
--  * Safety rule for UPDATE and DELETE: first run a SELECT with the same
--    WHERE condition to see which rows will change.
-- =====================================================================

-- #####################################################################
-- EXERCISE SET 1: BASIC INSERT OPERATIONS
-- #####################################################################
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS StaffDepartment;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS HighEarners;
DROP TABLE IF EXISTS NewHires;
DROP TABLE IF EXISTS Staff;

-- ---------------------------------------------------------------------
-- Exercise 1.1: Insert a single record
-- ---------------------------------------------------------------------
CREATE TABLE Staff (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE,
    Status     VARCHAR(10)   DEFAULT 'Active'
);

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

SELECT * FROM Staff;

-- ---------------------------------------------------------------------
-- Exercise 1.2: Insert multiple records in one statement
-- ---------------------------------------------------------------------
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S002', 'Sarah',   'Johnson', 'Analyst',   32000, '1985-03-22'),
    ('S003', 'Michael', 'Brown',   'Developer', 40000, '1990-07-10'),
    ('S004', 'Emily',   'Davis',   'Analyst',   28000, '1992-11-05'),
    ('S005', 'David',   'Wilson',  'Trainee',   18000, '2000-01-30'),
    ('S006', 'Anna',    'Lee',     'Developer', 42000, '1988-09-14');

SELECT COUNT(*) AS staff_count FROM Staff;   -- expected: 6

-- ---------------------------------------------------------------------
-- Exercise 1.3: Insert with NULL values (no salary yet)
-- ---------------------------------------------------------------------
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S007', 'Peter', 'Miller', 'Clerk', NULL, '1987-02-18');

SELECT StaffID, FirstName, Salary FROM Staff WHERE Salary IS NULL;

-- ---------------------------------------------------------------------
-- Exercise 1.4: Insert with a different column order
-- The values must follow the order of the column list, not the table.
-- ---------------------------------------------------------------------
INSERT INTO Staff (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

SELECT * FROM Staff WHERE StaffID = 'S008';

-- ---------------------------------------------------------------------
-- Exercise 1.5: Bulk insert with INSERT ... SELECT
-- ---------------------------------------------------------------------
CREATE TABLE HighEarners (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE
);

INSERT INTO HighEarners (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff
WHERE Salary >= 35000;

SELECT * FROM HighEarners;   -- expected: S001, S003, S006, S008

-- ---------------------------------------------------------------------
-- Exercise 1.6: Insert with DEFAULT values
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS Product;
CREATE TABLE Product (
    ProductID    INTEGER       PRIMARY KEY,
    ProductName  VARCHAR(50)   NOT NULL,
    Price        DECIMAL(10,2) DEFAULT 0.00,
    Stock        INTEGER       DEFAULT 0,
    Category     VARCHAR(30)   DEFAULT 'General'
);

-- Optional columns left out: the DEFAULT values are used
INSERT INTO Product (ProductID, ProductName) VALUES (1, 'Notebook');
-- All columns given
INSERT INTO Product (ProductID, ProductName, Price, Stock, Category)
VALUES (2, 'Pen', 1.50, 200, 'Stationery');
-- Only some optional columns given
INSERT INTO Product (ProductID, ProductName, Price) VALUES (3, 'Stapler', 7.25);
-- (MySQL and PostgreSQL also accept the keyword DEFAULT inside VALUES.)

SELECT * FROM Product;

-- ---------------------------------------------------------------------
-- Exercise 1.7: Prevent duplicate keys safely
-- ---------------------------------------------------------------------
-- a) The PRIMARY KEY itself rejects a duplicate. This statement would fail
--    with a duplicate-key / UNIQUE constraint error, so it stays commented:
-- INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
-- VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- b) Safe insert: the row is only inserted if the StaffID does not exist yet.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Omar', 'Khan', 'Analyst', 30000, '1993-04-12'
FROM (SELECT 1) AS dummy
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');

-- Running the same statement again inserts nothing (duplicate prevented):
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Omar', 'Khan', 'Analyst', 30000, '1993-04-12'
FROM (SELECT 1) AS dummy
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');

SELECT COUNT(*) AS rows_with_S009 FROM Staff WHERE StaffID = 'S009';   -- expected: 1
-- Shortcuts that exist only in some systems:
--   MySQL: INSERT IGNORE ... or INSERT ... ON DUPLICATE KEY UPDATE ...
--   PostgreSQL / SQLite: INSERT ... ON CONFLICT (StaffID) DO NOTHING

-- ---------------------------------------------------------------------
-- Exercise 1.8: Related records in two tables (referential integrity)
-- ---------------------------------------------------------------------
-- (SQLite only: run PRAGMA foreign_keys = ON; once per connection so that
--  foreign keys are enforced. MySQL and PostgreSQL enforce them by default.)
CREATE TABLE Department (
    DepartmentID    INTEGER      PRIMARY KEY,
    DepartmentName  VARCHAR(50)  NOT NULL
);

CREATE TABLE StaffDepartment (
    StaffID       VARCHAR(10) NOT NULL,
    DepartmentID  INTEGER     NOT NULL,
    PRIMARY KEY (StaffID, DepartmentID),
    FOREIGN KEY (StaffID)      REFERENCES Staff (StaffID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);

-- Parent rows first, then the child row that points to them
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (1, 'IT'), (2, 'Finance');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S010', 'Nadia', 'Karimi', 'Developer', 36000, '1994-08-09');
INSERT INTO StaffDepartment (StaffID, DepartmentID) VALUES ('S010', 1);

-- A link to a department that does not exist is rejected (so it is commented):
-- INSERT INTO StaffDepartment (StaffID, DepartmentID) VALUES ('S010', 99);

SELECT s.StaffID, s.FirstName, s.LastName, d.DepartmentName
FROM Staff s
JOIN StaffDepartment sd ON sd.StaffID = s.StaffID
JOIN Department d       ON d.DepartmentID = sd.DepartmentID;

-- ---------------------------------------------------------------------
-- Exercise 1.9: Conditional insert based on business logic
-- Rule: only candidates whose salary is between 20000 and 60000 are hired.
-- ---------------------------------------------------------------------
CREATE TABLE NewHires (
    StaffID    VARCHAR(10),
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE
);
INSERT INTO NewHires (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S011', 'Layla', 'Ahmadi', 'Analyst',   31000,  '1995-01-17'),   -- accepted
    ('S012', 'Karim', 'Rahimi', 'Developer', 150000, '1990-12-01'),   -- too high
    ('S013', 'Zahra', 'Noori',  'Clerk',      9000,  '1998-03-30');   -- too low

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM NewHires
WHERE Salary BETWEEN 20000 AND 60000;

SELECT StaffID, FirstName, Salary FROM Staff WHERE StaffID IN ('S011', 'S012', 'S013');   -- expected: only S011

-- ---------------------------------------------------------------------
-- Exercise 1.10: Single inserts versus one bulk insert
-- ---------------------------------------------------------------------
-- Approach A: three separate statements (three trips to the server)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S101', 'Test', 'One',   'Clerk', 20000, '1999-01-01');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S102', 'Test', 'Two',   'Clerk', 20000, '1999-01-01');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S103', 'Test', 'Three', 'Clerk', 20000, '1999-01-01');

-- Approach B: one statement with three rows (one trip to the server)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S104', 'Test', 'Four', 'Clerk', 20000, '1999-01-01'),
    ('S105', 'Test', 'Five', 'Clerk', 20000, '1999-01-01'),
    ('S106', 'Test', 'Six',  'Clerk', 20000, '1999-01-01');

SELECT COUNT(*) AS test_rows FROM Staff WHERE StaffID LIKE 'S1__';   -- expected: 6
-- With 3 rows no time difference can be seen. With thousands of rows the bulk
-- statement is much faster, because the server parses and commits once instead
-- of once per row. To measure: SQLite ".timer on", PostgreSQL "\timing", MySQL
-- shows the time after each statement in the command-line client.


-- #####################################################################
-- EXERCISE SET 2: UPDATE OPERATIONS
-- (2.1 to 2.5 run in order on the same data)
-- #####################################################################
-- Fresh start for this set: Set 2
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS StaffDepartment;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS HighEarners;
DROP TABLE IF EXISTS NewHires;
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE,
    Status     VARCHAR(10)   DEFAULT 'Active'
);
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S001', 'John',    'Smith',    'Manager',    45000, '1980-05-15'),
    ('S002', 'Sarah',   'Johnson',  'Analyst',    32000, '1985-03-22'),
    ('S003', 'Michael', 'Brown',    'Developer',  40000, '1990-07-10'),
    ('S004', 'Emily',   'Davis',    'Analyst',    28000, '1992-11-05'),
    ('S005', 'David',   'Wilson',   'Trainee',    18000, '2000-01-30'),
    ('S006', 'Anna',    'Lee',      'Developer',  42000, '1988-09-14'),
    ('S007', 'Peter',   'Miller',   'Clerk',       NULL, '1987-02-18'),
    ('S008', 'Jessica', 'Thompson', 'Supervisor', 38000, '1991-06-20'),
    ('S009', 'Lisa',    'Turner',   'Trainee',    17000, '2001-06-02');


-- Exercise 2.1: Update a single column
SELECT StaffID, FirstName, LastName, Salary FROM Staff WHERE StaffID = 'S001';   -- check first
UPDATE Staff SET Salary = 50000 WHERE FirstName = 'John' AND LastName = 'Smith';

-- Exercise 2.2: Update multiple columns
UPDATE Staff
SET Position = 'Senior Analyst', Salary = 35000
WHERE FirstName = 'Sarah' AND LastName = 'Johnson';

-- Exercise 2.3: Update with a calculation (10% raise for analysts)
-- LIKE '%Analyst' also matches 'Senior Analyst', so Sarah gets the raise too.
UPDATE Staff
SET Salary = ROUND(Salary * 1.10, 2)
WHERE Position LIKE '%Analyst';

-- Exercise 2.4: Update with CASE (Managers +15%, Analysts +10%, Developers +8%, others +5%)
-- Rows with NULL salary are skipped (NULL times a number stays NULL).
UPDATE Staff
SET Salary = ROUND(Salary * CASE
        WHEN Position = 'Manager'        THEN 1.15
        WHEN Position LIKE '%Analyst'    THEN 1.10
        WHEN Position LIKE '%Developer'  THEN 1.08
        ELSE 1.05
    END, 2)
WHERE Salary IS NOT NULL;

-- Exercise 2.5: Fill NULL values
UPDATE Staff SET Salary = 25000 WHERE Salary IS NULL;

SELECT StaffID, FirstName, LastName, Position, Salary FROM Staff ORDER BY StaffID;

-- #####################################################################
-- EXERCISE SET 3: DELETE OPERATIONS
-- #####################################################################
-- Fresh start for this set: Set 3
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS StaffDepartment;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS HighEarners;
DROP TABLE IF EXISTS NewHires;
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE,
    Status     VARCHAR(10)   DEFAULT 'Active'
);
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S001', 'John',    'Smith',    'Manager',    45000, '1980-05-15'),
    ('S002', 'Sarah',   'Johnson',  'Analyst',    32000, '1985-03-22'),
    ('S003', 'Michael', 'Brown',    'Developer',  40000, '1990-07-10'),
    ('S004', 'Emily',   'Davis',    'Analyst',    28000, '1992-11-05'),
    ('S005', 'David',   'Wilson',   'Trainee',    18000, '2000-01-30'),
    ('S006', 'Anna',    'Lee',      'Developer',  42000, '1988-09-14'),
    ('S007', 'Peter',   'Miller',   'Clerk',       NULL, '1987-02-18'),
    ('S008', 'Jessica', 'Thompson', 'Supervisor', 38000, '1991-06-20'),
    ('S009', 'Lisa',    'Turner',   'Trainee',    17000, '2001-06-02');


-- Exercise 3.1: Delete a single record
SELECT * FROM Staff WHERE StaffID = 'S007';   -- check first
DELETE FROM Staff WHERE StaffID = 'S007';     -- Peter Miller

-- Exercise 3.2: Delete multiple records (all trainees)
DELETE FROM Staff WHERE Position = 'Trainee';

-- Exercise 3.3: Delete with a complex condition (analysts earning less than 30000)
DELETE FROM Staff
WHERE Position LIKE '%Analyst' AND Salary < 30000;

SELECT StaffID, FirstName, Position, Salary FROM Staff ORDER BY StaffID;   -- remaining rows

-- Exercise 3.4: Soft delete (mark as inactive instead of deleting)
UPDATE Staff SET Status = 'Inactive' WHERE Position LIKE '%Developer';

SELECT StaffID, FirstName, Position, Status FROM Staff ORDER BY StaffID;
-- Normal queries then only look at active staff:
SELECT StaffID, FirstName, Position FROM Staff WHERE Status = 'Active';

-- #####################################################################
-- EXERCISE SET 4: TRANSACTIONS
-- BEGIN starts a transaction in SQLite, MySQL and PostgreSQL.
-- #####################################################################
-- Fresh start for this set: Set 4
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS StaffDepartment;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS HighEarners;
DROP TABLE IF EXISTS NewHires;
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE,
    Status     VARCHAR(10)   DEFAULT 'Active'
);
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S001', 'John',    'Smith',    'Manager',    45000, '1980-05-15'),
    ('S002', 'Sarah',   'Johnson',  'Analyst',    32000, '1985-03-22'),
    ('S003', 'Michael', 'Brown',    'Developer',  40000, '1990-07-10'),
    ('S004', 'Emily',   'Davis',    'Analyst',    28000, '1992-11-05'),
    ('S005', 'David',   'Wilson',   'Trainee',    18000, '2000-01-30'),
    ('S006', 'Anna',    'Lee',      'Developer',  42000, '1988-09-14'),
    ('S007', 'Peter',   'Miller',   'Clerk',       NULL, '1987-02-18'),
    ('S008', 'Jessica', 'Thompson', 'Supervisor', 38000, '1991-06-20'),
    ('S009', 'Lisa',    'Turner',   'Trainee',    17000, '2001-06-02');


-- Exercise 4.1: Simple transaction - move 5000 from one salary to another
BEGIN;
UPDATE Staff SET Salary = Salary - 5000 WHERE StaffID = 'S001';
UPDATE Staff SET Salary = Salary + 5000 WHERE StaffID = 'S002';
COMMIT;

SELECT StaffID, FirstName, Salary FROM Staff WHERE StaffID IN ('S001', 'S002');   -- 40000 and 37000

-- Exercise 4.2: Transaction with ROLLBACK (changes are undone)
BEGIN;
UPDATE Staff SET Salary = 0;
SELECT StaffID, Salary FROM Staff ORDER BY StaffID;   -- inside the transaction: all salaries are 0
ROLLBACK;
SELECT StaffID, Salary FROM Staff ORDER BY StaffID;   -- after ROLLBACK: the old salaries are back

-- Exercise 4.3: Transaction with error handling
-- Block A: all three inserts succeed, so the transaction is committed.
BEGIN;
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S010', 'Hamed', 'Sadat',  'Clerk',   22000, '1996-02-14');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S011', 'Mina',  'Faizi',  'Analyst', 30000, '1994-09-09');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S012', 'Sami',  'Wardak', 'Developer', 39000, '1993-05-21');
COMMIT;

-- Block B: if ANY statement fails, run ROLLBACK instead of COMMIT, and none of
-- the rows is kept. To see it, remove the two dashes in front of the duplicate INSERT.
BEGIN;
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S020', 'Temp', 'Person', 'Clerk', 20000, '1999-01-01');
-- INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES ('S010', 'Dup', 'Key', 'Clerk', 20000, '1999-01-01');   -- duplicate key: error
ROLLBACK;

SELECT StaffID FROM Staff WHERE StaffID IN ('S010', 'S011', 'S012', 'S020');   -- S010-S012 exist, S020 does not
-- Automatic error handling inside the database differs by system (not tested here):
--   MySQL: a stored procedure with DECLARE EXIT HANDLER FOR SQLEXCEPTION ... ROLLBACK
--   PostgreSQL: a DO block with EXCEPTION WHEN OTHERS THEN ...
--   SQLite: the application code issues ROLLBACK when a statement fails

-- #####################################################################
-- EXERCISE SET 5: COMBINED OPERATIONS
-- #####################################################################
-- Fresh start for this set: Set 5
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS StaffDepartment;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS HighEarners;
DROP TABLE IF EXISTS NewHires;
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
    StaffID    VARCHAR(10)   PRIMARY KEY,
    FirstName  VARCHAR(50)   NOT NULL,
    LastName   VARCHAR(50)   NOT NULL,
    Position   VARCHAR(50),
    Salary     DECIMAL(10,2),
    DOB        DATE,
    Status     VARCHAR(10)   DEFAULT 'Active'
);
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S001', 'John',    'Smith',    'Manager',    45000, '1980-05-15'),
    ('S002', 'Sarah',   'Johnson',  'Analyst',    32000, '1985-03-22'),
    ('S003', 'Michael', 'Brown',    'Developer',  40000, '1990-07-10'),
    ('S004', 'Emily',   'Davis',    'Analyst',    28000, '1992-11-05'),
    ('S005', 'David',   'Wilson',   'Trainee',    18000, '2000-01-30'),
    ('S006', 'Anna',    'Lee',      'Developer',  42000, '1988-09-14'),
    ('S007', 'Peter',   'Miller',   'Clerk',       NULL, '1987-02-18'),
    ('S008', 'Jessica', 'Thompson', 'Supervisor', 38000, '1991-06-20'),
    ('S009', 'Lisa',    'Turner',   'Trainee',    17000, '2001-06-02');


-- Exercise 5.1: Promotion - Sarah Johnson, Analyst to Senior Developer, 25% raise
BEGIN;
UPDATE Staff
SET Position = 'Senior Developer', Salary = ROUND(Salary * 1.25, 2)
WHERE FirstName = 'Sarah' AND LastName = 'Johnson' AND Position = 'Analyst';
COMMIT;

SELECT StaffID, FirstName, Position, Salary FROM Staff WHERE StaffID = 'S002';   -- Senior Developer, 40000

-- Exercise 5.2: New department - add 3 new staff members to 'Support'
CREATE TABLE Department (
    DepartmentID    INTEGER      PRIMARY KEY,
    DepartmentName  VARCHAR(50)  NOT NULL
);
CREATE TABLE StaffDepartment (
    StaffID       VARCHAR(10) NOT NULL,
    DepartmentID  INTEGER     NOT NULL,
    PRIMARY KEY (StaffID, DepartmentID),
    FOREIGN KEY (StaffID)      REFERENCES Staff (StaffID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);

BEGIN;
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (3, 'Support');
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S010', 'Farid', 'Azizi',  'Support Agent', 24000, '1997-03-03'),
    ('S011', 'Maryam', 'Hashemi', 'Support Agent', 24000, '1998-07-19'),
    ('S012', 'Yusuf', 'Popal',  'Support Lead',  30000, '1992-10-25');
INSERT INTO StaffDepartment (StaffID, DepartmentID)
SELECT s.StaffID, d.DepartmentID
FROM Staff s
CROSS JOIN Department d
WHERE d.DepartmentName = 'Support' AND s.StaffID IN ('S010', 'S011', 'S012');
COMMIT;

SELECT d.DepartmentName, s.StaffID, s.FirstName, s.LastName, s.Position
FROM Department d
JOIN StaffDepartment sd ON sd.DepartmentID = d.DepartmentID
JOIN Staff s            ON s.StaffID = sd.StaffID
WHERE d.DepartmentName = 'Support';   -- 3 rows

-- Exercise 5.3: Annual review and raises
-- The exercise sheet gives only the title, so this is my interpretation:
-- every employee gets a review rating from 1 to 5, and the raise depends on it:
--   rating 5: +10%    rating 4: +7%    rating 3: +4%    rating 2 or lower, or no review: +2%
-- The raises are applied in one transaction. Rows with NULL salary stay NULL.
CREATE TABLE Review (
    StaffID  VARCHAR(10) PRIMARY KEY,
    Rating   INTEGER     NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID)
);
INSERT INTO Review (StaffID, Rating) VALUES
    ('S001', 5), ('S002', 4), ('S003', 3), ('S004', 2), ('S006', 5), ('S008', 4);

BEGIN;
UPDATE Staff
SET Salary = ROUND(Salary * CASE (SELECT r.Rating FROM Review r WHERE r.StaffID = Staff.StaffID)
        WHEN 5 THEN 1.10
        WHEN 4 THEN 1.07
        WHEN 3 THEN 1.04
        ELSE 1.02
    END, 2)
WHERE Salary IS NOT NULL;
COMMIT;

SELECT s.StaffID, s.FirstName, s.Position, r.Rating, s.Salary
FROM Staff s
LEFT JOIN Review r ON r.StaffID = s.StaffID
ORDER BY s.StaffID;
