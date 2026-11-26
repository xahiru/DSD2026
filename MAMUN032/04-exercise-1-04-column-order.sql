-- Exercise 1.4: Insert using a different column order
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

INSERT INTO Staff
    (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES
    ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

SELECT * FROM Staff WHERE StaffID = 'S008';
