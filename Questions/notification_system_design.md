1. Real-Time Notification System Design
Scenario:
Imagine you have a system with organizations and users. Each organization has a time tracker. When a time tracker is started or stopped, the system logs an event, and you must notify all users of that organization about the tracker update.

Requirements:

Ordering: Notifications must be sent in the exact order the events were logged.
Latency: Each notification should reach users within 5 seconds of the event.
Scalability: The system should support millions of organizations without overloading the notification subsystem.
Question:
How would you design the backend to meet these requirements?
Follow-up Points:

What design patterns or architectural styles (e.g., event-driven architecture, message queues) would you employ?
How would you ensure strict message ordering and low latency?
What challenges might you encounter at scale, and how would you address them?


2. Handling External API Rate Limiting (Slack Integration)
Scenario:
Your application sends notifications via Slack, but Slack enforces a rate limit (e.g., a maximum number of requests per minute). The rate limit applies globally (not per organization).

Question:
How would you design your notification system to ensure that you never exceed Slack’s rate limits?
Follow-up Points:

What strategies (e.g., rate limiters, token buckets, queuing mechanisms) could you use?
How would you batch or delay messages if the limit is reached?
How do you handle retries or failures due to rate limiting while preserving message order?

3. High-Throughput Messaging with Ordering Guarantees
Scenario:
Consider a UI with a timer that a user can start and stop. Each action triggers messages sent via various messaging APIs (for example, Slack). The system must:

Process approximately 500 messages per second.
Guarantee that messages are delivered strictly in the order of events.
Handle possible external API failures and slow responses.
Deal with external rate limits (e.g., 1000 requests per minute per endpoint).
Question:
How would you architect a system that satisfies these requirements?
Follow-up Points:

What messaging patterns (e.g., queues, streams, or event sourcing) might you use to ensure message order and reliability?
How would you design a rate limiting mechanism or scheduler to interface with external APIs like Slack?
What strategies can be implemented for error handling and retries without breaking the message order?