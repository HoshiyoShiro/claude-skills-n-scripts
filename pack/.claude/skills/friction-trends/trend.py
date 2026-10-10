#!/usr/bin/env python3
"""Compare the two most recent comparable UX runs in a history folder.

Usage:
    python trend.py <history-dir>

Reads runs.csv and findings.csv (see SKILL.md). Standard library only.
"""
import csv
import sys
from collections import defaultdict
from pathlib import Path


def read(path):
    if not path.exists():
        return []
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    d = Path(sys.argv[1])
    runs, findings = read(d / "runs.csv"), read(d / "findings.csv")
    if not runs:
        print("no runs recorded yet")
        return 0

    # A run is identified by date + build; group rows per run.
    by_run = defaultdict(list)
    for r in runs:
        by_run[(r["date"], r["build"])].append(r)
    order = sorted(by_run)  # oldest to newest by date string
    if len(order) < 2:
        print("only one run recorded; nothing to compare yet")
        return 0

    new_key, new_rows = order[-1], by_run[order[-1]]

    def signature(rows):
        return (
            {r["persona"] for r in rows},
            {r["device"] for r in rows},
            {r["goal_id"] for r in rows},
        )

    prev_key = next((k for k in reversed(order[:-1]) if signature(by_run[k]) == signature(new_rows)), None)
    if prev_key is None:
        print(f"latest run {new_key}: no earlier run with the same persona, goals and device -> not comparable")
        return 0
    prev_rows = by_run[prev_key]

    def ease(rows):
        vals = [float(r["ease_score"]) for r in rows if r.get("ease_score")]
        return sum(vals) / len(vals) if vals else 0.0

    def outcomes(rows):
        c = defaultdict(int)
        for r in rows:
            c[r["outcome"]] += 1
        return dict(c)

    def keys(run_key):
        return {f["finding_key"]: f for f in findings if (f["date"], f["build"]) == run_key}

    a, b = keys(prev_key), keys(new_key)
    earlier = set()
    for k in order[: order.index(prev_key)]:
        earlier |= set(keys(k))
    fixed = sorted(set(a) - set(b))
    new = sorted(set(b) - set(a) - earlier)
    came_back = sorted((set(b) - set(a)) & earlier)
    still = sorted(set(a) & set(b))

    ea, eb = ease(prev_rows), ease(new_rows)
    delta = eb - ea
    print(f"Compared: {prev_key[0]} ({prev_key[1]}) -> {new_key[0]} ({new_key[1]})   Comparable: yes")
    print(f"Ease score: {ea:.1f} -> {eb:.1f} ({delta:+.1f})")
    print(f"Outcomes:   {outcomes(prev_rows)} -> {outcomes(new_rows)}")
    print(f"Fixed ({len(fixed)}):      {', '.join(fixed) or '-'}")
    print(f"New ({len(new)}):        {', '.join(new) or '-'}")
    print(f"Came back ({len(came_back)}): {', '.join(came_back) or '-'}")
    for k in still:
        sa, sb = a[k]["severity"], b[k]["severity"]
        note = "" if sa == sb else f"  severity {sa} -> {sb}"
        print(f"Still open: {k}{note}")
    blockers = [k for k in b if b[k]["severity"].lower() == "blocker"]
    verdict = "better" if delta > 0.25 and not blockers else "worse" if delta < -0.25 or came_back else "same"
    print(f"Verdict: {verdict}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
