---
name: ux-heuristics
description: Shared checklist, severity scale and scoring rules for judging usability findings, based on the ten usability heuristics. Gives every UX skill and the naive-user agent the same friction types, the same Blocker/Major/Minor definitions and a repeatable ease score. Use whenever a usability finding must be classified, rated or scored.
---

# UX heuristics

One vocabulary so findings from different runs and testers can be compared.

## Heuristics to check against
| # | Heuristic | Ask |
|---|---|---|
| 1 | Visibility of status | After an action, is it obvious something happened? Is there progress for slow work? |
| 2 | Match with the real world | Are the words the user's words? Is the order natural? |
| 3 | User control and freedom | Is there a clear way back, cancel or undo? |
| 4 | Consistency and standards | Same word, same place, same behavior everywhere? Common web conventions followed? |
| 5 | Error prevention | Does the design stop mistakes before they happen (formats shown, confirmation on destructive actions)? |
| 6 | Recognition over recall | Is everything needed visible, without remembering from another screen? |
| 7 | Flexibility and efficiency | Are there shortcuts that do not get in the way of beginners? |
| 8 | Minimal design | Is anything on screen irrelevant and distracting? |
| 9 | Error recovery | Does the message say what went wrong and what to do next, in plain words? |
| 10 | Help | Is help findable at the point of need and short? |

## Friction types (use these names)
unclear label or jargon; hidden or hard-to-find feature; icon without a label; no feedback after an action; slow with no progress indicator; unhelpful or technical error message; unforgiving of mistakes (data lost, no undo, no confirm on delete); confusing navigation or lost place; inconsistent wording or behavior; too many steps; unclear required fields or formats; dead end; empty state with no guidance; looks clickable but is not (or the reverse); layout problem (cut off, overlapping, off-screen); accessibility barrier; mobile barrier.

Map each finding to the heuristic number it breaks.

## Severity
| Level | Meaning | Examples |
|---|---|---|
| **Blocker** | The person could not continue, or believed a wrong result was right, or lost data | Dead end; success message but nothing saved; delete with no warning that removed the wrong thing |
| **Major** | The person reached the goal only after a real struggle, a wrong turn they could not explain, or luck | Feature in an unexpected menu; error with no next step; save with no confirmation |
| **Minor** | Noticed, caused a small hesitation, no harm | Inconsistent wording; slightly small target; unclear but guessable label |

Frequency raises priority, not severity: a Minor seen on every screen is a priority fix.

## Ease score (1 to 5), repeatable
Per goal:
- Done without struggle: **5**
- Done with struggle: **3**, minus 0.5 for each wrong turn beyond two, never below 2
- Wrong result (believed done, was not): **1**
- Gave up: **1**

Overall = average of the goal scores, minus **0.5** if any Blocker was logged, rounded to the nearest 0.5, kept between 1 and 5.

Read it as: 5 obvious; 4 easy, small hiccups; 3 usable with effort; 2 frustrating; 1 not usable alone.

## Reporting rules
- Every finding names: where, what the person did and saw, what they expected, severity, type, heuristic number, evidence path.
- Also list what worked well. Praise is data: it shows what to keep.
- Do not suggest code fixes. Suggestions are in the user's voice about what would have helped.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Classified and scored usability findings") recording the counts per severity and the ease score.
