"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the whole Atal'Utek probe record, brace-counted out of the SV.
"""
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = (r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER'
      r'\SavedVariables\MidnightHelper.lua')

t = open(SV, encoding='utf-8', errors='replace').read()
start = t.index('["atalProbe"] = {')
depth, i = 0, t.index('{', start)
while True:
    if t[i] == '{':
        depth += 1
    elif t[i] == '}':
        depth -= 1
        if depth == 0:
            break
    i += 1
block = t[start:i + 1]

print('%d regels\n' % block.count('\n'))
for line in block.splitlines():
    print(line)
