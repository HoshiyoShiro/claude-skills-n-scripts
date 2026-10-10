---
name: known-issues
description: Maintain and use a knowledge base of frequent bugs and their proven causes and fixes. Use at the start of any bug, error, crash or failure investigation to check for a matching known issue before debugging from scratch, and at the end to record the result. Works with bug-finder, feature-enhancer and browser-bug.
---

# Known Issues

The knowledge base (KB) is the file named in the project profile under Paths (default `known-issues.md` in the repository root).

## Rules
- Be concise. Check the KB first, then verify the match with evidence. Never apply a fix on a match alone.
- If no entry matches, or the top candidates are disproven, hand over to `bug-finder` and debug normally.
- After every resolved issue, update the KB.
- If anything is unclear, ask first. Never guess.
- Never store secrets, tokens, passwords, personal data or customer data in the KB.

## KB location
Default `known-issues.md` in the repository root. If it does not exist, ask where to keep it, then create it from the template below. An optional database table with the same fields is allowed, read-only unless the user approves writes.

## Phase 1: Lookup (before debugging)
1. Extract the signature: exact error text, code or exception type; the symptom in one line; the area (module, service, endpoint, table, screen); the environment, stack and the most recent change.
2. Search the KB by error text, then symptom, area and tags.
3. Score each candidate:
   - **Match** (0 to 3): 3 exact error and same area, 2 same error or same symptom and area, 1 similar symptom only, 0 none.
   - **Frequency:** `count`. **Reliability:** confirmed versus disproven. **Recency:** recent entries and recent changes in that area rank higher.
   - Rank by Match first, then Frequency x Reliability.
4. Pick the top one to three. State: the candidate, why it matches, how to verify.

## Phase 2: Verify (cheap check first)
Run the entry's `Verify` step. Confirmed: apply its `Fix`, then verify with the original repro and tests. Disproven: try the next candidate and record the miss. Unsure: collect more evidence or ask. If every candidate fails, switch to `bug-finder`.

## Phase 3: Record (after resolution)
- Confirmed entry: `Count + 1`, update `Last seen`, keep the fix current.
- Disproven for this case: add the ruling-out condition to `Not this when`.
- New issue: add an entry from the template. Merge duplicates; one entry per root cause.
- Keep entries short; link to commits or pull requests instead of pasting code. Redact sensitive data.

## Entry template

```
## KI-<number>: <short title>
- Tags: <area, stack, error code>
- Signature: <exact error text or symptom pattern>
- Count: <n>   First seen: <date>   Last seen: <date>
- Confidence: <high | medium | low>  (confirmed n / disproven n)
- Root cause: <one to two lines>
- Verify: <fast check that proves or disproves it>
- Fix: <steps or commit link>
- Prevention: <test, validation, monitoring, process>
- Not this when: <conditions that rule it out>
- Related: <KI ids, docs, tickets>
```

## KB maintenance
Keep entries sorted by Count, with an index at the top. Past about 100 entries, merge and archive old ones into `known-issues-archive.md`. Mark permanently fixed issues `Status: resolved` with the version or date. On request, report the top five recurring issues with suggested permanent fixes.

## Mining sources (to build or refresh the KB, with permission)
Git history (`git log --grep="fix"`, reverts, hotfix branches), tickets and post-mortems, error logs grouped by signature, error or audit tables (read-only, with a limit), CI failures, notes from the user. Mark unverified entries `Confidence: low`.

## Report format
```
Match:       <KI-id + title | none>
Why:         <signature/area match>
Verified:    <evidence | disproven | not tested>
Action:      <fix applied | next candidate | fallback to bug-finder>
KB update:   <count+1 | new entry KI-n | note added>
```

## Don'ts
- Don't treat a frequent cause as a confirmed cause.
- Don't stop at the first match if the evidence does not fit.
- Don't let the KB bias the investigation; if the evidence points elsewhere, leave the KB.
- Don't store sensitive data. Don't create duplicate entries.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Checked or updated the known-issues knowledge base") recording entries matched, added or updated.
