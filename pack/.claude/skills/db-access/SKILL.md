---
name: db-access
description: Look into the project databases quickly and safely across environments (dev, staging, uat, and so on), using credentials from a local git-ignored config file. Use whenever you need to inspect tables, columns, stored procedures, row counts or sample data, compare an object across environments, check what a script changed, or run an approved database script. Read-only by default; each environment has its own write policy.
---

# Database access

One helper, `db.sh`, connects to the environments listed in a local config file so nobody hunts for connection strings, reads are quick, and writes are deliberate. The shipped helper targets SQL Server through `sqlcmd`; see Other databases to adapt it.

## Setup (once per machine)
1. Copy `environments.example.conf` to `environments.local.conf` in this folder (it is git-ignored) and fill it in. One block per environment:
   ```
   dev.server=<host,port>
   dev.user=<login>
   dev.password=<password>
   dev.database=<database>
   dev.write=allowed        # allowed | confirm | never
   ```
   `allowed`: writes need only `--write`. `confirm`: writes also need `--confirm-env <env>`, which you pass only after the user confirms that environment. `never`: writes are refused (use for production, which is usually unreachable from here anyway).
2. The environment names and their purpose are listed in `.claude/project-profile.md`.
3. If credentials live in an application settings file, generate the config from it once instead of copying by hand; never print them.

## Rules
- **Read-only by default.** The helper refuses statements that change data or schema unless `--write` is given. Use `--write` only when the user asked for the change.
- **Shared environments need the user's go-ahead for that environment,** then `--confirm-env <env>`. Never write to a shared environment on your own initiative.
- **Scripts, not ad-hoc edits.** Schema changes go through the repository's script folder (idempotent, correct database), following the profile's database rules. No one-off raw statements.
- **Look before you write:** check the target (object exists, current definition, row counts) and show the user what will change.
- **Never print secrets or personal data.** Do not print the connection string or password (the helper never does). Do not select password, token, secret, key, configuration, phone, email, hash or salt columns, or personal names unless the task needs them. Use ids, usernames and codes. `sample` refuses sensitive columns unless `--allow-sensitive` is passed, which needs the user's request.
- **Keep reads small:** `TOP`, explicit columns (no `SELECT *` on sensitive tables), the profile's read hints.
- **Say which environment** every answer comes from. Never mix environments in one statement.
- The guard is a safety net for mistakes, not a security boundary; do not try to get around it.

## How to run it
From the repository root in a POSIX shell (Git Bash on Windows):

```
bash .claude/skills/db-access/db.sh <env|all> [flags] <command> [args]
```

Every call prints a `[db] env=... server=... db=... mode=...` line to stderr so the environment is always visible.

| Command | What it does |
|---|---|
| `whoami` | server, database, login, server time |
| `tables [pattern]` | tables matching the pattern (default: all) with row counts |
| `columns <table>` | columns, types, nullability |
| `procs [pattern]` | stored procedures with last modified |
| `params <proc>` | a procedure's parameters |
| `proc <name>` | a procedure's definition |
| `find <pattern>` | tables, procedures and columns whose name matches |
| `refs <object>` | procedures whose body mentions the object |
| `count <table>` | row count (no locks) |
| `sample <table> <cols> [n]` | last `n` rows (default 5) of the named columns |
| `compare <object>` | last-modified time and a hash of the definition in every environment (use `all`), to see drift |
| raw SQL | any read statement |

| Flag | Meaning |
|---|---|
| `--db <name>` | another database than the environment's default |
| `-f <file.sql>` | run a script file (from the file's folder with a relative name; an absolute Windows path can fail under Git Bash) |
| `--write` | allow data or schema changes |
| `--confirm-env <env>` | required with `--write` when the environment's policy is `confirm` |
| `--allow-sensitive` | let `sample` read sensitive columns; only on the user's request |

`EXEC` of read-style procedures (names starting Get, Find, Search or List, with or without your project's prefix) and the `sp_help` family count as reads; any other `EXEC` needs `--write`. Adjust the pattern in `guard()` to your naming.

## Common jobs
- **What does this procedure do, and is it the same everywhere?** `proc <name>`, then `all compare <name>`. Different hashes mean drift; dates show which side is older.
- **What does the code call?** Read the repository method for the procedure's name and parameters, then `params <proc>` in the target environment. A mismatch is the usual cause of works in dev, 500 in staging.
- **What shape is this table?** `columns`, `count`, then `sample` with a few named columns.
- **Did my script apply?** `compare` the object, or `find` the new table or column in each environment.
- **Where is this used?** `refs <object>`.

## Running a script on an environment
1. Show the user the script, the target environment and what it changes (the current state first).
2. Run on the development environment first if it is not there yet; report the output.
3. For a shared environment, wait for the user to say to run it there, then pass `--write --confirm-env <env>`.
4. Verify with a read (`compare`, `params`, a count or sample) and report. Report errors exactly; do not retry with changes.

## Other databases
Replace `run_sql` and `run_file` in `db.sh` with the client of your database (`psql -h ... -U ... -d ... -c`, `mysql ... -e`, `sqlite3`), and replace the catalog queries in `sql_for` (tables, columns, procs, params, proc, find, refs, compare) with the equivalents (`information_schema` for tables and columns; `pg_proc` and `pg_get_functiondef` for PostgreSQL; `SHOW CREATE PROCEDURE` for MySQL). The rules, flags and guard stay the same.

## Troubleshooting
- Login timeout or cannot open server: the host is unreachable from this network; say so, do not retry in a loop.
- Invalid object name for a cross-database reference: not available in that environment.
- Invalid column name: run `columns` first; schemas differ between environments.
- Very wide or garbled output: select fewer columns or truncate with `LEFT(col, 60)`.
- Client not found: it must be on the PATH of the shell.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Inspected or changed a database environment") recording the environment, what was read or run, any script and its result, and differences found between environments. Never log credentials or personal data.
