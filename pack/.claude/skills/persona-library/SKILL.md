---
name: persona-library
description: Ready-made user personas (first-timer, elderly, impatient mobile user, non-native speaker, screen-reader user, cautious user, power-user newcomer) with patience limits, reading habits and typical mistakes, plus a way to add project-specific personas. Use when running naive-user or any UX test and a persona must be chosen or written.
---

# Persona library

A persona decides how hard the product is judged. The same product can be fine for one persona and hopeless for another, so pick on purpose and say which was used.

## Rules
- Pick the persona the product is **for**, then add one harder persona to find the edges.
- A persona is behavior, not a stereotype: it sets patience, reading habits, vocabulary, device and typical mistakes, never judgements about who the person is.
- State the persona in one line at the top of every UX report. Compare runs only when the persona is the same.
- Project personas live in the file named under Paths in the profile (default `docs/personas.md`). Use those first; use the built-in ones below to fill gaps.

## Persona card (fields)
`Name | Who | Device | Tech comfort | Patience | Reading | Vocabulary | Typical mistakes | Needs | Gives up when`

Patience is a budget: **tries per step** before giving up and **actions without progress** before asking for help.

## Built-in personas

| Name | Who and device | Patience (tries / actions) | Reading and vocabulary | Typical mistakes and needs |
|---|---|---|---|---|
| **First-timer** (default) | Ordinary adult, laptop, comfortable with websites, never seen this product | 3 / 15 | Skims headings and button text, skips paragraphs; knows common web words only | Clicks the first plausible label, misses small links, does not know product jargon |
| **Cautious user** | Anyone afraid to break something, laptop | 2 / 10 | Reads warnings, hesitates on anything destructive | Stops at confirmations, avoids Save when unsure what it changes, wants undo |
| **Impatient mobile** | Phone, one hand, on the move | 2 / 8 | Reads almost nothing, taps fast | Double taps, mistaps small targets, leaves when a page is slow |
| **Older adult** | Larger text, tablet or laptop, little confidence | 4 / 20 | Reads every word slowly, literal | Misses icon-only buttons, fears forms that time out, expects confirmation on every step |
| **Non-native speaker** | Reads the interface language as a second language | 3 / 15 | Needs short plain words; idioms and abbreviations fail | Misreads long sentences, mistypes formats (dates, phone numbers) |
| **Screen-reader or keyboard user** | Keyboard only, may use a screen reader (see `accessibility-lens`) | 4 / 25 | Hears labels in order, depends on headings and landmarks | Gets stuck on unlabeled controls, focus traps, hover-only menus |
| **Power-user newcomer** | Experienced with similar products, new to this one | 3 / 20 | Scans fast, expects familiar conventions and shortcuts | Assumes other products' patterns, gets annoyed by non-standard names |

## Writing a project persona
1. Name the real audience (for example "shop assistant at the counter, on a shared PC, interrupted often").
2. Fill every card field; give the patience numbers explicitly.
3. List 3 to 5 things they already know (words, concepts) and 3 to 5 they do not.
4. Add the situation: interruptions, time pressure, device, connection quality.
5. Save to the personas file; never include real people, names of customers or contact details.

## Choosing
| Question | Pick |
|---|---|
| Can a new customer sign up and succeed alone? | First-timer |
| Is a risky action safe? | Cautious user |
| Is the phone layout usable? | Impatient mobile (with `mobile-user`) |
| Is the wording clear to everyone? | Non-native speaker (with `copy-and-error-review`) |
| Is it usable without a mouse? | Screen-reader or keyboard user (with `accessibility-lens`) |

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Chose or wrote a user persona") recording the persona used and where a new one was saved.
