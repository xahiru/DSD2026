-- Exercise 1.6 : Insert with DEFAULT values
-- Student : ANSARI MOHAMMAD ESA | ID: 20243120082 | Course: Database (YNU)
-- DBMS    : MySQL 8.0

USE dsd2026_ex1;

CREATE TABLE Product (
    ProductID   INT           NOT NULL AUTO_INCREMENT,
    ProductName VARCHAR(100)  NOT NULL,
    Category    VARCHAR(50)   NOT NULL DEFAULT 'General',
    Price       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Stock       INT           NOT NULL DEFAULT 0,
    CreatedAt   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ProductID)
);

-- (a) Only the required column: every other column uses its DEFAULT
INSERT INTO Product (ProductName) VALUES ('USB Cable');

-- (b) Some optional columns given
INSERT INTO Product (ProductName, Price) VALUES ('Notebook', 12.50);

-- (c) All columns given explicitly
INSERT INTO Product (ProductName, Category, Price, Stock)
VALUES ('Mechanical Keyboard', 'Electronics', 89.90, 25);

-- (d) The DEFAULT keyword used explicitly inside VALUES
INSERT INTO Product (ProductName, Category, Price, Stock)
VALUES ('Desk Lamp', DEFAULT, 24.00, DEFAULT);

-- Verify: compare which values came from DEFAULT
SELECT * FROM Product;
