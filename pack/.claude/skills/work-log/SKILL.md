---
name: work-log
description: Write a short, timestamped summary of what was done into the logs folder when a task that used one of the team skills is finished. Each of the other skills ends by applying this one. Lists the skills used and what each was used for.
---

# Work log

Every task that uses one of the team skills ends with a log entry, so the user can see afterwards what was done, when, and which skills were used for what.

## Where
The logs folder from `.claude/project-profile.md` (default `.claude/logs/`). The folder is git-ignored: logs stay on the machine and are never committed. Create it if missing.

## File name
`YYYY-MM-DD_HHmmss_<primary-skill>.md`, using the local time the task started. Take the stamp from the system clock (`date +"%Y-%m-%d_%H%M%S"`), not from memory. Example: `2026-01-01_143005_browser-qa.md`.

## One file per task
A task is one user request and the work it triggers. If several skills are used in the same task (for example browser-qa calling test-on-dev), they share one file: the first skill to finish writes it and later skills add their rows. Name the file after the main skill, the one the user called. A new request starts a new file.

## Content
Under about 40 lines, plain language, no secrets.

```markdown
# <Short title of the task>

- **Date / time:** 2026-01-01 14:30 (<timezone>)   **Duration:** about <n> min
- **Branch:** <current branch>   **Environment:** <local dev | staging | ...>
- **Request:** <one line: what the user asked for>

## Skills used
| Skill | Used for | Outcome |
|---|---|---|
| browser-qa | Ran the handover test for <feature> | 12 passed, 1 failed, 1 blocked |
| test-on-dev | Started a fresh local stack | Up |

## What was done
- <the actions, in order, one short line each>

## Result
- <the outcome and evidence: counts, report path, commit SHAs, URLs>

## Changes and side effects
- **Files / commits:** <files changed, commit SHAs, branches pushed, or none>
- **Database:** <scripts prepared or run and where, test data created, or none>
- **Left behind:** <test data, files, running processes, or none>

## Open items
- <what still needs a decision or follow-up, or none>
```

Per skill, also record:
- **browser-qa:** summary counts, report path, failed case ids.
- **browser-dev:** the feature, counts of met, partly met, not met and cannot verify, not-met ids, report path.
- **browser-bug:** bug ids with verdicts, regressions found, missing preconditions, report path.
- **checkin-merge:** each branch with commit SHA, subject and whether it was pushed; database scripts prepared or run.
- **test-on-dev:** what was stale and cleared, and the final state of each piece.
- **db-access:** the environment, what was read or run, any script and its result, differences between environments.
- **feature-enhancer / bug-finder:** the goal or root cause, files changed, how it was verified.
- **module-qa:** the module, the Q&A file path, entry counts per audience and per check type.
- **mockup-analyzer:** the screen analysed, gaps and questions raised.
- **known-issues / business-rules:** entries added, updated or matched.

Never put passwords, tokens, connection strings or secrets in a log, and no personal data; use ids and test names.

## Reply
After writing the file, mention its path in the final message in one line. Do not repeat the log's contents.

## Don'ts
- Don't write a log for a task that used none of the team skills, unless asked.
- Don't commit or push the logs folder.
- Don't overwrite an earlier log; each task gets its own file.
- Don't invent results: record only what was done and observed.
