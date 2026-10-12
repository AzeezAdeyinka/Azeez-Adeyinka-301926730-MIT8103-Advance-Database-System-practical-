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

CREATE TABLE DRIVERS (
    driver_id      INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(50) NOT NULL,
    phone_number   VARCHAR(20) NOT NULL UNIQUE,
    license_number VARCHAR(30) NOT NULL UNIQUE,
    status         ENUM('available', 'on_trip', 'offline') NOT NULL DEFAULT 'offline',
    rating         DECIMAL(2,1) NULL,
    joined_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_driver_rating CHECK (rating IS NULL OR rating BETWEEN 1.0 AND 5.0)
);

INSERT INTO drivers (full_name, phone_number, license_number)
   VALUES ('Test Driver 1', '08099990001', 'TEST-LIC-001');
   
SELECT *
FROM customers, drivers;


CREATE TABLE vehicles (
    vehicle_id   INT AUTO_INCREMENT PRIMARY KEY,
    driver_id    INT NOT NULL,
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_type ENUM('bike', 'car', 'van') NOT NULL,
    capacity_kg  DECIMAL(7,2) NOT NULL,
    CONSTRAINT foreignKey_vehicle_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    CONSTRAINT chk_capacity CHECK (capacity_kg > 0)
);

INSERT INTO vehicles (driver_id, plate_number, vehicle_type, capacity_kg)
	VALUES (1, 'TEST-001-AA', 'car', 300);
    
SELECT *
FROM customers, drivers, vehicles;

