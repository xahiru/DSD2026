# DreamHome — SQL Exercises, Set 1: Basic INSERT Operations

**Name:** ROY SUDIPTA · **Student ID:** 20243120070 · **DBMS:** MySQL 8

## Project structure

```
ROY070/
├── 01_schema.sql         all CREATE TABLE statements
├── 02_sample_data.sql    all INSERT solutions for 1.1 – 1.10
├── README.md
└── img/
    ├── erd_diagram.png
    ├── table_staff.png
    ├── table_high_earners.png
    ├── table_product.png
    └── table_department.png
```

## Files

| File | Content |
|------|---------|
| `01_schema.sql` | Creates `staff`, `high_earners`, `product`, `department`, plus `salary_audit` and `perf_test` |
| `02_sample_data.sql` | Exercises 1.1 – 1.10 (single insert, multi-row, NULL, column order, INSERT…SELECT, DEFAULT, duplicate handling, multi-table, conditional, and the single-vs-bulk timing test) |
| `img/` | ER diagram and a screenshot of each table |

## Requirements

- MySQL 8.0 (Workbench, or the `mysql` client)
- The `mysql` command-line client, or MySQL Workbench

## How to run

### Option A — command line

```bash
mysql -u root -p < 01_schema.sql
mysql -u root -p dreamhome < 02_sample_data.sql
```

`01_schema.sql` creates the `dreamhome` database and all tables; it also
drops them first, so running it again resets everything cleanly.

### Option B — MySQL Workbench

1. Open MySQL Workbench and connect to your local server.
2. Open `01_schema.sql` and run it (the lightning bolt). This creates the
   `dreamhome` database and all tables.
3. Open `02_sample_data.sql` and run it. The result grid for each query
   shows up at the bottom.
4. To reset, just run `01_schema.sql` again.

## Tables

**staff** — `staff_id` (PK), `first_name`, `last_name`, `position`, `salary`, `dob`, `department_id` (FK → `department`).

**high_earners** — a snapshot of staff earning ≥ 35000 (filled in 1.5).

**product** — `product_id` (auto-increment PK), `name`, `category`, `price`, `quantity`, `created_at`, all with defaults (1.6).

**department** — `dept_id` (PK), `dept_name` (1.8).

## Notes

- `staff_id` is `CHAR(4)` (not `INT`) because the IDs are zero-padded like `S001`; an integer would drop the leading zero.
- `salary` is `DECIMAL(10,2)` rather than `FLOAT`, since money stored as float loses precision when summed.
- Exercise 1.10 uses a stored procedure with `NOW(6)` to time 10,000 single inserts against one bulk insert — bulk insert wins by a wide margin because the per-statement overhead is paid only once.
