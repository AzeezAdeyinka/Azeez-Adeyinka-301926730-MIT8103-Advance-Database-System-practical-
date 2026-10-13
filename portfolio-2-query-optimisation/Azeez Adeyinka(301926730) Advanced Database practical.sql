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

INSERT INTO customers (customer_id, full_name, email, phone_number)
	VALUES
	(1, 'Tola Adebayo', 'tola.adebayo@example.com', '08011110001'),
	(2, 'Chinedu Adeoye', 'chinedu.adeoye@example.com', '08011110002'),
	(3, 'Amina Sani', 'amina.sani@example.com', '08011110003'),
	(4, 'Segun Eze', 'segun.eze@example.com', '08011110004'),
	(5, 'Ngozi Ibrahim', 'ngozi.ibrahim@example.com', '08011110005'),
	(6, 'Bola Okoro', 'bola.okoro@example.com', '08011110006'),
	(7, 'Kunle Williams', 'kunle.williams@example.com', '08011110007'),
	(8, 'Bisi Nwosu', 'bisi.nwosu@example.com', '08011110008'),
	(9, 'Emeka Balogun', 'emeka.balogun@example.com', '08011110009'),
	(10, 'Hassan Ajayi', 'hassan.ajayi@example.com', '08011110010'),
	(11, 'Femi Ogunleye', 'femi.ogunleye@example.com', '08011110011'),
	(12, 'Zainab Bakare', 'zainab.bakare@example.com', '08011110012'),
	(13, 'Ifeanyi Lawal', 'ifeanyi.lawal@example.com', '08011110013'),
	(14, 'Yetunde Danjuma', 'yetunde.danjuma@example.com', '08011110014'),
	(15, 'Musa Okafor', 'musa.okafor@example.com', '08011110015'),
	(16, 'Chioma Obi', 'chioma.obi@example.com', '08011110016'),
	(17, 'Dayo Umeh', 'dayo.umeh@example.com', '08011110017'),
	(18, 'Halima Yusuf', 'halima.yusuf@example.com', '08011110018'),
	(19, 'Obinna Musa', 'obinna.musa@example.com', '08011110019'),
	(20, 'Sade Fashola', 'sade.fashola@example.com', '08011110020');
 
   
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
    CONSTRAINT check_driver_rating CHECK (rating IS NULL OR rating BETWEEN 1.0 AND 5.0)
);

INSERT INTO drivers (driver_id, full_name, phone_number, license_number, status, rating) 
	VALUES
	(1, 'Bola Okafor', '08022220001', 'LAG-DL-1001', 'on_trip', 4.8),
	(2, 'Emeka Nwosu', '08022220002', 'LAG-DL-1002', 'available', 4.2),
	(3, 'Zainab Adebayo', '08022220003', 'LAG-DL-1003', 'available', 4.9),
	(4, 'Musa Danjuma', '08022220004', 'LAG-DL-1004', 'offline', 3.8),
	(5, 'Halima Williams', '08022220005', 'LAG-DL-1005', 'available', 4.0),
	(6, 'Tola Fashola', '08022220006', 'LAG-DL-1006', 'available', 4.0),
	(7, 'Segun Lawal', '08022220007', 'LAG-DL-1007', 'available', 4.8),
	(8, 'Kunle Okoro', '08022220008', 'LAG-DL-1008', 'offline', 3.8),
	(9, 'Hassan Musa', '08022220009', 'LAG-DL-1009', 'available', 4.5),
	(10, 'Ifeanyi Bakare', '08022220010', 'LAG-DL-1010', 'available', 3.8),
	(11, 'Chioma Ibrahim', '08022220011', 'LAG-DL-1011', 'on_trip', 4.0),
	(12, 'Obinna Yusuf', '08022220012', 'LAG-DL-1012', 'on_trip', 4.9),
	(13, 'Chinedu Ogunleye', '08022220013', 'LAG-DL-1013', 'available', 4.9),
	(14, 'Ngozi Eze', '08022220014', 'LAG-DL-1014', 'available', 4.0),
	(15, 'Bisi Umeh', '08022220015', 'LAG-DL-1015', 'available', 4.5),
	(16, 'Femi Ajayi', '08022220016', 'LAG-DL-1016', 'offline', 4.0),
	(17, 'Yetunde Sani', '08022220017', 'LAG-DL-1017', 'available', 4.9),
	(18, 'Dayo Obi', '08022220018', 'LAG-DL-1018', 'available', 3.8),
	(19, 'Sade Balogun', '08022220019', 'LAG-DL-1019', 'available', 4.0),
	(20, 'Amina Adeoye', '08022220020', 'LAG-DL-1020', 'offline', NULL);
   
SELECT *
FROM drivers;


CREATE TABLE vehicles (
    vehicle_id   INT AUTO_INCREMENT PRIMARY KEY,
    driver_id    INT NOT NULL,
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_type ENUM('bike', 'car', 'van') NOT NULL,
    capacity_kg  DECIMAL(7,2) NOT NULL,
    CONSTRAINT foreignKey_vehicle_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    CONSTRAINT check_capacity CHECK (capacity_kg > 0)
);

INSERT INTO vehicles (vehicle_id, driver_id, plate_number, vehicle_type, capacity_kg) 
	VALUES
	(1, 1, 'LAG-101-BB', 'car', 300.00),
	(2, 2, 'LAG-102-CC', 'car', 300.00),
	(3, 3, 'LAG-103-DD', 'car', 300.00),
	(4, 4, 'LAG-104-EE', 'car', 300.00),
	(5, 5, 'LAG-105-AA', 'car', 300.00),
	(6, 6, 'LAG-106-BB', 'car', 300.00),
	(7, 7, 'LAG-107-CC', 'car', 300.00),
	(8, 8, 'LAG-108-DD', 'car', 300.00),
	(9, 9, 'LAG-109-EE', 'car', 300.00),
	(10, 10, 'LAG-110-AA', 'car', 300.00),
	(11, 11, 'LAG-111-BB', 'bike', 25.00),
	(12, 12, 'LAG-112-CC', 'bike', 25.00),
	(13, 13, 'LAG-113-DD', 'bike', 25.00),
	(14, 14, 'LAG-114-EE', 'bike', 25.00),
	(15, 15, 'LAG-115-AA', 'bike', 25.00),
	(16, 16, 'LAG-116-BB', 'van', 1200.00),
	(17, 17, 'LAG-117-CC', 'van', 1200.00),
	(18, 18, 'LAG-118-DD', 'van', 1200.00),
	(19, 19, 'LAG-119-EE', 'van', 1200.00),
	(20, 20, 'LAG-120-AA', 'van', 1200.00);
    
SELECT *
FROM vehicles;


CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    address     VARCHAR(150) NOT NULL,
    area        VARCHAR(50) NOT NULL,
    latitude    DECIMAL(9,6) NOT NULL,
    longitude   DECIMAL(9,6) NOT NULL,
    CONSTRAINT check_latitude  CHECK (latitude  BETWEEN -90 AND 90),
    CONSTRAINT check_longitude CHECK (longitude BETWEEN -180 AND 180)
);

INSERT INTO locations (location_id, address, area, latitude, longitude) 
	VALUES
	(1, 'Obafemi Awolowo Way', 'Ikeja', 6.601800, 3.351500),
	(2, 'Admiralty Way', 'Lekki', 6.447400, 3.472300),
	(3, 'Adeola Odeku Street', 'Victoria Island', 6.428000, 3.421000),
	(4, 'Herbert Macaulay Way', 'Yaba', 6.517000, 3.384000),
	(5, 'Adeniran Ogunsanya Street', 'Surulere', 6.500000, 3.358000),
	(6, 'Lekki-Epe Expressway', 'Ajah', 6.466000, 3.568000),
	(7, 'Awolowo Road', 'Ikoyi', 6.452000, 3.435000),
	(8, 'Allen Avenue', 'Ikeja', 6.613000, 3.358000),
	(9, 'Ikorodu Road', 'Maryland', 6.572000, 3.366000),
	(10, 'Broad Street', 'Lagos Island', 6.453000, 3.390000),
	(11, 'Opebi Road', 'Ikeja', 6.595000, 3.355000),
	(12, 'Isaac John Street', 'GRA Ikeja', 6.588000, 3.350000),
	(13, 'Mobolaji Bank Anthony Way', 'Ikeja', 6.580000, 3.360000),
	(14, 'Ozumba Mbadiwe Avenue', 'Victoria Island', 6.430000, 3.420000),
	(15, 'Badagry Expressway', 'Festac', 6.465000, 3.283000),
	(16, 'Apapa Road', 'Apapa', 6.448000, 3.359000),
	(17, 'Egbeda Road', 'Egbeda', 6.587000, 3.290000),
	(18, 'Agege Motor Road', 'Mushin', 6.535000, 3.350000),
	(19, 'Chevron Drive', 'Lekki', 6.440000, 3.500000),
	(20, 'Bode Thomas Street', 'Surulere', 6.496000, 3.360000);
   
SELECT *
FROM locations;


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

INSERT INTO trips (trip_id, customer_id, driver_id, vehicle_id, trip_type, pickup_location_id, dropoff_location_id, status, requested_at, started_at, completed_at, distance_km, fare_amount) 
	VALUES
	(1, 4, 1, 1, 'ride', 8, 17, 'completed', '2026-09-01 11:13:00', '2026-09-01 11:27:00', '2026-09-01 11:51:00', 6.81, 1450.00),
	(2, 7, 11, 11, 'delivery', 15, 8, 'completed', '2026-09-02 16:26:00', '2026-09-02 16:38:00', '2026-09-02 17:38:00', 22.89, 4000.00),
	(3, 10, 2, 2, 'ride', 2, 19, 'completed', '2026-09-03 06:39:00', '2026-09-03 06:46:00', '2026-09-03 07:02:00', 3.08, 950.00),
	(4, 13, 12, 12, 'delivery', 9, 10, 'completed', '2026-09-04 11:52:00', '2026-09-04 12:05:00', '2026-09-04 12:53:00', 17.39, 3250.00),
	(5, 16, 3, 3, 'ride', 16, 1, 'completed', '2026-09-05 16:05:00', '2026-09-05 16:16:00', '2026-09-05 17:41:00', 34.36, 5300.00),
	(6, 19, 13, 13, 'delivery', 3, 12, 'completed', '2026-09-06 06:18:00', '2026-09-06 06:32:00', '2026-09-06 06:54:00', 5.87, 1600.00),
	(7, 2, 4, 4, 'ride', 10, 3, 'completed', '2026-09-07 11:31:00', '2026-09-07 11:42:00', '2026-09-07 12:20:00', 12.89, 2300.00),
	(8, 5, 14, 14, 'delivery', 17, 14, 'completed', '2026-09-08 16:44:00', '2026-09-08 16:59:00', '2026-09-08 17:21:00', 5.90, 1650.00),
	(9, 8, 5, 5, 'ride', 4, 5, 'completed', '2026-09-09 06:57:00', '2026-09-09 07:12:00', '2026-09-09 08:25:00', 28.68, 4500.00),
	(10, 11, NULL, NULL, 'delivery', 11, 16, 'cancelled', '2026-09-10 11:10:00', NULL, NULL, NULL, NULL),
	(11, 14, 6, 6, 'ride', 18, 7, 'completed', '2026-09-11 16:23:00', '2026-09-11 16:36:00', '2026-09-11 17:57:00', 32.64, 5050.00),
	(12, 17, 16, 16, 'delivery', 5, 18, 'completed', '2026-09-12 06:36:00', '2026-09-12 06:50:00', '2026-09-12 08:04:00', 29.18, 4900.00),
	(13, 20, 7, 7, 'ride', 12, 9, 'completed', '2026-09-13 11:49:00', '2026-09-13 11:58:00', '2026-09-13 12:24:00', 7.56, 1550.00),
	(14, 3, 17, 17, 'delivery', 19, 20, 'completed', '2026-09-14 16:02:00', '2026-09-14 16:16:00', '2026-09-14 17:22:00', 25.86, 4400.00),
	(15, 6, 8, 8, 'ride', 6, 11, 'completed', '2026-09-15 06:15:00', '2026-09-15 06:29:00', '2026-09-15 07:41:00', 28.59, 4500.00),
	(16, 9, 18, 18, 'delivery', 13, 2, 'completed', '2026-09-16 11:28:00', '2026-09-16 11:38:00', '2026-09-16 12:08:00', 9.48, 2150.00),
	(17, 12, 9, 9, 'ride', 20, 13, 'completed', '2026-09-17 16:41:00', '2026-09-17 16:52:00', '2026-09-17 18:13:00', 32.66, 5050.00),
	(18, 15, 19, 19, 'delivery', 7, 4, 'completed', '2026-09-18 06:54:00', '2026-09-18 07:07:00', '2026-09-18 07:56:00', 17.93, 3300.00),
	(19, 18, 10, 10, 'ride', 14, 15, 'completed', '2026-09-19 11:07:00', '2026-09-19 11:14:00', '2026-09-19 11:52:00', 13.13, 2350.00),
	(20, 1, 20, 20, 'delivery', 1, 6, 'cancelled', '2026-09-20 16:20:00', NULL, NULL, NULL, NULL),
	(21, 4, 1, 1, 'ride', 8, 17, 'completed', '2026-09-21 06:33:00', '2026-09-21 06:46:00', '2026-09-21 08:01:00', 29.96, 4700.00),
	(22, 7, 11, 11, 'delivery', 15, 8, 'completed', '2026-09-22 11:46:00', '2026-09-22 11:55:00', '2026-09-22 12:37:00', 14.84, 2900.00),
	(23, 10, 2, 2, 'ride', 2, 19, 'completed', '2026-09-23 16:59:00', '2026-09-23 17:14:00', '2026-09-23 17:30:00', 3.01, 900.00),
	(24, 13, 12, 12, 'delivery', 9, 10, 'completed', '2026-09-24 06:12:00', '2026-09-24 06:18:00', '2026-09-24 06:43:00', 6.87, 1750.00),
	(25, 16, 3, 3, 'ride', 16, 1, 'completed', '2026-09-25 11:25:00', '2026-09-25 11:40:00', '2026-09-25 11:56:00', 3.16, 950.00),
	(26, 19, 13, 13, 'delivery', 3, 12, 'completed', '2026-09-26 16:38:00', '2026-09-26 16:53:00', '2026-09-26 17:25:00', 10.13, 2200.00),
	(27, 2, 4, 4, 'ride', 10, 3, 'cancelled', '2026-09-27 06:51:00', NULL, NULL, NULL, NULL),
	(28, 5, 14, 14, 'delivery', 17, 14, 'completed', '2026-09-28 11:04:00', '2026-09-28 11:19:00', '2026-09-28 12:41:00', 32.92, 5400.00),
	(29, 8, 5, 5, 'ride', 4, 5, 'completed', '2026-09-29 16:17:00', '2026-09-29 16:26:00', '2026-09-29 17:19:00', 19.64, 3250.00),
	(30, 11, 15, 15, 'delivery', 11, 16, 'completed', '2026-09-30 06:30:00', '2026-09-30 06:37:00', '2026-09-30 07:21:00', 15.46, 2950.00),
	(31, 14, 6, 6, 'ride', 18, 7, 'completed', '2026-10-01 11:43:00', '2026-10-01 11:56:00', '2026-10-01 12:14:00', 3.82, 1050.00),
	(32, 17, 16, 16, 'delivery', 5, 18, 'completed', '2026-10-02 16:56:00', '2026-10-02 17:03:00', '2026-10-02 17:42:00', 13.43, 2700.00),
	(33, 20, NULL, NULL, 'ride', 12, 9, 'cancelled', '2026-10-03 06:09:00', NULL, NULL, NULL, NULL),
	(34, 3, 17, 17, 'delivery', 19, 20, 'completed', '2026-10-04 11:22:00', '2026-10-04 11:37:00', '2026-10-04 12:08:00', 9.62, 2150.00),
	(35, 6, 8, 8, 'ride', 6, 11, 'completed', '2026-10-05 16:35:00', '2026-10-05 16:41:00', '2026-10-05 17:36:00', 20.52, 3350.00),
	(36, 9, NULL, NULL, 'delivery', 13, 2, 'requested', '2026-10-13 06:12:00', NULL, NULL, NULL, NULL),
	(37, 12, NULL, NULL, 'ride', 20, 13, 'requested', '2026-10-13 07:19:00', NULL, NULL, NULL, NULL),
	(38, 15, 11, 11, 'delivery', 7, 4, 'accepted', '2026-10-13 08:26:00', NULL, NULL, NULL, NULL),
	(39, 18, 1, 1, 'ride', 14, 15, 'in_progress', '2026-10-13 09:33:00', '2026-10-13 09:45:00', NULL, NULL, NULL),
	(40, 1, 12, 12, 'delivery', 1, 6, 'in_progress', '2026-10-13 10:40:00', '2026-10-13 10:52:00', NULL, NULL, NULL);
   
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

INSERT INTO deliveries (trip_id, parcel_description, weight_kg, recipient_name, recipient_phone, delivery_status) 
	VALUES
	(2, 'Laptop bag', 13.59, 'Femi Okoro', '08033330002', 'delivered'),
	(4, 'Birthday cake box', 4.02, 'Tola Fashola', '08033330004', 'delivered'),
	(6, 'Shoe box', 5.39, 'Femi Danjuma', '08033330006', 'delivered'),
	(8, 'Grocery bag', 15.65, 'Tola Nwosu', '08033330008', 'delivered'),
	(10, 'Documents envelope', 63.17, 'Femi Adeoye', '08033330010', 'failed'),
	(12, 'Laptop bag', 107.68, 'Tola Obi', '08033330012', 'delivered'),
	(14, 'Birthday cake box', 84.10, 'Femi Ajayi', '08033330014', 'delivered'),
	(16, 'Shoe box', 5.26, 'Tola Eze', '08033330016', 'delivered'),
	(18, 'Grocery bag', 83.81, 'Femi Yusuf', '08033330018', 'delivered'),
	(20, 'Documents envelope', 145.10, 'Tola Bakare', '08033330020', 'failed'),
	(22, 'Laptop bag', 2.89, 'Femi Okoro', '08033330022', 'delivered'),
	(24, 'Birthday cake box', 12.13, 'Tola Fashola', '08033330024', 'delivered'),
	(26, 'Shoe box', 17.26, 'Femi Danjuma', '08033330026', 'delivered'),
	(28, 'Grocery bag', 9.29, 'Tola Nwosu', '08033330028', 'delivered'),
	(30, 'Documents envelope', 15.06, 'Femi Adeoye', '08033330030', 'delivered'),
	(32, 'Laptop bag', 142.33, 'Tola Obi', '08033330032', 'delivered'),
	(34, 'Birthday cake box', 68.98, 'Femi Ajayi', '08033330034', 'delivered'),
	(36, 'Shoe box', 139.66, 'Tola Eze', '08033330036', 'pending'),
	(38, 'Grocery bag', 8.86, 'Femi Yusuf', '08033330038', 'pending'),
	(40, 'Documents envelope', 14.20, 'Tola Bakare', '08033330040', 'in_transit');
   
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

INSERT INTO trip_status_history (trip_id, status, changed_at, note) 
	VALUES
	(1, 'requested', '2026-09-01 11:13:00', NULL),
	(1, 'accepted', '2026-09-01 11:15:00', NULL),
	(1, 'in_progress', '2026-09-01 11:27:00', NULL),
	(1, 'completed', '2026-09-01 11:51:00', NULL),
	(2, 'requested', '2026-09-02 16:26:00', NULL),
	(2, 'accepted', '2026-09-02 16:31:00', NULL),
	(2, 'in_progress', '2026-09-02 16:38:00', NULL),
	(2, 'completed', '2026-09-02 17:38:00', 'Delivered to recipient'),
	(3, 'requested', '2026-09-03 06:39:00', NULL),
	(3, 'accepted', '2026-09-03 06:41:00', NULL),
	(3, 'in_progress', '2026-09-03 06:46:00', NULL),
	(3, 'completed', '2026-09-03 07:02:00', NULL),
	(4, 'requested', '2026-09-04 11:52:00', NULL),
	(4, 'accepted', '2026-09-04 11:56:00', NULL),
	(4, 'in_progress', '2026-09-04 12:05:00', NULL),
	(4, 'completed', '2026-09-04 12:53:00', 'Delivered to recipient'),
	(5, 'requested', '2026-09-05 16:05:00', NULL),
	(5, 'accepted', '2026-09-05 16:10:00', NULL),
	(5, 'in_progress', '2026-09-05 16:16:00', NULL),
	(5, 'completed', '2026-09-05 17:41:00', NULL),
	(6, 'requested', '2026-09-06 06:18:00', NULL),
	(6, 'accepted', '2026-09-06 06:22:00', NULL),
	(6, 'in_progress', '2026-09-06 06:32:00', NULL),
	(6, 'completed', '2026-09-06 06:54:00', 'Delivered to recipient'),
	(7, 'requested', '2026-09-07 11:31:00', NULL),
	(7, 'accepted', '2026-09-07 11:35:00', NULL),
	(7, 'in_progress', '2026-09-07 11:42:00', NULL),
	(7, 'completed', '2026-09-07 12:20:00', NULL),
	(8, 'requested', '2026-09-08 16:44:00', NULL),
	(8, 'accepted', '2026-09-08 16:49:00', NULL),
	(8, 'in_progress', '2026-09-08 16:59:00', NULL),
	(8, 'completed', '2026-09-08 17:21:00', 'Delivered to recipient'),
	(9, 'requested', '2026-09-09 06:57:00', NULL),
	(9, 'accepted', '2026-09-09 07:02:00', NULL),
	(9, 'in_progress', '2026-09-09 07:12:00', NULL),
	(9, 'completed', '2026-09-09 08:25:00', NULL),
	(10, 'requested', '2026-09-10 11:10:00', NULL),
	(10, 'cancelled', '2026-09-10 11:22:00', 'Customer cancelled'),
	(11, 'requested', '2026-09-11 16:23:00', NULL),
	(11, 'accepted', '2026-09-11 16:25:00', NULL),
	(11, 'in_progress', '2026-09-11 16:36:00', NULL),
	(11, 'completed', '2026-09-11 17:57:00', NULL),
	(12, 'requested', '2026-09-12 06:36:00', NULL),
	(12, 'accepted', '2026-09-12 06:38:00', NULL),
	(12, 'in_progress', '2026-09-12 06:50:00', NULL),
	(12, 'completed', '2026-09-12 08:04:00', 'Delivered to recipient'),
	(13, 'requested', '2026-09-13 11:49:00', NULL),
	(13, 'accepted', '2026-09-13 11:51:00', NULL),
	(13, 'in_progress', '2026-09-13 11:58:00', NULL),
	(13, 'completed', '2026-09-13 12:24:00', NULL),
	(14, 'requested', '2026-09-14 16:02:00', NULL),
	(14, 'accepted', '2026-09-14 16:06:00', NULL),
	(14, 'in_progress', '2026-09-14 16:16:00', NULL),
	(14, 'completed', '2026-09-14 17:22:00', 'Delivered to recipient'),
	(15, 'requested', '2026-09-15 06:15:00', NULL),
	(15, 'accepted', '2026-09-15 06:20:00', NULL),
	(15, 'in_progress', '2026-09-15 06:29:00', NULL),
	(15, 'completed', '2026-09-15 07:41:00', NULL),
	(16, 'requested', '2026-09-16 11:28:00', NULL),
	(16, 'accepted', '2026-09-16 11:30:00', NULL),
	(16, 'in_progress', '2026-09-16 11:38:00', NULL),
	(16, 'completed', '2026-09-16 12:08:00', 'Delivered to recipient'),
	(17, 'requested', '2026-09-17 16:41:00', NULL),
	(17, 'accepted', '2026-09-17 16:44:00', NULL),
	(17, 'in_progress', '2026-09-17 16:52:00', NULL),
	(17, 'completed', '2026-09-17 18:13:00', NULL),
	(18, 'requested', '2026-09-18 06:54:00', NULL),
	(18, 'accepted', '2026-09-18 06:59:00', NULL),
	(18, 'in_progress', '2026-09-18 07:07:00', NULL),
	(18, 'completed', '2026-09-18 07:56:00', 'Delivered to recipient'),
	(19, 'requested', '2026-09-19 11:07:00', NULL),
	(19, 'accepted', '2026-09-19 11:12:00', NULL),
	(19, 'in_progress', '2026-09-19 11:14:00', NULL),
	(19, 'completed', '2026-09-19 11:52:00', NULL),
	(20, 'requested', '2026-09-20 16:20:00', NULL),
	(20, 'accepted', '2026-09-20 16:23:00', NULL),
	(20, 'cancelled', '2026-09-20 16:32:00', 'Customer cancelled'),
	(21, 'requested', '2026-09-21 06:33:00', NULL),
	(21, 'accepted', '2026-09-21 06:35:00', NULL),
	(21, 'in_progress', '2026-09-21 06:46:00', NULL),
	(21, 'completed', '2026-09-21 08:01:00', NULL),
	(22, 'requested', '2026-09-22 11:46:00', NULL),
	(22, 'accepted', '2026-09-22 11:51:00', NULL),
	(22, 'in_progress', '2026-09-22 11:55:00', NULL),
	(22, 'completed', '2026-09-22 12:37:00', 'Delivered to recipient'),
	(23, 'requested', '2026-09-23 16:59:00', NULL),
	(23, 'accepted', '2026-09-23 17:01:00', NULL),
	(23, 'in_progress', '2026-09-23 17:14:00', NULL),
	(23, 'completed', '2026-09-23 17:30:00', NULL),
	(24, 'requested', '2026-09-24 06:12:00', NULL),
	(24, 'accepted', '2026-09-24 06:16:00', NULL),
	(24, 'in_progress', '2026-09-24 06:18:00', NULL),
	(24, 'completed', '2026-09-24 06:43:00', 'Delivered to recipient'),
	(25, 'requested', '2026-09-25 11:25:00', NULL),
	(25, 'accepted', '2026-09-25 11:30:00', NULL),
	(25, 'in_progress', '2026-09-25 11:40:00', NULL),
	(25, 'completed', '2026-09-25 11:56:00', NULL),
	(26, 'requested', '2026-09-26 16:38:00', NULL),
	(26, 'accepted', '2026-09-26 16:41:00', NULL),
	(26, 'in_progress', '2026-09-26 16:53:00', NULL),
	(26, 'completed', '2026-09-26 17:25:00', 'Delivered to recipient'),
	(27, 'requested', '2026-09-27 06:51:00', NULL),
	(27, 'accepted', '2026-09-27 06:54:00', NULL),
	(27, 'cancelled', '2026-09-27 07:03:00', 'Customer cancelled'),
	(28, 'requested', '2026-09-28 11:04:00', NULL),
	(28, 'accepted', '2026-09-28 11:08:00', NULL),
	(28, 'in_progress', '2026-09-28 11:19:00', NULL),
	(28, 'completed', '2026-09-28 12:41:00', 'Delivered to recipient'),
	(29, 'requested', '2026-09-29 16:17:00', NULL),
	(29, 'accepted', '2026-09-29 16:22:00', NULL),
	(29, 'in_progress', '2026-09-29 16:26:00', NULL),
	(29, 'completed', '2026-09-29 17:19:00', NULL),
	(30, 'requested', '2026-09-30 06:30:00', NULL),
	(30, 'accepted', '2026-09-30 06:32:00', NULL),
	(30, 'in_progress', '2026-09-30 06:37:00', NULL),
	(30, 'completed', '2026-09-30 07:21:00', 'Delivered to recipient'),
	(31, 'requested', '2026-10-01 11:43:00', NULL),
	(31, 'accepted', '2026-10-01 11:47:00', NULL),
	(31, 'in_progress', '2026-10-01 11:56:00', NULL),
	(31, 'completed', '2026-10-01 12:14:00', NULL),
	(32, 'requested', '2026-10-02 16:56:00', NULL),
	(32, 'accepted', '2026-10-02 17:01:00', NULL),
	(32, 'in_progress', '2026-10-02 17:03:00', NULL),
	(32, 'completed', '2026-10-02 17:42:00', 'Delivered to recipient'),
	(33, 'requested', '2026-10-03 06:09:00', NULL),
	(33, 'cancelled', '2026-10-03 06:21:00', 'Customer cancelled'),
	(34, 'requested', '2026-10-04 11:22:00', NULL),
	(34, 'accepted', '2026-10-04 11:26:00', NULL),
	(34, 'in_progress', '2026-10-04 11:37:00', NULL),
	(34, 'completed', '2026-10-04 12:08:00', 'Delivered to recipient'),
	(35, 'requested', '2026-10-05 16:35:00', NULL),
	(35, 'accepted', '2026-10-05 16:38:00', NULL),
	(35, 'in_progress', '2026-10-05 16:41:00', NULL),
	(35, 'completed', '2026-10-05 17:36:00', NULL),
	(36, 'requested', '2026-10-13 06:12:00', NULL),
	(37, 'requested', '2026-10-13 07:19:00', NULL),
	(38, 'requested', '2026-10-13 08:26:00', NULL),
	(38, 'accepted', '2026-10-13 08:29:00', NULL),
	(39, 'requested', '2026-10-13 09:33:00', NULL),
	(39, 'accepted', '2026-10-13 09:35:00', NULL),
	(39, 'in_progress', '2026-10-13 09:45:00', NULL),
	(40, 'requested', '2026-10-13 10:40:00', NULL),
	(40, 'accepted', '2026-10-13 10:43:00', NULL),
	(40, 'in_progress', '2026-10-13 10:52:00', NULL);

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

INSERT INTO payments (trip_id, amount, method, status, paid_at) 
	VALUES
	(1, 1450.00, 'card', 'successful', '2026-09-01 11:56:00'),
	(2, 4000.00, 'wallet', 'successful', '2026-09-02 17:40:00'),
	(3, 950.00, 'transfer', 'successful', '2026-09-03 07:03:00'),
	(4, 3250.00, 'transfer', 'successful', '2026-09-04 12:56:00'),
	(5, 5300.00, 'cash', 'refunded', '2026-09-05 17:44:00'),
	(6, 1600.00, 'card', 'successful', '2026-09-06 06:59:00'),
	(7, 2300.00, 'card', 'failed', NULL),
	(7, 2300.00, 'cash', 'successful', '2026-09-07 12:24:00'),
	(8, 1650.00, 'wallet', 'successful', '2026-09-08 17:26:00'),
	(9, 4500.00, 'wallet', 'successful', '2026-09-09 08:30:00'),
	(11, 5050.00, 'card', 'successful', '2026-09-11 17:59:00'),
	(12, 4900.00, 'wallet', 'successful', '2026-09-12 08:08:00'),
	(13, 1550.00, 'wallet', 'successful', '2026-09-13 12:28:00'),
	(14, 4400.00, 'card', 'failed', NULL),
	(14, 4400.00, 'cash', 'successful', '2026-09-14 17:27:00'),
	(15, 4500.00, 'wallet', 'successful', '2026-09-15 07:45:00'),
	(16, 2150.00, 'wallet', 'successful', '2026-09-16 12:13:00'),
	(17, 5050.00, 'transfer', 'successful', '2026-09-17 18:17:00'),
	(18, 3300.00, 'cash', 'successful', '2026-09-18 07:59:00'),
	(19, 2350.00, 'transfer', 'successful', '2026-09-19 11:56:00'),
	(21, 4700.00, 'card', 'failed', NULL),
	(21, 4700.00, 'cash', 'successful', '2026-09-21 08:05:00'),
	(22, 2900.00, 'cash', 'successful', '2026-09-22 12:38:00'),
	(23, 900.00, 'card', 'successful', '2026-09-23 17:32:00'),
	(24, 1750.00, 'transfer', 'successful', '2026-09-24 06:45:00'),
	(25, 950.00, 'card', 'successful', '2026-09-25 12:01:00'),
	(26, 2200.00, 'transfer', 'successful', '2026-09-26 17:26:00'),
	(28, 5400.00, 'card', 'failed', NULL),
	(28, 5400.00, 'cash', 'successful', '2026-09-28 12:43:00'),
	(29, 3250.00, 'cash', 'successful', '2026-09-29 17:20:00'),
	(30, 2950.00, 'transfer', 'successful', '2026-09-30 07:22:00'),
	(31, 1050.00, 'transfer', 'successful', '2026-10-01 12:18:00'),
	(32, 2700.00, 'card', 'successful', '2026-10-02 17:44:00'),
	(34, 2150.00, 'card', 'successful', '2026-10-04 12:09:00'),
	(35, 3350.00, 'card', 'failed', NULL),
	(35, 3350.00, 'cash', 'successful', '2026-10-05 17:37:00'),
	(39, 3950.00, 'wallet', 'pending', NULL),
	(40, 1800.00, 'wallet', 'pending', NULL);
   
SELECT *
FROM payments;



-- QUERIES TO ANSWER IMPORTANT QUESTIONS
USE insightmove_db;

-- QUESTION 1: all customers
SELECT * 
FROM customers;

-- QUESTION 2: all completed trips
SELECT * 
FROM trips
WHERE status = 'completed';

-- QUESTION 3: drivers rated above 4.5, highest first
SELECT driver_id, full_name, rating
FROM drivers
WHERE rating > 4.5
ORDER BY rating DESC;

-- QUESTION 4: number of trips of each type
SELECT trip_type, COUNT(*) AS total_trips
FROM trips
GROUP BY trip_type;

-- QUESTION 5: total earnings per driver (completed trips only), highest first
SELECT drivers.driver_id, drivers.full_name, SUM(trips.fare_amount) AS total_earnings
FROM drivers
JOIN trips ON trips.driver_id = drivers.driver_id
WHERE trips.status = 'completed'
GROUP BY drivers.driver_id, drivers.full_name
ORDER BY total_earnings DESC;

-- QESTION 6: completed trips with the customer's name
SELECT trips.trip_id, customers.full_name, trips.trip_type, trips.fare_amount, trips.completed_at
FROM trips
JOIN customers ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed'
ORDER BY trips.completed_at;


-- QUESTION 7: customers with more than one completed trip
SELECT customers.customer_id, customers.full_name, COUNT(*) AS completed_trips
FROM customers
JOIN trips ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed'
GROUP BY customers.customer_id, customers.full_name
HAVING COUNT(*) > 1
ORDER BY completed_trips DESC;


-- QUESTION 8: average trip duration in minutes, per trip type
SELECT trip_type,
       AVG(TIMESTAMPDIFF(MINUTE, started_at, completed_at)) AS avg_minutes
FROM trips
WHERE status = 'completed'
GROUP BY trip_type;


-- QUESTION 9: completed trips with no successful payment
SELECT trips.trip_id, trips.fare_amount, trips.completed_at
FROM trips
LEFT JOIN payments
       ON payments.trip_id = trips.trip_id AND payments.status = 'successful'
WHERE trips.status = 'completed'
  AND payments.payment_id IS NULL;
