-- Exercise 1.1: Insert a Single Record
USE dsd2026;

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

SELECT * FROM Staff;