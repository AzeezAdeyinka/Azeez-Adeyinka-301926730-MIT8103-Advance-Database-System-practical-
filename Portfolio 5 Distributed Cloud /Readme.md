# Portfolio 5: Distributed Cloud 

**Course:** MIT 8103 Advanced Database Systems | **Cloud platform:** MongoDB Atlas (free M0 tier) on AWS | **Case study:** InsightMove

## 1. Overview

This portfolio deploys the InsightMove MongoDB data (from Portfolio 4) to a cloud cluster and examines how a distributed database provides replication, availability and consistency. Sharding is covered as a design, because the free tier does not support it.

## 2. Cloud Deployment

| Item | Value |
|---|---|
| Platform | MongoDB Atlas, free tier (M0) |
| Cloud provider and region | AWS, EU_WEST_3 (Paris) |
| MongoDB version | 8.0.36 |
| Project / cluster | InsightMove / Cluster0, status ACTIVE |
| Database | `insightmove` |
| Access | Database user with password; network access limited to my IP address |

The eight collections were imported from the Portfolio 4 JSON exports, and the date fields were converted from text to real dates, as in the local copy.

| Collection | Documents |
|---|---|
| customers | 1,000 |
| deliveries | 3,222 |
| drivers | 120 |
| locations | 60 |
| payments | 7,525 |
| trip_status_history | 30,888 |
| trips | 8,000 |
| vehicles | 120 |

Every count equals the local MongoDB copy and the MySQL table. A final check showed 0 documents with a date stored as text in all five collections that have dates.

## 3. Replication and Availability

Atlas runs the database as a **replica set** of three servers holding identical copies of the data. `db.hello()` and `replSetGetStatus` showed:

| Server | Role |
|---|---|
| `ac-ziljdh0-shard-00-00` | SECONDARY |
| `ac-ziljdh0-shard-00-01` | SECONDARY |
| `ac-ziljdh0-shard-00-02` | PRIMARY |

The replica set is named `atlas-7m19eu-shard-0`. All three servers are `ELECTABLE`, meaning any of them can become primary.

**How it works:** every write goes to the primary, which copies it to the two secondaries. If the primary fails, the secondaries hold an election and one becomes the new primary, so the database stays available. Because the data exists on three servers, losing one server loses nothing. During an election, writes pause for a short time.

## 4. Consistency

### 4.1 Write concern
A write concern decides when the database reports a write as successful. I inserted into a practice collection and timed five writes with each setting:

| Write concern | Meaning | Times (ms) |
|---|---|---|
| `w: 1` | success once the primary has the write | 294 (first run), 114, 109, 112, 106 |
| `w: "majority"` | success once at least two of three servers have it | 113, 112, 110, 114, 126 |

Both settings took about 110 ms. The first `w: 1` write was slower because it opened the connection and created the collection. Waiting for a second server added almost nothing, because the three servers are in the same data centre, and most of the time was the network trip to the cloud region. `w: "majority"` protects a write if the primary fails before it has copied it, so it is the safer choice for important data such as payments.

### 4.2 Read preference
| Read preference | Server that answered | Documents returned |
|---|---|---|
| `primary` | `shard-00-02` (primary) | 12 |
| `secondary` | `shard-00-00` (secondary) | 12 |

The secondary returned the same 12 documents as the primary, so the copies agree. Reading from a secondary spreads the read load across servers, but a secondary can lag slightly behind the primary, so a read may miss a very recent write (eventual consistency). Reading from the primary always gives the latest data.

### 4.3 Consistency and availability trade-off
A MongoDB replica set favours consistency: writes go to one primary, so all servers converge on one history. The cost is a brief pause in writes while a new primary is elected after a failure, and possible stale reads from secondaries.

## 5. Sharding Design

Sharding splits a large collection across several servers. The free tier cannot shard: running `sh.enableSharding("insightmove")` returned **Unauthorized (not authorized on admin)**, and sharding requires a dedicated paid cluster (M30 or above). The design below was therefore documented, not executed.

### Facts from my data
- `trips` has 8,000 documents from 980 different customers.
- The busiest customers are 185 (330 trips), 325 (219 trips) and 907 (155 trips).
- `status` has only 5 values.

### Shard key options
| Shard key | Strength | Weakness |
|---|---|---|
| `status` | none | only 5 values, so data cannot spread evenly |
| `requested_at` | date ranges stay together | all new trips land on the newest slice, so one server takes all the writes |
| `trip_id` (hashed) | writes spread evenly | a customer's trips are scattered, so customer lookups ask every server |
| `{ customer_id: 1, requested_at: 1 }` | customer lookups stay on one shard, and heavy customers are split by date | queries without `customer_id` (for example by driver) ask every shard |

### Chosen key: `{ customer_id: 1, requested_at: 1 }`
Customer lookups are the common read and are served by a single shard. The date part splits heavy customers such as customer 185 (4% of all trips) into several slices, and new trips come from many customers, so writes spread across shards.

```js
sh.enableSharding("insightmove")
db.trips.createIndex({ customer_id: 1, requested_at: 1 })
sh.shardCollection("insightmove.trips", { customer_id: 1, requested_at: 1 })
db.trips.getShardDistribution()
```

## 6. Comparison with MySQL

| Topic | MongoDB (Atlas) | MySQL |
|---|---|---|
| Replication | Built in: a replica set with automatic failover | Source-replica replication, set up and managed separately; failover needs extra tooling |
| Consistency | Primary-only writes; configurable write concern and read preference | A single server gives strict ACID guarantees; replicas by default copy changes with a delay |
| Scaling out | Sharding built in | Not built in; needs application-level splitting or additional tools |
| Multi-record transactions | Atomic only within a document unless multi-document transactions are used | Full transactions across tables (shown in Portfolio 3) |

For InsightMove, MySQL is the safer home for customer, booking and payment records that need strict transactions, and MongoDB on a replica set suits the large, fast-growing trip and tracking data that needs availability and the ability to scale.


## 7. Challenges and What I Learned

Atlas needs a project before it lets you create a cluster, so I first looked for a create button that did not exist until I created the project. Compass then failed to connect to the cluster, and the problem was network access: Atlas only accepts connections from approved addresses, so I added an access entry and tried again until it connected. I also found that the Atlas web page displays the database as `Insightmove`, while the shell shows the real, lowercase name `insightmove`, so I always check the name in the shell.

I learned that replication gives availability by keeping three copies and electing a new primary on failure, and that consistency is a choice: `w: "majority"` and primary reads give the strongest guarantees, while secondary reads trade freshness for spread-out load. The write timings taught me that in a small cloud setup the network round trip dominates the cost, so `majority` is cheap here. When I tried to enable sharding, Atlas refused with an authorisation error, which showed me that sharding is a paid feature, so I designed the shard key from my own data instead. The key facts were the 980 distinct customers and the few heavy customers, which led me to choose a compound key.

## 9. AI Use Declaration

- **Tool:** Claude (Anthropic)
- **Used for:** to make research on some bugs i encountered
