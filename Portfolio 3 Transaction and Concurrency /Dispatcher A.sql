use insightmove_db;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT driver_id, rating FROM drivers WHERE driver_id = 5;

SELECT driver_id, rating FROM drivers WHERE driver_id = 5;

COMMIT;
SELECT driver_id, rating FROM drivers WHERE driver_id = 5;


SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT driver_id, rating FROM drivers WHERE driver_id = 5;


SELECT driver_id, rating FROM drivers WHERE driver_id = 5;


-- problem, two dispatchers booking the same driver

START TRANSACTION;
SELECT driver_id, status FROM drivers WHERE driver_id = 3;

UPDATE trips SET driver_id = 3, vehicle_id = 3, status = 'accepted' WHERE trip_id = 7990;
UPDATE drivers SET status = 'on_trip' WHERE driver_id = 3;
COMMIT;


START TRANSACTION;
SELECT driver_id, status FROM drivers WHERE driver_id = 3 FOR UPDATE;

UPDATE trips SET driver_id = 3, vehicle_id = 3, status = 'accepted' WHERE trip_id = 7990;
UPDATE drivers SET status = 'on_trip' WHERE driver_id = 3;
COMMIT;

