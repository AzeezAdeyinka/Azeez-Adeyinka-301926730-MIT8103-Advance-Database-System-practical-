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


CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    address     VARCHAR(150) NOT NULL,
    area        VARCHAR(50) NOT NULL,
    latitude    DECIMAL(9,6) NOT NULL,
    longitude   DECIMAL(9,6) NOT NULL,
    CONSTRAINT chk_latitude  CHECK (latitude  BETWEEN -90 AND 90),
    CONSTRAINT chk_longitude CHECK (longitude BETWEEN -180 AND 180)
);

INSERT INTO locations (address, area, latitude, longitude)
   VALUES ('Test Street, NO 345 industrial Street', 'Ilupeju', 6.6018, 3.3515);
   
SELECT *
FROM customers, drivers, vehicles, locations;


CREATE TABLE trips (
    trip_id             INT AUTO_INCREMENT PRIMARY KEY,
    customer_id         INT NOT NULL,
    driver_id           INT NULL,
    vehicle_id          INT NULL,
    trip_type           ENUM('ride', 'delivery') NOT NULL,
    pickup_location_id  INT NOT NULL,
    dropoff_location_id INT NOT NULL,
    status              ENUM('requested', 'accepted', 'in_progress', 'completed', 'cancelled')
                        NOT NULL DEFAULT 'requested',
    requested_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at          DATETIME NULL,
    completed_at        DATETIME NULL,
    distance_km         DECIMAL(6,2) NULL,
    fare_amount         DECIMAL(10,2) NULL,
    CONSTRAINT foreignKey_trip_customer FOREIGN KEY (customer_id)         REFERENCES customers(customer_id),
    CONSTRAINT foreignKey_trip_driver   FOREIGN KEY (driver_id)           REFERENCES drivers(driver_id),
    CONSTRAINT foreignKey_trip_vehicle  FOREIGN KEY (vehicle_id)          REFERENCES vehicles(vehicle_id),
    CONSTRAINT foreignKey_trip_pickup   FOREIGN KEY (pickup_location_id)  REFERENCES locations(location_id),
    CONSTRAINT foreignKey_trip_dropoff  FOREIGN KEY (dropoff_location_id) REFERENCES locations(location_id),
    CONSTRAINT check_trip_locations CHECK (pickup_location_id <> dropoff_location_id),
    CONSTRAINT check_trip_fare      CHECK (fare_amount IS NULL OR fare_amount >= 0)
);

INSERT INTO trips (customer_id, trip_type, pickup_location_id, dropoff_location_id)
   VALUES (1, 'ride', 1, 2);
   

SELECT *
FROM trips;


CREATE TABLE deliveries (
    delivery_id        INT AUTO_INCREMENT PRIMARY KEY,
    trip_id            INT NOT NULL UNIQUE,
    parcel_description VARCHAR(150) NOT NULL,
    weight_kg          DECIMAL(6,2) NOT NULL,
    recipient_name     VARCHAR(50) NOT NULL,
    recipient_phone    VARCHAR(20) NOT NULL,
    delivery_status    ENUM('pending', 'picked_up', 'in_transit', 'delivered', 'failed')
                       NOT NULL DEFAULT 'pending',
    CONSTRAINT foreignKey_delivery_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
    CONSTRAINT check_weight CHECK (weight_kg > 0)
);

INSERT INTO deliveries (trip_id, parcel_description, weight_kg, recipient_name, recipient_phone)
   VALUES (1, 'Test parcel', 2.5, 'Test Recipient', '08099990002');
   
SELECT *
FROM deliveries;


CREATE TABLE trip_status_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    trip_id    INT NOT NULL,
    status     ENUM('requested', 'accepted', 'in_progress', 'completed', 'cancelled') NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note       VARCHAR(200) NULL,
    CONSTRAINT foreignKey_history_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE
);

INSERT INTO trip_status_history (trip_id, status) 
	VALUES (1, 'requested');
INSERT INTO trip_status_history (trip_id, status, note) 
	VALUES (1, 'accepted', 'Driver accepted');

SELECT *
FROM trip_status_history;


CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id    INT NOT NULL,
    amount     DECIMAL(10,2) NOT NULL,
    method     ENUM('cash', 'card', 'transfer', 'wallet') NOT NULL,
    status     ENUM('pending', 'successful', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    paid_at    DATETIME NULL,
    CONSTRAINT foreignKey_payment_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    CONSTRAINT check_payment_amount CHECK (amount > 0)
);

INSERT INTO payments (trip_id, amount, method)
   VALUES (1, 4500.00, 'card');
   
SELECT *
FROM payments;
