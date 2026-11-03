# Portfolio 4: NoSQL and Advanced Data Models

**Course:** MIT 8103 Advanced Database Systems | **Database:** MongoDB 9.0.4 (document database) | **Tools:** MongoDB Compass and mongosh | **Case study:** InsightMove

## 1. Overview

This portfolio models the InsightMove ride-hailing and delivery case study in a document database. The data from the MySQL database was exported, loaded into MongoDB, queried and indexed, and each result was compared with MySQL to confirm the two copies agree.

| File | Contents |
|---|---|
| `queries.js` | Every MongoDB command used |
| `screenshots/` | Evidence for each step |

## 2. NoSQL Model

**Type:** document model (MongoDB). Database name: `insightmove_nosql`.

The model follows the MySQL design: **eight collections, one for each MySQL table**, with the same field names, and with relationships kept as ID references (for example `trips.customer_id` points to `customers.customer_id`).

| Collection | Documents | MySQL table |
|---|---|---|
| customers | 1,000 | customers |
| drivers | 120 | drivers |
| vehicles | 120 | vehicles |
| locations | 60 | locations |
| trips | 8,000 | trips |
| deliveries | 3,222 | deliveries |
| trip_status_history | 30,888 | trip_status_history |
| payments | 7,525 | payments |

Every count equals the row count of the matching MySQL table. `trip_status_history` has 30,888 documents rather than the 30,884 in the original load file because my Portfolio 3 transaction exercises added rows to MySQL before I exported it.

### Alternative model: embedding

MongoDB can also store related data inside one document. A delivery trip could hold its parcel, status history and payments in a single document, so tracking a trip needs one read and no joins:

```js
{
  trip_id: 7990, trip_type: "delivery", status: "completed",
  customer: { customer_id: 412, full_name: "..." },
  driver: { driver_id: 3, full_name: "..." },
  pickup: { address: "...", area: "Ikeja", coordinates: [3.3524, 6.6037] },
  parcel: { description: "Groceries bag", weight_kg: 11.4, status: "delivered" },
  status_history: [ { status: "requested", at: ISODate("...") }, { status: "completed", at: ISODate("...") } ],
  payments: [ { amount: 4250, method: "card", status: "successful" } ]
}
```

I chose the one-collection-per-table design for this portfolio because it lets me compare MongoDB directly with my MySQL database. Every count and every query result can be checked against the same table, which proves the data was copied correctly. I would choose the embedded design for live trip tracking, where a trip and its history are always read together and a single read is faster than joining three tables.

## 3. Implementation

1. **Setup:** installed MongoDB Community Server and MongoDB Compass locally and confirmed the connection with `db.runCommand({ ping: 1 })`, which returned `{ ok: 1 }`.
2. **Export:** exported each MySQL table to JSON with the MySQL Workbench Table Data Export Wizard.
3. **Import:** imported each file into its own collection with Compass.
4. **Date conversion:** the export stores dates as text, so each date field was converted to a real date with `updateMany` and `$dateFromString`. A final check showed 0 documents with a text date in all five collections that have dates (`trips`, `trip_status_history`, `payments`, `customers`, `drivers`).
5. **Verification:** counted the documents in every collection and compared the counts with MySQL.

## 4. Queries and Results

Each query was also run in MySQL, and the results matched.

| # | Purpose | MongoDB | Result |
|---|---|---|---|
| 1 | Count cancelled trips | `db.trips.countDocuments({ status: "cancelled" })` | 724 (MySQL: 724) |
| 2 | Trips requested in July 2026 | `countDocuments` with an `ISODate` range on `requested_at` | 1,126 (MySQL: 1,126) |
| 3 | Top 5 completed fares since 1 Sept 2026 | `find` + projection + `sort({ fare_amount: -1 })` + `limit(5)` | Trips 6784, 6729, 6529, 7722, 7143, identical to MySQL |
| 4 | Update: assign a driver to a requested trip | `updateOne` on `trips` and `drivers`, `insertOne` on `trip_status_history` | Trip 7991 `accepted`, driver 6 `on_trip`, new history row added |
| 5 | Top 5 fares with customer name | Aggregation: `$match`, `$sort`, `$limit`, `$lookup`, `$unwind`, `$project` | Fares 15,950, 15,750, 15,700, 15,700, 15,650, same as MySQL (trip 4515, Chioma Folarin, first) |
| 6 | Earnings per driver | Aggregation: `$match`, `$group` with `$sum`, `$sort`, `$limit` | Driver 80: 628,800 over 102 trips; same top 5 drivers as MySQL |

`$lookup` is MongoDB's equivalent of a `JOIN`, and `$group` with `$sum` is `GROUP BY` with `SUM`.

**Note on query 5:** several trips share the same fare (two at 15,700, and more at 15,650), so MySQL and MongoDB can return different trips in tied positions. The fares themselves are identical and in the same order.

## 5. Indexing and Performance

Query: `db.trips.find({ status: "cancelled" })`, measured with `explain("executionStats")`.

| Measure | Before (no index) | After (`createIndex({ status: 1 })`) |
|---|---|---|
| Plan | COLLSCAN (full collection scan) | IXSCAN (index scan) |
| Documents returned | 724 | 724 |
| Documents examined | 8,000 | 724 |
| Index keys examined | 0 | 724 |
| Time | 4 ms | 1 ms |

Without the index MongoDB read all 8,000 trips to find 724. With it, MongoDB read only the 724 matching entries. The time difference is small because the collection is small, so the number of documents examined is the clearer evidence. This matches the behaviour of the MySQL indexes in Portfolio 2.

## 6. Suitability: Why a Document Database for InsightMove

**Where MongoDB fits well**
- **Tracking data is naturally a list.** A trip's status history grows as the trip progresses, and an array inside the trip document would be read together with it.
- **Flexible structure.** Delivery parcels vary (documents, food, furniture), and different parcels can carry different fields without changing a table structure.
- **Read speed for one trip.** An embedded trip document is retrieved in one read, with no joins.
- **Scaling.** MongoDB can split a large collection across servers (sharding), which suits a growing platform. This is explored in Portfolio 5.
- **Aggregation pipelines** give a readable way to compute totals and rankings.

**Where MySQL is the better choice**
- **Referential integrity.** MySQL enforces foreign keys and CHECK constraints, so a trip cannot point at a customer that does not exist. MongoDB does not enforce references between collections, so the application must.
- **Multi-table transactions.** Portfolio 3 showed MySQL changing three tables atomically in one transaction. In MongoDB the same assignment took three separate commands, and only a single document is updated atomically.
- **Joins and reporting.** Queries across many tables, such as payment reconciliation, are simpler in SQL.
- **Money and financial records.** The strict structure and constraints of MySQL suit payments.

**Conclusion:** for InsightMove I would use MySQL for the records that must stay consistent: customers, drivers, bookings and payments, where constraints and transactions protect the data. I would use MongoDB for live trip tracking and status history, where the data grows quickly, is read together, and needs to scale. Used together, each database does the job it is best at.


## 7. Challenges and What I Learned

My first import of `trips` showed only 1,000 documents instead of 8,000. I had exported from a query result, and MySQL Workbench limits a result grid to 1,000 rows, so I dropped the collection, re-exported the whole table with the Table Data Export Wizard, and imported again to get 8,000. I also created the database as `Insightmove_nosql` with a capital letter, and since MongoDB names are case-sensitive, I dropped it and recreated it in lowercase before importing anything.

The export stores every date as text, so I had to convert the date fields with `updateMany` and `$dateFromString`, and then check that no text dates remained. When I counted `trip_status_history` I got 30,888 documents, not the 30,884 in my original data, and I confirmed that MySQL also had 30,888 because my Portfolio 3 exercises had added history rows. I also found that the new history row got ID 30,890 although only 30,888 rows existed, which I believe is a gap left by the failed insert I rolled back in Portfolio 3, because MySQL does not hand back an auto-increment number after a rollback.

I learned that MongoDB queries map closely to SQL (`find` to `SELECT ... WHERE`, `$lookup` to `JOIN`, `$group` to `GROUP BY`), that an index changes a full collection scan into an index scan in MongoDB just as in MySQL, and that MongoDB does not enforce relationships between collections or make multi-collection changes atomic the way MySQL does. The update that assigns a driver took three separate commands in MongoDB where one MySQL transaction was enough, and that comparison shaped my choice of where each database belongs.

## 8. AI Use Declaration

- **Tool:** Claude (Anthropic)
- **Used for:** suggesting the MongoDB design, supplying the MongoDB commands and the date-conversion scripts. 
