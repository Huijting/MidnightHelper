# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: harvest the Coiled Isle achievement nodes out of HandyNotes_Midnight.

Its node keys encode the coordinates (37416053 -> 37.41 / 60.53) and the
trailing comment names the spot. Rob's standing instruction is that this
addon's rare/treasure coords are good enough to ship without a spot-check;
the achievement and criteria IDS are addon data like any other and still have
to survive his client.

Prints, per achievement, a ready-to-paste node list sorted north to south —
the same order the existing hunts use, because that is the order you walk.
"""
import io
import re
import sys
from collections import defaultdict

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = (r'E:\World of Warcraft\_retail_\Interface\AddOns'
     r'\HandyNotes_Midnight\zones\coiled_isles.lua')

t = io.open(P, encoding='utf-8', errors='replace', newline='').read()
lines = t.split('\n')

# Which map variable each block belongs to; the file uses more than one.
MAPID = {'map': 2512, 'vault_map': 2509, 'vault_map2': 2613}
for m in re.finditer(r'local\s+(\w*map\w*)\s*=\s*Map\(\{id\s*=\s*(\d+)', t):
    MAPID[m.group(1)] = int(m.group(2))

found = defaultdict(list)
cur = None

for i, line in enumerate(lines):
    m = re.match(r'\s*(\w+)\.nodes\[(\d{8})\]\s*=\s*(\w+)\(\{', line)
    if m:
        var, key, kind = m.group(1), m.group(2), m.group(3)
        cur = {
            'map': MAPID.get(var, '?'),
            'x': int(key[:4]) / 100.0,
            'y': int(key[4:]) / 100.0,
            'kind': kind,
            'name': None,
            'ach': [],
        }
        continue
    if cur is None:
        continue
    for a in re.finditer(r'Achievement\(\{id\s*=\s*(\d+),\s*criteria\s*=\s*(\d+)', line):
        cur['ach'].append((int(a.group(1)), int(a.group(2))))
    # The closing "})" carries the trailing comment that names the node.
    if line.startswith('})') or line.startswith('    })'):
        c = re.search(r'--\s*(.+?)\s*$', line)
        if c:
            cur['name'] = c.group(1)
        for aid, crit in cur['ach']:
            found[aid].append((crit, cur))
        cur = None

for aid in sorted(found):
    rows = found[aid]
    print('=' * 78)
    print('achievement %d  —  %d nodes' % (aid, len(rows)))
    print('=' * 78)
    rows.sort(key=lambda r: (r[1]['map'], r[1]['y'], r[1]['x']))
    for crit, n in rows:
        name = n['name'] or ''
        # Strip the ", the Coiled Isles" tail; the hunt already knows the zone.
        name = re.sub(r',\s*the Coiled Isles?$', '', name)
        print('\t\t\t{ criteria = %d, mapID = %d, x = %5.2f, y = %5.2f, name = "%s" },'
              % (crit, n['map'], n['x'], n['y'], name.replace('"', "'")))
    print()
