"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: HandyNotes_Midnight 149's Coiled Isle rares next to ours. Coordinates
are packed as one number per node (map.nodes[53777204] = 53.77 / 72.04).
"""
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

HN = (r'E:\World of Warcraft\_retail_\Interface\AddOns\HandyNotes_Midnight'
      r'\zones\coiled_isles.lua')
MH = (r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
      r'\Modules\Rares.lua')

hn = open(HN, encoding='utf-8', errors='replace').read()

# map.nodes[53777204] = Rare({ id = 264854, quest = 96491, ... }) -- Name
# Split on the node assignments rather than trying to match a closing brace: the
# blocks nest and do not all end the same way, and a strict anchor silently caught
# 1 of 34.
rows = []
chunks = re.split(r'(?=map\.nodes\[\d{8}\]\s*=\s*)', hn)
for chunk in chunks:
    m = re.match(r'map\.nodes\[(\d{8})\]\s*=\s*(\w+)\(\{', chunk)
    if not m:
        continue
    coord, kind = m.group(1), m.group(2)
    if kind not in ('Rare', 'RareElite'):
        continue
    npc = re.search(r'\bid\s*=\s*(\d+)', chunk)
    quest = re.search(r'\bquest\s*=\s*(\d+)', chunk)
    # The trailing "-- Name" comment sits on the line that closes the node.
    name = re.search(r'\n\}\)\s*--\s*(.+)', chunk)
    rows.append({
        'x': int(coord[:4]) / 100.0,
        'y': int(coord[4:]) / 100.0,
        'npc': npc.group(1) if npc else '?',
        'quest': quest.group(1) if quest else '?',
        'name': (name.group(1).strip() if name else '?')[:44],
    })

print('HandyNotes_Midnight 149 — Coiled Isle rares (%d)' % len(rows))
print('%-9s %-9s %-46s %s' % ('npc', 'quest', 'name', 'coords'))
print('-' * 92)
for r in sorted(rows, key=lambda r: r['npc']):
    print('%-9s %-9s %-46s %.2f, %.2f' % (r['npc'], r['quest'], r['name'], r['x'], r['y']))

# Ours: { questId, mapID, x, y, "Name", npcId }
mh = open(MH, encoding='utf-8', errors='replace').read()
block = mh[mh.index('local COILED_ISLE ='):]
block = block[:block.index('\n}')]
ours = re.findall(r'\{\s*(\d+),\s*(\d+),\s*([\d.]+),\s*([\d.]+),\s*"([^"]+)",\s*(\d+)\s*\}', block)

print()
print('Midnight Helper — Coiled Isle (%d)' % len(ours))
print('%-9s %-9s %-46s %s' % ('npc', 'quest', 'name', 'coords'))
print('-' * 92)
byNpc = {}
for q, mapid, x, y, name, npc in sorted(ours, key=lambda t: t[5]):
    print('%-9s %-9s %-46s %s, %s' % (npc, q, name[:44], x, y))
    byNpc[npc] = (q, float(x), float(y), name)

print()
print('VERSCHILLEN')
print('-' * 92)
hnByNpc = {r['npc']: r for r in rows}
for npc in sorted(set(list(byNpc) + list(hnByNpc))):
    a, b = byNpc.get(npc), hnByNpc.get(npc)
    if not a:
        print('%-9s ALLEEN in HandyNotes: %s  (quest %s, %.2f/%.2f)' % (
            npc, b['name'], b['quest'], b['x'], b['y']))
        continue
    if not b:
        print('%-9s ALLEEN bij ons: %s' % (npc, a[3]))
        continue
    notes = []
    if a[0] != b['quest']:
        notes.append('quest ONS %s vs HN %s' % (a[0], b['quest']))
    d = max(abs(a[1] - b['x']), abs(a[2] - b['y']))
    if d >= 0.5:
        notes.append('coords %.2f/%.2f vs %.2f/%.2f (%.2f uit elkaar)' % (
            a[1], a[2], b['x'], b['y'], d))
    if notes:
        print('%-9s %-30s %s' % (npc, a[3][:30], ' | '.join(notes)))
