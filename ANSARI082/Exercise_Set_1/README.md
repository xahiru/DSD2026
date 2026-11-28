# Exercise Set 1: Basic INSERT Operations

**Student:** ANSARI MOHAMMAD ESA | **ID:** 20243120082 | **Course:** Database | **University:** YNU
**DBMS:** MySQL 8.0 (MySQL Workbench 8.0 CE) | **Server version:** 8.0.46

## How to run
- MySQL Workbench: open `ALL_IN_ONE.sql` and press the lightning icon (Ctrl+Shift+Enter).
- Command line: `mysql -u root -p < run_all.sql` (from this folder).
- Every exercise file also runs on its own after `00_setup.sql` and the files before it. The script starts with `DROP DATABASE IF EXISTS dsd2026_ex1`, so it can be re-run safely.

## Exercises
| # | File | What it shows |
|---|------|---------------|
| 1.1 | `1_1_insert_single.sql` | Creates `Staff` and inserts one row (S001 John Smith) |
| 1.2 | `1_2_insert_multiple.sql` | Five rows in one `INSERT`; the table then holds 6 rows |
| 1.3 | `1_3_insert_null.sql` | NULL salary; found with `IS NULL`, not `= NULL` |
| 1.4 | `1_4_column_order.sql` | Values follow the column list, not the table order |
| 1.5 | `1_5_insert_select.sql` | `INSERT ... SELECT` copies salaries >= 35000 into `HighEarners` (4 rows) |
| 1.6 | `1_6_default_values.sql` | `DEFAULT` values, both omitted and written explicitly |
| 1.7 | `1_7_duplicate_prevention.sql` | `NOT EXISTS`, `INSERT IGNORE`, `ON DUPLICATE KEY UPDATE` |
| 1.8 | `1_8_related_tables.sql` | `Department` parent, foreign key from `Staff`, parent-before-child insert |
| 1.9 | `1_9_conditional_insert.sql` | Insert only if business rules pass (1 inserted, 2 rejected) |
| 1.10 | `1_10_single_vs_bulk.sql` | 2000 single inserts vs one bulk insert |

## Evidence (screenshots)

### 1.1 Single record
 ![1_1](screenshots/1_1.png)

### 1.2 Multiple records (6 rows, then the count)
 ![1_2_a](screenshots/1_2_a.png) ![1_2_b](screenshots/1_2_b.png)

### 1.3 NULL value
 ![1_3](screenshots/1_3.png)

### 1.4 Different column order
 ![1_4](screenshots/1_4.png)

### 1.5 INSERT ... SELECT (HighEarners, then the count)
 ![1_5_a](screenshots/1_5_a.png) ![1_5_b](screenshots/1_5_b.png)

### 1.6 DEFAULT values
 ![1_6](screenshots/1_6.png)

### 1.7 Duplicate prevention
Method 1 first run (1 row), second run (0 rows), then `INSERT IGNORE` warning 1062, S001 unchanged, upsert result (S009 salary 37000), duplicate check (empty), total 9:

 ![1_7_1](screenshots/1_7_1.png) ![1_7_2](screenshots/1_7_2.png) ![1_7_3](screenshots/1_7_3.png) ![1_7_4](screenshots/1_7_4.png) ![1_7_5](screenshots/1_7_5.png) ![1_7_6](screenshots/1_7_6.png) ![1_7_7](screenshots/1_7_7.png)

### 1.8 Related tables (foreign key and JOIN)
 ![1_8](screenshots/1_8.png)

### 1.9 Conditional insert
Rows inserted for the three candidates (1, 0, 0), then the final check showing only S011:

 ![1_9_1](screenshots/1_9_1.png) ![1_9_2](screenshots/1_9_2.png) ![1_9_3](screenshots/1_9_3.png) ![1_9_4](screenshots/1_9_4.png)

### 1.10 Single vs bulk
 ![1_10_1](screenshots/1_10_1.png) ![1_10_2](screenshots/1_10_2.png)

## Exercise 1.10: measured result
| Method | Rows | Seconds |
|--------|------|---------|
| 2000 single INSERTs (auto-commit) | 2000 | 2.601406 |
| 1 bulk INSERT ... SELECT | 2000 | 0.026742 |

The bulk insert was about **97.3 times faster**. Each single INSERT is parsed, executed and committed separately; the bulk statement is parsed once and committed once.

## Notes
- Duplicate keys raise Error 1062; the three methods in 1.7 each handle that differently (skip silently, skip with a warning, or update).
- Foreign keys in 1.8 enforce referential integrity: inserting a Staff row with a non-existent `DeptID` fails with Error 1452.
