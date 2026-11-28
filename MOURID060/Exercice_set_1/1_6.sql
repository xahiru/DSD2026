CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) DEFAULT 0.00,
    stock INT DEFAULT 10,
    status VARCHAR(20) DEFAULT 'Available'
);


INSERT INTO Product (product_name, price, stock, status)
VALUES ('Laptop', 1200, 5, 'Available');


INSERT INTO Product (product_name)
VALUES ('Keyboard');


INSERT INTO Product (product_name, price)
VALUES ('Mouse', 25);