---
name: business-rules
description: Keep and consult a register of confirmed business rules so changes and bug fixes never silently alter agreed behavior. Mode B (check) runs before designing a feature or fixing a bug; Mode A (record) runs when the user confirms a rule or decision. Used by feature-enhancer and bug-finder.
---

# Business Rules

The register is `business-rules.md` in this folder (path in the project profile). Follow its header: never change a `Locked: yes` rule unless the user explicitly asks, and never store secrets or personal data.

## Mode A: Record
Use when the user confirms a rule or decision, such as saying that it should always work a certain way, or asks to log one.
- Add one entry per rule in the register's format: Area, Rule, Status, Source (date and who or where), Evidence (file and line, tests), Decided by, Locked, Affects, Tests, History, Related.
- Status `confirmed` only when the user or owner approved it. A rule read from code but not approved is `inferred`.
- Give each rule a stable id with an area prefix, such as ORD-001, and update the index by area.
- A changed rule: mark the old entry `superseded`, add the new one, and link them in `History` and `Related`.
- Ask before setting `Locked: yes`.

## Mode B: Check
Run before designing a feature or fixing a bug.
1. Search the register by area, keywords, and the screens, endpoints and tables the change touches (`Affects`).
2. List the matches in one short block: id, rule, status, locked.
3. Keep every listed rule unchanged. If the work would change one, stop and ask: which rule, what changes, what else it affects.
4. If a reported bug matches a registered rule, say it is registered behavior and ask whether to change the rule.
5. If nothing matches, say so and continue. Mention inferred behavior that is not registered and offer to record it.

## Don'ts
- Don't edit a locked rule without an explicit request.
- Don't register guesses as `confirmed`.
- Don't duplicate rules; update the existing entry's `History`.
- Don't put secrets or personal data in the register.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Checked or recorded business rules") recording rules checked, added or superseded.
