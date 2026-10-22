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
