# -*- coding: utf-8 -*-
"""C1: does every event MH registers exist in Blizzard's own list? (plan deel 2; Rob 10 Nov 2026: "Ja, stap 2")

Reads tools/blizzard_events_snapshot.json (made by event_snapshot.py from Gethe/wow-ui-source) and every literal
event name in RegisterEvent / RegisterUnitEvent calls of the files the two .toc files load.
  - MidnightHelper.toc (retail) is checked against `live` + `ptr`; MidnightHelper_Camelot.toc (Forever) against
    `forever`. A file that returns at its top on the other game (`if not ns.IS_FOREVER then return end` and the
    reverse) is skipped for that game.
  - A registration inside pcall(...) is listed apart: it cannot break a reload, someone already guarded it.
⚠️ A name outside the list is "nakijken", never "fout": not measured how complete Blizzard's documentation is.
⚠️ Calls with a variable (`f:RegisterEvent(e)` in a loop) are counted as a blind spot, not checked.
⚠️ The snapshot says its own build and date; the check says aloud when it is older than the newest Interface in the
   .toc or older than STALE_DAYS (a silent stale list is the cache trap from CLAUDE.md).

Usage:  run event_check              -> the report
        run event_check --selftest   -> LEARNED_SPELL_IN_TAB (the 8 Aug 2026 fault) must come out as nakijken
"""
import datetime
import io
import json
import os
import re
import sys

STALE_DAYS = 28
# MH_EVENT_SNAPSHOT: the nightly watcher fetches a fresh list into a temp file and checks against that, so it can
# report "the repo's snapshot is behind" while touching only its own report file (one writer per file).
SNAP = os.environ.get("MH_EVENT_SNAPSHOT") or os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                                           "blizzard_events_snapshot.json")
LIT = re.compile(r'(pcall\(\s*)?[\w.:]*Register(?:Unit)?Event[\s(,]*(?:[\w.]+\s*,\s*)?"([A-Z][A-Z0-9_]+)"')
VAR = re.compile(r'Register(?:Unit)?Event\(\s*[a-z_][\w.]*\s*[,)]')
TOP_FOREVER_ONLY = re.compile(r'^if not ns\.IS_FOREVER then\s*(?:return|\r?\n\s*return)', re.M)
TOP_RETAIL_ONLY = re.compile(r'^if ns\.IS_FOREVER then\s*(?:return|\r?\n\s*return)', re.M)


def toc_files(root, toc):
    out = []
    p = os.path.join(root, toc)
    if not os.path.isfile(p):
        return out
    with open(p, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#") and line.lower().endswith(".lua"):
                out.append(line.replace("\\", "/"))
    return out


def toc_max_interface(root):
    best = 0
    with open(os.path.join(root, "MidnightHelper.toc"), encoding="utf-8", errors="replace") as fh:
        for line in fh:
            if line.startswith("## Interface:"):
                best = max([best] + [int(x) for x in re.findall(r"\d+", line)])
    return best


def build_to_interface(build):
    m = re.match(r"(\d+)\.(\d+)\.(\d+)", build or "")
    return int(m.group(1)) * 10000 + int(m.group(2)) * 100 + int(m.group(3)) if m else 0


def scan(root, files, skip_re):
    found, guarded, blind, skipped = {}, {}, 0, []
    for rel in files:
        p = os.path.join(root, rel)
        if not os.path.isfile(p):
            continue
        with open(p, encoding="utf-8", errors="replace") as fh:
            src = fh.read()
        if skip_re and skip_re.search("\n".join(src.splitlines()[:60])):
            skipped.append(rel)
            continue
        for n, line in enumerate(src.splitlines(), 1):
            s = line.lstrip()
            if s.startswith("--"):
                continue
            for m in LIT.finditer(line):
                (guarded if m.group(1) else found).setdefault(m.group(2), []).append("%s:%d" % (rel, n))
            blind += len(VAR.findall(line))
    return found, guarded, blind, skipped


def run(root, extra_src=None):
    """Returns (report_lines, nakijken_count, stale_warnings, control_ok)."""
    lines, stale = [], []
    if not os.path.isfile(SNAP):
        return ["snapshot missing: run event_snapshot --write"], 0, ["no snapshot"], False
    with open(SNAP, encoding="utf-8") as fh:
        snap = json.load(fh)
    br = snap["branches"]
    fetched = datetime.date.fromisoformat(snap["fetched"])
    age = (datetime.date.today() - fetched).days
    if age > STALE_DAYS:
        stale.append("snapshot is %d days old (fetched %s): run event_snapshot --write" % (age, snap["fetched"]))
    newest = max(build_to_interface(b["build"]) for k, b in br.items() if k in ("live", "ptr"))
    want = toc_max_interface(root)
    if newest < want:
        stale.append("snapshot's newest retail build is %d, the .toc declares %d: refresh the snapshot" % (newest, want))
    retail_list = set(br.get("live", {}).get("events", [])) | set(br.get("ptr", {}).get("events", []))
    forever_list = set(br.get("forever", {}).get("events", []))
    lines.append("snapshot %s · live %s · ptr %s · forever %s" % (
        snap["fetched"], br.get("live", {}).get("build"), br.get("ptr", {}).get("build"), br.get("forever", {}).get("build")))
    total = 0
    games = (("retail", "MidnightHelper.toc", retail_list, TOP_FOREVER_ONLY),
             ("Forever", "MidnightHelper_Camelot.toc", forever_list, TOP_RETAIL_ONLY))
    for game, toc, known, skip_re in games:
        files = toc_files(root, toc)
        found, guarded, blind, skipped = scan(root, files, skip_re)
        if not known:
            lines.append("%s: NOT CHECKED — no event list for this game in the snapshot" % game)
            continue
        miss = sorted(e for e in found if e not in known)
        gmiss = sorted(e for e in guarded if e not in known)
        total += len(miss)
        lines.append("%s (%s, %d files, %d skipped as other-game-only): %d distinct events, %d in pcall, %d calls with a "
                     "variable (blind spot)" % (game, toc, len(files), len(skipped), len(found), len(guarded), blind))
        for e in miss:
            lines.append("   nakijken  %-40s %s" % (e, ", ".join(found[e][:3])))
        for e in gmiss:
            lines.append("   in pcall  %-40s %s (guarded, cannot break a reload)" % (e, ", ".join(guarded[e][:2])))
    # Positive control in the same run: the 8 Aug 2026 fault must not be in the retail list.
    control_ok = "LEARNED_SPELL_IN_TAB" not in retail_list and "PLAYER_LOGIN" in retail_list
    return lines, total, stale, control_ok


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    lines, total, stale, ok = run(root)
    for l in lines:
        print(l)
    for s in stale:
        print("STALE", s)
    print("positive control (LEARNED_SPELL_IN_TAB, the 8 Aug 2026 fault, is NOT in the retail list; PLAYER_LOGIN is):",
          "OK" if ok else "FAILED")
    if "--selftest" in sys.argv[1:]:
        found, _, _, _ = scan(root, [], None)
        src = 'f:RegisterEvent("LEARNED_SPELL_IN_TAB")'
        m = LIT.search(src)
        print("selftest: the scanner reads", m and m.group(2), "from", src)
        return 0 if ok and m and m.group(2) == "LEARNED_SPELL_IN_TAB" else 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
