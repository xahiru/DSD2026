02_Insert_Operations.sql 
-- Exercise 1.1: Create Staff table
CREATE TABLE DreamHome.Staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    dob DATE
) ENGINE = InnoDB;
-- Exercise 1.1: Insert a single record
INSERT INTO DreamHome.Staff (
        staff_id,
        first_name,
        last_name,
        position,
        salary,
        dob
    )
VALUES (
        'S001',
        'John',
        'Smith',
        'Manager',
        45000,
        '1980-05-15'
    );
SELECT *
FROM DreamHome.Staff;

-- Exercise 1.2 Insert Multiple Records

INSERT INTO DreamHome.staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob
)
VALUES 

   ('S002', 'Sarah', 'Johnson', 'Analyst', '28000', '1992-03-12'),
   ('S003', 'Ali',    'Ahmadi', 'Teacher', '30000', '1998-07-23'),
   ('S004', 'Mohammad', 'Amiri', 'Worker', '45000', '2003-04-1' ),
   ('S005', 'Fatima', 'Rezayi',  'Layer',  '54000', '2000-08-29'),
   ('S006', 'Kazim',  'Honarjo', 'Boss',   '40000', '2022-09-24');

-- Check Exercise 1.2
SELECT * FROM DreamHome.staff
ORDER BY staff_id;

-- Exercise 1.3: Insert with NULL Values
INSERT INTO DreamHome.staff(
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob
)
VALUES('S007', 'Farhad', 'Jaefari', 'Student', NULL, '2006-06-25');
-- Check Exercise 1.3
SELECT * FROM DreamHome.staff
ORDER BY staff_id;

--check just the null insertion
SELECT * FROM DreamHome.staff
WHERE salary is NULL;

-- Exercise 1.4: Insert with Different Column Order

INSERT INTO DreamHome.Staff (
    last_name,
    staff_id,
    first_name,
    position,
    salary,
    dob
)
VALUES (
    'Hadi',
    'S008',
    'Krimi',
    'Supervisor',
    38000,
    '1991-06-20'
);

-- Verify Exercise 1.4
SELECT * FROM DreamHome.Staff
ORDER BY staff_id;

SELECT * FROM DreamHome.Staff
WHERE staff_id = 'S008';

UPDATE DreamHome.staff SET first_name ='Hadi', last_name='Krimi' WHERE staff_id ='S008';

SELECT * FROM DreamHome.staff
WHERE staff_id = 'S008';

-- Exercise 1.5: Create HighEarners table
CREATE TABLE IF NOT EXISTS DreamHome.HighEarners LIKE DreamHome.staff;
SELECT * FROM DreamHome.highearners;

SELECT * FROM DreamHome.Staff
WHERE salary >= 35000;

INSERT INTO DreamHome.Highearners
SELECT * FROM  DreamHome.Staff
WHERE salary >= 35000;

-- Verify Exercise 1.5
SELECT * FROM DreamHome.HighEarners
ORDER BY staff_id;

-- Exercise 1.6: Create product table with DEFAULT values
CREATE TABLE DreamHome.Product(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) DEFAULT 0.00,
    quantity INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Available',
    created_data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB;

-- Isert a product with specified values
INSERT INTO DreamHome.product(
    product_name,
    price,
    quantity,
    status
)
VALUES(
    'Laptop',
    850.00,
    10,
    'Available'
);

-- Insert a product using default values 
INSERT INTO DreamHome.Product(
    product_name
)
VALUES(
    'Keyboard'
);

-- Insert using the DEFAULT keyword
INSERT INTO DreamHome.product(
    product_name,
    price,
    quantity,
    status
)
VALUES(
    'Mouse',
    25.00,
    DEFAULT,
    DEFAULT
);

SELECT * FROM DreamHome.product;

-- Exercise 1.7: Duplicate key demonstration
INSERT INTO DreamHome.Staff
VALUES (
    'S001',
    'John',
    'Smith',
    'Manager',
    45000,
    '1980-05-15'
);

-- Exercise 1.7: Method 1 - INSERT IGNORE
INSERT IGNORE INTO DreamHome.Staff
VALUES (
    'S001',
    'John',
    'Smith',
    'Manager',
    45000,
    '1980-05-15'
);


-- Exercise 1.7: Method 2 - NOT EXISTS
INSERT INTO DreamHome.Staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob
)
SELECT
    'S001',
    'John',
    'Smith',
    'Manager',
    45000,
    '1980-05-15'
WHERE NOT EXISTS (
    SELECT 1
    FROM DreamHome.Staff
    WHERE staff_id = 'S001'
);

-- Exercise 1.7: Method 3 - ON DUPLICATE KEY UPDATE
INSERT INTO DreamHome.Staff
VALUES (
    'S001',
    'John',
    'Smith',
    'Manager',
    45000,
    '1980-05-15'
)
ON DUPLICATE KEY UPDATE
    salary = 45000,
    position = 'Manager';

-- Verify Exercise 1.7
SELECT * FROM DreamHome.staff
WHERE staff_id='S001';

SELECT COUNT(*) AS total_staff
FROM DreamHome.staff;

-- Exercise 1.8: Create Department table
CREATE TABLE DreamHome.Department(
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
)ENGINE=InnoDB;

-- Insert department records
INSERT INTO DreamHome.Department (
    department_id,
    department_name,
    location
)
VALUES
    ('D001', 'Management', 'Building A'),
    ('D002', 'IT', 'Building B'),
    ('D003', 'Finance', 'Building C');

SELECT * FROM DreamHome.Department;

-- Add department_id column add foreign key
ALTER TABLE DreamHome.staff
ADD COLUMN department_id VARCHAR(10),
ADD CONSTRAINT fk_staff_department
    FOREIGN KEY (department_id)
    REFERENCES DreamHome.Department(department_id);

-- Insert a staff member into the IT department
INSERT INTO DreamHome.Staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob,
    department_id
)
VALUES (
    'S009',
    'Robert',
    'Anderson',
    'Developer',
    37000,
    '1994-08-21',
    'D002'
);

-- Verify the relationship between Staff and Department
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    s.position,
    s.salary,
    d.department_name,
    d.location
FROM DreamHome.Staff AS s
INNER JOIN DreamHome.Department AS d
    ON s.department_id = d.department_id;

-- Test foreign key constraint 
INSERT INTO DreamHome.Staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob,
    department_id
)
VALUES (
    'S010',
    'James',
    'Clark',
    'Analyst',
    30000,
    '1996-05-12',
    'D999'
);

SELECT * FROM DreamHome.Staff
ORDER BY staff_id;

-- Exercise 1.9: Conditional Insert (Valid Salary)
INSERT INTO DreamHome.Staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob,
    department_id
)
SELECT
    'S010',
    'James',
    'Clark',
    'Analyst',
    32000,
    '1996-05-12',
    'D003'
WHERE 32000 BETWEEN 20000 AND 60000
AND NOT EXISTS (
    SELECT 1
    FROM DreamHome.Staff
    WHERE staff_id = 'S010'
);

SELECT * FROM DreamHome.Staff
WHERE staff_id = 'S010';

-- Exercise 1.9: Conditional Insert (Invalid Salary)
INSERT INTO DreamHome.Staff (
    staff_id,
    first_name,
    last_name,
    position,
    salary,
    dob,
    department_id
)
SELECT
    'S011',
    'William',
    'Thomas',
    'Developer',
    75000,
    '1990-08-15',
    'D002'
WHERE 75000 BETWEEN 20000 AND 60000
AND NOT EXISTS (
    SELECT 1
    FROM DreamHome.Staff
    WHERE staff_id = 'S011'
);

SELECT * FROM DreamHome.Staff
WHERE staff_id = 'S011';

SELECT * FROM DreamHome.Staff
ORDER BY staff_id;

-- Exercise 1.10: Performance Comparison
CREATE TABLE DreamHome.SingleInsertTest (
    id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary DECIMAL(10,2)
) ENGINE=InnoDB;

CREATE TABLE DreamHome.BulkInsertTest
LIKE DreamHome.SingleInsertTest;

-- Method 1: Single INSERT statements
INSERT INTO DreamHome.SingleInsertTest
VALUES (1, 'Employee 1', 30000);
INSERT INTO DreamHome.SingleInsertTest
VALUES (2, 'Employee 2', 32000);
INSERT INTO DreamHome.SingleInsertTest
VALUES (3, 'Employee 3', 35000);
INSERT INTO DreamHome.SingleInsertTest
VALUES (4, 'Employee 4', 38000);
INSERT INTO DreamHome.SingleInsertTest
VALUES (5, 'Employee 5', 40000);

-- Method 2: Bulk INSERT statement
INSERT INTO DreamHome.BulkInsertTest
VALUES
    (1, 'Employee 1', 30000),
    (2, 'Employee 2', 32000),
    (3, 'Employee 3', 35000),
    (4, 'Employee 4', 38000),
    (5, 'Employee 5', 40000);

SELECT * FROM DreamHome.SingleInsertTest;

SELECT * FROM DreamHome.BulkInsertTest;
