# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: did /mh atal's trait sweep ever see the Altar of Corrosion tree?

The four disputed choice nodes (Spiritual Succession vs our own wording) can
only be settled by the node's own description. Before building anything new,
check whether the existing sweep already holds it — and if not, say WHY rather
than "not found": which trees did it see, and did any of them carry names?
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


def block(key, src):
    i = src.find('["%s"]' % key)
    if i < 0:
        return None
    s = src.index('{', i)
    d, j = 0, s
    while j < len(src):
        if src[j] == '{':
            d += 1
        elif src[j] == '}':
            d -= 1
            if d == 0:
                break
        j += 1
    return src[s:j + 1]


def split_top(blob):
    out, d, buf = [], 0, ''
    for ch in blob[1:-1]:
        if ch == '{':
            d += 1
        if d > 0:
            buf += ch
        if ch == '}':
            d -= 1
            if d == 0:
                out.append(buf)
                buf = ''
    return out


def f(chunk, name):
    m = re.search(r'\["%s"\]\s*=\s*("(?:[^"\\]|\\.)*"|true|false|[\d.-]+)'
                  % name, chunk)
    if not m:
        return None
    v = m.group(1)
    if v.startswith('"'):
        return v[1:-1]
    if v in ('true', 'false'):
        return v == 'true'
    return v


probe = block('atalProbe', t)
tr = block('traits', probe) if probe else None
if not tr:
    print('geen traits-blok in atalProbe — de sweep heeft niets weggeschreven.')
    sys.exit(0)

WANTED = ('Spiritual Succession', 'Surge Seniority', 'Egg Evasion',
          'Egg Specialist', 'Spectral Shipping', 'Spirit Walk',
          'Glideways', 'Swift Steps')

print('%-8s %-10s %-7s %s' % ('tree', 'config', 'nodes', 'namen gelezen'))
print('-' * 62)
total_named, hit = 0, []
for e in split_top(tr):
    tree = f(e, 'treeID')
    cfg = f(e, 'configID')
    nodes = f(e, 'nodes')
    nn = block('nodeNames', e)
    rows = split_top(nn) if nn else []
    named = [f(r, 'name') for r in rows]
    named = [n for n in named if n]
    total_named += len(named)
    for n in named:
        if n in WANTED:
            hit.append((tree, n, f(rows[named.index(n)], 'desc')))
    print('%-8s %-10s %-7s %d' % (tree or '?', cfg or '-', nodes or '?', len(named)))

print('-' * 62)
print('%d namen in totaal over alle bomen' % total_named)

print('\nde vier omstreden keuzeknopen:')
if hit:
    for tree, name, desc in hit:
        print('  tree %s  %s' % (tree, name))
        print('    %s' % (desc or '— geen beschrijving —'))
else:
    print('  GEEN ENKELE gevonden.')
    print('  ⚠️ Dat bewijst niet dat ze niet bestaan. De sweep heeft %d namen'
          % total_named)
    print('     gelezen, dus namen lezen wérkt — maar de Altar-boom zat er niet bij.')
    print('     Waarschijnlijkste reden: de boom hoort bij content die deze')
    print('     character niet heeft vrijgespeeld. Meten op een character die')
    print('     de questketen af heeft, staand bij de Altar.')
