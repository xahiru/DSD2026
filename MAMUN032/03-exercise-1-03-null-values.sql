-- Exercise 1.3: Insert a staff member with NULL salary
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES
    ('S007', 'Peter', 'Miller', 'Trainee', NULL, '1998-04-25');

SELECT * FROM Staff WHERE StaffID = 'S007';
