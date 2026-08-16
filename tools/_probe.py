# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: pull every delve Sturdy Chest out of HandyNotes_Midnight as data.

Rob: "in de delves kunnen we ook een route inbouwen voor de treasures." The
coordinates already exist twice on this machine — in HandyNotes and, for the two
12.1 delves, inside our own locale strings as {WAY:} markup. Emitting a Lua data
table lets the route read data instead of parsing translated prose.

Cross-checks the two we already ship: if HandyNotes disagrees with our own tip
text, that is a real conflict and the script refuses rather than picking a side.
"""
import io
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

HN = (r'E:\World of Warcraft\_retail_\Interface\AddOns'
      r'\HandyNotes_Midnight\zones\delves.lua')
ENUS = (r'E:\World of Warcraft\_retail_\Interface\AddOns'
        r'\MidnightHelper\Locales\enUS.lua')

t = io.open(HN, encoding='utf-8', errors='replace').read()

# var -> uiMapID, from the Map({id = N}) declarations at the top.
maps = {}
for m in re.finditer(r'^local\s+(\w+)\s*=\s*Map\(\{id\s*=\s*(\d+).*?--\s*(.+?)\s*$',
                     t, re.M):
    maps[m.group(1)] = (int(m.group(2)), m.group(3))

chests = {}
for m in re.finditer(
        r'^(\w+)\.nodes\[(\d{8})\]\s*=\s*SturdyChest\(\{(.*?)\}\)', t, re.M | re.S):
    var, key, body = m.group(1), m.group(2), m.group(3)
    if var not in maps:
        continue
    mid, label = maps[var]
    q = re.search(r'quest\s*=\s*(\d+)', body)
    a = re.search(r'achievementID\s*=\s*(\d+)', body)
    n = re.search(r"#(\d+)", body)
    chests.setdefault(mid, {'label': label, 'rows': []})['rows'].append({
        'x': int(key[:4]) / 100.0, 'y': int(key[4:]) / 100.0,
        'quest': int(q.group(1)) if q else None,
        'ach': int(a.group(1)) if a else None,
        'n': int(n.group(1)) if n else None,
    })

# Cross-check against what we already ship for the two 12.1 delves.
loc = io.open(ENUS, encoding='utf-8', errors='replace').read()
ours = {}
for m in re.finditer(r'\{WAY:(\d+):([\d.]+):([\d.]+):Sturdy Chest (\d)\}', loc):
    ours.setdefault(int(m.group(1)), {})[int(m.group(4))] = (
        float(m.group(2)), float(m.group(3)))

bad = 0
for mid, byn in sorted(ours.items()):
    rows = chests.get(mid, {}).get('rows', [])
    for n, (x, y) in sorted(byn.items()):
        match = [r for r in rows if r['n'] == n]
        if not match:
            print('CONFLICT %s #%d staat niet in HandyNotes' % (mid, n))
            bad += 1
            continue
        r = match[0]
        if abs(r['x'] - x) > 0.02 or abs(r['y'] - y) > 0.02:
            print('CONFLICT %s #%d  wij %.2f/%.2f  HandyNotes %.2f/%.2f'
                  % (mid, n, x, y, r['x'], r['y']))
            bad += 1
if bad:
    print('\n%d conflict(en) — niets geschreven. Los dit op voor de data erin gaat.' % bad)
    sys.exit(1)
print('kruiscontrole: onze eigen {WAY:}-coords komen exact overeen met HandyNotes.')
print()

for mid in sorted(chests):
    d = chests[mid]
    rows = sorted(d['rows'], key=lambda r: (r['n'] or 99))
    print('\t[%d] = { -- %s' % (mid, d['label']))
    for r in rows:
        print('\t\t{ x = %5.2f, y = %5.2f, quest = %s },'
              % (r['x'], r['y'], r['quest'] if r['quest'] else 'nil'))
    print('\t},')
print()
print('%d delve-kaarten, %d kisten' % (len(chests), sum(len(c['rows']) for c in chests.values())))
