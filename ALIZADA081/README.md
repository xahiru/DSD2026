# Database System Design — SQL Practice Exercises

## Student Information

- **Name:** Mohammad Alizada
- **Student ID:** 20243120081
- **University:** Yunnan University
- **Course:** Database System Design
- **Student Folder:** ALIZADA081

## 1. Project Overview

This assignment demonstrates basic SQL INSERT operations using MySQL. The objective is to understand data insertion, default values, NULL values, duplicate key prevention, referential integrity, conditional insertion, and bulk insertion.

All exercises are implemented using the DreamHome database.

## 2. Development Environment

- MySQL Community Server
- MySQL Workbench
- Visual Studio Code
- SQLTools
- SQLTools MySQL/MariaDB/TiDB Driver
- Git and GitHub

## 3. Completed Exercises

| Exercise | Description |
|---|---|
| 1.1 | Insert a Single Record |
| 1.2 | Insert Multiple Records |
| 1.3 | Insert with NULL Values |
| 1.4 | Insert with Different Column Order |
| 1.5 | Bulk Insert with INSERT ... SELECT |
| 1.6 | Insert with DEFAULT Values |
| 1.7 | Insert and Handle Duplicate Key Prevention |
| 1.8 | Multi-Table Insert (Related Records) |
| 1.9 | Conditional Insert Based on Business Logic |
| 1.10 | Performance Comparison — Single vs Bulk Insert |

## 4. Database Tables

| Table | Purpose |
|---|---|
| Staff | Stores employee information |
| HighEarners | Stores selected employees earning 35000 or more |
| Product | Demonstrates default values |
| Department | Demonstrates foreign key relationships |
| SingleInsertTest | Tests individual INSERT operations |
| BulkInsertTest | Tests bulk INSERT operations |

## 5. Project Files

| File or Folder | Description |
|---|---|
| 01_Create_Database.sql | Creates the DreamHome database |
| 02_Insert_Operations.sql | Contains the ten INSERT exercises |
| Screenshot/ | Contains screenshots of execution results |
| README.md | Project documentation |

## 6. How to Run

1. Install and start MySQL Community Server.
2. Connect to MySQL using VS Code or MySQL Workbench.
3. Execute `01_Create_Database.sql`.
4. Open `02_Insert_Operations.sql`.
5. Execute each exercise separately in numerical order.
6. Verify the results using SELECT statements.

Note: Some statements intentionally demonstrate duplicate key and foreign key errors. These errors are expected and demonstrate database integrity constraints.

## 7. Learning Outcomes

Through this assignment, I practiced:

- Creating databases and tables.
- Inserting single and multiple records.
- Working with NULL and DEFAULT values.
- Preventing duplicate primary keys.
- Establishing foreign key relationships.
- Applying business conditions to data insertion.
- Comparing single and bulk INSERT operations.
- Verifying database records using SQL queries.

## 8. Conclusion

This assignment demonstrates the fundamental principles of SQL data insertion and relational database integrity using MySQL.

The submission focuses on Exercise Set 1, Basic INSERT Operations, as required by the instructor.