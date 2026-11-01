# Portable Skills Pack

Twenty-three reusable agent skills, written to work on any codebase. Everything that is specific to one system (environments, ports, branch names, commit tags, database rules, accounts) lives in one file, the **project profile**, which every skill reads. Fill it in once per project; the skills need no other edits.

How to install and adapt the pack: see `INSTRUCTIONS.md`. The files themselves live in `../pack/.claude/`.

## Build and fix

| Skill | Purpose |
|---|---|
| `mockup-analyzer` | Analyse a mockup or screenshot before building |
| `feature-enhancer` | Plan and build features without breaking behavior |
| `bug-finder` | Evidence-based root-cause analysis and fix |
| `known-issues` | Knowledge base of recurring bugs and proven fixes |
| `business-rules` | Register of confirmed rules that must not change silently |
| `db-access` | Safe database navigation across environments (+ helper script and example config) |
| `checkin-merge` | Stage, commit, push, cherry-pick by convention |
| `vibecode-practices` | Binding standards for the Supabase, Render, Vercel, Clerk and Stripe stack: database and security rules, pre-merge self-check (+ reference checklists) |

## Test

| Skill | Purpose |
|---|---|
| `test-on-dev` | Bring up a fresh local stack |
| `browser-setup` | Shared Playwright setup, evidence capture and accounts (+ `helpers.mjs`) |
| `browser-qa` | Run a handover test document in a real browser (+ handover template) |
| `browser-dev` | Check a new feature against its requirements |
| `browser-bug` | Check whether a bug is fixed |

## Usability (used by the `naive-user` agent)

| Skill | Purpose |
|---|---|
| `persona-library` | Ready-made user personas with patience limits and habits; how to write project personas |
| `user-goals` | Turn a feature into outcome-only goals that give no interface hints |
| `first-impression-test` | Five-second screen test and navigation label guess |
| `ux-heuristics` | Shared friction types, severity scale and repeatable ease score |
| `copy-and-error-review` | Rate labels, errors and empty states; find inconsistent terms |
| `accessibility-lens` | Keyboard-only, zoom and contrast runs against WCAG 2.2 AA |
| `mobile-user` | Phone viewport, touch and slow connection run |
| `friction-trends` | Save runs to a history and compare over time (+ `trend.py`) |

## Knowledge

| Skill | Purpose |
|---|---|
| `module-qa` | Verified Q&A per module for agents, users and the team |
| `work-log` | Timestamped log of each task and the skills used |

The project profile (`project-profile.md`) is the one file you fill in per project.

Agents that orchestrate these skills are described in `AGENTS.md`.
