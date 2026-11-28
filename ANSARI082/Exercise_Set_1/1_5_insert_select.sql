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
