-- Exercise 1.3: Insert with NULL Values
USE dsd2026;

INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S007', 'David', 'Miller', 'Intern', NULL, '2000-12-01');

SELECT * FROM Staff;