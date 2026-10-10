---
name: browser-qa
description: Test a proposed feature in a real browser against the local dev stack, following a handover test document, and report a pass/fail checklist. Use when the user says browser qa, qa test, test this in the browser, or hands over a test document or test cases to verify. Drives the app with Playwright, collects screenshots and console and network evidence, and does not fix code.
---

# Browser QA

The user hands over a test document. Run it in a real browser against the dev code, follow it literally, and return a checklist of results with evidence.

## Rules
- **The handover document is the spec.** Test what it says, in its order, with its data and expected results. Do not invent cases. Anything extra goes in an Also noticed list, not the checklist.
- **Report, do not fix.** A failure is a result, not a task. Offer `bug-finder` afterwards.
- **Evidence for every result:** a screenshot, the text or value observed, and for failures the console errors and failed API calls.
- **Never guess.** Missing data, an unclear step or an ambiguous expected result: ask first in one numbered list, or mark the case `BLOCKED` with the reason.
- **No secrets in output.** Never print or store passwords or tokens in files, the checklist or scripts left on disk. Take credentials from the accounts file and pass them through environment variables.

## 1. Read the handover
Get the document (a path, pasted text or a link). Extract and show back in a few lines: the feature and the branch or build it should run on; the environment, accounts or roles and test data; each case (id, preconditions, steps, expected result); what is out of scope. The document should follow `HANDOVER_TEMPLATE.md` in this folder.

Login accounts are in `.claude/skills/browser-qa/accounts.local.json` (git-ignored; format below). Read it at run time, pass values through environment variables, never print or copy them. Ask only for what is missing: another role, test data, which branch is checked out, whether real outbound messages (email, SMS, chat channels) may be sent.

Do not start until the document is clear enough to run.

## 2. Bring up the stack fresh
Apply `test-on-dev`. Confirm the checked-out branch matches the handover and that the stack runs the current code, not an old build. Use the development environment only; never a shared or production one unless the user says so in this request.

## 3. Set up the browser tooling (outside the repository)
Keep everything in a temporary or scratch folder, never in the repo:

```
<scratch>/qa/                          package.json, node_modules, run scripts
<scratch>/qa/results/<date-time>/      screenshots, traces, report.md
```

- Install once: `npm init -y` then `npm i playwright` (pin a version). Run `npx playwright install chromium` if launching fails for a missing browser; fall back to an installed Chrome with `channel: 'chrome'`.
- Launch **headed** so the user can watch, with a small `slowMo` (about 150 ms); headless only if asked.
- One fresh browser context per user, `ignoreHTTPSErrors: true` for self-signed development certificates, a 1440x900 viewport.
- Write a Node script with one function per case, so one failure does not stop the rest.
- Per case record: console errors, uncaught page errors, API responses with status 400 or above (method, URL, status), a screenshot at the end and at each meaningful step.

`accounts.local.json` format:

```json
{
  "environment": "local dev",
  "accounts": [
    { "role": "<role name>", "username": "<user>", "password": "<password>", "extraLoginFields": { "<field>": "<value>" } }
  ]
}
```

## 4. Run the cases
For each case, in the document's order:
1. Check preconditions; set them up through the UI when the document says how; if impossible mark `BLOCKED`.
2. Perform the steps as written. Find elements by visible text, labels and roles, not brittle CSS paths. Wait for the UI (auto-waiting assertions), not fixed sleeps.
3. Compare the actual result with the document's expected result, on the exact thing it names (text, count, order, state, URL), not only that something loaded.
4. Result:
   - `PASS`: matches.
   - `FAIL`: differs, and a second attempt gives the same result.
   - `BLOCKED`: could not run (missing data, a prior case failed and this depends on it, environment problem).
   - `SKIPPED`: out of scope, or the user said to skip it.
5. A first failure gets one retry; a retry that passes is `PASS` with a flaky note. Before calling a failure a product bug, make sure it is not your script (locator, timing); look at the screenshot.

### Cases that need a simulated user
If a case needs an end user who arrives through a channel you cannot log into (chat widget, messaging app, email), use the project's user-simulation skill or script named in the profile. If there is none, mark the case `BLOCKED` with that reason.

### Data safety
- Dev data may be shared. Do only what the document requires. Name anything you create with the profile's test prefix. Do not delete, edit or disable existing records unless the document requires it, and then only the ones it names. Clean up what you created when told to; otherwise list what was left.
- Anything that sends a real message outside the system needs the user's go-ahead in this session; without it mark the case `BLOCKED` because it would send a real message.

## 5. Report
Save the full result as `<scratch>/qa/results/<date-time>/report.md` and give the checklist in the reply:

```
QA result: <feature>   Branch: <branch>   Env: local dev   Date: <date time>
Summary: <n> cases: <p> passed, <f> failed, <b> blocked, <s> skipped

| # | Case | Result | Evidence |
|---|------|--------|----------|
| TC-01 | <name from the document> | PASS | <what was observed>, screenshot path |
| TC-02 | ... | FAIL | expected <x>, got <y>, screenshot path |

Failures
- TC-02: steps to reproduce, expected versus actual, console errors, failed API calls (method URL status), screenshot path.

Blocked / skipped
- TC-05: <reason>

Also noticed (not in the document)
- <console errors elsewhere, visual glitches, anything odd>

Left behind in dev: <records created and not cleaned up | none>
```

Use the document's own ids and names. Close with the verdict and one offer: hand failures to `bug-finder`, or re-run failed cases after a fix.

## Don'ts
- Don't add, reorder or reinterpret test cases. Don't fix code during QA.
- Don't run against shared or production environments unless asked.
- Don't put Playwright, scripts or results in the repository, and don't commit them.
- Don't print or save credentials.
- Don't call a case `PASS` without comparing against its expected result.
- Don't leave test data behind without listing it.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Ran a browser QA test from a handover document") recording pass, fail, blocked and skipped counts, failed case ids and the report path.
