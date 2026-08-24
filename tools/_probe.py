# -*- coding: utf-8 -*-
"""The bountiful run's chunk log: what fed her, and did anything unattributable slip past?

Same reader as before. Positive control: events WITH a chunk must show gains, or nothing
below means anything.
"""
import io
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
lines = io.open(SV, encoding="utf-8", errors="replace").read().splitlines()

start = next((n for n, l in enumerate(lines) if '["chunkLog"]' in l), None)
if start is None:
    raise SystemExit("No chunkLog in SavedVariables.")
depth, end = 0, len(lines)
for n in range(start, len(lines)):
    depth += lines[n].count("{") - lines[n].count("}")
    if n > start and depth <= 0:
        end = n
        break

rows, cur, d = [], [], 0
for n in range(start + 1, end):
    l = lines[n]
    if d == 0 and l.strip() == "{":
        cur, d = [], 1
        continue
    if d > 0:
        d += l.count("{") - l.count("}")
        if d <= 0:
            rows.append("\n".join(cur))
            d = 0
        else:
            cur.append(l)


def num(r, key):
    m = re.search(r'\["%s"\]\s*=\s*(-?\d+)' % key, r)
    return int(m.group(1)) if m else None


new = [r for r in rows if '["items"]' in r or '["chunks"]' in r]
print("events: %d (per-event rows: %d)\n" % (len(rows), len(new)))

gained = [r for r in new if (num(r, "gained") or 0) > 0]
withchunk = [r for r in gained if (num(r, "chunks") or 0) > 0]
nochunk = [r for r in gained if (num(r, "chunks") or 0) == 0]
print("events with a gain: %d   (with a chunk: %d = positive control, without: %d)"
      % (len(gained), len(withchunk), len(nochunk)))

if not withchunk:
    raise SystemExit("\nNo chunk event gained -- the log is broken, read nothing into the rest.")

print("\nGAINS WITH NO CHUNK — what else paid:")
tally = {}
for r in nochunk:
    names = re.findall(r'\["name"\]\s*=\s*"([^"]*)"', r)
    g = num(r, "gained")
    print("   +%-7s  %s" % (g, ", ".join(names) or "(unnamed)"))
    for nm in names:
        tally[nm] = tally.get(nm, 0) + 1

print("\nby item:")
for nm in sorted(tally, key=lambda k: -tally[k]):
    print("   %-32s %d" % (nm, tally[nm]))

# Events with several items and a gain: unattributable by design, worth knowing the size of.
multi = [r for r in gained if len(re.findall(r'\["id"\]', r)) > 1]
print("\nmulti-item events with a gain (not attributable): %d" % len(multi))
