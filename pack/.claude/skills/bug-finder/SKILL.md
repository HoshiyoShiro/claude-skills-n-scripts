---
name: bug-finder
description: Systematic bug finding and root-cause analysis. Use whenever the user reports a bug, crash, error, wrong output, slow performance, flaky behavior or a failed build or deploy, or asks to review, debug, audit or find issues in code or a system.
---

# Bug Finder

## Rules
- Be concise. Never guess: every claim is backed by evidence (log, code line, test result). Change one variable at a time.
- If anything is unclear, ask first. Never guess requirements.
- Use the database for clues when access exists (read-only; see `db-access`).
- Check `known-issues` first: match the symptom against frequent causes, verify the top candidate, and debug from scratch only if none fit. Record the result afterwards.
- Before fixing, apply `business-rules` (Mode B). Registered behavior is not a bug unless the user says so; ask before changing it.
- If a mockup is provided, apply `mockup-analyzer` first and treat the mockup as expected behavior.
- Anything hard to reverse or affecting shared systems needs the user's approval first.

## Clarify first (mandatory when information is missing)
Expected versus actual behavior; the exact error, screenshot or trace; steps to reproduce (always or intermittent); environment, version, user or account; when it started and what changed before (deploy, configuration, data, dependency); the service, module, table or endpoint involved; whether the system is live and whether there is urgency or data-loss risk; what was already tried.

Ask in one numbered list with likely options. Stop and wait before risky actions.

## Database clues (read-only)
Use `db-access`. Read only; limit rows; prefer non-production; redact personal data and secrets. Look at: schema, indexes, constraints; recent rows around the failure time; bad data (nulls, duplicates, orphans, wrong status, invalid formats, encoding or timezone); error, audit, job and queue tables; migration history and missing scripts; locks and long-running queries; query plans for slow queries; row counts and growth. Record each finding as: query, result, what it suggests. Compare an object across environments when it works in one and fails in another.

## Workflow
1. **Isolate.** State the symptom (expected versus actual). Reproduce it with minimal steps. Narrow the layer (UI, API, service, database, network, infrastructure, configuration, dependency), the time (what changed recently; use `git log -p` or `git bisect`) and the input (which data, user, environment or version triggers it).
2. **Collect information before theorizing.** The exact error and full stack trace; logs around the failure; versions; configuration (secrets redacted); the code path from entry to failure; network and database state; resource state.
3. **Hypothesize.** Up to three likely causes ranked by probability and ease of testing, each with the test that would prove or disprove it.
4. **Test and confirm the root cause.** Cheapest test first. Add targeted logging or a failing test that captures the bug. Ask why until you reach the origin, not just the symptom.
5. **Fix.** The smallest safe change that addresses the root cause. No unrelated refactoring. Show the diff.
6. **Verify.** The failing test passes, the original repro no longer fails, the existing suite shows no regression, edge cases and related paths are checked. `browser-bug` can confirm a UI bug in a real browser.
7. **Report.**

```
Problem:      <one line>
Root cause:   <one to two lines, with file:line if known>
Evidence:     <log/trace/test output>
Fix:          <what changed and why>
Verification: <how it was confirmed>
Prevention:   <test, validation, monitoring or process change>
```

## Static review checklist (when there is no symptom, just find bugs)
Null and empty handling, off-by-one; type coercion, overflow, float precision, timezone and encoding; unhandled errors, swallowed exceptions, missing awaits; races, shared state, deadlocks, missing transactions; resource leaks (files, sockets, connections, listeners, timers); input validation, injection, authorization gaps; secrets in code or logs, insecure defaults, CORS and CSRF; N+1 queries, missing indexes, unbounded queries or loops; missing timeouts, retry storms, no idempotency; configuration drift between environments; dependency conflicts and deprecated APIs; missing tests on risky branches. For each finding: severity, location, why it is a bug, suggested fix.

## Common patterns
| Symptom | Check first |
|---|---|
| Works locally, fails elsewhere | environment variables, versions, permissions, network, data differences, database scripts not applied |
| Intermittent or flaky | race conditions, timeouts, caching, shared state, clock or timezone |
| Gets slower over time | memory or connection leaks, unbounded growth, missing index |
| 500 or crash after deploy | diff the release, migrations, configuration, dependency bumps |
| Connection refused or timeout | service up, port, DNS, firewall, TLS, pool exhaustion |
| Wrong data | input mutation, stale cache, wrong join or filter, type conversion |

## Don'ts
- Don't apply a fix before confirming the cause.
- Don't change several things at once.
- Don't hide the error (empty catch, silent default) as a fix.
- Don't claim fixed without verification output.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Investigated and fixed a bug") recording the root cause, files changed and how it was verified.
