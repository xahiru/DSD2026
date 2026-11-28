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
