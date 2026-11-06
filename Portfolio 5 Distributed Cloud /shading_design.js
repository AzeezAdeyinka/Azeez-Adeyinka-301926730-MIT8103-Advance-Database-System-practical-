// Sharding design for InsightMove (NOT executed: the free Atlas tier cannot shard).
// These commands are for a dedicated paid cluster (M30 or above).
//
// Chosen shard key: { customer_id: 1, requested_at: 1 }
//   - "show this customer's trips" includes customer_id, so it is answered by one shard
//   - heavy customers (customer 185 has 330 trips, about 4% of all trips) are split by date
//   - new trips come from many customers, so writes spread across shards
//   - trade-off: queries without customer_id (for example by driver) must ask every shard

// 1. Allow the database to be sharded
sh.enableSharding("insightmove")

// 2. Create the index that supports the shard key
db.trips.createIndex({ customer_id: 1, requested_at: 1 })

// 3. Shard the trips collection on that key
sh.shardCollection("insightmove.trips", { customer_id: 1, requested_at: 1 })

// 4. Check how the data is spread across shards
db.trips.getShardDistribution()
