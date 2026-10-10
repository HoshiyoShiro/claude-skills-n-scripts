---
name: copy-and-error-review
description: Collect every label, message, empty state and error seen during a UX run and rate each for plain language, specificity and next step; find terms used inconsistently. Use after a naive-user run, when a user says the wording is confusing, or when reviewing error and confirmation messages.
---

# Copy and error review

Words are most of an interface. This skill turns the text seen during a run into a checked inventory with proposed rewrites in plain language. It reviews wording only; it never edits code.

## Rules
- Quote the text exactly as shown, with the screen and the situation that produced it.
- Judge as the persona would read it, not as the developer meant it.
- Proposed rewrites are plain-language suggestions for the owner to decide on; they are not applied here.
- Keep a record of the language the interface uses; judge a non-default language by the same rules.

## Inventory
During or after a run, list every distinct string the person had to understand: page titles, menu items, button labels, field labels and hints, placeholder text, validation messages, error messages, empty states, confirmations, success messages, tooltips, and help text. Note where each appeared.

## Checks
| Check | Pass when |
|---|---|
| **Plain language** | A first-timer understands it without product knowledge; no codes, abbreviations or internal names |
| **Specific** | It says what, not "something went wrong" or "invalid input" |
| **Next step** | It tells the person what to do now, in the same message |
| **Short** | One idea per sentence; no long paragraphs for an action |
| **Active and calm** | No blame ("you entered an invalid value") and no alarm for harmless events |
| **Consistent** | The same thing has one name everywhere, and one name means one thing |
| **Honest** | A success message appears only after success; a warning matches the real risk |
| **Right action label** | Buttons name the result ("Save changes", "Send invoice") not a vague verb ("Submit", "OK", "Apply") |
| **Format help** | Fields that need a format show it before the mistake (example, mask) |

## Error message anatomy
A good error says **what happened**, **why** (when known and useful) and **what to do next**, in plain words, near the field it concerns, without a stack trace, code or blame. Rate each error: good, fair or poor, and say which part is missing.

## Term map
Build a table of the product's names for each concept as seen on screen. Flag:
- two names for one thing (Client, Customer, Contact);
- one name for two things;
- a button that does not match the page it leads to;
- words that differ from the persona's own word for the thing.

## Report
```
Persona: <one line>   Language: <language>   Screens covered: <list>   Strings reviewed: <n>

Findings (worst first)
| # | Screen | Text as shown | Problem (check failed) | Severity | Suggested wording |
|---|--------|---------------|------------------------|----------|-------------------|

Error messages
| Situation | Message | Rating | Missing part |
|-----------|---------|--------|--------------|

Term map conflicts
| Concept | Names used | Where | Suggested single term |
|---------|------------|-------|-----------------------|

Good wording worth keeping
- <text and why it works>
```
Severity follows `ux-heuristics`. A message that hides the cause of data loss is a Blocker.

## Don'ts
- Don't rewrite the product's tone wholesale; fix what blocks understanding.
- Don't judge words from code or translation files; judge what the person saw.
- Don't apply changes; hand the list to the owner.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Reviewed interface wording and error messages") recording strings reviewed, findings by severity and term conflicts.
