---
name: browser-bug
description: Check in a real browser whether a reported bug is actually fixed. Use when the user says browser bug, is the bug fixed, or verify the fix, or hands over a bug report or bug handover to confirm after a fix. Re-runs the original steps, checks neighbouring cases and regressions, and returns a verdict per bug (fixed, not fixed, partly fixed, cannot verify). Does not fix code.
---

# Browser bug: is it really fixed?

A fix is only done when the original failure no longer happens, nothing near it broke, and the evidence is on record. Use the same browser setup, safety and data rules as `browser-qa`; this file covers what differs.

## Rules
- **The report defines fixed.** The symptom, exact steps and expected behavior come from the bug report, not from the fix. Different behavior that looks fine is not a pass unless it matches the expected result.
- **Evidence for every verdict:** screenshot, the text or value seen, the status and error text of the failing call, the console output.
- **Report, do not fix.** If not fixed, say so and offer `bug-finder`.
- **Do not guess.** Missing steps, an unclear expected result, or missing data or an account: ask, or mark `cannot verify` with the reason.
- **Development environment only** unless the user names another. Name test data with the profile's prefix. No real outbound messages without the user's go-ahead. No secrets in output.

## 1. Read the bug report
Get the report (a handover file, a ticket, pasted text or the user's description). For each bug write down and show back:

| Field | Content |
|---|---|
| Bug id | the report's id, or BUG-1, and so on |
| Symptom | what the user saw, with the exact message or status code |
| Steps | what triggered it, with role, data and page |
| Expected | what should happen |
| Claimed cause and fix | what changed and where (background only) |
| Fix type | code, database script, configuration, or test data or test change |
| Not a defect | items the report says are test-environment problems; do not test them as bugs |

Note what must be in place for the fix to show: the build or branch, database scripts that must be applied, services that must run. A fix waiting on a script is not fixed.

## 2. Prepare
Bring up the stack fresh with `test-on-dev`; confirm the branch and the fix are in the running build, not an older one. For a database fix, confirm the script is applied in the environment under test with `db-access` (read-only: `compare`, `params`, `columns`); report any gap; running a script is a separate decision that needs the user's go-ahead. Apply the `browser-qa` tooling setup. Use the project's simulation skill when the steps need an end user.

## 3. Verify each bug
1. **Original steps, exactly as reported,** same role and data. Capture the result.
2. **Compare with the expected result.** The failing call must now succeed (status and response), the error text must be gone, the right outcome must show.
3. **Neighbouring cases**, chosen from the cause: other roles and scopes; other types or channels when the bug was in a shared component (a 500 on three types: test all three, and the ones that already worked); boundary and empty cases; after a reload.
4. **Regressions around the change:** screens and flows sharing the changed code, and what business rules say must stay the same. A few quick passes, not a full run.
5. **Verdict:**
   - **Fixed:** original steps give the expected result, neighbours pass, no regression.
   - **Partly fixed:** original steps pass but a neighbouring case or variant still fails; say which.
   - **Not fixed:** the symptom still appears (retry once to rule out stale state, an old build or timing).
   - **Cannot verify:** a precondition is missing (script not applied, no test account, no test contact) or the expected result is unclear.
   - **New problem:** the fix works but something else broke; list it as a new finding with steps.

Items the report calls not a defect are listed under not tested, and why, not run as bugs.

## 4. Report
Save the full report as `<scratch>/qa/results/<date-time>/browser-bug-report.md` and give:

```
Bug verification   Branch: <branch>   Env: local dev   Date: <date time>
Bugs: <n> total: <f> fixed, <p> partly fixed, <x> not fixed, <c> cannot verify

| Bug | Symptom (short) | Verdict | Evidence |
|-----|-----------------|---------|----------|
| <id> | <symptom> | Fixed | <call> now 200, screenshot path |
| <id> | <symptom> | Not fixed | <what still happens>, screenshot path |

Details for each bug not fully fixed
- <bug>: steps, expected, observed, status and error text, console, screenshot

Neighbouring cases and regressions checked
- <list with result>

Not tested, and why
- <bug or case>: <reason>

New problems found
- <steps and evidence, or none>

Left behind in dev: <test data created and not removed | none>
```

Close with the verdict and one offer: hand open bugs to `bug-finder`, or re-run after the next fix. For a confirmed fix with a known cause, offer to record it in `known-issues`.

## Don'ts
- Don't call a bug fixed because the page loads; compare to the expected result.
- Don't test only the exact steps; check what the cause implies.
- Don't test the not-a-defect items as bugs.
- Don't fix code, run database scripts or change existing data unasked.
- Don't run against shared or production environments unless asked.
- Don't print or save credentials.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Verified in the browser whether reported bugs are fixed") recording bug ids with verdicts, regressions found, missing preconditions and the report path.
