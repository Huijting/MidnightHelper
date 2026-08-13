"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the aura-instance probe's two runs, filter by filter.
Brace-count the block: this SV file writes every key at column 0, nested or not.
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
start = t.index('["auraInstanceProbe"] = {')
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

for state in ('standing', 'inCombat'):
    m = re.search(r'\["%s"\] = \{' % state, block)
    if not m:
        print('=== %s: niet gevonden ===' % state)
        continue
    d, j = 0, block.index('{', m.start())
    while True:
        if block[j] == '{':
            d += 1
        elif block[j] == '}':
            d -= 1
            if d == 0:
                break
        j += 1
    sub = block[m.start():j + 1]

    print('=' * 66)
    print(state.upper())
    print('=' * 66)
    for key in ('verdict', 'shape', 'total', 'readable', 'secret'):
        v = re.search(r'\["%s"\] = ("?)([^,"]*)\1,' % key, sub)
        if v:
            print('  %-10s %s' % (key, v.group(2)))
    print('  filters:')
    for f in re.findall(r'\{[^{}]*?\["filter"\][^{}]*?\}', sub, re.S):
        name = re.search(r'\["filter"\] = "([^"]*)"', f)
        res = re.search(r'\["result"\] = "([^"]*)"', f)
        cnt = re.search(r'\["count"\] = (\d+)', f)
        print('    %-24s %-10s %s' % (
            name.group(1) if name else '?',
            res.group(1) if res else '?',
            (cnt.group(1) + ' instance(s)') if cnt else ''))
    print()
