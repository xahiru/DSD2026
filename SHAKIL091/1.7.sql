-- Exercise 1.7: Insert and Handle Duplicate Key Prevention
USE dsd2026;

-- (a) INSERT IGNORE: duplicate hole skip kore, error dey na
INSERT IGNORE INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15');

-- (b) ON DUPLICATE KEY UPDATE: already thakle update kore
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
VALUES ('S001', 'John', 'Smith', 'Senior Manager', 50000, '1980-05-15')
ON DUPLICATE KEY UPDATE Position = VALUES(Position), Salary = VALUES(Salary);

-- (c) NOT EXISTS diye age check kore tarpor insert
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT 'S009', 'Olivia', 'Moore', 'Accountant', 43000, '1989-04-14'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = 'S009');

SELECT * FROM Staff;