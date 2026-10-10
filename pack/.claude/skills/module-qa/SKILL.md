---
name: module-qa
description: Write and maintain a Q&A for a module so agents, end users and the team can quickly get answers about it. Use after a module is implemented, or when the user asks for a Q&A for a module, asks to test the module and give a Q&A, asks to update the Q&A, or when someone asks how a module works and the answer should come from the saved Q&A first. Answers are checked against the code and, when asked, a test run, and saved under the Q&A folder.
---

# Module Q&A

A short, trustworthy list of questions and answers per module, so when someone asks how does this work, the answer is already written, verified and easy to find.

## Rules
- **True before pretty.** Every answer is backed by the code, a test result or a confirmed business rule. Where behavior is unclear, ask; do not guess.
- **Say how each answer was checked:** `tested` (run in the app, with the date), `code` (read from the code, with the file), `rule` (a registered business rule, with its id), or `to confirm` (needs an owner's answer). Keep `to confirm` answers out of the end-user list until confirmed.
- **Ask the way people ask.** Use the words an agent, user or teammate would use, and the exact labels, buttons and messages from the screen, in bold.
- **Short answers.** The direct answer first, then steps if needed; about five lines at most; link to details.
- **Right audience, right language.** Tag each entry with an audience from the profile (typically staff, end user, team). Staff and end-user answers are plain and non-technical, never mention tables, endpoints or code. Team answers may be technical.
- **No secrets or personal data:** no passwords, tokens, connection strings, real names or contact details. Use test names and ids.
- **Do not restate business rules.** Link the rule id and quote it once; if the code and a locked rule disagree, flag it to the user.

## Where it lives
`<Q&A folder from the profile>/<module-slug>.md`, one file per module, plus an index `README.md` listing every module, its last update date and entry counts per audience. Tracked in git. Create the folder and index if missing.

## Mode A: create or update a module's Q&A
1. **Pin down the module:** name, branch, what is in it (screens, endpoints, jobs, permissions). If not stated, infer from recent changes and confirm in one line.
2. **Collect the facts, in this order:** the handover or test document; the module's code (UI labels and messages, validation, permission checks, limits); the business-rules register; recent commits; earlier QA reports or work logs. Read the existing Q&A so you update rather than duplicate.
3. **Test it when asked.** If the user says to test the module: bring the stack up with `test-on-dev`, drive it in the browser as in `browser-qa`, use the simulation skill when an end user is needed, and record the exact wording of what the screen shows. Development data only; no code fixes. Without that instruction answers come from the code and are marked `code`.
4. **Draft the entries** from the checklist below and check each answer against its source.
5. **Write the file and update the index.** Replace outdated entries; one entry per question.
6. **Report** in a few lines: module, entries per audience, how many are `tested`, `code`, `rule`, `to confirm`, and questions needing an owner.

### What to cover (an entry for each item that applies)
What it is for and who uses it; who can use it (roles, scopes, permissions, what a lower role cannot do); how to do each main task (numbered steps with exact labels); what each control, filter, status, badge, toggle and column means; what happens after each action (what is saved, where it shows, what else changes); rules and limits (caps, ordering, defaults, time zones, retention) with rule ids; each error or warning message, what it means and how to fix it; differences per channel or variant and what is not supported; things people may expect that are not supported yet; known issues and workarounds; what changed from the previous behavior; who to ask.

## File format

```markdown
# <Module name> Q&A

Branch: <branch>   Last updated: <yyyy-mm-dd>   Last tested: <yyyy-mm-dd | not tested>
Scope: <one line>   Related business rules: <ids or none>

## <Audience 1>

### Q: How do I <task>?
**A:** <short answer, then numbered steps with the exact labels in bold.>
- Checked: tested 2026-01-01 | Source: `path/to/file` | Rule: <id>
- Related: <other question titles>

## <Audience 2>
### Q: ...
```

Group by audience, then by theme (getting started, daily use, limits, problems). Most asked first.

## Mode B: answer a question from the Q&A
1. Search the Q&A folder for the module and question, matching meaning, not only words.
2. Answer from the entry in the style of its audience and say when it was last checked. Do not rewrite the facts.
3. If the entry is missing, answer from the code or a quick test, say it was not in the Q&A, and offer to add it.
4. If the entry looks out of date against the code, say so and offer to update it.

## Keeping it current
When a module changes, list the entries it affects, update or remove them, and set `Last updated`. Do not leave a wrong answer.

## Don'ts
- Don't answer from memory or assumption.
- Don't put developer terms in staff or end-user answers.
- Don't include secrets, real personal data or internal ids.
- Don't copy the whole business-rules register or code into the Q&A.
- Don't leave `to confirm` items in the end-user list.
- Don't fix code or change data while writing the Q&A.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Wrote or updated a module Q&A, or answered from it") recording the module, the file path, entry counts per audience and per check type, and the questions left for an owner.
