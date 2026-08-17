# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: GTFO 6.7.2 landed this morning with "Added Midnight spells (delves)".
GTFO only lists things that DAMAGE YOU AVOIDABLY, which is exactly the shape of
a "do not stand in this" tip -- so the question is how much of it lands on
content our delve coach already covers, and how much is new.

Counts per zone block, then holds the zone ids against ours. Candidates only:
GTFO's ids are datamined for content that is not live yet, same provenance as
DBM's, so this measures OVERLAP, never truth.
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
MH = os.path.join(ADDONS, 'MidnightHelper')
G = os.path.join(ADDONS, 'GTFO', 'Spells', 'GTFO_Spells_MN.lua')

t = io.open(G, encoding='utf-8', errors='replace', newline='').read()
lines = t.split('\n')

blocks, cur = [], None
for l in lines:
    m = re.match(r'^--- \* (.+?) \((\d+)\) \*', l)
    if m:
        cur = {'zone': m.group(1), 'id': m.group(2), 'ids': [], 'todo': 0}
        blocks.append(cur)
        continue
    if cur is None:
        continue
    m = re.match(r'^GTFO\.SpellID\["(\d+)"\]', l)
    if m:
        cur['ids'].append(m.group(1))
    elif re.match(r'^GTFO\.SpellID\["\?+"\]', l):
        cur['todo'] += 1

# Everything our own addon references, so "new" means new to us.
ours = ''
for root, dirs, files in os.walk(MH):
    dirs[:] = [d for d in dirs if d not in ('.git', 'docs', 'tools')]
    for f in files:
        if f.endswith('.lua'):
            ours += io.open(os.path.join(root, f), encoding='utf-8',
                            errors='replace', newline='').read()

print('=' * 76)
print('GTFO 6.7.2 — Midnight-spells per zone, en wat wij er al van kennen')
print('=' * 76)
print('%-26s %7s %6s %5s %6s  %s' % ('zone', 'uiMapID', 'spells', 'TODO',
                                     'nieuw', 'zone-id bij ons?'))
print('-' * 76)
tot_new = 0
for b in blocks:
    new = [i for i in b['ids'] if i not in ours]
    tot_new += len(new)
    known_zone = 'ja' if b['id'] in ours else '—'
    print('%-26s %7s %6d %5d %6d  %s' % (
        b['zone'][:26], b['id'], len(b['ids']), b['todo'], len(new), known_zone))

print('-' * 76)
print('%d zone-blokken, %d spell-ids nieuw voor ons' % (len(blocks), tot_new))

print('\nDe nieuwe ids per zone (kandidaten — de client geeft pas de naam):')
for b in blocks:
    new = [i for i in b['ids'] if i not in ours]
    if new:
        print('  %-26s %s' % (b['zone'][:26], ' '.join(new)))
