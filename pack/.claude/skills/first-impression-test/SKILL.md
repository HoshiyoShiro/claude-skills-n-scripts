---
name: first-impression-test
description: Five-second test of a screen and a label-guess test of the navigation, done as a first-time user. Judges whether a person understands what a page is for, who it is for and what to do first, before using it. Use when checking a landing page, dashboard, empty state or the main menu, or when naive-user starts a session.
---

# First-impression test

People decide in seconds whether they understand a screen. This skill measures that without any prior knowledge. It runs as the `naive-user` persona and uses `browser-setup`.

## Rules
- Answer **before** looking at the intended purpose. Write the answers to a file first; only then read the profile's intended-purpose line and compare.
- One look, one screenshot, answers from memory of what was on the screen, as a real person would.
- No scrolling in the first look; what is above the fold is what counts.
- Report what was understood, not what was meant.

## Part 1: five-second screen test
1. Open the page at its normal entry point. Take a screenshot at the viewport size of the persona's device. Do not interact.
2. Write the answers, short and in the person's words:
   - **What is this for?**
   - **Who is it for?**
   - **What would I click first, and why?**
   - **What worries or confuses me?**
   - **What do I expect to find if I keep going?**
3. Rate each: **clear**, **partly clear** or **unclear**, and note your confidence.
4. Now compare with the intended purpose from the profile. Record the match: **same**, **close**, **different**, **no idea**.

## Part 2: navigation label guess
1. List every top-level menu or tab label visible on first view, in order.
2. For each, write what you expect to find behind it, in one line, before opening anything.
3. Open each and record what was actually there. Rate the match: **as expected**, **partly**, **surprise**.
4. Score: label match rate = as expected ÷ total labels. Under 70 percent is a finding.
5. Note labels that sound the same, labels that are jargon, icon-only items, items hidden under "More", and anything you would not have found without being told.

## Part 3: empty and first-run state
If the first screen after login is empty, say whether it tells you what to do next. An empty state with no guidance is a finding.

## Report
```
Screen: <name>   Persona: <one line>   Device: <desktop | phone>   Date: <date time>

Five-second answers
| Question | Answer | Clarity | Matches intent |
|---|---|---|---|

Navigation label guess
| Label | I expected | Actual | Match |
|---|---|---|---|
Label match rate: <n of m> (<percent>)

Findings
- <label or screen element, what a person would think, severity>
```
Severity and scoring follow `ux-heuristics`.

## Don'ts
- Don't read the page's text carefully; a five-second look is skimming.
- Don't read docs, code or the intended purpose before answering.
- Don't click anything in Part 1.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Ran a first-impression test") recording the screens tested, the label match rate and the main findings.
