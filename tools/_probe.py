# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the last one. "Manuel de Midnight Saison 1" — I wrote the pattern
without the "de". Then a final proof pass over every pack.
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

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'
P = os.path.join(BASE, 'Translations2026.lua')

OLD, NEW = 'Manuel de Midnight Saison 1 :', 'Manuel de Midnight :'
t = io.open(P, encoding='utf-8', newline='').read()
n = t.count(OLD)
print('frFR-anker: %dx' % n)
if n == 1:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t.replace(OLD, NEW))
    os.replace(P + '.tmp', P)
    print('geschreven')
elif n == 0:
    sys.exit(1)

PAT = re.compile(r'(season\s*1|saison\s*1|temporada\s*1|stagione\s*1|seizoen\s*1)', re.I)
KEY = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=')
KEEP = {
    'ST_CLOSE_HEADER', 'ST_CLOSE_KSM',
    'DELVE_TIP_TORMENTS_RISE_OVERVIEW', 'CODEX_127_SPOREFALL_BODY',
    'DGN_BADGE_S1', 'DGN_GROUP_SEASON', 'MPLUS_HEADER',
    'DELVE_REWARDS_UNMEASURED', 'MPLUS_AFFIX_UNMEASURED',
}
print('\n=== eindcontrole ===')
left = {}
for fn in sorted(os.listdir(BASE)):
    if not fn.endswith('.lua'):
        continue
    for i, line in enumerate(io.open(os.path.join(BASE, fn), encoding='utf-8', errors='replace'), 1):
        if not PAT.search(line) or line.strip().startswith('--'):
            continue
        m = KEY.match(line)
        key = m.group(1) if m else '(comment)'
        if key.startswith('CHANGELOG_') or key in KEEP or key == '(comment)':
            continue
        left.setdefault(key, []).append('%s:%d' % (fn, i))
print('schoon' if not left else left)
