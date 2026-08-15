# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: CODEX_ROUTE_BTN next to every CODEX_CAT_COILEDISLE (7 packs). The
button that starts the Honored Dead hunt from the Codex article.
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

NEW = {
    'enUS': 'Follow the route',
    'itIT': 'Segui il percorso',
    'nlNL': 'Volg de route',
    'deDE': 'Der Route folgen',
    'frFR': 'Suivre la route',
    'esES': 'Seguir la ruta',
    'ptBR': 'Seguir a rota',
}
LANG_ORDER = ['enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR']

t = io.open(P, encoding='utf-8', newline='').read()
if 'CODEX_ROUTE_BTN' in t:
    print('staat er al')
    sys.exit(0)
eol = '\r\n' if '\r\n' in t else '\n'
out, n = [], 0
for line in t.split(eol):
    out.append(line)
    if 'CODEX_CAT_COILEDISLE' in line and n < 7:
        indent = line[:len(line) - len(line.lstrip())]
        out.append('%sCODEX_ROUTE_BTN = "%s",' % (indent, NEW[LANG_ORDER[n]]))
        n += 1
print('%d van 7' % n)
if n != 7:
    print('NIETS geschreven')
    sys.exit(1)
io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
