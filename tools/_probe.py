# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: WAY_FLIGHT_HINT in seven packs, anchored on WAY_NO_PIN.
One %s = the flight point's name, which stays in Blizzard's spelling
(a proper noun the player will read off their own flight map).
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
    'enUS': 'Nearest flight point there: %s.',
    'nlNL': 'Dichtstbijzijnde flight point daar: %s.',
    'deDE': 'Nächster Flugpunkt dort: %s.',
    'frFR': 'Point de vol le plus proche là-bas : %s.',
    'esES': 'Punto de vuelo más cercano allí: %s.',
    'ptBR': 'Ponto de voo mais próximo lá: %s.',
    'itIT': 'Punto volo più vicino lì: %s.',
}
for code, text in NEW.items():
    assert '"' not in text, code
    assert text.count('%s') == 1, code

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'WAY_FLIGHT_HINT' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    for line in t.split(eol):
        out.append(line)
        if 'WAY_NO_PIN' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            out.append('%sWAY_FLIGHT_HINT = "%s",' % (indent, NEW[codes[added]]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d toegevoegd' % (name, added))
