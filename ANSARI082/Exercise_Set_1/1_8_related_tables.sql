-- Exercise 1.8 : Multi-table insert (related records, referential integrity)
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Parent table first
CREATE TABLE Department (
    DeptID   VARCHAR(5)  NOT NULL,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50) NULL,
    PRIMARY KEY (DeptID),
    UNIQUE (DeptName)
);

-- Link Staff (child) to Department (parent) with a foreign key
ALTER TABLE Staff
    ADD COLUMN DeptID VARCHAR(5) NULL,
    ADD CONSTRAINT fk_staff_dept FOREIGN KEY (DeptID) REFERENCES Department (DeptID);

-- Rule: PARENT row must exist before the CHILD row.
INSERT INTO Department (DeptID, DeptName, Location) VALUES
    ('D01', 'Management',  'Building A'),
    ('D02', 'Engineering', 'Building B'),
    ('D03', 'Support',     'Building C');

-- New staff member referencing an existing department
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
VALUES ('S010', 'Wei', 'Chen', 'Developer', 39000, '1995-09-12', 'D02');

-- Verify with a JOIN
SELECT s.StaffID, s.FirstName, s.LastName, d.DeptName
FROM Staff s JOIN Department d ON s.DeptID = d.DeptID;

-- Referential integrity in action (not run, would stop the script):
--   INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
--   VALUES ('S099', 'Test', 'User', 'Analyst', 30000, '1999-01-01', 'D99');
--   -> Error 1452: Cannot add or update a child row: a foreign key constraint fails
