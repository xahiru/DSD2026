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
