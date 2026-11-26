# DreamHome - SQL Exercises SET 1 

Name: Ngoyi Ilunga Herve Emmanuel | Student ID: 20243120090 | DBMS: PostgreSQL


## Project structure

```
C:.
│__ 01_schema.sql
│   02_sample_data.sql
│   README.md
│
└───img
        erd_diagram.png
        table_department.png
        table_high_earners.png
        table_product.png
        table_staff.png
```

## Files

| File | Content |
|---|---|
| `01_schema.sql` | Creates the tables: `staff`, `high_earners`, `product`, `department`, plus the single vs bulk insert test (1.10) |
| `02_sample_data.sql` | Inserts the data and runs the solutions for exercises 1.1 to 1.9 |
| `img/` | Screenshots: the ERD diagram (`erd_diagram.png`) and the content of each table (`table_staff.png`, `table_high_earners.png`, `table_product.png`, `table_department.png`) |

## Requirements

- PostgreSQL 11 or newer
- pgAdmin or psql

## How to run
 
OPTION A:
 
1. Create the database (once, while connected to `postgres`):
```sql
CREATE DATABASE dreamhome;
```
 
2. Connect to it:
   - psql: `\c dreamhome`
   - pgAdmin: right-click `dreamhome` > Query Tool
3. Run `01_schema.sql`.
4. Run `02_sample_data.sql`.
To start again from zero, run `01_schema.sql` again. It drops and recreates the tables.
 
With psql you can run both files like this:
 
```
psql -U postgres -d dreamhome -f 01_schema.sql
psql -U postgres -d dreamhome -f 02_sample_data.sql
```
 
OPTION B:
 
Create the database directly in pgAdmin and use the Query Tool to paste the code and execute it.
 
1. Open pgAdmin and connect to your server.
2. In the left tree, right-click Databases > Create > Database...
3. Write `dreamhome` as the database name and click Save.
4. Right-click `dreamhome` > Query Tool. Check that the tab title shows `dreamhome`.
5. Paste the code of `01_schema.sql` and click Execute (the play button, or F5).
6. Clear the editor, paste the code of `02_sample_data.sql` and click Execute again.
7. To see the result, go to `dreamhome` > Schemas > public > Tables, right-click Tables > Refresh, then right-click a table (for example `staff`) > View/Edit Data > All Rows.

To start again from zero, run `01_schema.sql` again.

## Tables

**staff**: first_name, last_name, staff_id (primary key), position, salary, dob.
A `department_id` column (foreign key to `department`) is added in exercise 1.8 with `ALTER TABLE`.

**high_earners**: same structure as `staff`, filled in 1.5 with staff earning 35000 or more.

**product**: product_id, name, price, quantity, category, created_at (with default values, used in 1.6).

**department**: department_id, dept_name.

## Notes

- Table and column names are lowercase because PostgreSQL folds unquoted names to lowercase (`HighEarners` becomes `high_earners`).
- If you get `current transaction is aborted, commands ignored until end of transaction block`, run `ROLLBACK;` and look for the first error above it. The other errors are only a result of that one.
- There is no `CREATE DATABASE IF NOT EXISTS` in PostgreSQL, so the database is created separately in step 1.