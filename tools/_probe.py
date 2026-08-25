# -*- coding: utf-8 -*-
"""The control run: is the chunk log EMPTY?

Rob killed things in a delve and looted nothing, and Valeera's standing rose. An empty log
is the proof that no loot event fired -- without it we are trusting that autoloot stayed
quiet, which is the one thing that could void the test.

⚠️ Absence is only evidence if the probe can find something when it is there. So this also
reports whether the key exists at all: "no chunkLog key" and "chunkLog with zero rows" are
different answers, and only the second one means anything.
"""
import io
import os
import sys
import time

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
print("file written: %s (%.1f minutes ago)" % (
    time.strftime("%H:%M:%S", time.localtime(os.path.getmtime(SV))),
    (time.time() - os.path.getmtime(SV)) / 60.0))

lines = io.open(SV, encoding="utf-8", errors="replace").read().splitlines()
start = next((n for n, l in enumerate(lines) if '["chunkLog"]' in l), None)
if start is None:
    print("\nNo chunkLog key at all -- logging was off, or the reload has not landed yet.")
    print("That is NOT the same as 'nothing was looted'.")
    raise SystemExit(0)

depth, end = 0, len(lines)
for n in range(start, len(lines)):
    depth += lines[n].count("{") - lines[n].count("}")
    if n > start and depth <= 0:
        end = n
        break

rows, d = 0, 0
for n in range(start + 1, end):
    l = lines[n]
    if d == 0 and l.strip() == "{":
        rows += 1
        d = 1
        continue
    if d > 0:
        d += l.count("{") - l.count("}")
        if d <= 0:
            d = 0

print("\nchunkLog present: lines %d..%d" % (start, end))
print("loot events recorded: %d" % rows)
if rows == 0:
    print("\n✅ EMPTY. No loot event fired, so the XP gain came from something that is not")
    print("   loot -- the kills. The control holds.")
else:
    print("\n⚠️ NOT empty. Something was looted after all, so this run cannot settle it.")
    for n in range(start, min(end, start + 40)):
        print("   " + lines[n])
