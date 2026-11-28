-- Exercise 1.10: Performance Comparison - Single vs Bulk Insert
USE dsd2026;

CREATE TABLE PerfTest (
    id  INT PRIMARY KEY,
    val VARCHAR(20)
);

-- Approach 1: Single inserts (5 separate statements)
INSERT INTO PerfTest VALUES (1, 'a');
INSERT INTO PerfTest VALUES (2, 'b');
INSERT INTO PerfTest VALUES (3, 'c');
INSERT INTO PerfTest VALUES (4, 'd');
INSERT INTO PerfTest VALUES (5, 'e');

-- Approach 2: Bulk insert (1 statement, 5 rows)
INSERT INTO PerfTest VALUES
(6, 'f'), (7, 'g'), (8, 'h'), (9, 'i'), (10, 'j');

SELECT * FROM PerfTest;