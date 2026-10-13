# Normalisation Explanation

## 1. Starting point: one unnormalised sheet

Imagine InsightMove storing everything in a single sheet, one row per trip:

| trip_id | customer_name | customer_phone | driver_name | driver_phone | plate_number | vehicle_type | pickup_address | dropoff_address | parcel_description | status_history | payment_amount |
|---|---|---|---|---|---|---|---|---|---|---|---|

This design causes three anomalies:

- **Update anomaly:** a customer who takes 50 trips has their name and phone repeated 50 times. If the phone number changes, all 50 rows must be updated, and missing one leaves contradictory data.
- **Insertion anomaly:** a new driver or vehicle cannot be recorded until they have a trip.
- **Deletion anomaly:** deleting a customer's only trip also deletes everything known about that customer.

## 2. First Normal Form (1NF): one value per cell, no repeating groups

`status_history` holds several values in one cell (for example "requested, accepted, in_progress, completed"). This breaks 1NF.

**Fix:** a separate `trip_status_history` table with one row per status change, linked to the trip by `trip_id`. Every column in every table now holds a single value.

## 3. Second Normal Form (2NF): no partial dependency on a key

2NF applies where a key has several columns, and every non-key column must depend on the whole key. Attributes that depend on only part of the trip, such as the customer or the vehicle, are separated out:

| Attribute | Depends on | Moved to |
|---|---|---|
| parcel_description, weight_kg, recipient details | the delivery | `deliveries` |
| payment amount, method, status | the payment | `payments` |

Every table uses a single-column surrogate primary key (`customer_id`, `trip_id`, and so on), so no partial dependency can exist.

## 4. Third Normal Form (3NF): no transitive dependency

In the single sheet, `customer_name` and `customer_phone` depend on the customer, not directly on `trip_id`. The chain is `trip_id → customer → customer_name`. Every non-key column must depend only on its own table's key, so each group moved to its own table:

| Columns in the sheet | Depend on | Moved to |
|---|---|---|
| customer_name, customer_phone, email | customer_id | `customers` |
| driver_name, driver_phone, license_number | driver_id | `drivers` |
| plate_number, vehicle_type, capacity_kg | vehicle_id | `vehicles` |
| pickup_address, dropoff_address | location_id | `locations` |

`trips` now stores only IDs that point to these tables, plus facts about the trip itself (type, status, times, distance, fare).

All eight tables satisfy 3NF. Each is also in BCNF, because every determinant (the left side of each dependency) is a candidate key.

## 5. Deliberate design choices

- **`locations` is one table used twice:** `trips` has two foreign keys to it, `pickup_location_id` and `dropoff_location_id`. An address is stored once and reused by any trip.
- **`deliveries` is separate from `trips`:** parcel fields apply only to delivery trips. Keeping them in `trips` would leave empty (NULL) columns on every passenger ride. `deliveries.trip_id` is `UNIQUE`, so each trip has at most one delivery record.
- **Derived values are not stored:** a driver's total earnings and total trip count are not columns, because they can be calculated from `trips` and `payments`. Storing them would create data that can go out of date.
- **Status is stored twice on purpose:** `trips.status` holds the current stage, and `trip_status_history` keeps every earlier stage as an audit trail. This is a deliberate trade-off, not a normalisation error.
- **Nullable foreign keys:** `trips.driver_id` and `trips.vehicle_id` are NULL until a driver accepts the trip.
