# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: ACH_TREASURE_COILEDISLE, seven packs, anchored on
ACH_TREASURE_EVERSONG.

This key is only a FALLBACK — AchievementName() asks the client for the real
achievement title first and only lands here if the API is unavailable. So the
zone name stays English (Blizzard owns it) and the surrounding word follows
each language, the same rule the other four hunt titles already follow.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'

NEW = {
    'enUS': 'Treasures of the Coiled Isle',
    'nlNL': 'Schatten van de Coiled Isle',
    'deDE': 'Schätze der Coiled Isle',
    'frFR': 'Trésors de la Coiled Isle',
    'esES': 'Tesoros de la Coiled Isle',
    'ptBR': 'Tesouros da Coiled Isle',
    'itIT': 'Tesori della Coiled Isle',
}
for code, text in NEW.items():
    assert '"' not in text, code

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'ACH_TREASURE_COILEDISLE' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    for line in t.split(eol):
        out.append(line)
        if 'ACH_TREASURE_EVERSONG' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            out.append('%sACH_TREASURE_COILEDISLE = "%s",' % (indent, NEW[codes[added]]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d ankers — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d toegevoegd' % (name, added))
