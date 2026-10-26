use insightmove_db;

START TRANSACTION;
UPDATE drivers SET rating = 3.0 WHERE driver_id = 5;
COMMIT;

START TRANSACTION;
UPDATE drivers SET rating = 4.0 WHERE driver_id = 5;
COMMIT;


START TRANSACTION;
SELECT driver_id, status FROM drivers WHERE driver_id = 3;


UPDATE trips SET driver_id = 3, vehicle_id = 3, status = 'accepted' WHERE trip_id = 7991;
UPDATE drivers SET status = 'on_trip' WHERE driver_id = 3;
COMMIT;



START TRANSACTION;
SELECT driver_id, status FROM drivers WHERE driver_id = 3 FOR UPDATE;

ROLLBACK;
