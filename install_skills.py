#!/usr/bin/env python3
"""Copy the portable skills and agents from pack/.claude into a target project.

Usage:
    python install_skills.py <target-project-dir> [--source DIR] [--force] [--only name1,name2] [--no-agents]

Existing files are never overwritten unless --force is given. Also appends the git-ignore lines
the skills need. Nothing is executed and no network is used.
"""
import argparse
import re
import shutil
import sys
from pathlib import Path

GITIGNORE_LINES = [
    ".claude/skills/browser-qa/accounts.local.json",
    ".claude/skills/db-access/environments.local.conf",
    ".claude/logs/",
]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("target")
    ap.add_argument("--source", help="a .claude folder to copy from; default: pack/.claude next to this script")
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--no-agents", action="store_true", help="skip .claude/agents/")
    ap.add_argument("--only", default="", help="comma-separated skill names (profile is always included)")
    a = ap.parse_args()

    target = Path(a.target).resolve()
    if not target.is_dir():
        print(f"target is not a folder: {target}", file=sys.stderr)
        return 2
    source = Path(a.source).resolve() if a.source else Path(__file__).parent / "pack" / ".claude"
    if not source.is_dir():
        print(f"source folder not found: {source}", file=sys.stderr)
        return 2

    only = {s.strip() for s in a.only.split(",") if s.strip()}
    written = skipped = 0
    for src in sorted(p for p in source.rglob("*") if p.is_file()):
        rel = src.relative_to(source)
        parts = rel.parts
        if only and parts[0] == "skills" and parts[1] not in only:
            continue
        if a.no_agents and parts[0] == "agents":
            continue
        dest = target / ".claude" / rel
        if dest.exists() and not a.force:
            print(f"skip (exists): .claude/{rel.as_posix()}")
            skipped += 1
            continue
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
        shutil.copymode(src, dest)
        print(f"wrote: .claude/{rel.as_posix()}")
        written += 1

    gi = target / ".gitignore"
    existing = gi.read_text(encoding="utf-8") if gi.exists() else ""
    missing = [l for l in GITIGNORE_LINES if l not in existing.splitlines()]
    if missing:
        with gi.open("a", encoding="utf-8", newline="\n") as f:
            if existing and not existing.endswith("\n"):
                f.write("\n")
            f.write("\n# Portable skills: local-only files\n" + "\n".join(missing) + "\n")
        print(f"updated .gitignore (+{len(missing)} lines)")

    # Warn about skills the installed files mention but that are not installed.
    available = {p.name for p in (source / "skills").iterdir() if p.is_dir()}
    installed = {p.name for p in (target / ".claude" / "skills").glob("*") if p.is_dir()}
    mentioned = set()
    for md in list((target / ".claude" / "skills").rglob("*.md")) + list((target / ".claude" / "agents").glob("*.md")):
        mentioned |= set(re.findall(r"`([a-z][a-z0-9-]+)`", md.read_text(encoding="utf-8")))
    missing = sorted((mentioned & available) - installed)
    if missing:
        print("note: installed files mention skills that are not installed: " + ", ".join(missing))
        print("      add them with --only, or ignore if you do not use those features")

    print(f"done: {written} written, {skipped} skipped")
    print("next: fill in .claude/project-profile.md, then copy the example files (see docs/INSTRUCTIONS.md)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
