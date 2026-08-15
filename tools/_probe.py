# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the spec's twelve names are in no tree. Two readings stay open —
the Codex is not a trait tree, or the spec's names (guide-sourced and admittedly
paraphrased) are simply wrong. Search on names that came from our OWN measured
research instead: the Altar's four discovery nodes and the Corrosive Spirit
ranks from VAULTS_DISCOVERIES, plus anything venom/corrosion-shaped.

Prints every node name of the trees that match, so the answer is readable
rather than inferred.
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

# From our own notes, not from the spec: node names the Altar of Corrosion is
# documented to have, and the words the whole zone is built on.
NEEDLES = ['corrosi', 'corrode', 'venom', 'poison', 'serpent', 'snake', 'viper',
           'ophidian', "ula'tek", 'ulatek', 'atal', 'spirit walk', 'broodmaster',
           'spectral', 'run of the vaults', 'glideway', 'swift steps',
           'miasma', 'mephitic', 'gorgon', 'lithic', 'plumage', 'mucus']

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


probe = block('atalProbe', t)
tb = block('traits', probe)

trees = []
for r in split_top(tb):
    tid = re.search(r'\["treeID"\]\s*=\s*(\d+)', r)
    nm = re.search(r'\["configName"\]\s*=\s*"([^"]*)"', r)
    cnt = re.search(r'\["nodes"\]\s*=\s*(\d+)', r)
    nb = block('nodeNames', r)
    names = []
    if nb:
        for n in split_top(nb):
            m = re.search(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"', n)
            sid = re.search(r'\["spellID"\]\s*=\s*(\d+)', n)
            rk = re.search(r'\["ranks"\]\s*=\s*(\d+)', n)
            names.append((m.group(1) if m else None,
                          sid.group(1) if sid else '?',
                          rk.group(1) if rk else '0'))
    trees.append((int(tid.group(1)) if tid else 0,
                  nm.group(1) if nm else '',
                  int(cnt.group(1)) if cnt else 0, names))

print('%-7s %-26s %-7s %-9s %s' % ('tree', 'configName', 'nodes', 'met naam', 'treffers'))
print('-' * 92)
best = []
for tid, cname, cnt, names in trees:
    withname = sum(1 for x in names if x[0])
    hits = [x[0] for x in names if x[0]
            and any(k in x[0].lower() for k in NEEDLES)]
    print('%-7s %-26s %-7s %-9s %s' % (tid, cname[:26], cnt, withname,
                                       ', '.join(hits[:4]) or '-'))
    if hits:
        best.append((tid, cname, names, hits))

print()
for tid, cname, names, hits in best:
    print('=' * 78)
    print('tree %s  %s  — alle %d nodes' % (tid, cname, len(names)))
    print('=' * 78)
    for nm, sid, rk in names:
        mark = '*' if nm and any(k in nm.lower() for k in NEEDLES) else ' '
        print('  %s %-38s spell %-9s ranks %s' % (mark, nm or '(naamloos)', sid, rk))
    print()
