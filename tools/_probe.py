# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: turn the coordinates in the three Vaults Codex bodies into {WAY:}
links, all seven languages at once. Possible in one pass because the patterns
are language-neutral: memorial names stay English ("To a sister"), and the
numbers are identical in every pack.

Three shapes:
1. The twelve memorials: |cffffffffTo …|r X, Y  → {WAY:2509:X:Y:To … X, Y}
2. Fixed strings that are byte-identical across languages (Er'inye's spot, the
   Feather, the Underbelly entrance) → one literal replace each, map 2509.
3. Szarith the Fanged, plain "38.40, 17.69" — the ONLY one on map 2613; a
   default-2509 regex would send the reader to the wrong map, so he is done
   first as a literal, before the generic patterns run.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
KEYS = ('CODEX_ATALUTEK_BODY', 'CODEX_ATALUTEK_DISC_BODY', 'CODEX_ATALUTEK_DEAD_BODY')

t = io.open(P, encoding='utf-8', newline='').read()
if '{WAY:2509:46.79' in t:
    print('staat er al')
    sys.exit(0)
eol = '\r\n' if '\r\n' in t else '\n'

# -- 3. Szarith first: 2613, before anything generic touches his numbers.
SZARITH = ('38.40, 17.69', '{WAY:2613:38.40:17.69:Szarith the Fanged}')

# -- 2. Fixed, byte-identical strings, all map 2509.
FIXED = [
    ('|cffffffff51.10, 62.76|r', "{WAY:2509:51.10:62.76:Er'inye}"),
    ('|cffffffff48.46, 25.80|r', "{WAY:2509:48.46:25.80:Feather of Tok'jara}"),
    ('|cffffffff47.30, 11.20|r', '{WAY:2509:47.30:11.20:The Underbelly}'),
    # In de coach-teksten staat de Feather zonder kleurwrap ("at 48.46, 25.80").
    ('48.46, 25.80', "{WAY:2509:48.46:25.80:Feather of Tok'jara}"),
]

# -- 1. The memorials: colour-wrapped English label + coords.
MEMORIAL = re.compile(r'\|cffffffff(To [^|]{1,30})\|r (\d{1,2}\.\d{2}), (\d{1,2}\.\d{2})')

def memorial_sub(m):
    label, x, y = m.group(1), m.group(2), m.group(3)
    return '{WAY:2509:%s:%s:%s %s, %s}' % (x, y, label, x, y)

lines = t.split(eol)
out = []
touched = {k: 0 for k in KEYS}
for line in lines:
    stripped = line.lstrip()
    hit = None
    for k in KEYS:
        if stripped.startswith(k + ' = "'):
            hit = k
            break
    if hit:
        new = line.replace(SZARITH[0], SZARITH[1])
        for old, repl in FIXED:
            new = new.replace(old, repl)
        new, n = MEMORIAL.subn(memorial_sub, new)
        touched[hit] += 1
        line = new
    out.append(line)

for k, n in touched.items():
    print('%s: %d regels bewerkt' % (k, n))
if any(n != 7 for n in touched.values()):
    print('niet overal 7 — NIETS geschreven')
    sys.exit(1)

body = eol.join(out)
print('memorial-links totaal: %d (verwacht 84 = 12 x 7)' % body.count('{WAY:2509:4') if False else '')
count_mem = len(re.findall(r'\{WAY:2509:\d', body))
print('WAY-links op 2509: %d · op 2613: %d' % (count_mem, len(re.findall(r'\{WAY:2613:', body))))

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(body)
os.replace(P + '.tmp', P)
print('geschreven')
