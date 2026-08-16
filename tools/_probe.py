# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: repair the missing comma my own last pass dropped.

The insert built `y = 76.63  note = "..."` because the captured group ended
before the comma and I did not put one back. luac caught it immediately, which
is exactly why every write here is followed by a syntax check.
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

P = (r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
     r'\Modules\AchievementsData.lua')

t = io.open(P, encoding='utf-8', newline='').read()
fixed, n = re.subn(r'(y = [\d.]+)\s+note = "', r'\1, note = "', t)
print('%d regels gerepareerd' % n)
if n == 0:
    print('niets te doen')
    sys.exit(0)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(fixed)
os.replace(P + '.tmp', P)
print('geschreven')
