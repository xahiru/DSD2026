-- Exercise 1.5: Bulk Insert with INSERT ... SELECT
USE dsd2026;

CREATE TABLE HighEarners (
    StaffID   VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Position  VARCHAR(50),
    Salary    DECIMAL(10,2),
    DOB       DATE
);

INSERT INTO HighEarners (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT StaffID, FirstName, LastName, Position, Salary, DOB
FROM Staff
WHERE Salary >= 35000;

SELECT * FROM HighEarners;