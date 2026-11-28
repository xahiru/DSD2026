-- Exercise 1.9: Conditional Insert Based on Business Logic
USE dsd2026;

-- (a) Salary 47000, range er moddhe, tai insert hobe
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S012', 'Grace', 'Lee', 'Analyst', 47000, '1994-08-08'
FROM DUAL
WHERE 47000 BETWEEN 20000 AND 100000;

-- (b) Salary 500000, range er baire, tai insert hobe na
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S013', 'Rich', 'Guy', 'CEO', 500000, '1970-01-01'
FROM DUAL
WHERE 500000 BETWEEN 20000 AND 100000;

SELECT * FROM Staff;