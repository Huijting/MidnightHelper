# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: read the trait-tree sweep. Controls first, then the question.

The controls decide whether this run means anything: the class trees and Runes
of Power (tree 1186) must be in there. Only with those present does an absent
Corrosive Codex say something.
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


probe = block('atalProbe', t)
if not probe:
    print('geen atalProbe')
    sys.exit(1)

tb = block('traits', probe)
if tb is None:
    print('geen traits-blok — draaide de oude probe nog?')
    sys.exit(1)

rows, d, buf = [], 0, ''
for ch in tb[1:-1]:
    if ch == '{':
        d += 1
    if d > 0:
        buf += ch
    if ch == '}':
        d -= 1
        if d == 0:
            rows.append(buf)
            buf = ''

print('%-8s %-10s %-7s %s' % ('treeID', 'configID', 'nodes', 'trait-currencies'))
print('-' * 74)
trees = []
for r in rows:
    tid = re.search(r'\["treeID"\]\s*=\s*(\d+)', r)
    cfg = re.search(r'\["configID"\]\s*=\s*(\d+)', r)
    nds = re.search(r'\["nodes"\]\s*=\s*(\d+)', r)
    curs = re.findall(r'\["traitCurrencyID"\]\s*=\s*(\d+)', r)
    qty = re.findall(r'\["quantity"\]\s*=\s*(\d+)', r)
    if not tid:
        continue
    trees.append(int(tid.group(1)))
    pairs = ', '.join('%s(q=%s)' % (c, q) for c, q in zip(curs, qty)) or '-'
    print('%-8s %-10s %-7s %s' % (tid.group(1), cfg.group(1) if cfg else '?',
                                  nds.group(1) if nds else '?', pairs))

print()
print('trees gevonden: %d' % len(trees))
print('CONTROLE Runes of Power (1186): %s'
      % ('AANWEZIG' if 1186 in trees else 'ONTBREEKT'))
if not trees:
    print('LEEG — de veeg bewijst niets, hij is stuk.')
elif 1186 not in trees:
    print('De controle ontbreekt, dus een afwezige Codex zegt hier niets.')
else:
    print('Controle staat er. Een boom die geen talent- of Runes-boom is, is de kandidaat.')
