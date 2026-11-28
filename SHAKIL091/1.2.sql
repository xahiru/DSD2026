-- Exercise 1.2: Insert Multiple Records
USE dsd2026;

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES
('S002', 'Alice',   'Brown',  'Developer', 52000, '1990-03-10'),
('S003', 'Robert',  'Wilson', 'Analyst',   48000, '1988-07-22'),
('S004', 'Emma',    'Davis',  'Designer',  41000, '1992-11-05'),
('S005', 'Michael', 'Clark',  'Clerk',     30000, '1995-01-18'),
('S006', 'Sophia',  'Taylor', 'Tester',    36000, '1993-09-30');

SELECT * FROM Staff;