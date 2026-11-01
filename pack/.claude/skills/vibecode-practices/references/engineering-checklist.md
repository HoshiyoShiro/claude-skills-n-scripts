# Engineering knowledge checklist

Consider the relevant topics when designing or reviewing. Items are grouped by area.

**Database and data:** Indexes, EXPLAIN ANALYZE, N+1 Queries, Full Table Scans, Connection Pooling, Database Migrations, Down Migrations, Transactions, ACID, Isolation Levels, Deadlocks, Optimistic Locking, Pessimistic Locking, Normalization, Denormalization, Foreign Keys, Unique Constraints, Cascading Deletes, Soft Deletes, UUIDs vs Auto-Increment, Cursor-Based Pagination, Full-Text Search, Read Replicas, Replication Lag, Sharding, Partitioning, Hot Partitions, Postgres VACUUM, Materialized Views, ORM Lazy Loading

**Backups and recovery:** Backups, Testing Your Restores, Point-in-Time Recovery, Disaster Recovery, RTO and RPO

**Distributed systems:** CAP Theorem, Eventual Consistency, Strong Consistency, Raft Consensus, Leader Election, Split Brain, Quorums, Clock Skew, Distributed Locks, Consistent Hashing, Bloom Filters, Two-Phase Commit, CQRS, Event Sourcing, Change Data Capture, Outbox Pattern, Race Conditions

**Resilience:** Backpressure, Load Shedding, Bulkheads, Jitter, Retry Storms, Cascading Failures, Thundering Herd, Graceful Degradation, Failover, Multi-Region, Availability Zones, Single Points of Failure, Chaos Engineering

**Caching (Upstash/Redis, CDN):** Cache Invalidation, Cache Hit Ratio, TTLs, Cache Warming, Write-Through vs Write-Back, Redis Eviction Policies, CDNs, Cache-Control Headers, ETags

**Messaging and jobs:** Dead Letter Queues, Poison Messages, At-Least-Once Delivery, Exactly-Once Semantics, Message Ordering, Kafka Consumer Groups, Partition Keys, Background Jobs, Webhook Retries

**Networking and protocols:** DNS, DNS Propagation, HTTP Status Codes, HTTP Method Semantics, Keep-Alive, HTTP/2, WebSockets, Server-Sent Events, Long Polling, gRPC, Protocol Buffers, Latency vs Throughput, Compression, Egress Fees

**API design:** API Versioning, OpenAPI Specs, Backward Compatibility, Request Size Limits, Schema Validation

**Cloud and infrastructure:** VPCs, Subnets, NAT Gateways, Firewalls, Security Groups, Service Mesh, Ingress Controllers, Public S3 Buckets, Presigned URLs, Cloud Billing Alerts

**Reliability and operations:** Health Checks, Liveness vs Readiness Probes, Graceful Shutdown, Connection Draining, Stateless Services, SLAs, SLOs, Error Budgets, Incident Response, On-Call, Runbooks, Postmortems

**Scaling and performance:** Autoscaling, Horizontal vs Vertical Scaling, Cold Starts, Capacity Planning, Load Testing, Memory Leaks, OOM Killer, Profiling, Flame Graphs, Big O Notation, Debouncing

**Observability:** Structured Logging, Log Levels, Log Rotation, Distributed Tracing, OpenTelemetry, Correlation IDs, Metrics Cardinality, p99 Latency, Alert Fatigue, Error Tracking

**Deployment and DevOps:** Infrastructure as Code, Terraform State, GitOps, Blue-Green Deployments, Canary Releases, Rollbacks, Feature Flags, Environment Parity, Staging Environments, 12-Factor Apps, Semantic Versioning, Lockfiles, Reproducible Builds, Branch Protection

**Containers:** Multi-Stage Builds, Non-Root Containers, Image Scanning, Resource Requests and Limits, Pod Disruption Budgets

**Testing:** Unit Tests, Integration Tests, End-to-End Tests, Contract Testing, Flaky Tests, Mocking, Regression Tests, Smoke Tests, Property-Based Testing, Fuzzing

**Code correctness:** Error Handling, Edge Cases, Off-by-One Errors, Floating Point Math, **Storing Money as Floats (AVOID; use integer minor units or decimals)**, Time Zones, Daylight Saving Time, Unicode, Character Encoding, Thread Safety, Event Loop Blocking, Unhandled Promise Rejections, Integer Overflow, Garbage Collection

**Code health:** Technical Debt, Dead Code, Merge Conflicts, Reading the maxed LOC Diff (review the whole diff, even a very large one)

**Compliance and business:** GDPR, PII Handling, Audit Logs, Data Residency, SOC 2, PCI DSS, Cookie Consent, Software Licenses, Chargebacks, Bot Protection

**Email deliverability (Resend):** SPF, DKIM and DMARC, Email Bounce Handling

**AI and LLM features (Pinecone, prompts):** Prompt Injection, Hallucinated Packages (verify any package an AI suggests actually exists), Real-time Streaming, Context Windows, Evals, Model Version Pinning
