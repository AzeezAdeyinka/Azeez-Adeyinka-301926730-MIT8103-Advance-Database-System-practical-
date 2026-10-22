SHOW INDEX FROM trips;

SHOW INDEX FROM payments;

EXPLAIN SELECT * FROM trips WHERE status = 'cancelled';

EXPLAIN SELECT COUNT(*) FROM trips
WHERE requested_at BETWEEN '2026-07-01 00:00:00' AND '2026-07-31 23:59:59';

EXPLAIN SELECT driver_id, COUNT(*) AS completed_deliveries
FROM trips
WHERE status = 'completed' AND trip_type = 'delivery'
GROUP BY driver_id;

EXPLAIN SELECT customers.full_name, trips.trip_id, trips.fare_amount
FROM trips
JOIN customers ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed' AND trips.requested_at >= '2026-09-01'
ORDER BY trips.fare_amount DESC
LIMIT 20;


EXPLAIN SELECT * FROM payments WHERE method = 'card' AND status = 'failed';

EXPLAIN ANALYZE SELECT * FROM trips WHERE status = 'cancelled';

SELECT * FROM trips WHERE status = 'cancelled';

SELECT COUNT(*) FROM trips
WHERE requested_at BETWEEN '2026-07-01 00:00:00' AND '2026-07-31 23:59:59';


SELECT driver_id, COUNT(*) AS completed_deliveries
FROM trips
WHERE status = 'completed' AND trip_type = 'delivery'
GROUP BY driver_id;


SELECT customers.full_name, trips.trip_id, trips.fare_amount
FROM trips
JOIN customers ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed' AND trips.requested_at >= '2026-09-01'
ORDER BY trips.fare_amount DESC
LIMIT 20;

SELECT * FROM payments WHERE method = 'card' AND status = 'failed';


EXPLAIN ANALYZE SELECT COUNT(*) FROM trips
WHERE requested_at BETWEEN '2026-07-01 00:00:00' AND '2026-07-31 23:59:59';

EXPLAIN ANALYZE SELECT driver_id, COUNT(*) AS completed_deliveries
FROM trips
WHERE status = 'completed' AND trip_type = 'delivery'
GROUP BY driver_id;


EXPLAIN ANALYZE SELECT customers.full_name, trips.trip_id, trips.fare_amount
FROM trips
JOIN customers ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed' AND trips.requested_at >= '2026-09-01'
ORDER BY trips.fare_amount DESC
LIMIT 20;


EXPLAIN ANALYZE SELECT * FROM payments WHERE method = 'card' AND status = 'failed';


CREATE INDEX idx_trips_status_type_driver ON trips (status, trip_type, driver_id);
CREATE INDEX idx_trips_requested_at ON trips (requested_at);
CREATE INDEX idx_trips_fare ON trips (fare_amount);
CREATE INDEX idx_payments_method_status ON payments (method, status);


ANALYZE TABLE trips, payments;

SHOW INDEX FROM trips;

EXPLAIN ANALYZE SELECT * FROM trips WHERE status = 'cancelled';

use insightmove_db;

EXPLAIN ANALYZE SELECT COUNT(*) FROM trips
WHERE requested_at BETWEEN '2026-07-01 00:00:00' AND '2026-07-31 23:59:59';

EXPLAIN ANALYZE SELECT driver_id, COUNT(*) AS completed_deliveries
FROM trips
WHERE status = 'completed' AND trip_type = 'delivery'
GROUP BY driver_id;

EXPLAIN ANALYZE SELECT customers.full_name, trips.trip_id, trips.fare_amount
FROM trips
JOIN customers ON trips.customer_id = customers.customer_id
WHERE trips.status = 'completed' AND trips.requested_at >= '2026-09-01'
ORDER BY trips.fare_amount DESC
LIMIT 20;

EXPLAIN ANALYZE SELECT * FROM payments WHERE method = 'card' AND status = 'failed';

CREATE INDEX idx_trips_status_type_driver ON trips (status, trip_type, driver_id);
CREATE INDEX idx_trips_requested_at ON trips (requested_at);
CREATE INDEX idx_trips_fare ON trips (fare_amount);
CREATE INDEX idx_payments_method_status ON payments (method, status);
ANALYZE TABLE trips, payments;
