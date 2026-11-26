-- Exercise 1.7: Check for an existing ID before inserting
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT
    'S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15'
WHERE NOT EXISTS (
    SELECT 1
    FROM Staff
    WHERE StaffID = 'S001'
);

SELECT COUNT(*) AS JohnRecordCount
FROM Staff
WHERE StaffID = 'S001';
