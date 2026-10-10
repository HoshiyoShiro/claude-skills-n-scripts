---
name: user-goals
description: Turn a feature, requirement list, mockup or module into three to five plain-language user goals for naive-user, written without any interface words so the goal gives no hints. Use before running a naive-user or first-impression test, or when someone asks what a first-time user should try to do.
---

# User goals

A goal is what a person wants to get done, in their words. It must not name a screen, menu, button or system term, otherwise the test is no longer clueless.

## Rules
- Write the goal as an outcome, not steps: "Get my order changed to a different address", not "Open Orders and click Edit".
- No interface words, no product jargon, no field names. If a system term is unavoidable, the persona is told it as part of their story, the way a real person would have been told.
- Each goal has a **starting state**, a **success check** (how the person would know it worked, seen on screen) and a **reality check** (how the tester confirms afterwards that it really worked).
- Three to five goals per feature or module, ordered the way a real person meets the product: first contact, main task, a variation, a mistake to recover from, finding something again later.
- Cover every role the profile lists for the feature, one persona per role.
- Do not invent features. Take goals from the requirements, business rules, mockup analysis, module Q&A or the user's request.

## Procedure
1. Gather sources: requirements or plan, `business-rules` for the area, `mockup-analyzer` report if any, `module-qa` entries, the user's request.
2. List what a person can achieve with the feature, as outcomes.
3. Rewrite each outcome in the persona's voice and words, with the situation that makes them want it.
4. Add one **recovery goal** (they made a mistake and want it undone) and one **return goal** (come back later and find or change what they did).
5. Run the **leak check**: strike any word that appears as a label, menu or term in the product. Replace with what a person would say.
6. Hand the list to `naive-user` with the persona. Keep the sources and the reality checks to yourself; do not pass them to the tester.

## Goal template
```
Goal G1: <outcome in the person's words>
Who and why: <persona and the situation that makes them want this>
Starts from: <logged in or not; what they already have>
Success looks like (the person's view): <what they would see to feel done>
Reality check (for the reviewer only): <how to confirm it really happened: record, state, message>
Roles: <role this persona plays>
Priority: <High | Medium | Low>
```

## Examples
| Weak (leaks UI) | Good (outcome only) |
|---|---|
| Open Settings > Users and click Add user | A new colleague starts on Monday and needs to be able to log in |
| Use the filter bar to find overdue invoices | Find out which customers still owe me money |
| Click Export to CSV | Get this list into a spreadsheet to send to my accountant |
| Delete the draft message | I wrote something by mistake and do not want it sent |

## Don'ts
- Don't include steps, shortcuts or menu names.
- Don't write goals that need knowledge of the data model.
- Don't write goals the product is not meant to support.
- Don't give the tester the reality check.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Wrote user goals for a UX test") recording the feature, the number of goals and the persona.
