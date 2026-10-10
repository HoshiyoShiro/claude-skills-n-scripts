# Portable Skills Pack

Fourteen reusable agent skills, written to work on any codebase. Everything that is specific to one system (environments, ports, branch names, commit tags, database rules, accounts) lives in one file, the **project profile**, which every skill reads. Fill in the profile once per project; the skills need no other edits.

How to install and adapt the pack: see `INSTRUCTIONS.md`. The files themselves live in `../pack/.claude/`.

| # | Item | Location (under `pack/.claude/`) | Purpose |
|---|---|---|---|
| 1 | project profile | `project-profile.md` | The one file you fill in per project |
| 2 | `mockup-analyzer` | `skills/mockup-analyzer/` | Analyse a mockup or screenshot before building |
| 3 | `known-issues` | `skills/known-issues/` | Knowledge base of recurring bugs and proven fixes |
| 4 | `feature-enhancer` | `skills/feature-enhancer/` | Plan and build features without breaking behavior |
| 5 | `bug-finder` | `skills/bug-finder/` | Evidence-based root-cause analysis and fix |
| 6 | `business-rules` | `skills/business-rules/` | Register of confirmed rules that must not change silently |
| 7 | `checkin-merge` | `skills/checkin-merge/` | Stage, commit, push, cherry-pick by convention |
| 8 | `test-on-dev` | `skills/test-on-dev/` | Bring up a fresh local stack |
| 9 | `browser-qa` | `skills/browser-qa/` | Run a handover test document in a real browser (+ handover template) |
| 10 | `browser-dev` | `skills/browser-dev/` | Check a new feature against its requirements |
| 11 | `browser-bug` | `skills/browser-bug/` | Check whether a bug is fixed |
| 12 | `db-access` | `skills/db-access/` | Safe database navigation across environments (+ helper script and example config) |
| 13 | `module-qa` | `skills/module-qa/` | Verified Q&A per module for agents, users and the team |
| 14 | `work-log` | `skills/work-log/` | Timestamped log of each task and the skills used |

Agents that orchestrate these skills are described in `AGENTS.md`.
