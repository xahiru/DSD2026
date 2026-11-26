-- 1.1
INSERT INTO staff (first_name, last_name, staff_id, position, salary, dob)
VALUES ('John Smith', '', 'S001', 'Manager', 45000, '1980-05-15');

SELECT * FROM staff;

-- 1.2
INSERT INTO staff (first_name, last_name, staff_id, position, salary, dob)
VALUES
    ('Sarah',   'Johnson', 'S002', 'Analyst',   32000, '1990-03-12'),
    ('Michael', 'Brown',   'S003', 'Developer', 42000, '1988-11-02'),
    ('Emily',   'Davis',   'S004', 'Developer', 40000, '1992-07-25'),
    ('David',   'Wilson',  'S005', 'Trainee',   20000, '2000-01-30'),
    ('Laura',   'Martinez','S006', 'Analyst',   34000, '1989-09-09');

SELECT * FROM staff ORDER BY staff_id;

-- 1.3
INSERT INTO staff (first_name, last_name, staff_id, position, salary, dob)
VALUES ('Peter', 'Miller', 'S007', 'Trainee', NULL, '1999-04-18');

SELECT * FROM staff WHERE salary IS NULL;

-- 1.4
INSERT INTO staff (last_name, staff_id, first_name, position, salary, dob)
VALUES ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000, '1991-06-20');

SELECT * FROM staff WHERE staff_id = 'S008';

-- 1.5
INSERT INTO high_earners (staff_id, first_name, last_name, position, salary, dob)
SELECT staff_id, first_name, last_name, position, salary, dob
FROM   staff
WHERE  salary >= 35000;

SELECT * FROM high_earners ORDER BY salary DESC;

-- 1.6
INSERT INTO product (name) VALUES ('Notebook');

INSERT INTO product (name, price, quantity, category)
VALUES ('Laptop', 899.99, 10, 'Electronics');


INSERT INTO product (name, price) VALUES ('Mouse', 19.50);

INSERT INTO product (name, price, quantity, category)
VALUES ('Pen', DEFAULT, DEFAULT, DEFAULT);

SELECT * FROM product;

-- 1.7

INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob)
VALUES ('S001', 'John', 'Smith', 'Manager', 45000, '1980-05-15')
ON CONFLICT (staff_id) DO NOTHING;

INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob)
SELECT 'S002', 'Sarah', 'Johnson', 'Analyst', 32000::numeric, '1990-03-12'::date
WHERE NOT EXISTS (SELECT 1 FROM staff WHERE staff_id = 'S002');

INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob)
VALUES ('S008', 'Jessica', 'Thompson', 'Supervisor', 38000, '1991-06-20')
ON CONFLICT (staff_id) DO UPDATE
SET position = EXCLUDED.position,
    salary   = EXCLUDED.salary;

SELECT COUNT(*) AS total_staff FROM staff;

-- 1.8
INSERT INTO department (dept_name)
VALUES ('Management'), ('Analytics'), ('Engineering');

ALTER TABLE staff
    ADD COLUMN department_id INT REFERENCES department (department_id);

INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob, department_id)
VALUES ('S009', 'Daniel', 'Green', 'Analyst', 33000, '1993-08-21',
        (SELECT department_id FROM department WHERE dept_name = 'Analytics'));

UPDATE staff s
SET    department_id = d.department_id
FROM   department d
WHERE  (d.dept_name = 'Management'  AND s.position IN ('Manager', 'Supervisor'))
   OR  (d.dept_name = 'Analytics'   AND s.position = 'Analyst')
   OR  (d.dept_name = 'Engineering' AND s.position = 'Developer');


SELECT s.staff_id, s.first_name, s.last_name, s.position, d.dept_name
FROM   staff s
LEFT JOIN department d ON d.department_id = s.department_id
ORDER BY s.staff_id;


-- 1.9
INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob)
SELECT v.staff_id, v.first_name, v.last_name, v.position, v.salary, v.dob
FROM (VALUES ('S010', 'Tom', 'Baker', 'Analyst', 22000::numeric, '1995-02-14'::date))
     AS v (staff_id, first_name, last_name, position, salary, dob)
WHERE v.salary BETWEEN 20000 AND 100000;

INSERT INTO staff (staff_id, first_name, last_name, position, salary, dob)
SELECT v.staff_id, v.first_name, v.last_name, v.position, v.salary, v.dob
FROM (VALUES ('S011', 'Too', 'Low', 'Analyst', 5000::numeric, '1996-01-01'::date))
     AS v (staff_id, first_name, last_name, position, salary, dob)
WHERE v.salary BETWEEN 20000 AND 100000;

SELECT staff_id, first_name, salary FROM staff WHERE staff_id IN ('S010', 'S011');