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
