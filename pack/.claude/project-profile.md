# Project profile

The single place where this project's specifics live. Every skill reads this file instead of hard-coding them. Keep it short and current. Never put passwords, tokens or connection strings here.

## Basics
- **Name:** <project name>
- **Stack:** <for example: Vue 3 + ASP.NET Core 8 + SQL Server + Redis>
- **Repo layout:** <where the backend, frontend, database scripts and docs live>

## Branches and commits
- **Protected branches (never push unless named in the request):** <main, release/*, ...>
- **Commit message format:** `[Type] <Title>`   (Title: sentence case, no trailing period, first line 72 characters or fewer)
- **Allowed types:** Enhancement, Bug Fix, Hotfix, Patch, Feature, UIUX, Refactor, Docs, Config, Performance, Revert
- **Attribution lines (co-author, "generated with"):** none
- **Branch to environments map** (used to prepare database scripts on a feature commit):

  | Branch | Environments |
  |---|---|
  | <feature-branch-a> | dev, staging |
  | <feature-branch-b> | dev, uat |

## Environments
| Alias | Purpose | App URL | Database host | Database name | Writes |
|---|---|---|---|---|---|
| dev | local/dev | https://localhost:5173 | <host> | <db> | allowed |
| staging | shared | <url> | <host> | <db> | confirm |
| prod | production | <url> | not reachable from here | | never |

Connection details are read from `.claude/skills/db-access/environments.local.conf` (git-ignored).

## Local stack (used by test-on-dev)
| Piece | Start command | Working dir | Port | Health check |
|---|---|---|---|---|
| <cache/queue, e.g. redis> | `docker run -d --name <name> -p 6379:6379 redis:7` | | 6379 | `docker exec <name> redis-cli ping` |
| <API> | `<command>` | <dir> | <port> | <url returns any HTTP status> |
| <frontend> | `<command>` | <dir> | <port> | <url returns 200> |

Ports to clear of stale processes: <list>
Kill only processes belonging to this project.

## Build and check commands
- **Backend:** <build command>   **Tests:** <command>
- **Frontend:** <type-check / lint / build commands>

## Test accounts and data
- **Accounts file (git-ignored):** `.claude/skills/browser-qa/accounts.local.json`
- **Roles available:** <super admin, supervisor, agent, ...>
- **Test data prefix:** `QA-<yyyymmdd>-`
- **Real outbound messages** (email, SMS, chat channels) **allowed in tests?** no, unless the user says so in the request

## Database rules
- **Script folder:** <for example `Database/`>
- **Naming:** <table prefix, procedure prefix>
- **Rules:** <for example: stored procedures only; NOLOCK on reads; no foreign keys, triggers or views; scripts idempotent>
- **Run order and who may run it:** scripts run on dev first; shared environments only on the user's say-so.

## Paths
- **Business rules register:** `.claude/skills/business-rules/business-rules.md`
- **Known issues:** `known-issues.md`
- **Module Q&A:** `docs/module-qa/`
- **Work logs:** `.claude/logs/` (git-ignored)
- **Handover documents:** `docs/handover/` (or wherever the team keeps them)

## User simulation (optional)
If the system has users that arrive through channels you cannot log into (chat widget, messaging apps, email), note here how tests can simulate them (a skill name, a script, a webhook), and which ids are safe fake ids.
