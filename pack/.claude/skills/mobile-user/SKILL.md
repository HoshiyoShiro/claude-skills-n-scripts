---
name: mobile-user
description: Re-run user goals on a phone-sized viewport with touch input and a slow connection, as a one-handed, impatient mobile user. Finds tiny tap targets, horizontal scrolling, covered content, hover-only features and slow pages. Use with naive-user for the impatient-mobile persona or when asked whether the product works on a phone.
---

# Mobile user

Same goals as a desktop run, but the person is on a phone. Uses `browser-setup` with `device: 'phone'`, and the persona is usually **Impatient mobile** from `persona-library`.

## Rules
- Use touch events (`tap`), not mouse hover or right click.
- Test at least two sizes: 390x844 and a small 360x640. Portrait first; check landscape once on the main task.
- A desktop-only feature is not a defect if the product states it; otherwise a missing mobile path is a finding.
- This is an emulation, not a real device. State that in the report.

## Runs
1. **Layout:** no horizontal scrolling, text readable without zoom, nothing cut off or overlapping, sticky headers and footers not covering content or the keyboard area, modals fit the screen and can be closed.
2. **Touch targets:** primary targets are at least 44x44 CSS px (the stricter practical guide; 24x24 is the WCAG 2.2 AA minimum) with spacing between neighbours. Measure with `boundingBox()`; list the small ones on the main path.
3. **Input:** fields use the right keyboard type (`type`, `inputmode`, `autocomplete`); labels stay visible after focus; no tiny date pickers; typing is not required where a selection would do.
4. **Navigation:** the menu is reachable and understandable on a small screen, and the back button behaves; no feature depends on hover.
5. **Speed:** apply a slow connection with the Chrome DevTools Protocol (`Network.emulateNetworkConditions`, about 1.6 Mbps down, 150 ms latency) and CPU throttling 4x. Note any wait over 3 seconds with no progress indicator, and double-submit risk when the person taps twice.
6. **Interruption:** reload mid-form, background and return (page reload as a stand-in). Is the entered data lost? Is the person told?
7. **Goals:** run the same goals as the desktop run, with the persona's lower patience, and compare the outcomes.

## Report
```
Persona: <one line>   Device: 390x844 and 360x640, touch, throttled network   Date: <date time>

| Goal | Desktop outcome | Phone outcome | Difference |
|------|-----------------|---------------|------------|

Findings (worst first)
| # | Where | What happened | Type | Severity | Evidence |
|---|-------|---------------|------|----------|----------|

Small targets on the main path
| Screen | Control | Size | Neighbour spacing |

What worked well
- <good mobile choices>

Limits: emulated viewport; real device features (camera, share sheet, biometric, true keyboard behavior) not covered.
```
Types and severity follow `ux-heuristics` (use "mobile barrier" where nothing more specific fits).

## Don'ts
- Don't use mouse-only actions.
- Don't judge on one screen size.
- Don't claim real-device coverage.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Ran a mobile user check") recording sizes, goals run, findings by severity and the desktop-versus-phone differences.
