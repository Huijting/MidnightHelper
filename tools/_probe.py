# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: dump the 12.1 Valeera tree with the game's own effect text.

Season 2 opens on the 18th and the curio advisor has no pack for it. The three
poison spell ids were measured on the PTR and confirmed on live; what was still
missing is what they actually DO, because the prose on file came from the page
that had all three ids wrong.
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
WANT_TREE = 1223

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


def unesc(s):
    return (s.replace('\\n', ' ').replace('\\"', '"')
             .replace('\\\\', '\\').strip())


probe = block('atalProbe', t)
tb = block('traits', probe)

target = None
withdesc = totalnamed = 0
for r in split_top(tb):
    tid = re.search(r'\["treeID"\]\s*=\s*(\d+)', r)
    nb = block('nodeNames', r)
    for n in (split_top(nb) if nb else []):
        if re.search(r'\["name"\]', n):
            totalnamed += 1
        if re.search(r'\["desc"\]', n):
            withdesc += 1
    if tid and int(tid.group(1)) == WANT_TREE:
        target = r

print('nodes met naam: %d   waarvan met beschrijving: %d' % (totalnamed, withdesc))
if withdesc == 0:
    print('GEEN beschrijvingen — GetSpellDescription gaf niets terug of is niet gecached.')
    print('Dat is een lege meting, geen bewijs dat de teksten niet bestaan.')
    sys.exit(0)
print()

if not target:
    print('tree %d niet gevonden' % WANT_TREE)
    sys.exit(1)

nb = block('nodeNames', target)
seen = set()
print('=' * 78)
print('tree %d — 12.1 Valeera Sanguinar' % WANT_TREE)
print('=' * 78)
for n in split_top(nb):
    nm = re.search(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"', n)
    sid = re.search(r'\["spellID"\]\s*=\s*(\d+)', n)
    ds = re.search(r'\["desc"\]\s*=\s*"((?:[^"\\]|\\.)*)"', n)
    rk = re.search(r'\["ranks"\]\s*=\s*(\d+)', n)
    key = sid.group(1) if sid else (nm.group(1) if nm else '?')
    if key in seen:
        continue
    seen.add(key)
    print('%-36s spell %-9s ranks %s' % (
        (nm.group(1) if nm else '(naamloos)'), key, rk.group(1) if rk else '0'))
    if ds:
        print('    %s' % unesc(ds.group(1))[:400])
    else:
        print('    (geen beschrijving uit de client)')
