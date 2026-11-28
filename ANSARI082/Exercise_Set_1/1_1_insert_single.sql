-- Exercise 1.1 : Insert a single record
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Staff table. StaffID is the primary key; Salary may be NULL (needed in 1.3).
CREATE TABLE Staff (
    StaffID   VARCHAR(10)   NOT NULL,
    FirstName VARCHAR(50)   NOT NULL,
    LastName  VARCHAR(50)   NOT NULL,
    Position  VARCHAR(50)   NOT NULL,
    Salary    DECIMAL(10,2) NULL,
    DOB       DATE          NOT NULL,
    PRIMARY KEY (StaffID)
);

-- Insert John Smith (S001, Manager, 45000, 1980-05-15)
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- Verify
SELECT * FROM Staff;
