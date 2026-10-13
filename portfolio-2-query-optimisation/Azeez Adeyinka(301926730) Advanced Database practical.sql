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
