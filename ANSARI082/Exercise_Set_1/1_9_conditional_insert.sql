-- Exercise 1.9 : Conditional insert based on business logic
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

-- Business rules for a new hire:
--   R1: salary between 20000 and 100000
--   R2: a Manager must earn at least 40000
--   R3: StaffID must not already exist
-- Technique: INSERT ... SELECT ... WHERE <rules>. If any rule fails, 0 rows are inserted.

-- Candidate 1: Olivia Martin, Analyst, 34000  -> passes -> inserted
SET @id='S011', @fn='Olivia', @ln='Martin', @pos='Analyst', @sal=34000, @dob='1994-02-11';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate1_rows;   -- expected 1

-- Candidate 2: Tom Baker, Developer, 150000 -> violates R1 -> rejected
SET @id='S012', @fn='Tom', @ln='Baker', @pos='Developer', @sal=150000, @dob='1991-08-30';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate2_rows;   -- expected 0

-- Candidate 3: Rachel Green, Manager, 30000 -> violates R2 -> rejected
SET @id='S013', @fn='Rachel', @ln='Green', @pos='Manager', @sal=30000, @dob='1985-05-05';
INSERT INTO Staff (StaffID, FirstName, LastName, Position, Salary, DOB)
SELECT @id, @fn, @ln, @pos, @sal, @dob FROM DUAL
WHERE @sal BETWEEN 20000 AND 100000
  AND (@pos <> 'Manager' OR @sal >= 40000)
  AND NOT EXISTS (SELECT 1 FROM Staff WHERE StaffID = @id);
SELECT ROW_COUNT() AS candidate3_rows;   -- expected 0

-- Verify: only S011 was added
SELECT StaffID, FirstName, LastName, Position, Salary
FROM Staff WHERE StaffID IN ('S011','S012','S013');   -- expected: S011 only
