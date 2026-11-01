# claude-skills-n-scripts

A portable pack of Claude agent **skills** and **agents** that work on any codebase. Everything specific to one project (environments, ports, branch names, commit tags, database rules, accounts) lives in a single file, the **project profile**. Fill it in once per project; the skills need no other edits.

## Layout

```
pack/.claude/
  project-profile.md        the one file you fill in per project
  skills/                   23 skills (one folder each, SKILL.md inside)
  agents/                   master, software-engineer, bug-hunter, qa-tester, naive-user
docs/
  INSTRUCTIONS.md           install, set up, adapt, troubleshoot
  SKILLS.md                 overview of the 23 skills
  AGENTS.md                 overview of the 5 agents
install_skills.py           copies the pack into a project
validate_pack.py            checks the pack's structure and cross-references
```

## Skills (23)

| Group | Skills |
|---|---|
| Build and fix | `mockup-analyzer`, `feature-enhancer`, `bug-finder`, `known-issues`, `business-rules`, `db-access`, `checkin-merge`, `vibecode-practices` |
| Test | `test-on-dev`, `browser-setup`, `browser-qa`, `browser-dev`, `browser-bug` |
| Usability | `persona-library`, `user-goals`, `first-impression-test`, `ux-heuristics`, `copy-and-error-review`, `accessibility-lens`, `mobile-user`, `friction-trends` |
| Knowledge | `module-qa`, `work-log` |

Details of each are in [`docs/SKILLS.md`](docs/SKILLS.md).

## Agents (5)

`master` (orchestrator), `software-engineer`, `bug-hunter`, `qa-tester`, and `naive-user`, a deliberately clueless first-time user that finds out whether the product can be used without help. See [`docs/AGENTS.md`](docs/AGENTS.md).

## Quick start

```bash
python install_skills.py /path/to/your/project
```

Then edit `.claude/project-profile.md` in that project and restart your assistant session. Full steps are in [`docs/INSTRUCTIONS.md`](docs/INSTRUCTIONS.md).

Useful flags: `--only name1,name2` (install some skills), `--no-agents`, `--force` (overwrite).

## Contributing

Ideas and improvements are welcome. Open an issue or submit a pull request.
