"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: correct the author credit in the About window, every language.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

ROOT = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
OLD = 'Inchy & Gemma & Cursor'
NEW = 'TwelveInchy & Claude'

TARGETS = [
    r'Locales\deDE.lua',
    r'Locales\enUS.lua',
    r'Locales\esES.lua',
    r'Locales\frFR.lua',
    r'Locales\itIT.lua',
    r'Locales\nlNL.lua',
    r'Locales\ptBR.lua',
    r'tools\build_deDE.py',
]

for rel in TARGETS:
    p = os.path.join(ROOT, rel)
    t = open(p, encoding='utf-8', newline='').read()
    n = t.count(OLD)
    if n == 0:
        print('%-24s niets te doen' % rel)
        continue
    t = t.replace(OLD, NEW)
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%-24s %d vervangen' % (rel, n))
