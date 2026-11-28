-- Exercise 1.10 : Performance - single inserts vs bulk insert
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

CREATE TABLE Perf_Single  (id INT PRIMARY KEY, val VARCHAR(40));
CREATE TABLE Perf_Bulk    (id INT PRIMARY KEY, val VARCHAR(40));
CREATE TABLE Perf_Results (method VARCHAR(40), rows_inserted INT, seconds DECIMAL(12,6));

-- ---------- Approach A: 2000 separate INSERT statements (each auto-committed) ----------
DROP PROCEDURE IF EXISTS load_single;
DELIMITER $$
CREATE PROCEDURE load_single(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        INSERT INTO Perf_Single (id, val) VALUES (i, CONCAT('row_', i));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

SET autocommit = 1;                 -- every INSERT is its own transaction
SET @t0 = NOW(6);
CALL load_single(2000);
SET @single_sec = TIMESTAMPDIFF(MICROSECOND, @t0, NOW(6)) / 1000000;

-- ---------- Approach B: ONE bulk INSERT ... SELECT generating 2000 rows ----------
SET SESSION cte_max_recursion_depth = 10000;
SET @t1 = NOW(6);
INSERT INTO Perf_Bulk (id, val)
WITH RECURSIVE seq (n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM seq WHERE n < 2000
)
SELECT n, CONCAT('row_', n) FROM seq;
SET @bulk_sec = TIMESTAMPDIFF(MICROSECOND, @t1, NOW(6)) / 1000000;

-- ---------- Results ----------
INSERT INTO Perf_Results VALUES
    ('2000 single INSERTs', (SELECT COUNT(*) FROM Perf_Single), @single_sec),
    ('1 bulk INSERT',       (SELECT COUNT(*) FROM Perf_Bulk),   @bulk_sec);

SELECT method, rows_inserted, seconds FROM Perf_Results;
SELECT ROUND(@single_sec / @bulk_sec, 1) AS bulk_is_x_times_faster;

-- Why: each single INSERT is parsed, executed and committed (flushed to the redo log) separately.
-- A bulk INSERT does one parse and one commit for all rows.
