-- Exercise 1.2 : Insert multiple records (5 rows, ONE statement)
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- One INSERT with several value lists: one round trip, one statement.
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB) VALUES
    ('S002', 'Sarah',   'Johnson',  'Analyst',   30000, '1992-03-10'),
    ('S003', 'Michael', 'Brown',    'Developer', 42000, '1988-11-02'),
    ('S004', 'Emily',   'Davis',    'Analyst',   33000, '1993-07-25'),
    ('S005', 'David',   'Wilson',   'Developer', 40000, '1990-01-18'),
    ('S006', 'Lisa',    'Anderson', 'Trainee',   22000, '2000-09-05');

-- Verify: 6 rows expected (S001-S006)
SELECT * FROM Staff ORDER BY StaffID;
SELECT COUNT(*) AS total_staff FROM Staff;
