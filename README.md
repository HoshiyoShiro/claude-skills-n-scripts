# claude-skills-n-scripts

A portable pack of Claude agent **skills** and **agents** that work on any codebase. Everything specific to one project (environments, ports, branch names, commit tags, database rules, accounts) lives in a single file, the **project profile**. Fill it in once per project; the skills need no other edits.

## Layout

```
pack/.claude/
  project-profile.md        the one file you fill in per project
  skills/                   14 skills (one folder each, SKILL.md inside)
  agents/                   master, software-engineer, bug-hunter, qa-tester
docs/
  INSTRUCTIONS.md           install, set up, adapt, troubleshoot
  SKILLS.md                 overview of the 14 skills
  AGENTS.md                 overview of the 4 agents
install_skills.py           copies the pack into a project
```

## Skills

| Skill | Purpose |
|---|---|
| `mockup-analyzer` | Analyse a mockup or screenshot before building |
| `known-issues` | Knowledge base of recurring bugs and proven fixes |
| `feature-enhancer` | Plan and build features without breaking behavior |
| `bug-finder` | Evidence-based root-cause analysis and fix |
| `business-rules` | Register of confirmed rules that must not change silently |
| `checkin-merge` | Stage, commit, push, cherry-pick by convention |
| `test-on-dev` | Bring up a fresh local stack |
| `browser-qa` | Run a handover test document in a real browser |
| `browser-dev` | Check a new feature against its requirements |
| `browser-bug` | Check whether a bug is fixed |
| `db-access` | Safe database navigation across environments |
| `module-qa` | Verified Q&A per module |
| `work-log` | Timestamped log of each task and the skills used |

## Quick start

```bash
python install_skills.py /path/to/your/project
```

Then edit `.claude/project-profile.md` in that project and restart your assistant session. Full steps are in [`docs/INSTRUCTIONS.md`](docs/INSTRUCTIONS.md).

Useful flags: `--only name1,name2` (install some skills), `--no-agents`, `--force` (overwrite).

## Contributing

Ideas and improvements are welcome. Open an issue or submit a pull request.
