---
name: friction-trends
description: Save the results of each naive-user or UX run to a history file and compare runs over time, showing whether usability is improving, which findings are fixed, new or have come back, and whether a change helped. Use after every UX run and when asked how usability has changed.
---

# Friction trends

One run tells you where it hurts. A series of runs tells you whether the product is getting easier. This skill keeps the history and does the comparison. The history file location is in the profile under Paths (default `docs/ux-history/`); it is tracked in git so the team sees it.

## Rules
- Only compare runs with the **same persona, same goals and same device**. If any differ, mark the comparison `not comparable` and say what differs.
- Never edit or delete past rows. Corrections are new rows with a note.
- Record the build (commit short SHA and branch) so changes can be tied to results.
- No personal data or credentials in the history.

## Files
```
docs/ux-history/
  runs.csv         one row per goal per run
  findings.csv     one row per finding per run
  README.md        what the columns mean (created on first use)
```

`runs.csv` columns: `date, build, branch, persona, device, goal_id, goal_title, outcome, steps, wrong_turns, ease_score`

`findings.csv` columns: `date, build, finding_key, screen, type, severity, heuristic, text`

`finding_key` is a stable fingerprint: `<screen>|<type>|<short subject>`, lower case (for example `invoice list|no feedback|save button`). The same problem in a later run reuses the key so its life can be followed.

## After each run
1. Append the rows for this run to both files (create them with a header on first use).
2. Compare with the previous comparable run: `python .claude/skills/friction-trends/trend.py docs/ux-history`.
3. Give the comparison in the reply and add it to the run's report.

## Comparison report
```
Compared: <date A, build A>  to  <date B, build B>   Persona: <p>  Device: <d>   Comparable: yes | no (why)

Ease score:  <A> -> <B>   (<delta>)
Goals:       <done / struggle / gave up / wrong result at A> -> <at B>

Findings
  Fixed:      <keys present at A, absent at B>
  New:        <keys absent at A, present at B>
  Still open: <keys in both>, with severity changes
  Came back:  <keys seen earlier, absent at A, present again at B>

Verdict: better | same | worse, with the main reason
```

## Reading trends
- Three or more runs: look at the ease score line and the count of open Blockers and Majors.
- A fix that closes one finding and opens another in the same screen is a swap, not progress; say so.
- A changed build with no change in findings means the work did not touch what users struggle with.

## Don'ts
- Don't average runs with different personas or goals.
- Don't rewrite history rows.
- Don't hide a regression: a returning Blocker goes at the top of the reply.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Saved a UX run to the history and compared trends") recording the build, the verdict and counts of fixed, new, open and returned findings.
