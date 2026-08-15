# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: correct "To sons" from Rob's own measurement.

He walked the route, earned The Honored Dead, and found one marker off. Our
data said 42.91 / 41.23 (HandyNotes); he stood on it and read 42.84 / 39.93.
The x is within rounding, the y is 1.3 out — enough to put the arrow past it.

This is the first HandyNotes coordinate on the Coiled Isle proven wrong. His
standing rule is to use their coords without a spot-check because they run
about 95% right; this is one of the other 5%, and now it is measured.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'

EDITS = [
    (os.path.join(BASE, 'Modules', 'AchievementsData.lua'),
     'x = 42.91, y = 41.23',
     'x = 42.84, y = 39.93',
     1),
    (os.path.join(BASE, 'Locales', 'Codex.lua'),
     '{WAY:2509:42.91:41.23:To sons 42.91, 41.23}',
     '{WAY:2509:42.84:39.93:To sons 42.84, 39.93}',
     7),
]

for path, old, new, expect in EDITS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    n = t.count(old)
    print('%-22s %d gevonden (verwacht %d)' % (name, n, expect))
    if n != expect:
        print('   NIETS geschreven — alles of niets')
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(t.replace(old, new))
    os.replace(path + '.tmp', path)
    print('   geschreven')

# Bewijs: nergens meer het oude paar.
print()
for path, old, _new, _e in EDITS:
    t = io.open(path, encoding='utf-8', errors='replace').read()
    print('%-22s oude waarde nog aanwezig: %s'
          % (os.path.basename(path), 'JA' if old in t else 'nee'))
