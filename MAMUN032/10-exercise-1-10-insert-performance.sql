-- Exercise 1.10: Compare separate and bulk inserts
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

CREATE TABLE SingleInsertTest (
    ID INT PRIMARY KEY,
    Name VARCHAR(30)
);

CREATE TABLE BulkInsertTest LIKE SingleInsertTest;

-- Three separate INSERT statements
SET @single_start = NOW(6);

INSERT INTO SingleInsertTest VALUES (1, 'A');
INSERT INTO SingleInsertTest VALUES (2, 'B');
INSERT INTO SingleInsertTest VALUES (3, 'C');

SET @single_us = TIMESTAMPDIFF(MICROSECOND, @single_start, NOW(6));

-- One INSERT statement with three rows
SET @bulk_start = NOW(6);

INSERT INTO BulkInsertTest VALUES
    (1, 'A'),
    (2, 'B'),
    (3, 'C');

SET @bulk_us = TIMESTAMPDIFF(MICROSECOND, @bulk_start, NOW(6));

SELECT
    @single_us AS SeparateInsertMicroseconds,
    @bulk_us AS BulkInsertMicroseconds;

SELECT
    (SELECT COUNT(*) FROM SingleInsertTest) AS SeparateRows,
    (SELECT COUNT(*) FROM BulkInsertTest) AS BulkRows;
