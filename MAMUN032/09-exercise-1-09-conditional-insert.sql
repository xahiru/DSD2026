-- Exercise 1.9: Insert only when salary is within range
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

-- Valid salary: this row will be inserted
INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT
    'S010', 'Nina', 'Patel', 'Analyst', 32000, '1996-02-14'
WHERE 32000 BETWEEN 20000 AND 60000;

-- Invalid salary: this row will not be inserted
INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT
    'S011', 'Omar', 'Khan', 'Developer', 70000, '1995-10-08'
WHERE 70000 BETWEEN 20000 AND 60000;

SELECT StaffID, FirstName, Salary
FROM Staff
WHERE StaffID IN ('S010', 'S011');
