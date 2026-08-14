"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: everything HandyNotes_Midnight 150 knows about the Vaults of Atal'Utek
(map 2509) and its sub-map 2613. Rob asked last night what there is to DO in there
and where — this is what a trusted source already has.
"""
import re
import sys
from collections import Counter

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

HN = (r'E:\World of Warcraft\_retail_\Interface\AddOns\HandyNotes_Midnight'
      r'\zones\coiled_isles.lua')
hn = open(HN, encoding='utf-8', errors='replace').read()

rows = []
# \b before the alternation: without it, "map" also matches INSIDE "vault_map"
# (the underscore is a word character, so \b does not apply there), and every
# vault node got split into a "vault_" chunk plus a "map.nodes[...]" chunk that
# then read as a Coiled Isle node and was skipped. 24 nodes came out as 6.
for chunk in re.split(r'(?=\b(?:vault_map2|vault_map|map)\.nodes\[\d{8}\]\s*=\s*)', hn):
    m = re.match(r'(vault_map2|vault_map|map)\.nodes\[(\d{8})\]\s*=\s*(\w+)\(\{', chunk)
    if not m:
        continue
    which, coord, kind = m.group(1), m.group(2), m.group(3)
    if which == 'map':
        continue  # that is The Coiled Isle itself, already compared
    x, y = int(coord[:4]) / 100.0, int(coord[4:]) / 100.0
    quest = re.search(r'\bquest\s*=\s*(\d+)', chunk)
    ach = re.search(r'Achievement\(\{id\s*=\s*(\d+)(?:,\s*criteria\s*=\s*(\d+))?', chunk)
    name = re.search(r'\n\}\)\s*--\s*(.+)', chunk)
    rows.append({
        'map': 2509 if which == 'vault_map' else 2613,
        'kind': kind, 'x': x, 'y': y,
        'quest': quest.group(1) if quest else None,
        'ach': ach.group(1) if ach else None,
        'crit': ach.group(2) if ach and ach.group(2) else None,
        'name': (name.group(1).strip() if name else '')[:34],
        'placeholder': (x == 10.0 and y in (10.0, 20.0, 30.0)),
    })

print('Vaults of Atal'"'"'Utek in HandyNotes_Midnight 150 — %d nodes' % len(rows))
print()
kinds = Counter((r['kind'], r['map']) for r in rows)
for (kind, mp), n in sorted(kinds.items()):
    ph = sum(1 for r in rows if r['kind'] == kind and r['map'] == mp and r['placeholder'])
    print('  %-16s map %-6d %2d node(s)%s' % (
        kind, mp, n, ('  waarvan %d placeholder' % ph) if ph else ''))

aches = Counter(r['ach'] for r in rows if r['ach'])
print()
print('  achievements: %s' % ', '.join('%s (%dx)' % (a, n) for a, n in aches.items()))

print()
print('%-16s %-6s %-9s %-9s %-34s %s' % ('kind', 'map', 'quest', 'criteria', 'name', 'coords'))
print('-' * 96)
for r in sorted(rows, key=lambda r: (r['kind'], r['map'], r['x'])):
    mark = '  <- placeholder' if r['placeholder'] else ''
    print('%-16s %-6d %-9s %-9s %-34s %.2f, %.2f%s' % (
        r['kind'], r['map'], r['quest'] or '-', r['crit'] or '-',
        r['name'], r['x'], r['y'], mark))
