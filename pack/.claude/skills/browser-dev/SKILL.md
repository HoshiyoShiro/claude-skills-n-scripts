---
name: browser-dev
description: Check in a real browser that a newly added feature meets its requirements. Use when the user says browser dev, check the feature against the requirements, or does this follow the requirements, or after a feature is built and needs confirming against a requirements list, plan, business rules or mockup. Produces a requirement-by-requirement checklist (met, partly met, not met, cannot verify). Does not fix code.
---

# Browser dev: does the feature meet its requirements?

`browser-qa` runs a list of test cases. This skill starts from the **requirements** and checks each one in the browser, so the question is the feature right is traceable. Use the same browser setup, safety and data rules as `browser-qa`; this file covers what differs.

## Rules
- **The requirements are the spec.** Judge the feature against them, not against what the code happens to do. A requirement the build does differently is `not met`.
- **Evidence for every verdict:** a screenshot, the text or value seen, and for failures the console errors and failed API calls.
- **Do not guess.** A vague requirement or two possible readings: ask, or mark `cannot verify` and say why.
- **Do not fix.** Report; offer `bug-finder` for what is not met.
- **Development environment only** unless the user names another and gives its address. Name test data with the profile's prefix; do only what the requirements need. No real outbound messages without the user's go-ahead. No secrets in output; logins come from `browser-qa/accounts.local.json` through environment variables.

## 1. Gather the requirements
From whatever exists, and show the list back in a few lines before testing: the user's request in this conversation; the plan, spec or handover document; the registered business rules touching the feature (`business-rules`); a mockup, if given (apply `mockup-analyzer` to turn it into requirements); the diff or commit messages only to know what was built and where, never as the source of what was required.

Turn each into a **numbered requirement** (`REQ-1`, `REQ-2`, and so on): one testable statement with its source. Split compound statements; keep the author's words; mark what is in scope for this build. If the handover has test cases, keep their ids next to the requirement they cover. Ask only for what is missing: roles, test data, environment, whether real outbound messages are allowed.

## 2. Prepare
Bring up the stack fresh with `test-on-dev` and confirm the checked-out branch holds the feature. Apply the `browser-qa` tooling setup. For cases needing a simulated end user, use the project's simulation skill (profile). Check database-backed requirements (what is saved, scoping) read-only with `db-access`.

## 3. Check each requirement
For every requirement, in order:
1. Decide how to observe it: page, role, data. Several requirements can share a session.
2. Do it in the browser as a user would; find elements by visible text, labels and roles.
3. Compare with the requirement's exact wording (text, count, order, state, who sees it, what is saved).
4. Verdict:
   - **Met:** observed and matches.
   - **Partly met:** some holds; say which part is missing or different.
   - **Not met:** observed and differs, or absent (retry once to rule out timing or script error).
   - **Cannot verify:** needs data, an account or a service that is not available, or the requirement is unclear; give the reason.
5. Also check what the requirement implies: **roles and scopes** (what a lower role or another tenant sees versus what is stated); **states** (empty, loading, error, long text, many items); **persistence** (reload and confirm the change is still there); **no regression next to it** where a requirement or rule says the neighbouring screen must stay as before; **mockup fidelity** when a mockup was given (layout, labels, order, states side by side).

Keep a list of things no requirement covers (not in the requirements): extra behavior, rough edges, console errors elsewhere.

## 4. Report
Save the full report as `<scratch>/qa/results/<date-time>/browser-dev-report.md` and give the checklist:

```
Feature: <name>   Branch: <branch>   Env: local dev   Date: <date time>
Requirements: <n> total: <m> met, <p> partly met, <x> not met, <c> cannot verify

| REQ | Requirement (short) | Source | Verdict | Evidence |
|-----|---------------------|--------|---------|----------|
| REQ-1 | <statement> | handover section 5 / rule id / mockup | Met | <what was seen>, screenshot path |
| REQ-2 | ... | ... | Not met | expected <x>, saw <y>, screenshot path |

Not met or partly met
- REQ-2: what it says, what the build does, steps to see it, console and API errors.

Cannot verify
- REQ-5: <reason and what would unblock it>

Not in the requirements
- <extras and rough edges>

Left behind in dev: <test data created and not removed | none>
```

Close with the verdict and one offer: hand the gaps to `bug-finder` or `feature-enhancer`, or re-run after changes.

## Don'ts
- Don't add, drop or reword requirements to make them pass.
- Don't call something met without comparing to the exact wording; it loads is not it works.
- Don't fix code or change existing data beyond what a requirement needs.
- Don't run against shared or production environments unless asked.
- Don't print or save credentials.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Checked a feature against its requirements in the browser") recording counts of met, partly met, not met and cannot verify, the not-met ids and the report path.
