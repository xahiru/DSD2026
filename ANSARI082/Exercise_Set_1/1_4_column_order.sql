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
