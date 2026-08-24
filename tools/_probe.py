# -*- coding: utf-8 -*-
"""How many distinct Midnight delves does the roster actually carry?

The CurseForge page claims 13. Venomfall Deeps went in today on TWO maps with one poiID, so
counting rows would give 14 and be wrong by one. Count distinct NAMES.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
text = io.open(os.path.join(REPO, "Modules", "Delves.lua"), encoding="utf-8").read()

m = re.search(r"MIDNIGHT_DELVES\s*=\s*\{(.*?)\n\}", text, re.S)
if not m:
    raise SystemExit("Could not find the roster table -- do not trust any number below.")
rows = re.findall(r'\{\s*(\d+)\s*,\s*(\d+)\s*,\s*[\d.]+\s*,\s*[\d.]+\s*,\s*"([^"]+)"', m.group(1))
names = {}
for poi, mapid, name in rows:
    names.setdefault(name, []).append((poi, mapid))

print("rows: %d   distinct delves: %d\n" % (len(rows), len(names)))
for name in sorted(names):
    where = names[name]
    extra = "   (%d maps: %s)" % (len(where), ", ".join(w[1] for w in where)) if len(where) > 1 else ""
    print("   %-32s poi %-6s%s" % (name, where[0][0], extra))
