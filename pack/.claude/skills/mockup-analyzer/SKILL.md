---
name: mockup-analyzer
description: Analyze design mockups, wireframes, screenshots, Figma exports, or UI images to understand every component, state, and behavior. Use whenever the user provides a mockup/screenshot/design image or link, or asks to implement, compare, review, or debug a UI against a design. Works with bug-finder and feature-enhancer when a mockup is given.
---

# Mockup Analyzer

Needs a model that can read images. Reads `.claude/project-profile.md` for the design system and stack.

## Rules
- Be concise. No filler.
- Describe only what is visible. Mark anything inferred as "assumed".
- If anything is unclear or missing, ask questions first. Ask as many as needed. Never guess requirements.
- Study the existing codebase and database for clues when available (read-only for the database).
- Analysis comes first. Do not write code until the analysis is confirmed.

## Working with other skills
- **feature-enhancer + mockup:** run this skill first. Its report feeds "Understand the request" and the acceptance criteria.
- **bug-finder + mockup:** treat the mockup as the expected behavior, compare it with the actual UI, and list differences as bugs.
- If both a mockup and an existing implementation exist, map each mockup component to its existing code component (reuse before creating).
- **browser-dev** can later check the built feature against the requirements this analysis produces.

## Clarify first (mandatory when information is missing)
- Final design or draft? Any newer version?
- Platform and breakpoints: web, mobile, tablet, desktop? Responsive rules?
- Which design system, component kit or existing styles should be used?
- Light/dark mode? Branding, fonts, icon source?
- Behavior behind each interactive element (click, hover, submit, drag, swipe)?
- Real data source for each dynamic element (API, database table, static)?
- Missing states: loading, empty, error, success, disabled, long text?
- Roles or permissions that change what is shown?
- Accessibility, localization, RTL?
- Only one screen provided? Ask for the rest of the flow.

Group questions in one numbered list, short and answerable in one line, with a recommended default where helpful. Wait for answers before implementation.

## Workflow

### 1. Overview
Screen name and purpose, user goal, where it sits in the flow (entry and exit points). Layout structure (header, navigation, content, footer, grid), spacing rhythm, visual hierarchy.

### 2. Component inventory
List every component, top to bottom, left to right:

| # | Component | Type | Content/Label | Purpose | States visible | Interaction | Data source |
|---|---|---|---|---|---|---|---|

Group into larger parts (filter bar, data table), mark repeated or reusable components, identify variants and compositions.

### 3. Study each component
- **Visual:** size, spacing, alignment, color (hex if estimable), typography, border, radius, shadow, icon style.
- **Content:** fixed or dynamic, maximum lengths, truncation or wrapping.
- **States:** default, hover, focus, active, disabled, loading, error, empty, selected, expanded.
- **Behavior:** triggers, results, validation, transitions, keyboard use.
- **Data:** fields, formats, sorting, filtering, paging.
- **Responsive and accessibility:** adaptation at small widths, labels, contrast, focus order, roles, alt text.

### 4. Flows and logic
User flows (happy path and alternatives), validation rules and messages shown or implied, conditional UI, where each link or button leads.

### 5. Design tokens
Estimate and flag as approximate: colors (primary, secondary, neutral, semantic), type scale, spacing, radius, shadows, breakpoints. Compare with the project's existing tokens and reuse them.

### 6. Map to the system
Existing components that match (reuse), need changes (extend) or are missing (create). Endpoints, tables, columns and permissions each component needs (check the schema read-only; flag missing fields). Impact on existing screens, routes, state and tests.

### 7. Gaps and risks
Missing states, unclear behavior, inconsistent labels, contrast problems, costly parts, conflicts with existing patterns. Each gap becomes a question or a stated assumption.

### 8. Report

```
Screen:        <name + purpose>
Components:    <count + inventory table>
Key behaviors: <interactions and flows>
Tokens:        <colors/typography/spacing, approx>
Mapping:       <reuse / extend / create + API and data needs>
Gaps/Risks:    <list>
Questions:     <numbered list>
Next step:     <feature-enhancer plan | bug list | awaiting answers>
```

## Bug hunting (mockup vs actual UI)
`Component | Expected (mockup) | Actual | Severity | Likely cause`. Check layout, spacing, colors, typography, missing or extra elements, states, breakpoints, copy, icons, alignment, overflow, behavior.

## Feature development
Turn components into a build checklist: layout, static components, data wiring, interactions, states, responsive, accessibility, tests. Add acceptance criteria per component (visual match and behavior). Verify side by side when done.

## Don'ts
- Don't invent behavior or data that is not visible without marking it "assumed".
- Don't skip hidden states (empty, error, loading).
- Don't create a component when an existing one fits.
- Don't ignore the design system for pixel-perfect copying.
- Don't start coding before the analysis is confirmed.

## Work log
When the task is finished, apply the `work-log` skill: add a row for this skill ("Analysed a mockup") recording the screen analysed, and the gaps and questions raised.
