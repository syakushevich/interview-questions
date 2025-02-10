# Types of Locks in Relational Databases

Relational databases use several locking mechanisms to maintain data consistency and manage concurrent access. Here are some common types:

## 1. Table-Level Locks
- **Description:** Lock the entire table.
- **Usage:** Often used during bulk updates or schema changes.
- **Pros:** Simple and ensures no conflicting operations on any rows.
- **Cons:** Very coarse; it prevents any other transaction from accessing any part of the table, limiting concurrency.

## 2. Row-Level Locks
- **Description:** Lock individual rows that are being modified.
- **Usage:** Commonly used for update or delete operations where only specific rows are affected.
- **Pros:** Allows high concurrency as only the affected rows are locked.
- **Cons:** More overhead in managing many locks, especially when many rows are involved.

## 3. Page-Level Locks
- **Description:** Lock a fixed-size block (or page) of data, which can contain multiple rows.
- **Usage:** Balances between the granularity of row-level locks and the simplicity of table-level locks.
- **Pros:** Can reduce locking overhead when many rows in the same page are updated.
- **Cons:** May lock more rows than necessary, which can unnecessarily reduce concurrency.

## 4. Shared and Exclusive Locks
- **Shared Locks (S-locks):**
  - Allow multiple transactions to read the same data concurrently.
  - Prevent data modifications until all shared locks are released.
- **Exclusive Locks (X-locks):**
  - Only one transaction can hold an exclusive lock on a resource.
  - Blocks both reading and writing by other transactions.

## 5. Intent Locks
- **Description:** Used to signal the intention to acquire more granular locks (like row-level locks) later.
- **Usage:** Helps the database engine manage locking hierarchies and prevent conflicts between table-level and row-level locks.
- **Example:** An "intent exclusive" lock on a table indicates that a transaction intends to obtain exclusive locks on some rows within that table.

---

# Concurrency Control: Pessimistic vs. Optimistic Locking in Rails

## Pessimistic Locking

### Concept
- **Pessimistic Locking** involves locking a record as soon as it is read for update, so that no other transaction can modify it until the lock is released.

### Implementation in Rails
- Use ActiveRecord's `lock` method or `with_lock` block.
  ```ruby
  # Example using pessimistic locking:
  user = User.lock.find(1)
  user.update!(balance: user.balance - 100)
