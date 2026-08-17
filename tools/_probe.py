# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: harvest GTFO's Midnight hazards PROPERLY.

The first pass keyed off section headers of the form `--- * Zone (id) *` and
so silently skipped every entry filed under a header without an id -- which is
exactly where the two Season 2 delves live. Rob asking "does this affect
Season 2?" is what surfaced it. This pass reads each GTFO.SpellID entry and
takes the `instance =` on the entry itself, which is the field GTFO actually
keys on, so a header style cannot hide anything again.

Reads both the Spells and Fail files: GTFO splits "this hurts" from "you
failed", and both are avoidable damage.
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
FILES = [
    os.path.join(ADDONS, 'GTFO', 'Spells', 'GTFO_Spells_MN.lua'),
    os.path.join(ADDONS, 'GTFO', 'Spells', 'GTFO_Fail_MN.lua'),
]

ours = ''
for root, dirs, files in os.walk(MH):
    dirs[:] = [d for d in dirs if d not in ('.git', 'docs', 'tools')]
    for f in files:
        if f.endswith('.lua'):
            ours += io.open(os.path.join(root, f), encoding='utf-8',
                            errors='replace', newline='').read()

entries = []
for path in FILES:
    if not os.path.exists(path):
        print('ontbreekt: %s' % path)
        continue
    src = io.open(path, encoding='utf-8', errors='replace', newline='').read()
    kind = 'fail' if 'Fail' in os.path.basename(path) else 'spell'
    # Each entry runs from GTFO.SpellID[...] to its closing };
    for m in re.finditer(r'GTFO\.SpellID\["(\d+)"\]\s*=\s*\{(.*?)\n\};',
                         src, re.S):
        sid, body = m.group(1), m.group(2)
        # A commented-out entry inside a --[[ ]]-- block is a TODO, not data.
        start = m.start()
        opened = src.rfind('--[[', 0, start)
        closed = src.rfind(']]--', 0, start)
        if opened > closed:
            continue
        inst = re.search(r'instance\s*=\s*(\d+)', body)
        enc = re.search(r'encounter\s*=\s*(\d+)', body)
        desc = re.search(r'--\s*desc\s*=\s*"(.*?)"', body)
        entries.append({
            'id': sid,
            'instance': inst.group(1) if inst else None,
            'encounter': enc.group(1) if enc else None,
            'desc': desc.group(1) if desc else '',
            'kind': kind,
        })

by_inst = {}
for e in entries:
    by_inst.setdefault(e['instance'], []).append(e)

print('=' * 78)
print('GTFO Midnight — per instance, uit de entries zelf (niet uit de kopjes)')
print('=' * 78)
print('%-9s %6s %6s %6s  %s' % ('instance', 'spells', 'fail', 'nieuw', 'voorbeeld'))
print('-' * 78)
tot_new = 0
for inst in sorted(by_inst, key=lambda x: (x is None, x)):
    rows = by_inst[inst]
    new = [r for r in rows if r['id'] not in ours]
    tot_new += len(new)
    ns_ = sum(1 for r in rows if r['kind'] == 'spell')
    nf = sum(1 for r in rows if r['kind'] == 'fail')
    ex = next((r['desc'] for r in rows if r['desc']), '')
    print('%-9s %6d %6d %6d  %s' % (inst or '—', ns_, nf, len(new), ex[:34]))

print('-' * 78)
print('%d entries, %d instances, %d ids die wij nog nergens noemen'
      % (len(entries), len(by_inst), tot_new))

# The two Season 2 delves specifically -- the question that prompted this pass.
print('\n' + '=' * 78)
print('SEASON 2 (12.1): Gnarldor Isle 3038, The Ring of Glory 3077')
print('=' * 78)
for inst in ('3038', '3077', '2963'):
    rows = by_inst.get(inst, [])
    print('\ninstance %s — %d entries' % (inst, len(rows)))
    for r in rows:
        print('   %-10s enc %-6s %-5s %s   %s' % (
            r['id'], r['encounter'] or '—', r['kind'], r['desc'],
            '(nieuw)' if r['id'] not in ours else '(kennen we)'))

print('\n' + '=' * 78)
print('ALLE nieuwe ids per instance (kandidaten — de client geeft de naam)')
print('=' * 78)
for inst in sorted(by_inst, key=lambda x: (x is None, x)):
    new = [r for r in by_inst[inst] if r['id'] not in ours]
    if new:
        print('  %-8s %s' % (inst or '—', ' '.join(r['id'] for r in new)))
