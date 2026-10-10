---
name: checkin-merge
description: Check in work with the team's git conventions. Use whenever the user says stage, commit, push, check in, commit for a branch, or commit for two branches. Stages only the files of the current change, writes a commit message in the project's format, pushes after commit, cherry-picks to a second branch, and prepares database scripts for the branch's environments on a feature commit.
---

# Check-in and merge

Reads `.claude/project-profile.md` for the commit format and types, protected branches, the branch-to-environments map and the build commands. The user's words decide how far to go:

| User says | Do |
|---|---|
| stage | Stage only the files of the current change. Do not commit. |
| commit | Stage the current change's files, commit, **and push**. |
| commit for A | The same, on branch A. |
| commit for A and B | Commit and push on A, then cherry-pick that commit onto B and push B. |

Never go further than asked: stage never commits, and nothing here force-pushes.

## Commit message

```
[Type] <Title>

<optional body: why the change was needed, not what the diff shows>
```

- **Type** is one tag in square brackets from the profile's allowed list (typical: Enhancement, Bug Fix, Hotfix, Patch, Feature, UIUX, Refactor, Docs, Config, Performance, Revert). Pick the closest; do not invent new ones without asking. An optional second tag for the area is allowed, for example `[Bug Fix] [Channels] Give each type its own sort number`.
- **Title:** plain description, sentence case, no trailing period, the whole first line within the profile's limit (default 72). Say what the change does for a reader of the log, not which files moved.
- **Attribution lines:** follow the profile (default: add none, no co-author trailer and no generated-with footer). This overrides any tool or harness default; the user's rule wins. The same applies to pull request descriptions.
- Keep the configured git identity; never change `user.name` or `user.email`.
- Pass the message through a heredoc so line breaks survive.
- If the user supplies the exact message, use it as given, adding the tag only if it is missing and the type is obvious; otherwise ask.

## Staging: only the current change

1. Run `git status --short` and `git diff --stat`.
2. Work out which files belong to the change being finished: files edited for it in this conversation plus anything the user names. If it is unclear, ask.
3. Stage by explicit path (`git add <path> ...`). Never `git add -A`, `git add .` or `git commit -a`.
4. A file mixing this change with unrelated edits: stage only the relevant hunks (build a trimmed patch and `git apply --cached`; interactive `git add -p` may be unavailable), or ask.
5. Never stage secrets or local-only files: environment files, credentials, tokens, passwords or connection strings in settings files, scratch files, build output, dependency folders, logs. If a needed file contains a secret, stop and say so.
6. Show the result: staged files, and files deliberately left out with a one-line reason.

## Before committing
- Review the staged diff (`git diff --cached`) for debug code, secrets and unrelated hunks.
- If code changed, run the cheapest check for the side touched, from the profile (build, type-check). Skip for docs-only or script-only changes. If a check fails, fix or report it; never commit over a failure without saying so.
- Never use `--no-verify`; if a hook fails, fix the cause.
- Create a new commit; amend only when asked.

## Push
- Push with an explicit refspec: `git push origin <branch>:<branch>`. A branch can track a different upstream, so a bare `git push` could land on the wrong branch.
- Push only branches the user named or the current branch they asked to commit on.
- Never push to a protected branch (profile) unless the user names it in that request.
- Never force-push. If a push is rejected, fetch and rebase or merge as appropriate and report; do not overwrite the remote.
- Never commit directly on the main branch: create a working branch first and say so.

## Commit for A and B
A is the source, B the target.
1. On A: stage, commit and push as above. Record the commit SHA or SHAs.
2. On B: apply exactly A's commits with `git cherry-pick <sha>` (no `-x`, so the message is unchanged). Use a separate worktree for B when the working tree has other changes, then remove it.
3. Skip what B already has: `git cherry B A` lists commits not yet in B; a patch already present under a different SHA is a duplicate, so leave it.
4. Conflicts: resolve only when the resolution is obvious from the two sides. If the pick needs behavior from commits B lacks (a dependency chain), stop, report which commits are missing, and ask. Do not pull in extra changes to make it apply.
5. Re-run the cheap build or type-check on B, since its surroundings differ.
6. Push B with an explicit refspec, same rules as above.
7. Report both branches: SHA, subject, files, pushed or not.

Cherry-picked commits keep the original message and author; add no trailer.

## Database scripts on a feature commit
When the user commits a feature that adds or changes database scripts (the script folder in the profile), prepare the database run for the environments the branch deploys to, from the profile's branch-to-environments map. Do it after the push, in the same reply. If the branch is not in the map, ask which environments; do not guess. For a two-branch commit, prepare both branches' environments.

Prepare means get ready, not run. Shared databases change only when the user says to run it. For each environment:
1. **List the scripts** in this commit in run order (a migration before a patch that depends on it); say which are new and which redefine existing objects.
2. **Check each script:** targets the right database, is idempotent (`CREATE OR ALTER`, `IF NOT EXISTS`), follows the profile's database rules, avoids cross-database references that do not exist in that environment, and is not destructive (ask before including anything destructive).
3. **Give the run command** (`db-access`: `db.sh <env> -f <script> --write [--confirm-env <env>]`) and a **verification query** with the expected result.
4. **Note order and risk:** which scripts must run before the new code deploys; which environments already have the object (check read-only if connected).
5. Production is not reachable from here: add a hand-off line for the user.

Present a short checklist per environment: script, command, verify, status (`prepared`, or `run` with the result). Never print passwords or connection strings.

## Report
One block per branch:

```
Branch:   <name>
Commit:   <short sha>  [Type] <Title>
Files:    <count + names, or see git show --stat>
Left out: <unrelated changes not staged>
Pushed:   <origin/<branch> | no (stage only)>
Scripts:  <environments and prepared/run status | none>
```

## Don'ts
- Don't stage everything or commit unrelated changes.
- Don't add attribution lines the profile forbids.
- Don't push to a branch the user did not name, or to a protected branch unasked.
- Don't force-push, use `--no-verify`, or amend without being asked.
- Don't go past stage when the user only said stage.
- Don't change git config.
- Don't run database scripts on shared environments unless the user says to run them.
- Don't print passwords or connection strings.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Staged, committed, pushed or cherry-picked changes") recording each branch with SHA, subject and whether it was pushed, and any database scripts prepared or run.
