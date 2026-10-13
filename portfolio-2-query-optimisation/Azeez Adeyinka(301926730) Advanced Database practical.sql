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
