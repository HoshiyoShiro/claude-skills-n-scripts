# Portable Skills and Agents: Instructions

How to reuse the skills pack and agents pack in another project, or on another machine.

## 1. What you have

| Path | What it is |
|---|---|
| `pack/.claude/project-profile.md` | The one file you fill in per project |
| `pack/.claude/skills/` | 14 skills: mockup-analyzer, known-issues, feature-enhancer, bug-finder, business-rules, checkin-merge, test-on-dev, browser-qa (+ handover template), browser-dev, browser-bug, db-access (+ helper script and example config), module-qa, work-log |
| `pack/.claude/agents/` | 4 agents: master (orchestrator), software-engineer, bug-hunter, qa-tester |
| `install_skills.py` | Copies the pack into a project folder (Python 3, no dependencies) |
| `docs/SKILLS.md`, `docs/AGENTS.md` | Overview tables for the skills and the agents |
| `docs/INSTRUCTIONS.md` | This file |

Everything project-specific is in **one file**, `.claude/project-profile.md`. The skills and agents read it; they contain no project names, ports, branch names or database naming rules.

## 2. Install into a project

From the root of this repository:

```
python install_skills.py <path-to-target-project>
```

- Copies `pack/.claude/` into the target's `.claude/` (skills, agents and the project profile).
- Never overwrites an existing file unless you pass `--force`. Re-running is safe.
- `--only name1,name2` installs just those skills (the profile is always included), `--no-agents` skips the agents.
- Appends three lines to the target's `.gitignore` (accounts file, database config, logs folder).

Manual alternative: copy the folders you want from `pack/.claude/` into your project's `.claude/` yourself.

Other tools: the skills are plain markdown with a short frontmatter, so they also work as instruction files for other assistants (see section 6).

## 3. Set up the project (about 15 minutes)

1. **Fill in `.claude/project-profile.md`.** This is the only required edit. Replace every `<placeholder>`:
   - stack and repository layout
   - protected branches, commit types, and whether attribution lines are allowed
   - the branch-to-environments map (which environments a feature branch deploys to)
   - the environments table (alias, URL, database host, write policy)
   - the local stack table (what to start, in which folder, on which port, and how to check it is up)
   - build and check commands
   - database rules (script folder, naming, required patterns)
   - paths for the register, known issues, Q&A and logs (the defaults work)
   - how end users can be simulated, if at all
2. **Database access (only if you use `db-access`).** In `.claude/skills/db-access/`, copy `environments.example.conf` to `environments.local.conf` and fill in each environment. It is git-ignored. Use write policy `allowed` for local dev, `confirm` for shared environments, `never` for production.
3. **Test accounts (only if you use the browser skills).** Create `.claude/skills/browser-qa/accounts.local.json` in the format shown in the browser-qa skill. It is git-ignored. Use test accounts only.
4. **Business rules.** Delete the example entry in `.claude/skills/business-rules/business-rules.md` once you add a real one, and set an area prefix for rule ids.
5. **Known issues.** Create `known-issues.md` in the repository root (the known-issues skill creates it on first use if it is missing).
6. **Restart the assistant session** so it loads the new skills and agents.
7. **Check it works:** ask it to run `db-access` with `whoami` on dev, and `test-on-dev` to start the stack. Fix the profile if either fails.

## 4. Using it

Skills trigger on plain requests. Typical phrases:

| You say | Skill or agent |
|---|---|
| here is a mockup, build it | mockup-analyzer then feature-enhancer (software-engineer) |
| add or change this feature | feature-enhancer (software-engineer) |
| something is broken, find out why | known-issues then bug-finder (bug-hunter) |
| test on dev | test-on-dev |
| browser qa, here is the test document | browser-qa (qa-tester) |
| check the feature against the requirements | browser-dev (qa-tester) |
| is the bug fixed | browser-bug (qa-tester) |
| compare this procedure across environments | db-access |
| stage, commit, push, commit for A and B | checkin-merge |
| make a Q&A for this module | module-qa |
| rule confirmed: ... | business-rules (record) |

Every skill ends by writing a short log entry (work-log) into `.claude/logs/`.

**With the master agent.** Run the master agent as the main session. It routes your request to the right worker, runs the chains (build, test, fix, retest, commit), asks you before anything that crosses a module boundary, and does the commits. Without it, call the skills or workers directly.

The agents are written for a layered application with shared code, stored procedures or tables, and several environments. Edit the Impact gate list in `master.md` if your system has other kinds of shared things.

## 5. Adapting it

**A different stack.** Only the profile changes. Example local stack rows:

| Stack | Piece | Start command | Port | Health check |
|---|---|---|---|---|
| Node API + React | API | `npm run dev` in `server/` | 3000 | `curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health` |
| Node API + React | Web | `npm run dev` in `web/` | 5173 | URL returns 200 |
| Django | API | `python manage.py runserver` | 8000 | URL answers |
| Any | Postgres | `docker run -d --name pg -p 5432:5432 -e POSTGRES_PASSWORD=dev postgres:16` | 5432 | `docker exec pg pg_isready` |

**A different database.** `db.sh` targets SQL Server through `sqlcmd`. For PostgreSQL or MySQL replace `run_sql` and `run_file` with `psql` or `mysql` calls and swap the catalog queries in `sql_for` (the db-access skill lists the equivalents). The rules, flags, environment config and write guard stay the same. Edit the read-style procedure pattern in `guard()` to match your naming.

**Different commit tags.** Change the allowed types in the profile. The skill uses whatever the profile lists.

**No database, no browser, no shared environments.** Install only what you need with `--only`, for example `--only feature-enhancer,bug-finder,checkin-merge,work-log`. Skills that mention a missing skill (for example db-access) say what to do when it is absent.

**Naming skills differently.** If you rename a skill folder, search the pack for its old name: skills refer to each other by name.

## 6. Using the agents and skills in other tools

The skill files are markdown. Most assistants can use them in one of these ways:

| Tool | How |
|---|---|
| Claude Code | Install as described above. Agents run through the Agent tool; skills load on matching requests |
| Codex, Cursor, Copilot, other assistants that read an instructions file | Paste the profile and the skills you want into `AGENTS.md`, `.cursorrules` or the tool's custom-instructions file, one `## <skill name>` section each. Drop the frontmatter lines. Keep the work-log reference only if you keep that skill |
| A plain chat | Paste one skill at the start of the conversation when you need it |

Agents: the frontmatter fields (`tools`, `skills`) are Claude Code features. In other tools, keep the body as the role description and list the skills the agent should apply in its first line. The master agent needs a tool that can start sub-agents; without one, use its routing table and rules as a checklist for yourself.

## 7. What is not in the pack, and why

These were built for one system and do not generalize as they are:

| Original | Why it was left out | What to do instead |
|---|---|---|
| Live Chat widget simulation | Drives one product's chat widget and its test page | Write a user-simulation skill for your system (below) |
| Messaging-channel simulation (Telegram, WhatsApp, LINE, Facebook) | Posts that product's webhook payloads and signs them with its channel secrets | Same |
| Back-office design system, framework pattern and UI skills | Tied to one design system and stack | Add your own design-system skill and list it in `software-engineer`'s `skills:` |
| Project instructions file (CLAUDE.md) | Architecture and database rules of one system | Put your own rules in your instructions file; mirror the key ones in the profile |

**Writing a user-simulation skill for your system.** The skills that need an end user (browser-qa, browser-dev, browser-bug, bug-hunter) look for one named in the profile. A good one:
1. Finds the entry point for end users (a widget page, a webhook route, an inbound email address, an API) and how to address a specific tenant, channel or chatbot.
2. Sends traffic the way the real provider would (same payload shape, same signature or secret), so the real pipeline runs instead of a fake path.
3. Uses ids that cannot belong to a real person, names every simulated user with the test prefix, and never sends replies to real addresses.
4. Keeps volume small and asks before using many users or many messages.
5. Reads secrets only to sign requests, passes them through environment variables, and never prints or saves them.
6. Verifies the result in the database or the UI, and returns ids and names so QA can find the conversations.
Then name it in the profile under User simulation.

## 8. Rules the pack enforces (change them in the profile or skill if you disagree)

- Stage by explicit path, never everything. Commit message `[Type] <Title>`. Push with an explicit refspec. Never force-push. No attribution lines unless the profile allows them.
- Databases are read-only by default; writes need a flag and, on shared environments, the user's confirmation for that environment.
- Test accounts, database config and logs are git-ignored; secrets are never printed, logged or put in reports.
- QA skills report and never fix; fixing is a separate step.
- Anything that crosses a module boundary or alters shared objects is raised with the user first.

## 9. Maintenance

- Keep the profile current: when ports, environments or branch names change, edit the profile only.
- Review `known-issues.md` and the business rules register as part of normal work; they are only useful if they are kept up to date.
- To change a skill for all projects, edit it here under `pack/.claude/` and re-run the installer with `--force` in each project (it overwrites, so commit local edits first).
- Bump a note at the top of the pack with the date when you change it.

## 10. Troubleshooting

| Problem | Check |
|---|---|
| Skills do not appear | Restart the session; confirm each `SKILL.md` has the frontmatter block with `name` and `description` |
| A skill ignores the profile | Confirm `.claude/project-profile.md` exists and its placeholders are filled |
| `db.sh` says missing config | Copy `environments.example.conf` to `environments.local.conf` and fill it in |
| `db.sh` cannot connect | The host is unreachable from this network or the credentials are wrong; the helper prints the client's error |
| Installer finds no files | Run it from a checkout of this repository, or pass `--source <folder>` pointing at a `.claude` folder |
| Bash scripts fail on Windows | Use Git Bash; use relative paths for script files |

## 11. Known limits of this pack

- The generic database helper's write guard and sensitive-column check were tested against a live database server. A full read against all environments could not be repeated at the end because the network to the database hosts was unreachable at that moment; the earlier project-specific version of the helper ran the same commands successfully.
- The browser, QA and simulation steps are procedures for the assistant. They were written from this project's use and were not re-run against a second project.
- The Playwright version is not pinned in the skill text; pin the version you test with.
