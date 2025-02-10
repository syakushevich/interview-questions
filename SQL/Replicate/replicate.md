## Replication in SQL

## Overview

Replication is a technique to improve both read and write performance by separating them across multiple database instances. Typically, reads far outnumber writes, so replication helps scale the system effectively.

## How Replication Works
async function submitForm(csrfToken, agent) {
    if (!csrfToken) {
        console.error("[ERROR] Cannot submit form, CSRF token is missing.");
        return;
    }

    const captchaToken = await solveCaptcha();

    // Define the request body
    const formData = new URLSearchParams();
    formData.append("direction", "ru");
    formData.append("sum", "200000");
    formData.append("currency", "RUB");
    formData.append("email", "aaa@mail.ru");
    formData.append("captcha", captchaToken);
    formData.append("secretSum", "");
    formData.append("cardType", "1");

    try {
        console.log("[INFO] Sending form submission request...");

        const response = await fetch("https://www.rs-express.ru/transfers", {
            method: "POST",
            headers: {
                "Accept": "*/*",
                "Accept-Language": "en-US,en;q=0.9",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "Priority": "u=1, i",
                "Sec-Ch-Ua": "\"Chromium\";v=\"128\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"128\"",
                "Sec-Ch-Ua-Mobile": "?0",
                "Sec-Ch-Ua-Platform": "\"Mac OS X\"",
                "Sec-Fetch-Dest": "empty",
                "Sec-Fetch-Mode": "cors",
                "Sec-Fetch-Site": "same-origin",
                "X-Csrf-Token": csrfToken,
                "X-Requested-With": "XMLHttpRequest"
            },
            body: formData.toString(),
            credentials: "include"
        });

        const contentType = response.headers.get("content-type");

        if (contentType && contentType.includes("application/json")) {
            const data = await response.json();
            console.log("[SUCCESS] Form submitted. Response URL:", data?.url || "No URL found in response");
        } else {
            const text = await response.text();
            console.error("[ERROR] Response is not JSON. Raw Response:", text.substring(0, 500)); // Print first 500 characters
        }

    } catch (error) {
        console.error("[ERROR] Failed to submit form:", error.message);
    }
}

- **Primary Database (Read + Write)**: The main database where all write operations occur.
- **Replica Databases (Read-Only)**: Synchronize data from the primary database and handle read queries.
- **Horizontal Scalability**: Distributes read operations across multiple replicas, improving query performance.
- **Trade-off**: Managing replicas introduces complexity, requiring synchronization and monitoring tools.

## Example: Setting Up Replication in PostgreSQL

```sql
-- On the primary database
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET hot_standby = on;
SELECT pg_start_backup('initial_backup');
```

```sql
-- On the replica database
CREATE SUBSCRIPTION my_subscription
    CONNECTION 'host=primary_db user=replica_user password=secret'
    PUBLICATION my_publication;
```

## Managing Replication with PgBouncer and PgPool-II

- **PgBouncer**: A lightweight connection pooler that helps distribute queries efficiently.
- **PgPool-II**: Provides connection pooling, load balancing, and automatic failover for PostgreSQL replication setups.

## Conclusion

Indexes, partitioning, bulk insertion using `COPY`, and replication are key techniques for optimizing SQL database performance. Indexing speeds up queries, partitioning manages large datasets efficiently, `COPY` accelerates bulk data insertion, and replication scales read and write performance while ensuring data consistency.
