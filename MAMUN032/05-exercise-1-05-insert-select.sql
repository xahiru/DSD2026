-- Exercise 1.5: Copy high-earning staff into a new table
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

CREATE TABLE HighEarners LIKE Staff;

INSERT INTO HighEarners
    (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT
    StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff
WHERE Salary >= 35000;

SELECT * FROM HighEarners ORDER BY StaffID;
