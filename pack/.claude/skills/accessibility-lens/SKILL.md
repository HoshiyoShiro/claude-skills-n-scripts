---
name: accessibility-lens
description: Re-run a user goal with a keyboard only, at 200 percent zoom, and with attention to labels, focus and contrast, as a user who cannot use a mouse or sees poorly would. Reports accessibility barriers against WCAG 2.2 AA. Use with naive-user for keyboard or screen-reader personas, or when asked whether the product is accessible.
---

# Accessibility lens

Same goals as a normal run, different constraints. Uses `browser-setup`. It finds common barriers; it does not replace testing with a real screen reader or an expert audit, and it says so in the report.

## Rules
- The persona is a person, not a checklist: the question is "could they finish the goal", then "which rule did the barrier break".
- Keyboard-only means no mouse for the whole run: no `click()` on elements unless it was reached with Tab and activated with Enter or Space.
- Report observed barriers with evidence; do not claim conformance.

## Runs
### 1. Keyboard only
- Tab, Shift+Tab, Enter, Space, arrow keys, Escape only.
- Record: can every control be reached; is the **focus visible** at all times; is the **tab order** logical; any **keyboard trap** (focus cannot leave a dialog or widget); does Escape close dialogs and return focus to where it came from; do custom controls (menus, tabs, date pickers) work with arrow keys; is there a **skip link** past repeated navigation; does anything work only on hover.

### 2. Zoom and text size
- 200 percent browser zoom (equivalent to a 720 px wide viewport) and text-only enlargement.
- Record: content cut off, overlapped or needing two-direction scrolling; controls pushed off-screen; fixed bars covering content.

### 3. Names, roles and structure
- Use `locator.ariaSnapshot()` on each page to read what a screen reader would get.
- Record: controls without an accessible name (icon buttons), inputs without a label, images without text alternatives where they carry meaning, missing or skipped heading levels, no landmarks (`main`, `nav`), link text like "click here", status messages (saved, error) not announced (no live region or role).

### 4. Colour and contrast
- Measure text and control contrast with a script on computed styles: ratio of at least 4.5:1 for normal text, 3:1 for large text and for borders of controls.
- Record: information shown by colour alone (red field with no text), low-contrast placeholder or disabled-looking active controls, focus indicator contrast.

### 5. Motion and time
- Note auto-moving content that cannot be stopped, session timeouts with no warning, and anything that flashes.

### Optional automated pass
`@axe-core/playwright` (pin the version) gives a list of machine-detectable violations. Treat it as a hint list: it finds about a third of real issues; the manual runs above find the rest.

## Mapping to WCAG 2.2 AA (examples)
| Barrier | Criterion |
|---|---|
| Not reachable by keyboard | 2.1.1 Keyboard |
| Keyboard trap | 2.1.2 No keyboard trap |
| Focus not visible | 2.4.7 Focus visible |
| Illogical focus order | 2.4.3 Focus order |
| Missing label or name | 1.3.1 Info and relationships, 4.1.2 Name, role, value |
| Contrast too low | 1.4.3 Contrast (minimum), 1.4.11 Non-text contrast |
| Content lost at zoom | 1.4.4 Resize text, 1.4.10 Reflow |
| Color only | 1.4.1 Use of color |
| Target too small | 2.5.8 Target size (minimum) |
| Status not announced | 4.1.3 Status messages |

## Report
```
Persona: <one line>   Goals run: <list>   Date: <date time>

| Goal | Keyboard-only outcome | At 200 percent | Blocking barrier |
|------|-----------------------|----------------|------------------|

Barriers (worst first)
| # | Where | What happened | Criterion | Severity | Evidence |
|---|-------|---------------|-----------|----------|----------|

What worked well
- <good focus handling, labels, headings>

Limits of this check: not tested with a real screen reader or assistive hardware.
```
Severity follows `ux-heuristics`: a barrier that stops the goal is a Blocker.

## Don'ts
- Don't use the mouse in the keyboard run.
- Don't call a page accessible because the automated pass is clean.
- Don't fix code from here.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Ran an accessibility check") recording the goals run, barriers by severity and the limits stated.
