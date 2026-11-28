CREATE TABLE HighEarners (
    staff_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    dob DATE
);

INSERT INTO HighEarners
SELECT *
FROM Staff
WHERE salary >= 35000;