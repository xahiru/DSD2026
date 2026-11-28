-- Exercise 1.8: Multi-Table Insert (Related Records)
USE dsd2026;

CREATE TABLE Department (
    DeptID   INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

ALTER TABLE Staff ADD COLUMN DeptID INT;

ALTER TABLE Staff ADD CONSTRAINT fk_staff_dept
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID);

-- Parent table age (Department)
INSERT INTO Department (DeptID, DeptName)
VALUES (1, 'IT'), (2, 'HR');

-- Tarpor child table (Staff)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB, DeptID)
VALUES ('S010', 'Daniel', 'White', 'Developer', 55000, '1991-02-02', 1);

SELECT * FROM Department;
SELECT * FROM Staff;