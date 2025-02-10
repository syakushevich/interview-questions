# Transaction Isolation Levels in Relational Databases

## Available Isolation Levels

1. **Read Uncommitted**
   - **Description:**
     Allows transactions to read data that has not yet been committed by other transactions (dirty reads).
   - **Consistency:**
     Lowest consistency; transactions can see changes that might be rolled back.
   - **Concurrency:**
     Very high, due to minimal locking.

2. **Read Committed**
   - **Description:**
     Only committed data is visible. Dirty reads are prevented, but non-repeatable reads and phantom reads can occur.
   - **Consistency:**
     Provides a reasonable level of consistency for many applications.
   - **Concurrency:**
     Good balance between consistency and performance; widely used as a default isolation level.

3. **Repeatable Read**
   - **Description:**
     Ensures that if a row is read twice within the same transaction, the data remains the same (prevents non-repeatable reads). Phantom reads may still occur in some systems.
   - **Consistency:**
     Higher consistency than Read Committed.
   - **Concurrency:**
     Concurrency is reduced because locks may be held for the duration of the transaction to maintain repeatable reads.

4. **Serializable**
   - **Description:**
     The strictest isolation level, where transactions execute in a manner equivalent to serial execution. Prevents dirty reads, non-repeatable reads, and phantom reads.
   - **Consistency:**
     Highest level of consistency.
   - **Concurrency:**
     Lowest concurrency, as it requires heavy locking and can lead to transaction rollbacks in high-contention scenarios.

## Impact on Consistency and Concurrency

- **Lower Isolation Levels (Read Uncommitted):**
  - **Consistency:** May lead to data anomalies like dirty reads.
  - **Concurrency:** Maximizes throughput by reducing locking.

- **Intermediate Isolation Levels (Read Committed and Repeatable Read):**
  - **Consistency:** Prevents dirty reads; Repeatable Read adds further consistency by avoiding non-repeatable reads.
  - **Concurrency:** Offers a trade-off between data integrity and performance, with Repeatable Read generally locking more than Read Committed.

- **Highest Isolation Level (Serializable):**
  - **Consistency:** Ensures complete isolation and highest data integrity.
  - **Concurrency:** Limits throughput due to strict locking and increased risk of transaction rollbacks in concurrent environments.

# Changing the Transaction Isolation Level in Rails

## Using ActiveRecord Transaction Blocks

Rails allows you to set the isolation level on a per-transaction basis with ActiveRecord. For example:

```ruby
ActiveRecord::Base.transaction(isolation: :serializable) do
  # Your transactional code here
end
Supported Isolation Levels:
The symbols you can use (e.g., :read_uncommitted, :read_committed, :repeatable_read, :serializable) depend on your database adapter. PostgreSQL, for instance, supports all these levels.
Using Raw SQL Commands Within a Transaction
You can also change the isolation level using a raw SQL command:

ruby
Copy
ActiveRecord::Base.transaction do
  ActiveRecord::Base.connection.execute("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ")
  # Your transactional code here
end
Global or Connection-Level Settings
Some database adapters allow you to configure a default isolation level in the connection settings or database configuration files. However, setting the isolation level per transaction is generally recommended for finer control.

By understanding these isolation levels and how to configure them in Rails, you can better balance consistency and concurrency in your application based on its specific requirements.

Copy
```