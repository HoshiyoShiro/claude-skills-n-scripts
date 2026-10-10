---
name: feature-enhancer
description: Plan and implement new features or enhancements to existing code. Use whenever the user asks to add, extend, improve, modify or refactor a feature, change existing behavior, add an option, field, endpoint or screen, or says "enhance", "upgrade", "add support for" or "make it also do X" in an existing codebase.
---

# Feature Enhancer

Reads `.claude/project-profile.md` for the stack, build commands and database rules.

## Rules
- Be concise. Read existing code before writing new code; follow its patterns, naming and style.
- Smallest change that fully meets the requirement. No unrelated refactors.
- Never break existing behavior. Stay backward compatible unless the user says otherwise.
- If a requirement is unclear or missing, ask first. Never guess requirements.
- Use the database for clues when access exists (read-only; see `db-access`).
- Before designing, apply `business-rules` (Mode B): list the registered rules the change touches and keep them unchanged unless the user explicitly approves a change.
- If a mockup or design image is provided, apply `mockup-analyzer` first and use its report as the requirements.
- Follow the profile's database rules for any schema or data-access change.
- Anything that is hard to reverse or affects shared systems (schema changes on shared environments, breaking API changes, large refactors) needs the user's approval first.

## Clarify first (mandatory when requirements are missing)
Goal and users; the exact new behavior with an example (input, expected output); what stays the same; acceptance criteria; what is explicitly out of scope; data changes (new fields or tables, migration, backfill); UI/UX (screens, labels, validation, messages); permissions and roles; edge cases (empty, duplicate, large volume, concurrent use); constraints (deadline, performance, libraries, compliance); compatibility (can contracts change, feature flag or rollout plan); integrations (other systems, notifications, reports, exports).

Ask in one numbered list, short, with options and a recommended default. Wait for answers. Proceed on stated assumptions only if the user says to.

## Database clues (read-only)
Use `db-access` when a connection exists; otherwise ask the user to run the queries and paste results. Read only; limit rows; redact personal data and secrets. Look at: schema, indexes and constraints of the feature's entities; sample rows for real data shape and status values; lookup and configuration tables that drive behavior; relationships and cascades; row counts and distributions to size migrations; migration history and naming conventions. Record each finding as: query, result, impact on the design.

## Workflow
1. **Understand the request.** Restate in one or two lines what changes, for whom and why. Write testable acceptance criteria and the out-of-scope list.
2. **Study the existing feature.** Entry points (routes, components, handlers, jobs); the full flow from input to storage to output; data models, contracts, configuration, permissions, tests, docs; conventions for errors, logging, naming and layout; history of related changes.
3. **Assess impact.** Callers of anything you change; public contracts (API, schema, events); compatibility, migrations, flags, defaults; security (auth, validation, data exposure); performance (queries, loops, payloads, caching); risk low, medium or high.
4. **Design briefly.** Simplest approach that fits the architecture; extend rather than rewrite. If there are options, compare in two or three lines each and recommend one. List the changes per layer (data, backend, frontend, configuration, tests and docs). High risk: use a flag and plan the rollback.
5. **Plan the steps.** Small, ordered, individually testable: tests that describe the behavior; schema change with migration; core logic; API and UI wiring; edge cases and errors; docs.
6. **Implement.** One step at a time, small diffs. Reuse helpers and components. Validate inputs, handle errors, log consistently. No hard-coded secrets, paths or magic values. Comment only the why.
7. **Verify.** New and existing tests pass; happy path, edge cases, permissions and failure paths; old behavior unchanged where it should be; lint, type-check and build per the profile; a manual run of the flow when tests cannot cover it. For UI work, `browser-dev` can check it against the requirements.
8. **Report.**

```
Goal:          <one line>
Changes:       <files/modules and what changed>
Design note:   <key decision and why>
Compatibility: <breaking? migration? flag?>
Verification:  <tests run, results>
Risks:         <what could go wrong, rollback plan>
Follow-ups:    <optional next improvements>
```

## Quality checklist
- [ ] Meets every acceptance criterion
- [ ] Matches existing style and architecture
- [ ] Backward compatible, or the break is called out
- [ ] Inputs validated, errors handled, no sensitive data leaked
- [ ] Tests added or updated
- [ ] No N+1 queries, unbounded loops or heavy work on hot paths
- [ ] Migration safe and reversible
- [ ] Docs and configuration examples updated
- [ ] No dead code, debug logging or TODOs left behind

## Don'ts
- Don't start coding before reading the existing implementation.
- Don't change public contracts silently.
- Don't bundle unrelated cleanups.
- Don't add dependencies when the existing stack can do it.
- Don't claim "done" without verification output.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Planned and implemented a feature or enhancement") recording the goal, files changed and how it was verified.
