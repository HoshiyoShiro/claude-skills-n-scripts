# Portable Agents Pack

Five reusable agent definitions that work with the portable skills pack (see `../pack/.claude/skills/`). They contain no project-specific facts: everything specific (branch names, commit format, architecture rules, shared-code list, environments) is read from `.claude/project-profile.md` and the project's own instructions file (for example CLAUDE.md or AGENTS.md).

The files (in `../pack/.claude/agents/`) use the Claude Code sub-agent format: a markdown file with a frontmatter block (`name`, `description`, `tools`, `skills`) and the agent's instructions as the body. For other tools see `INSTRUCTIONS.md`, section "Using the agents in other tools".

| Agent | Role | Writes code | Skills it uses |
|---|---|---|---|
| `master` | Orchestrator: routes, gates, commits, reports. Run as the main session agent. | No | checkin-merge, business-rules, persona-library, user-goals, friction-trends, work-log |
| `software-engineer` | Builds and enhances features, plan first | Yes | mockup-analyzer, feature-enhancer, business-rules, known-issues, db-access, module-qa |
| `bug-hunter` | Root cause, fix, verify | Yes | known-issues, bug-finder, business-rules, db-access, test-on-dev |
| `qa-tester` | Tests in a real browser, returns verdicts | No (reports only) | test-on-dev, browser-setup, browser-qa, browser-dev, browser-bug, business-rules, db-access, module-qa |
| `naive-user` | Plays a clueless first-time user through the real UI and reports where it was confusing; never reads code or docs | No (reports only) | test-on-dev, browser-setup, persona-library, user-goals, first-impression-test, ux-heuristics, copy-and-error-review, accessibility-lens, mobile-user, friction-trends, work-log |

Add project-specific skills (design system, framework patterns, user simulation) to the `skills:` list of the agent that needs them.

## The naive-user loop

```
master: pick persona (persona-library) + write goals (user-goals)
  -> naive-user: first impression, run goals, score, save history (friction-trends)
  -> master: triage findings with the user
  -> software-engineer (UI, wording, flow) or bug-hunter (broken behavior)
  -> naive-user: same persona and goals again -> trend: better, same or worse
```

The naive-user agent never receives source paths, requirements, Q&A, business rules or the product's intended purpose before its first look. That is what keeps it clueless.
