// Portfolio 4: NoSQL and Advanced Data Models
// InsightMove, MongoDB 9.0.4. Run in mongosh (MongoDB Compass shell).

// ------------------------------------------------------------
// 1. Connection test
// ------------------------------------------------------------
db.runCommand({ ping: 1 })                    // expected: { ok: 1 }

use insightmove_nosql                          // database name is case-sensitive

// ------------------------------------------------------------
// 2. Date conversion after importing the MySQL JSON exports
//    (the export writes dates as text; convert each to a real date, once)
// ------------------------------------------------------------
db.customers.updateMany(
  { added_at: { $type: "string" } },
  [ { $set: { added_at: { $dateFromString: { dateString: "$added_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
)

db.drivers.updateMany(
  { joined_at: { $type: "string" } },
  [ { $set: { joined_at: { $dateFromString: { dateString: "$joined_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
)

// trips: started_at and completed_at are empty for trips never started/completed,
// so only text values are converted
db.trips.updateMany({}, [
  { $set: {
    requested_at: { $dateFromString: { dateString: "$requested_at", format: "%Y-%m-%d %H:%M:%S" } },
    started_at: { $cond: [ { $eq: [ { $type: "$started_at" }, "string" ] },
                           { $dateFromString: { dateString: "$started_at", format: "%Y-%m-%d %H:%M:%S" } },
                           "$started_at" ] },
    completed_at: { $cond: [ { $eq: [ { $type: "$completed_at" }, "string" ] },
                             { $dateFromString: { dateString: "$completed_at", format: "%Y-%m-%d %H:%M:%S" } },
                             "$completed_at" ] }
  } }
])

db.trip_status_history.updateMany(
  { changed_at: { $type: "string" } },
  [ { $set: { changed_at: { $dateFromString: { dateString: "$changed_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
)

db.payments.updateMany(
  { paid_at: { $type: "string" } },
  [ { $set: { paid_at: { $dateFromString: { dateString: "$paid_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
)

// ------------------------------------------------------------
// 3. Verification
// ------------------------------------------------------------
// Document count of every collection (compare with the MySQL row counts)
db.getCollectionNames().sort().forEach(n => print(n, db.getCollection(n).countDocuments()))
// expected: customers 1000, deliveries 3222, drivers 120, locations 60,
//           payments 7525, trip_status_history 30888, trips 8000, vehicles 120

// No date left as text (every line should end in 0)
["trips:requested_at", "trip_status_history:changed_at", "payments:paid_at", "customers:added_at", "drivers:joined_at"].forEach(x => {
  const [c, f] = x.split(":");
  print(c, f, db.getCollection(c).countDocuments({ [f]: { $type: "string" } }));
})

// ------------------------------------------------------------
// 4. Queries (each result was compared with MySQL)
// ------------------------------------------------------------
// Q1: cancelled trips (MySQL: SELECT COUNT(*) FROM trips WHERE status = 'cancelled')
db.trips.find({ status: "cancelled" }).limit(3)
db.trips.countDocuments({ status: "cancelled" })                      // 724

// Q2: trips requested in July 2026
db.trips.countDocuments({
  requested_at: { $gte: ISODate("2026-07-01T00:00:00Z"), $lte: ISODate("2026-07-31T23:59:59Z") }
})                                                                    // 1126

// Q3: top 5 completed fares since 1 September 2026
db.trips.find(
  { status: "completed", requested_at: { $gte: ISODate("2026-09-01T00:00:00Z") } },
  { _id: 0, trip_id: 1, customer_id: 1, fare_amount: 1, requested_at: 1 }
).sort({ fare_amount: -1 }).limit(5)

// ------------------------------------------------------------
// 5. Update: a dispatcher assigns an available driver to a requested trip
//    (three collections, three commands; compare with the MySQL transaction)
// ------------------------------------------------------------
const t = db.trips.findOne({ status: "requested", driver_id: null });
const d = db.drivers.findOne({ status: "available" });

db.trips.updateOne(
  { trip_id: t.trip_id },
  { $set: { driver_id: d.driver_id, vehicle_id: d.driver_id, status: "accepted" } }
);
db.drivers.updateOne({ driver_id: d.driver_id }, { $set: { status: "on_trip" } });

const last = db.trip_status_history.find().sort({ history_id: -1 }).limit(1).next();
db.trip_status_history.insertOne({
  history_id: last.history_id + 1,
  trip_id: t.trip_id,
  status: "accepted",
  changed_at: new Date(),
  note: "Driver assigned by dispatcher"
});

printjson({ trip_id: t.trip_id, driver_id: d.driver_id });

// Check the result (use the numbers printed above; in my run: trip 7991, driver 6)
printjson({
  trip: db.trips.findOne({ trip_id: 7991 }, { _id: 0, trip_id: 1, driver_id: 1, vehicle_id: 1, status: 1 }),
  driver: db.drivers.findOne({ driver_id: 6 }, { _id: 0, driver_id: 1, status: 1 })
})
db.trip_status_history.find({ trip_id: 7991 }).sort({ changed_at: 1 })

// ------------------------------------------------------------
// 6. Aggregations
// ------------------------------------------------------------
// A1: top 5 fares with the customer's name ($lookup works like a JOIN)
db.trips.aggregate([
  { $match: { status: "completed" } },
  { $sort: { fare_amount: -1 } },
  { $limit: 5 },
  { $lookup: { from: "customers", localField: "customer_id", foreignField: "customer_id", as: "customer" } },
  { $unwind: "$customer" },
  { $project: { _id: 0, trip_id: 1, fare_amount: 1, customer_name: "$customer.full_name" } }
])

// A2: total earnings per driver (GROUP BY with SUM)
db.trips.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$driver_id", total_earnings: { $sum: "$fare_amount" }, trips: { $sum: 1 } } },
  { $sort: { total_earnings: -1 } },
  { $limit: 5 }
])                                                                     // driver 80: 628800 over 102 trips

// ------------------------------------------------------------
// 7. Indexing and performance
// ------------------------------------------------------------
// Baseline plan, before the index
db.trips.find({ status: "cancelled" }).explain("executionStats")      // COLLSCAN, 8000 documents examined

// Create the index and confirm it exists
db.trips.createIndex({ status: 1 })                                   // status_1
db.trips.getIndexes()

// Compare with and without the index
function summary(cursor) {
  const e = cursor.explain("executionStats").executionStats;
  printjson({ returned: e.nReturned, keysExamined: e.totalKeysExamined, docsExamined: e.totalDocsExamined, ms: e.executionTimeMillis });
}
print("WITHOUT index (forced full scan):");
summary(db.trips.find({ status: "cancelled" }).hint({ $natural: 1 }));  // 724 returned, 8000 examined
print("WITH index:");
summary(db.trips.find({ status: "cancelled" }));                        // 724 returned, 724 examined
