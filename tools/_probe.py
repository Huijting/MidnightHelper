# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: merge Zygor's 671 flight points into Modules/FlightPointsData.lua.

⚠️ UNION, AND OURS WINS. The diff showed two stops that exist only in our table —
Amani Foothold (Eagletender Mal'Tiki, in the Vaults) and Atal'Aman — because we
measured them and Zygor does not carry them under that map. A regenerate that
simply overwrote the file would delete two things we know are right in exchange
for 671 we have not checked.

So: keep every row we already ship, add everything of theirs we do not have, and
mark which is which in the file itself.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

ADDONS = r'E:\World of Warcraft\_retail_\Interface\AddOns'
TAXI = os.path.join(ADDONS, 'ZygorGuidesViewer', 'Libs-Retail', 'LibTaxi-1.0', 'data.lua')
ROVER = os.path.join(ADDONS, 'ZygorGuidesViewer', 'Libs-Retail', 'LibRover-1.0', 'data.lua')
OURS = os.path.join(ADDONS, 'MidnightHelper', 'Modules', 'FlightPointsData.lua')


def read(p):
    return io.open(p, encoding='utf-8', errors='replace').read()


rover = read(ROVER)
name_to_map = {}
for m in re.finditer(r'^\["([^"]+)"\]\s*=\s*\{(.*?)\}\s*,?\s*$', rover, re.M):
    floors = {int(f.group(1)): int(f.group(2))
              for f in re.finditer(r'\[(\d+)\]\s*=\s*(\d+)', m.group(2))}
    if floors:
        name_to_map[m.group(1)] = floors


def resolve(zykey):
    floor, base = 0, zykey
    if '/' in zykey:
        base, _, f = zykey.rpartition('/')
        try:
            floor = int(f)
        except ValueError:
            base = zykey
    floors = name_to_map.get(base) or name_to_map.get(zykey)
    if not floors:
        return None
    return floors.get(floor) or floors.get(0) or next(iter(floors.values()))


taxi = read(TAXI)
theirs = {}
for zykey, body in re.findall(r"\['([^']+)'\]\s*=\s*\{(.*?)\n\s*\},", taxi, re.S):
    mapID = resolve(zykey)
    if not mapID:
        continue
    for m in re.finditer(
            r'\{name="([^"]+)"\s*,\s*faction="(\w)"\s*,\s*npc="([^"]*)"'
            r'(?:\s*,\s*npcid=(\d+))?\s*,\s*x=([\d.]+)\s*,\s*y=([\d.]+)', body):
        theirs.setdefault(mapID, []).append(
            (m.group(1), float(m.group(5)), float(m.group(6)), m.group(2)))

# ---- what we already ship ----------------------------------------------------
src = read(OURS)
head = src[:src.index('ns.FLIGHT_POINTS = {')]
tail = src[src.index('--- uiMapID -> { { name, x, y }, ... }'):]
tail = tail[tail.index('function ns.GetNearestFlightPoint'):]

mine, cur = {}, None
for line in src.split('\n'):
    m = re.match(r'\s*\[(\d+)\]\s*=\s*\{', line)
    if m:
        cur = int(m.group(1))
        mine[cur] = []
        continue
    m = re.match(r'\s*\{\s*"([^"]+)"\s*,\s*([\d.]+)\s*,\s*([\d.]+)', line)
    if m and cur:
        mine[cur].append((m.group(1), float(m.group(2)), float(m.group(3)), 'B'))

kept = sum(len(v) for v in mine.values())
merged, added = {}, 0
for mid in set(mine) | set(theirs):
    rows, seen = [], set()
    for r in mine.get(mid, []):          # ours first: measured beats harvested
        if r[0] not in seen:
            seen.add(r[0])
            rows.append(r)
    for r in theirs.get(mid, []):
        if r[0] not in seen:
            seen.add(r[0])
            rows.append(r)
            added += 1
    rows.sort(key=lambda r: r[0])
    merged[mid] = rows

out = [head]
out.append('--- uiMapID -> { { name, x, y, faction }, ... }\n')
out.append('---\n')
out.append('--- ⚠️ REGENERATED 16 aug 2026 from Zygor (LibTaxi joined to LibRover through\n')
out.append('--- their own name->uiMapID table, never by matching zone names by eye). Rerun\n')
out.append('--- tools/flight_points.py after a Zygor update: it diffs before it prints.\n')
out.append('---\n')
out.append('--- Our own measured stops were KEPT and take precedence. Amani Foothold\n')
out.append('--- (Eagletender Mal\'Tiki, in the Vaults) and Atal\'Aman exist only here —\n')
out.append('--- overwriting the file wholesale would have traded two things we know are\n')
out.append('--- right for %d we have not walked to.\n' % added)
out.append('---\n')
out.append('--- faction: "A", "H" or "B". Sending an Alliance player to a Horde flight\n')
out.append('--- master is a confident wrong answer, so the filter needs the letter.\n')
out.append('ns.FLIGHT_POINTS = {\n')
for mid in sorted(merged):
    out.append('\t[%d] = {\n' % mid)
    for name, x, y, fac in merged[mid]:
        out.append('\t\t{ "%s", %.2f, %.2f, "%s" },\n'
                   % (name.replace('"', '\\"'), x, y, fac))
    out.append('\t},\n')
out.append('}\n\n')
out.append(tail)

txt = ''.join(out)
io.open(OURS + '.tmp', 'w', encoding='utf-8', newline='').write(txt)
os.replace(OURS + '.tmp', OURS)

print('kaarten: %d' % len(merged))
print('punten : %d  (van ons behouden: %d, van Zygor toegevoegd: %d)'
      % (sum(len(v) for v in merged.values()), kept, added))
