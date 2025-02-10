# Transaction Isolation Levels in Relational Databases

## Available Isolation Levels

1. **Read Uncommitted**
   - **Description:** The lowest isolation level where transactions may see uncommitted changes made by other transactions (i.e., dirty reads).
   - **Consistency vs. Concurrency:**
     - *Consistency:* Very low, as uncommitted (and possibly rolled-back) changes can be read.
     - *Concurrency:* High, because minimal locking is performed.

2. **Read Committed**
   - **Description:** Ensures that any data read is committed at the moment it is read; dirty reads are prevented. This is the default level in many databases.
   - **Consistency vs. Concurrency:**
     - *Consistency:* Prevents dirty reads but may allow non-repeatable reads and phantom reads.
     - *Concurrency:* Good balance, allowing higher concurrency while still preventing the most egregious inconsistencies.

3. **Repeatable Read**
   - **Description:** Guarantees that if a row is read twice in the same transaction, the data will not change (no non-repeatable reads). However, phantom reads (new rows appearing) can still occur.
   - **Consistency vs. Concurrency:**
     - *Consistency:* Stronger consistency than Read Committed since multiple reads within a transaction are consistent.
     - *Concurrency:* May reduce concurrency compared to Read Committed due to the increased locking needed to maintain consistency.

4. **Serializable**
   - **Description:** The strictest isolation level. Transactions are executed in a way that the outcome is as if they were processed serially, one after the other.
   - **Consistency vs. Concurrency:**
     - *Consistency:* Highest consistency, preventing dirty reads, non-repeatable reads, and phantom reads.
     - *Concurrency:* Lower concurrency since transactions might block each other and serialization errors (leading to rollbacks) can occur under heavy load.

## Impact on Consistency and Concurrency
- **Higher Isolation Levels (e.g., Serializable):**
  - *Consistency:* Provide the most robust consistency guarantees.
  - *Concurrency:* Tend to reduce throughput and increase the chance of transaction rollbacks due to conflicts.
- **Lower Isolation Levels (e.g., Read Uncommitted or Read Committed):**
  - *Consistency:* Allow for higher concurrency but at the cost of potential read anomalies like dirty reads (in Read Uncommitted) or non-repeatable/phantom reads (in Read Committed).
  - *Concurrency:* Generally offer higher throughput and less contention among transactions.

# Changing Transaction Isolation Level in Rails

## Using ActiveRecord Transaction Blocks

Since Rails 4.2, you can specify the isolation level when starting a transaction. For example:

```ruby
ActiveRecord::Base.transaction(isolation: :serializable) do
  # Your transactional code here
end
