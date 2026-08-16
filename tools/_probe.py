# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: what does the client say about the curios in Rob's Valeera window?

Poisons, Combat Curio and Utility Curio each offer a choice, and the advisor has
nothing for Season 2. This morning's sweep captured GetSpellDescription for the
12.1 companion tree, so the material for real advice may already be on disk —
measured text rather than a guide's paraphrase.
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


probe = block('atalProbe', t)
tb = block('traits', probe) if probe else None
if not tb:
    print('geen traits-blok')
    sys.exit(1)

target = None
for r in split_top(tb):
    m = re.search(r'\["treeID"\]\s*=\s*(\d+)', r)
    if m and int(m.group(1)) == 1223:
        target = r
        break
if not target:
    print('tree 1223 niet gevonden')
    sys.exit(1)

# What Rob's window actually shows, plus the alternatives we know of.
WANT = [
    'Poison of the Forgotten Master', 'Soulthirst Venom', 'Bloodcrypt Toxin',
    'Ouroboric Curse', 'Soul-Cracking Dreamcatcher',
    'Scar of Kathra\'natir', 'Blood-Stained Blades', 'Vampiric Reaping',
    'Shadow Veil', 'Crimson Vial Fumes', 'Pain Killer', 'Cloak of Darkness',
    'Your First Mistake', 'Attack from the Shadows', 'Poison Cloud',
]

nb = block('nodeNames', target)
found = {}
for n in split_top(nb or '{}'):
    nm = re.search(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"', n)
    ds = re.search(r'\["desc"\]\s*=\s*"((?:[^"\\]|\\.)*)"', n)
    sid = re.search(r'\["spellID"\]\s*=\s*(\d+)', n)
    rk = re.search(r'\["ranks"\]\s*=\s*(\d+)', n)
    if not nm:
        continue
    name = nm.group(1)
    if name in found:
        continue
    found[name] = (sid.group(1) if sid else '?',
                   rk.group(1) if rk else '0',
                   ds.group(1) if ds else None)

have = 0
for w in WANT:
    row = found.get(w)
    print('=' * 76)
    if not row:
        print('%s — NIET in de boom' % w)
        continue
    sid, rk, desc = row
    print('%s   spell %s   ranks %s' % (w, sid, rk))
    if desc:
        clean = desc.replace('\\r', ' ').replace('\\n', ' ')
        clean = re.sub(r'\|c[nA-Fa-f0-9]{6,}|\|r|\|T[^|]*\|t', '', clean)
        clean = re.sub(r'\s+', ' ', clean).strip()
        print('   %s' % clean)
        have += 1
    else:
        print('   (geen beschrijving)')

print()
print('%d van de %d hebben een gemeten effecttekst.' % (have, len(WANT)))
