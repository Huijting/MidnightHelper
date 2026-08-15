"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: finish what the last run started. enUS lost its "Season 1" but the
other six packs still carry it, and three of them translate the word ("Saison",
"Temporada"), which is why a single anchor found only half of them.

Nothing else changes: the sentence keeps its own language and punctuation, only
the season number goes.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'

PAIRS = [
    ('itIT', 'Il tuo manuale per la Midnight Season 1 —', 'Il tuo manuale per Midnight —'),
    ('nlNL', 'Jouw Midnight Season 1-handboek —', 'Jouw Midnight-handboek —'),
    ('deDE', 'Dein Handbuch für Midnight Season 1 —', 'Dein Handbuch für Midnight —'),
    ('frFR', 'Ton manuel pour Midnight Saison 1 —', 'Ton manuel pour Midnight —'),
    ('esES', 'Tu manual para Midnight Temporada 1:', 'Tu manual para Midnight:'),
    ('ptBR', 'Seu manual para Midnight Temporada 1 —', 'Seu manual para Midnight —'),
]

t = io.open(P, encoding='utf-8', newline='').read()
changed, problems = 0, []

for code, old, new in PAIRS:
    n = t.count(old)
    if n != 1:
        problems.append('%s: anker %d keer gevonden (verwacht 1)' % (code, n))
        continue
    t = t.replace(old, new)
    changed += 1
    print('%s: ok' % code)

for p in problems:
    print(p)

if changed == len(PAIRS) and not problems:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('%d van %d — NIETS geschreven' % (changed, len(PAIRS)))
    sys.exit(1)

# Prove it: no CODEX_PANEL_INTRO may still name a season.
print('\n--- controle ---')
for i, line in enumerate(io.open(P, encoding='utf-8', newline='').read().splitlines(), 1):
    if 'CODEX_PANEL_INTRO' in line:
        low = line.lower()
        bad = ('season 1' in low) or ('saison 1' in low) or ('temporada 1' in low)
        print('%s regel %d' % ('FOUT ' if bad else 'ok   ', i))
