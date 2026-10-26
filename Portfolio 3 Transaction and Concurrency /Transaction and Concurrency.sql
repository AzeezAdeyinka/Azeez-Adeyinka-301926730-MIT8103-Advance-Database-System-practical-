use insightmove_db;

-- portfolio 3
--  Transaction and concurrency   TRIP ID = 7989  DRIVER ID = 1

SELECT trip_id FROM trips WHERE status = 'requested' LIMIT 1;
SELECT driver_id, status FROM drivers WHERE status = 'available' LIMIT 1;

START TRANSACTION;

UPDATE trips
SET driver_id = 1, vehicle_id = 1, status = 'accepted'
WHERE trip_id = 7989;

UPDATE drivers
SET status = 'on_trip'
WHERE driver_id = 1;

INSERT INTO trip_status_history (trip_id, status, note)
VALUES (7989, 'accepted', 'Driver assigned by dispatcher');

COMMIT;


SELECT trip_id, driver_id, vehicle_id, status FROM trips WHERE trip_id = 7989;
SELECT driver_id, status FROM drivers WHERE driver_id = 1;
SELECT * FROM trip_status_history WHERE trip_id = 7989;


SELECT driver_id, status FROM drivers WHERE status = 'available' LIMIT 1;

START TRANSACTION;

UPDATE drivers SET status = 'on_trip' WHERE driver_id = 3;

SELECT driver_id, status FROM drivers WHERE driver_id = 3;


INSERT INTO trip_status_history (trip_id, status, note)
VALUES (TRIP_ID, 'lost', 'This status is not allowed');

ROLLBACK;

SELECT driver_id, status FROM drivers WHERE driver_id = 3;


SELECT driver_id, rating FROM drivers WHERE driver_id = 5;


-- problem, two dispatchers booking the same driver

SELECT trip_id FROM trips WHERE status = 'requested' LIMIT 2;
SELECT driver_id, status FROM drivers WHERE status = 'available' LIMIT 1;


SELECT trip_id, driver_id, status FROM trips WHERE trip_id IN (7990, 7991);

UPDATE trips SET driver_id = NULL, vehicle_id = NULL, status = 'requested' WHERE trip_id IN (7990, 7991);
UPDATE drivers SET status = 'available' WHERE driver_id = 3;
SELECT trip_id, driver_id, status FROM trips WHERE trip_id IN (7990, 7991);


SELECT trip_id, driver_id, status FROM trips WHERE trip_id IN (7990, 7991);

-- Reset
UPDATE trips SET driver_id = NULL, vehicle_id = NULL, status = 'requested' WHERE trip_id IN (7990, 7991);
UPDATE drivers SET status = 'available' WHERE driver_id = 3;
