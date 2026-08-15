# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: read ns.db.achCheck and print the nodes a short hunt is missing.

/mh ach check found one: Showdown Slugger: Naigtal ships 8 nodes for 10
criteria. The command stored the client's full criteria list for exactly that
hunt, so the two missing ones are a subtraction, not a search.
"""
import io
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = (r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER'
     r'\SavedVariables\MidnightHelper.lua')

t = io.open(P, encoding='utf-8', errors='replace', newline='').read()

i = t.find('["achCheck"]')
if i < 0:
    print('geen achCheck in de SavedVariables')
    sys.exit(1)

start = t.index('{', i)
depth, j = 0, start
while j < len(t):
    if t[j] == '{':
        depth += 1
    elif t[j] == '}':
        depth -= 1
        if depth == 0:
            break
    j += 1
blob = t[start:j + 1]

print('wrongCriteria  =', re.search(r'\["wrongCriteria"\]\s*=\s*(\d+)', blob).group(1)
      if re.search(r'\["wrongCriteria"\]\s*=\s*(\d+)', blob) else '?')
print('incompleteHunts=', re.search(r'\["incompleteHunts"\]\s*=\s*(\d+)', blob).group(1)
      if re.search(r'\["incompleteHunts"\]\s*=\s*(\d+)', blob) else '?')
print()

# Every hunt row that carries a "missing" table, with its context.
for m in re.finditer(r'\["incomplete"\]\s*=\s*true', blob):
    # Walk back to the start of this row's table, then forward to its end.
    k = blob.rfind('{', 0, m.start())
    d, e = 0, k
    while e < len(blob):
        if blob[e] == '{':
            d += 1
        elif blob[e] == '}':
            d -= 1
            if d == 0:
                break
        e += 1
    row = blob[k:e + 1]
    name = re.search(r'\["name"\]\s*=\s*"([^"]*)"', row)
    aid = re.search(r'\["id"\]\s*=\s*(\d+)', row)
    nodes = re.search(r'\["nodes"\]\s*=\s*(\d+)', row)
    total = re.search(r'\["clientCriteria"\]\s*=\s*(\d+)', row)
    print('=' * 70)
    print('%s  (%s)' % (name.group(1) if name else '?', aid.group(1) if aid else '?'))
    print('wij: %s nodes   client: %s criteria' % (
        nodes.group(1) if nodes else '?', total.group(1) if total else '?'))
    print('=' * 70)

    ms = re.search(r'\["missing"\]\s*=\s*\{', row)
    if not ms:
        print('geen missing-lijst opgeslagen')
        continue
    d, e2 = 0, row.index('{', ms.start() + len('["missing"] ='))
    s2 = e2
    while e2 < len(row):
        if row[e2] == '{':
            d += 1
        elif row[e2] == '}':
            d -= 1
            if d == 0:
                break
        e2 += 1
    miss = row[s2:e2 + 1]
    for sub in re.finditer(r'\{[^{}]*\}', miss):
        c = sub.group(0)
        cid = re.search(r'\["id"\]\s*=\s*(\d+)', c)
        idx = re.search(r'\["index"\]\s*=\s*(\d+)', c)
        txt = re.search(r'\["text"\]\s*=\s*"([^"]*)"', c)
        print('   ONTBREEKT  criteria = %-8s index %-3s  %s' % (
            cid.group(1) if cid else '?',
            idx.group(1) if idx else '?',
            txt.group(1) if txt else '(geen tekst)'))
    print()
