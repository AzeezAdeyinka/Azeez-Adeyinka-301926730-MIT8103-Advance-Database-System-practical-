// Portfolio 5: Distributed Cloud 
// InsightMove on MongoDB Atlas (free M0 tier, AWS EU_WEST_3). Run in mongosh on the Atlas connection.

show dbs
use insightmove

// ------------------------------------------------------------
// 1. Verify the cloud copy
// ------------------------------------------------------------
db.getCollectionNames().sort().forEach(n => print(n, db.getCollection(n).countDocuments()))
// expected: customers 1000, deliveries 3222, drivers 120, locations 60,
//           payments 7525, trip_status_history 30888, trips 8000, vehicles 120

// Dates were imported as text; convert once (same scripts as Portfolio 4)
db.customers.updateMany(
  { added_at: { $type: "string" } },
  [ { $set: { added_at: { $dateFromString: { dateString: "$added_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
);
db.drivers.updateMany(
  { joined_at: { $type: "string" } },
  [ { $set: { joined_at: { $dateFromString: { dateString: "$joined_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
);
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
]);
db.trip_status_history.updateMany(
  { changed_at: { $type: "string" } },
  [ { $set: { changed_at: { $dateFromString: { dateString: "$changed_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
);
db.payments.updateMany(
  { paid_at: { $type: "string" } },
  [ { $set: { paid_at: { $dateFromString: { dateString: "$paid_at", format: "%Y-%m-%d %H:%M:%S" } } } } ]
);

// No date left as text (every line should end in 0)
["trips:requested_at", "trip_status_history:changed_at", "payments:paid_at", "customers:added_at", "drivers:joined_at"].forEach(x => {
  const [c, f] = x.split(":");
  print(c, f, db.getCollection(c).countDocuments({ [f]: { $type: "string" } }));
})

// ------------------------------------------------------------
// 2. Replication and availability
// ------------------------------------------------------------
db.hello()
// setName atlas-7m19eu-shard-0; three hosts; isWritablePrimary true

db.adminCommand({ replSetGetStatus: 1 }).members.map(m => ({ name: m.name, state: m.stateStr }))
// shard-00-00 SECONDARY, shard-00-01 SECONDARY, shard-00-02 PRIMARY

// ------------------------------------------------------------
// 3. Consistency
// ------------------------------------------------------------
// 3a. Write concern (practice collection, so InsightMove data is untouched)
let s = Date.now();
const r1 = db.consistency_test.insertOne({ note: "w1" }, { writeConcern: { w: 1 } });
print("w:1 acknowledged:", r1.acknowledged, "took", Date.now() - s, "ms")

let s2 = Date.now();
const r2 = db.consistency_test.insertOne({ note: "majority" }, { writeConcern: { w: "majority" } });
print("w:majority acknowledged:", r2.acknowledged, "took", Date.now() - s2, "ms")

for (const wc of [{ w: 1 }, { w: "majority" }]) {
  const t = [];
  for (let i = 0; i < 5; i++) {
    const st = Date.now();
    db.consistency_test.insertOne({ note: "loop" }, { writeConcern: wc });
    t.push(Date.now() - st);
  }
  print(JSON.stringify(wc), t.join(" ms, ") + " ms");
}
// w:1       294, 114, 109, 112, 106 ms
// majority  113, 112, 110, 114, 126 ms

// 3b. Read preference: which server answers, and do the copies agree?
db.consistency_test.find().readPref("primary").explain().serverInfo.host     // shard-00-02 (primary)
db.consistency_test.find().readPref("secondary").explain().serverInfo.host   // shard-00-00 (secondary)
db.consistency_test.find().readPref("secondary").itcount()                   // 12
db.consistency_test.countDocuments()                                         // 12

// Remove the practice collection
db.consistency_test.drop()

// ------------------------------------------------------------
// 4. Facts used for the shard key decision
// ------------------------------------------------------------
db.trips.distinct("customer_id").length                                      // 980 customers
db.trips.aggregate([{ $group: { _id: "$customer_id", n: { $sum: 1 } } }, { $sort: { n: -1 } }, { $limit: 3 }])
// customer 185: 330 trips, 325: 219, 907: 155
db.trips.distinct("status").length                                           // 5 values

// ------------------------------------------------------------
// 5. Sharding attempt on the free tier (refused)
// ------------------------------------------------------------
sh.enableSharding("insightmove")
// MongoServerError[AtlasError]: (Unauthorized) not authorized on admin to execute command { enableSharding: ... }
