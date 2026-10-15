"""What changed in HandyNotes_Midnight since the last look? Part of the morning round.

    probe_job.txt:  run handynotes_watch

Rob, 15 Oct 2026: HandyNotes is "meestal de beste bron van allemaal", and after an update "op alles, en dat moet
eigenlijk altijd". That day version 158 quietly added quest ids to every Labyrinth chest and placed five sealed chests no
guide had; nobody would have noticed without opening the file. addon_updates only says THAT the version moved.

This keeps a copy of HandyNotes_Midnight's zone files from the last run in tools/handynotes_snapshot/ (local, not in git:
it describes one machine) and prints, per zone, the lines that were added or removed since then, with the coordinates
(XXXXYYYY -> XX.XX/YY.YY, truncated like HandyNotes) and quest/npc ids pulled out. It does NOT judge relevance: the
reader compares against MH's own data (Modules/DelveChestData.lua, the rare and treasure lists, Codex {WAY} links).

First run (no snapshot yet): records everything, reports only the version and file count, so there is a baseline.
"""
import difflib
import glob
import io
import os
import re
import shutil

HERE = os.path.dirname(os.path.abspath(__file__))
ADDONS = os.path.dirname(os.path.dirname(HERE))
HN = os.path.join(ADDONS, "HandyNotes_Midnight")
SNAP = os.path.join(HERE, "handynotes_snapshot")
MAX_LINES = 40  # per zone; a whole new zone file is summarised, not dumped

COORD = re.compile(r"\b(\d{8})\b")
IDS = re.compile(r"\b(quest|id|npcID|npc|questID)\s*=\s*\{?\s*(\d{4,7})")


def version():
    toc = os.path.join(HN, "HandyNotes_Midnight.toc")
    try:
        for line in io.open(toc, encoding="utf-8-sig", errors="replace"):
            m = re.match(r"^##\s*Version\s*:\s*(.+)$", line.strip(), re.I)
            if m:
                return m.group(1).strip()
    except OSError:
        pass
    return "?"


def describe(line):
    """The line, plus its coordinates and ids in plain form."""
    bits = []
    for c in COORD.findall(line):
        bits.append("%d.%02d/%d.%02d" % (int(c[:2]), int(c[2:4]), int(c[4:6]), int(c[6:8])))
    named = IDS.findall(line)
    for k, v in named:
        bits.append("%s %s" % (k, v))
    if not named:
        # Positional helpers like AddAncientChest(coord, quest, ...): a bare 5-7 digit number is an id.
        for v in re.findall(r"(?<![\d.])(\d{5,7})(?![\d.])", line):
            bits.append("id " + v)
    s = line.strip()
    if len(s) > 150:
        s = s[:147] + "..."
    return s + (("   [" + ", ".join(bits) + "]") if bits else "")


def main():
    if not os.path.isdir(HN):
        print("HandyNotes_Midnight is not installed at", HN)
        return 1
    ver = version()
    files = sorted(glob.glob(os.path.join(HN, "zones", "*.lua")))
    seen_ver_path = os.path.join(SNAP, "VERSION.txt")
    if not os.path.isdir(SNAP):
        os.makedirs(SNAP)
        for p in files:
            shutil.copy2(p, os.path.join(SNAP, os.path.basename(p)))
        io.open(seen_ver_path, "w", encoding="utf-8").write(ver)
        print("HandyNotes_Midnight %s: baseline recorded (%d zone files). Next run shows what changed." % (ver, len(files)))
        return 0
    old_ver = io.open(seen_ver_path, encoding="utf-8").read().strip() if os.path.exists(seen_ver_path) else "?"
    print("HandyNotes_Midnight: last seen %s, now %s" % (old_ver, ver))
    changed = 0
    old_names = {os.path.basename(p) for p in glob.glob(os.path.join(SNAP, "*.lua"))}
    for p in files:
        name = os.path.basename(p)
        new = io.open(p, encoding="utf-8", errors="replace").read().splitlines()
        snap = os.path.join(SNAP, name)
        if name not in old_names:
            changed += 1
            print("\n== %s: NEW zone file (%d lines, %d coordinates)" % (name, len(new), sum(len(COORD.findall(l)) for l in new)))
            continue
        old = io.open(snap, encoding="utf-8", errors="replace").read().splitlines()
        if old == new:
            continue
        changed += 1
        diff = [l for l in difflib.unified_diff(old, new, lineterm="", n=0) if l[:1] in "+-" and l[:3] not in ("+++", "---")]
        adds = sum(1 for l in diff if l.startswith("+"))
        print("\n== %s: +%d / -%d lines" % (name, adds, len(diff) - adds))
        for l in diff[:MAX_LINES]:
            print("  " + l[0] + " " + describe(l[1:]))
        if len(diff) > MAX_LINES:
            print("  ... %d more" % (len(diff) - MAX_LINES))
    for name in sorted(old_names - {os.path.basename(p) for p in files}):
        changed += 1
        print("\n== %s: zone file REMOVED" % name)
    if not changed:
        print("No zone file changed.")
    # Move the baseline forward only after printing, so a crash above shows the same diff again next time.
    for p in glob.glob(os.path.join(SNAP, "*.lua")):
        os.remove(p)
    for p in files:
        shutil.copy2(p, os.path.join(SNAP, os.path.basename(p)))
    io.open(seen_ver_path, "w", encoding="utf-8").write(ver)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
