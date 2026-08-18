# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Lint check [10] asks "is every command in CommandList.lua actually routed?"
Nobody asks the mirror question: is every routed command in the list? Eight
commands were added in two days and none of them appear, so the answer is
probably no and probably worse than eight.
"""
import glob
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

MH = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'

listed = set()
src = io.open(os.path.join(MH, 'Modules', 'CommandList.lua'),
              encoding='utf-8', errors='replace').read()
for m in re.finditer(r'cmd = "/mh\s*([^"]*)"', src):
    listed.add(m.group(1).split()[0] if m.group(1).strip() else '')

# Routed: `msg == "x"` and `msg:match("^x")` in Core.lua and the modules.
routed = set()
paths = [os.path.join(MH, 'Core.lua')]
paths += sorted(glob.glob(os.path.join(MH, 'Modules', '*.lua')))
for p in paths:
    text = io.open(p, encoding='utf-8', errors='replace').read()
    for m in re.finditer(r'msg\s*==\s*"([a-z]+)"', text):
        routed.add(m.group(1))
    for m in re.finditer(r'msg:match\("\^([a-z]+)', text):
        routed.add(m.group(1))

print('in de spelerslijst : %d' % len(listed))
print('gerouteerd in code : %d' % len(routed))

missing = sorted(routed - listed)
print('\n' + '=' * 60)
print('GEROUTEERD MAAR NIET IN DE LIJST — %d' % len(missing))
print('=' * 60)
for c in missing:
    print('  /mh %s' % c)

ghost = sorted(listed - routed)
print('\n' + '=' * 60)
print('IN DE LIJST MAAR NIET GEVONDEN ALS ROUTE — %d' % len(ghost))
print('(check [10] zegt 0; die kijkt breder dan dit script, dus')
print(' verschillen hier zijn eerder mijn regex dan een echt gat)')
print('=' * 60)
for c in ghost:
    print('  /mh %s' % c)
