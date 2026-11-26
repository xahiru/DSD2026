-- CREATE DATABASE dreamhome; for mysql

DROP TABLE IF EXISTS salary_audit, perf_test, product, high_earners, staff, department CASCADE;

-- 1.1

CREATE TABLE staff (
    first_name  VARCHAR(50)   NOT NULL,
    last_name   VARCHAR(50),
    staff_id    VARCHAR(10)   PRIMARY KEY,
    position    VARCHAR(50),
    salary      NUMERIC(10,2) CHECK (salary >= 0),
    dob         DATE
);

-- 1.1 (insert), 1.2, 1.3 and 1.4 are in 02_sample_demo.sql

-- 1.5:
CREATE TABLE high_earners (LIKE staff INCLUDING ALL);

-- 1.5 (insert) is in 02_sample_demo.sql

-- 1.6
CREATE TABLE product (
    product_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    price       NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    quantity    INT           NOT NULL DEFAULT 0,
    category    VARCHAR(50)   DEFAULT 'General',
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- 1.6 (insert) and 1.7 are in 02_sample_demo.sql

-- 1.8
CREATE TABLE department (
    department_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name      VARCHAR(50) NOT NULL UNIQUE
);

-- 1.8 (insert) and 1.9 are in 02_sample_demo.sql

-- 1.10
CREATE TABLE perf_test (id INT, info TEXT);

DO $$
DECLARE
    t0 TIMESTAMPTZ;
    t1 TIMESTAMPTZ;
    t2 TIMESTAMPTZ;
    t3 TIMESTAMPTZ;
BEGIN
    t0 := clock_timestamp();
    FOR i IN 1..10000 LOOP
        INSERT INTO perf_test VALUES (i, 'row ' || i);
    END LOOP;
    t1 := clock_timestamp();

    TRUNCATE perf_test;

    t2 := clock_timestamp();
    INSERT INTO perf_test
    SELECT g, 'row ' || g FROM generate_series(1, 10000) AS g;
    t3 := clock_timestamp();

    RAISE NOTICE 'Single inserts (10000 rows): %', t1 - t0;
    RAISE NOTICE 'Bulk insert    (10000 rows): %', t3 - t2;
END $$;

DROP TABLE perf_test;