# SQL Indexes

## Overview

Indexes in SQL help optimize query performance by allowing faster searches. However, they come with trade-offs.

## How Indexes Work

- **Without an index**: SQL performs a sequential scan, checking each row one by one.
- **With an index**: SQL organizes the column data in a structured way, enabling efficient lookups using a parallel index scan.
- **Trade-off**: Indexing speeds up read operations but slows down writes, as the index needs to be updated whenever data changes.

## Benefits of Indexing

- **Faster Query Execution**: Lookups, filtering, and sorting become more efficient.
- **Optimized Search Performance**: Reduces the number of rows SQL needs to scan.
- **Supports Unique Constraints**: Ensures uniqueness in indexed columns.

## Downsides of Indexing

- **Increased Storage Usage**: Indexes consume additional disk space.
- **Slower Write Operations**: Insert, update, and delete operations require index updates.
- **Maintenance Overhead**: Frequent changes require index rebuilding.

## Example: Creating an Index in SQL

```sql
CREATE INDEX idx_users_email ON users(email);
```

Using an index, queries searching by email will be much faster:

```sql
SELECT * FROM users WHERE email = 'user@example.com';
```

## Example: Using Indexes in Ruby on Rails (ActiveRecord)

### Migration to Add an Index

```ruby
class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email
  end
end
```

### Query Performance Improvement

With an index on `email`, the following query will execute faster:

```ruby
User.find_by(email: 'user@example.com')
```

## Conclusion

Indexes are crucial for optimizing query performance, especially in large datasets. However, they should be used judiciously to balance read and write performance.
