-- Exercise 1.6: Insert with DEFAULT Values
USE dsd2026;

CREATE TABLE Product (
    ProductID   INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price       DECIMAL(10,2) DEFAULT 9.99,
    Stock       INT DEFAULT 0,
    Category    VARCHAR(50) DEFAULT 'General'
);

-- Without optional columns (defaults will be used)
INSERT INTO Product (ProductName) VALUES ('Pen');

-- With optional columns specified
INSERT INTO Product (ProductName, Price, Stock, Category)
VALUES ('Laptop', 750.00, 10, 'Electronics');

-- Using the DEFAULT keyword explicitly
INSERT INTO Product (ProductName, Price, Stock)
VALUES ('Notebook', DEFAULT, 50);

SELECT * FROM Product;