## Transaction and Concurrency

**Scenario:** two dispatchers try to assign the same available driver (driver 3) to two different requested trips (7990 and 7991) at the same time.

### The problem: a race condition
1. Both sessions started a transaction and read driver 3 as `available`.
2. Session A assigned trip 7990 to driver 3, set the driver to `on_trip` and committed.
3. Session B, still believing the driver was free, assigned trip 7991 to driver 3 and committed.

Both transactions succeeded and neither produced an error, so driver 3 ended up on two trips at once. Each transaction was correct on its own, but together they broke the business rule that a driver has one active trip. The outcome depended on the timing of the two sessions.

### The fix: row locking with SELECT ... FOR UPDATE
1. Session A started a transaction and read driver 3 with `FOR UPDATE`, which locked the row.
2. Session B ran the same statement and had to wait, because A held the lock.
3. Session A assigned trip 7990 and committed, which released the lock.
4. Session B's read then completed and showed driver 3 as `on_trip`, so B rolled back instead of assigning the driver.

Result: trip 7990 belongs to driver 3 and trip 7991 stays `requested`. No double booking.

### Why it works
`FOR UPDATE` turns the "read, then decide, then write" sequence into one protected step. Only one transaction at a time can read the row with the intention of changing it, so the second one always sees the result of the first. The trade-off is that locks make other sessions wait, so transactions that hold them should be kept short. 

### Evidence

| Evidence | Screenshot |
I have added the png screenshot of the query output



