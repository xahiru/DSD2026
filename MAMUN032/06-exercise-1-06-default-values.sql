-- Exercise 1.6: Insert products with default values
-- MySQL 8.4 | Exercise Set 1
-- Run files 01 through 10 in order, once, in the dedicated practice database.

USE exercise_set_1;

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) DEFAULT 0.00,
    Stock INT DEFAULT 0,
    Category VARCHAR(50) DEFAULT 'General'
);

-- All values supplied
INSERT INTO Product
    (ProductID, ProductName, Price, Stock, Category)
VALUES
    (1, 'Keyboard', 1500, 10, 'Electronics');

-- Optional columns omitted: defaults will be used
INSERT INTO Product
    (ProductID, ProductName)
VALUES
    (2, 'Notebook');

-- Explicitly request DEFAULT for Price
INSERT INTO Product
    (ProductID, ProductName, Price, Stock)
VALUES
    (3, 'Pen', DEFAULT, 50);

SELECT * FROM Product ORDER BY ProductID;
