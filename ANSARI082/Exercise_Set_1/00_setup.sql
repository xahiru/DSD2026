-- Exercise Set 1 : Setup
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

-- A dedicated database keeps this work separate from other schemas (e.g. ai_weather).
DROP DATABASE IF EXISTS dsd2026_ex1;
CREATE DATABASE dsd2026_ex1 CHARACTER SET utf8mb4;
USE dsd2026_ex1;
SELECT DATABASE() AS current_database;
