# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: add `ach`/`crit` named fields to the eleven Coiled Isle rares that
matched an achievement-63358 criterion by NPC id.

Named fields rather than a seventh positional number: Lua allows both in one
table, and `crit = 115284` says what it is where a bare seventh integer would
not. The two rares with no criterion are left alone and stay honest about it.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = (r'E:\World of Warcraft\_retail_\Interface\AddOns'
     r'\MidnightHelper\Modules\Rares.lua')

# npcID -> criterion, matched on NPC id (the strongest key available).
CRIT = {
    265237: 115284,  # Lockjaw the Snapper
    261109: 115287,  # Sss'alik, The Rotten Claw
    256631: 115286,  # Big Mon
    257906: 115285,  # Coin-Eye Skully
    268049: 115280,  # Siltmouth, the Unflappable
    264854: 115279,  # Farthik the Plunderer
    258920: 115283,  # Nar'zira
    258916: 110172,  # Garsecg          — had quest 0
    261142: 115288,  # Destra           — had quest 0
    265262: 115281,  # Hisstara         — had quest 0
    268090: 115784,  # Kari'zah the Forgotten — had quest 0
}

t = io.open(P, encoding='utf-8', newline='').read()
if 'crit = 115284' in t:
    print('staat er al')
    sys.exit(0)

changed = 0
for npc, crit in CRIT.items():
    old = ', %d }' % npc
    new = ', %d, ach = 63358, crit = %d }' % (npc, crit)
    n = t.count(old)
    if n != 1:
        print('npc %d: %d treffers (verwacht 1) — NIETS geschreven' % (npc, n))
        sys.exit(1)
    t = t.replace(old, new)
    changed += 1

print('%d van %d rares gekoppeld' % (changed, len(CRIT)))
if changed != len(CRIT):
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
os.replace(P + '.tmp', P)
print('geschreven')
