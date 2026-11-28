CREATE TABLE Staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    dob DATE
);

INSERT INTO Staff (
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