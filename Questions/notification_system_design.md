# 1. Real-Time Notification System Design

**Scenario Recap:**
Organizations have users and a time tracker. When a tracker starts or stops, an event is logged and all users of that organization must be notified. Requirements include strict ordering, sub-5-second latency, and support for millions of organizations without overloading the notification subsystem.

## Design Approach

### Event-Driven Architecture
- **Publish-Subscribe Model:**
  - When a time tracker event occurs (start/stop), publish an event to a messaging system.
  - Use a message broker such as **Kafka** or **RabbitMQ**.

- **Message Queues/Streams:**
  - Each organization’s events can be tagged with a unique key (e.g., organization ID).
  - Use partitioning (Kafka) or dedicated queues (RabbitMQ) to ensure that events for the same organization are processed in order.

### Ensuring Strict Message Ordering and Low Latency
- **Partitioning by Organization:**
  - For systems like Kafka, assign a partition key using the organization ID so that all messages for a given organization go to the same partition and are thus processed sequentially.

- **Dedicated Consumer Workers:**
  - Have consumer services subscribe to the appropriate queues or partitions.
  - These workers process messages immediately upon arrival, ensuring the sub-5-second latency requirement.

- **In-Memory Queues & Fast Processing:**
  - Employ fast, in-memory queuing systems to minimize processing delays.
  - Use lightweight worker processes (e.g., with Sidekiq) that can quickly dequeue and process events.

### Scalability Considerations
- **Horizontal Scaling:**
  - Scale the number of consumer workers horizontally based on the load.
  - Ensure that the messaging system can partition data and distribute load across many workers.

- **Backpressure and Load Balancing:**
  - Implement backpressure mechanisms to prevent overwhelming the system when processing spikes occur.
  - Use load balancing to distribute the notification tasks evenly across available workers.

- **Decoupling:**
  - Keep the event generation (tracker events) decoupled from the notification service so that high loads in one don’t directly impact the other.

---

# 2. Handling External API Rate Limiting (Slack Integration)

**Scenario Recap:**
Notifications are sent via Slack, which enforces a global rate limit (e.g., a fixed number of requests per minute). The system must ensure that this limit is never exceeded.

## Design Approach

### Global Rate Limiting Strategy
- **Centralized Rate Limiter:**
  - Implement a rate limiter (using algorithms like token bucket or leaky bucket) to control the number of Slack API calls.
  - This limiter is shared across all instances of the notification system to enforce a global cap.

- **Central Outbound Queue:**
  - Place all Slack-bound messages into a single global queue.
  - A scheduler or dispatcher service dequeues messages at a controlled rate that complies with Slack’s limits.

### Batching and Delaying
- **Batching Requests:**
  - If supported by Slack, group several notifications into one API call.

- **Delay Mechanisms:**
  - When the rate limit is approached or exceeded, delay additional messages until tokens become available.
  - Use a scheduling mechanism to reattempt sending messages after a calculated delay.

### Error Handling and Retries
- **Exponential Backoff:**
  - On receiving rate limit errors (e.g., HTTP 429), employ exponential backoff for retries.
  - Ensure that retries are queued and processed in order.

- **Idempotency:**
  - Design the notification calls to be idempotent so that retrying does not result in duplicate notifications.

- **Preserving Message Order:**
  - Even during retries, maintain the order by keeping the messages in the same queue order until they are successfully sent.

---

# 3. High-Throughput Messaging with Ordering Guarantees

**Scenario Recap:**
A UI timer generates events (start/stop) triggering messages that must be processed at roughly 500 messages per second, delivered in strict order, while handling external API failures and rate limits (e.g., 1000 requests per minute per endpoint).

## Design Approach

### Messaging Patterns and System Architecture
- **Event Sourcing and Queues:**
  - Use an event-sourcing approach where every timer event is logged as an immutable event.
  - Leverage a high-throughput message broker (e.g., Kafka) to stream events reliably.

- **Partitioning for Ordering:**
  - Partition events by user or session identifier to ensure that messages are processed in the order they are generated.
  - Within each partition, the order is strictly maintained.

### Rate Limiting and Scheduling
- **Dedicated Scheduler:**
  - Implement a scheduler that interfaces with external APIs like Slack.
  - The scheduler respects the global rate limits by using a token bucket algorithm to throttle outgoing requests.

- **Rate Limiter Integration:**
  - Combine the scheduler with a rate limiter to ensure that even under high throughput, the number of API calls per minute does not exceed the allowed threshold.

- **Batch Processing:**
  - If the external API supports it, batch multiple messages together to minimize the number of calls.

### Error Handling and Retry Strategies
- **Error Resilience:**
  - Design the consumer workers to detect API failures or slow responses.
  - On failure, messages remain in the queue and are retried after a delay, ensuring that order is maintained.

- **Exponential Backoff and Circuit Breakers:**
  - Use exponential backoff for retries when failures occur.
  - Consider employing circuit breakers to temporarily suspend calls to the external API if failures persist, then resume once the API stabilizes.

- **Idempotency and Logging:**
  - Ensure that processing of messages is idempotent to avoid duplicate processing during retries.
  - Log each attempt for monitoring and debugging purposes.

---

## Summary

- **For Real-Time Notification System Design:**
  Use an event-driven architecture with dedicated queues and partitions to maintain order, leverage fast consumer workers for low latency, and scale horizontally to support millions of organizations.

- **For Handling External API Rate Limiting (Slack):**
  Use a centralized rate limiter and outbound queue to control the rate of API calls, implement batching and delay mechanisms, and design robust retry strategies with exponential backoff while preserving message order.

- **For High-Throughput Messaging with Ordering Guarantees:**
  Employ event sourcing and partitioned messaging systems, integrate a dedicated scheduler with a rate limiter, and ensure error handling and retries do not disrupt the strict order of events.

This multi-layered approach ensures that your system can deliver notifications reliably, within the required latency, and at scale while handling external API constraints.
