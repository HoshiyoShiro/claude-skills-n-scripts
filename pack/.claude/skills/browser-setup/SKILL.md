---
name: browser-setup
description: Shared real-browser tooling for every skill that drives the app with Playwright (browser-qa, browser-dev, browser-bug, naive-user and the UX skills). Sets up a scratch folder outside the repository, launches headed browsers per user or device, captures console, network and screenshot evidence, and reads test accounts safely. Use whenever a skill says to set up the browser.
---

# Browser setup

One place for the browser mechanics so the QA and UX skills only describe what to test. Reads `.claude/project-profile.md` for URLs, the test prefix and the accounts file path.

## Rules
- Everything lives in a scratch folder, never in the repository, and is never committed.
- Development environment only, unless the user names another in the request.
- Credentials come from the accounts file, are passed through environment variables, and are never printed, logged or written into scripts or reports.
- Report what the browser showed; do not fix code from here.

## Scratch layout
```
<scratch>/qa/                          package.json, node_modules, helpers.mjs, run scripts
<scratch>/qa/results/<date-time>/      screenshots, traces, report files
```

## Install (once)
- `npm init -y`, then `npm i playwright@<pinned version>`. Pin the version you tested with.
- If launching fails for a missing browser: `npx playwright install chromium`, or use an installed Chrome with `channel: 'chrome'`. In managed environments that ship a browser, point `executablePath` at it and do not download another.
- Copy `helpers.mjs` from this skill's folder into `<scratch>/qa/`.

## Launch
- **Headed** with `slowMo` about 150 ms so a person can watch; headless only if asked.
- One fresh context per user or device. `ignoreHTTPSErrors: true` for self-signed development certificates.
- Desktop: 1440x900. Phone: 390x844 with `isMobile` and `hasTouch` (see `mobile-user`). Other devices from Playwright's built-in device list.
- `helpers.mjs` exposes `launch(opts)`, `attachEvidence(page, log)` and `shot(page, dir, name)`.

## Evidence per page
Record console errors, uncaught page errors, responses with status 400 or above (method, URL, status), and a screenshot at each meaningful step and at every failure. `attachEvidence` does the first three.

## Accounts
Login accounts are in `.claude/skills/browser-qa/accounts.local.json` (git-ignored). Read it at run time; never print it.

```json
{
  "environment": "local dev",
  "accounts": [
    { "role": "<role name>", "username": "<user>", "password": "<password>", "extraLoginFields": { "<field>": "<value>" } }
  ]
}
```

## Data safety
- Name anything you create with the profile's test prefix and list what was left behind.
- Do not delete, edit or disable existing records unless the task requires it, and then only the ones it names.
- Anything that sends a real message outside the system needs the user's go-ahead in this session.

## Don'ts
- Don't put Playwright, scripts or results in the repository.
- Don't use fixed sleeps when an auto-waiting check will do.
- Don't print or save credentials.
