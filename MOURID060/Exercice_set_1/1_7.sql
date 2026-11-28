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
)
ON DUPLICATE KEY UPDATE
    staff_id = staff_id;