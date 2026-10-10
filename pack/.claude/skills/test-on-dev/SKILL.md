---
name: test-on-dev
description: Bring the whole local stack up fresh so the user can test against the development environment. Use when the user says test on dev, start everything, launch frontend and backend, restart the stack, or anything meaning get my local environment running. Clears stale processes, starts the dependencies, the backend and the frontend, then replies in one line.
---

# Test on dev

Get a clean local stack running, then say it is done. No commentary, no recap of steps.

**Reply style:** one short line when everything is up, for example: Done. Frontend <url>, API <url>, <dependency> up. Say more only if something failed: exactly what failed and the error.

## What the stack is
Read the **Local stack** table in `.claude/project-profile.md`: each piece, its start command, working directory, port and health check, and the list of ports to clear. The typical order is dependencies (container engine, cache, queue, local database), then the backend, then the frontend. If the frontend proxies to the backend, the backend port must be up for the app to work.

## Every time: start fresh
Run the whole procedure each time. Never assume a previous run is still healthy.

1. **Find stale processes** on the profile's ports (Windows: `netstat -ano | grep -E ":(<ports>) "`; macOS and Linux: `lsof -i :<port>`), plus leftover processes of this project's backend or dev server from earlier runs.
2. **Stop them** (Windows PowerShell `Stop-Process -Id <pid> -Force`; elsewhere `kill <pid>`). Only processes holding these ports or clearly belonging to this project; never unrelated runtimes. If the port holder is a container engine's proxy for a dependency, handle it in step 3.
3. **Dependencies.** Check the container engine (`docker info`). If it is down, start it and poll until it answers (up to about two minutes). Restart or create each dependency container from the profile, then confirm it answers its health check (for example a cache's ping). Dependency containers can exit unexpectedly, so confirm they are running afterwards. Without a required dependency the backend may crash on start, so confirm it first.
4. **Backend.** Start it in the background from its working directory with the profile's command (development profile). Wait until its URL answers; any HTTP response counts as up (self-signed certificates: skip verification for the check). If it exits, read its output and fix or report it.
5. **Frontend.** Start it in the background. Install dependencies first if the dependency folder is missing. Wait until its URL answers.
6. **Confirm** every piece against its health check, then send the one-line reply.

Run long-lived processes as background commands so they keep running after the reply.

## If something fails
State which piece failed and the exact error in one or two lines. Fix what you can safely (port still held, engine not up yet, install needed) and retry once. Never change code, data or configuration to get the stack up without asking.

## Don'ts
- Don't skip the stale-process cleanup, even if ports look free.
- Don't kill processes that are not this project's.
- Don't point the stack at a shared or production environment; this skill is for the development profile only.
- Don't run database scripts, run full builds or commit anything unless asked.
- Don't write a long summary.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Brought up a fresh local stack") recording what was stale and cleared and the final state of each piece.
