#!/usr/bin/env python3
"""Check the pack for broken structure before release.

Usage:
    python validate_pack.py [pack/.claude]

Checks: every skill and agent has frontmatter with matching name and a description; every skill an
agent lists exists; every 'apply the `x` skill' reference points at a real skill; the profile exists.
Exit code 1 when a problem is found. Standard library only.
"""
import re
import sys
from pathlib import Path


def frontmatter(text):
    m = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not m:
        return None
    fm, key = {}, None
    for line in m.group(1).splitlines():
        if re.match(r"^\s+-\s+", line) and key:
            fm.setdefault(key, []).append(line.split("-", 1)[1].strip())
        elif ":" in line:
            key, val = line.split(":", 1)
            key, val = key.strip(), val.strip()
            fm[key] = val if val else []
    return fm


def main():
    root = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parent / "pack" / ".claude")
    problems = []
    skills = {}
    for f in sorted((root / "skills").glob("*/SKILL.md")):
        fm = frontmatter(f.read_text(encoding="utf-8"))
        name = f.parent.name
        if fm is None:
            problems.append(f"{f}: missing frontmatter")
            continue
        if fm.get("name") != name:
            problems.append(f"{f}: name '{fm.get('name')}' does not match folder '{name}'")
        if not fm.get("description"):
            problems.append(f"{f}: missing description")
        skills[name] = f

    agents = {}
    for f in sorted((root / "agents").glob("*.md")):
        fm = frontmatter(f.read_text(encoding="utf-8"))
        if fm is None:
            problems.append(f"{f}: missing frontmatter")
            continue
        if fm.get("name") != f.stem:
            problems.append(f"{f}: name '{fm.get('name')}' does not match file '{f.stem}'")
        if not fm.get("description"):
            problems.append(f"{f}: missing description")
        for s in fm.get("skills", []) or []:
            if s not in skills:
                problems.append(f"{f}: lists unknown skill '{s}'")
        agents[f.stem] = f

    ref = re.compile(r"(?:apply|use|run|with) (?:the )?`([a-z][a-z0-9-]+)`(?: skill)?")
    known = set(skills) | set(agents)
    for f in list(skills.values()) + list(agents.values()):
        for m in ref.finditer(f.read_text(encoding="utf-8")):
            name = m.group(1)
            if name in known or name in {"sqlcmd", "npm", "npx", "git", "python", "db"}:
                continue
            if re.fullmatch(r"[a-z]+-[a-z-]+", name) and name.startswith(("browser-", "test-", "work-", "bug-", "known-", "module-", "feature-", "business-", "mockup-", "db-", "checkin-", "persona-", "user-", "first-", "ux-", "copy-", "accessibility-", "mobile-", "friction-")):
                problems.append(f"{f}: references unknown skill '{name}'")

    if not (root / "project-profile.md").exists():
        problems.append("project-profile.md is missing")

    for p in problems:
        print("PROBLEM:", p)
    print(f"checked {len(skills)} skills, {len(agents)} agents: {'OK' if not problems else str(len(problems)) + ' problem(s)'}")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
