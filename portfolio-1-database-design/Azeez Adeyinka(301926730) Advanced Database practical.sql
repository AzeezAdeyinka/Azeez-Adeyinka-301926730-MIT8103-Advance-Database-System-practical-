   CREATE DATABASE insightmove_db;
   USE insightmove_db;
   
   CREATE TABLE CUSTOMERS (
		customer_id INT AUTO_INCREMENT PRIMARY KEY,
		full_name VARCHAR(50) NOT NULL,
		email VARCHAR(100) UNIQUE KEY NOT NULL,
		phone_number VARCHAR(20) UNIQUE KEY NOT NULL,
        added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ) ;

USE insightmove_db;

INSERT INTO customers (full_name, email, phone_number)
   VALUES ('Test customer 1', 'testcustomer1@gmail.com', '08012345678');
   
SELECT * 
FROM customers;

