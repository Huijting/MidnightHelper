# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: does Frost Mage's right column actually LACK keys, or are they just
off-screen?

Rob's Layout tab shows Counterspell, Shimmer, Frost Nova and friends with no key
next to them, while the left columns show theirs fine. Two very different bugs:
the allocator never gave them a key, or the key is drawn past the window edge.
The generated data answers it without touching the UI.
"""
import io
import json
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = (r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
     r'\tools\keybind_sheet\keybinds.json')

d = json.load(io.open(P, encoding='utf-8'))
specs = d['specs']

want = None
for s in specs:
    name = s.get('spec') or s.get('name') or ''
    if 'frost' in str(name).lower() and 'mage' in str(s).lower()[:400]:
        want = s
        break
if want is None:
    print('specs beschikbaar:')
    for s in specs[:50]:
        print('  ', s.get('spec') or s.get('name'), '|', s.get('class'))
    sys.exit(0)

print('spec:', want.get('spec') or want.get('name'), '/', want.get('class'))
print()
print('%-18s %s' % ('toets', 'spell'))
print('-' * 46)
keys = want.get('keys') or want.get('binds') or {}
if isinstance(keys, dict):
    for k in sorted(keys):
        print('%-18s %s' % (k, keys[k]))
else:
    for row in keys:
        print('%-18s %s' % (row.get('key'), row.get('spell')))

print()
LOOK = ['Counterspell', 'Shimmer', 'Frost Nova', 'Remove Curse', 'Polymorph',
        'Spellsteal', "Dragon's Breath"]
flat = keys if isinstance(keys, dict) else {r.get('key'): r.get('spell') for r in keys}
rev = {}
for k, v in flat.items():
    rev.setdefault(str(v), []).append(k)
for name in LOOK:
    print('%-18s -> %s' % (name, ', '.join(rev.get(name, [])) or 'GEEN TOETS'))
