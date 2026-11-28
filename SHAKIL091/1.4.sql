-- Exercise 1.4: Insert with Different Column Order
USE dsd2026;

INSERT INTO Staff (LastName, StaffID, FirstName, Position, Salary, DOB)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

SELECT * FROM Staff;