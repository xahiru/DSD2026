-- Exercise 1.2: Insert five staff members
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES
    ('S002', 'Sarah', 'Johnson', 'Analyst', 30000, '1992-03-10'),
    ('S003', 'David', 'Brown', 'Developer', 40000, '1990-07-22'),
    ('S004', 'Emily', 'Davis', 'Analyst', 28000, '1995-11-05'),
    ('S005', 'Michael', 'Wilson', 'Developer', 36000, '1993-01-18'),
    ('S006', 'Lisa', 'Taylor', 'Trainee', 20000, '2000-09-12');

SELECT * FROM Staff ORDER BY StaffID;
