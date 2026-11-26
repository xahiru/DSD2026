-- Exercise 1.8: Insert related department and staff records
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

ALTER TABLE Staff
    ADD COLUMN DepartmentID INT,
    ADD CONSTRAINT fk_staff_department
        FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID);

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES (1, 'IT');

INSERT INTO Staff
    (StaffID, FirstName, LastName, Position, Salary, DOB, DepartmentID)
VALUES
    ('S009', 'Alex', 'Lee', 'Developer', 32000, '1994-08-16', 1);

SELECT
    s.StaffID,
    s.FirstName,
    s.DepartmentID,
    d.DepartmentName
FROM Staff AS s
JOIN Department AS d
    ON s.DepartmentID = d.DepartmentID
WHERE s.StaffID = 'S009';
