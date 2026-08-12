"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the three SMC pin keys in seven languages.
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

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'
ORDER = ['SMC_PIN_GOTO_FMT', 'SMC_PIN_TRAINER_FMT', 'SMC_PIN_CLICK_HINT']

PACK = {
    'enUS': {
        'SMC_PIN_GOTO_FMT': 'Set a waypoint to %s.',
        'SMC_PIN_TRAINER_FMT': 'Set a waypoint to the %s trainer.',
        'SMC_PIN_CLICK_HINT': 'Click: map pin + /way #2393 (TomTom when you have it)',
    },
    'nlNL': {
        'SMC_PIN_GOTO_FMT': 'Zet een waypoint naar %s.',
        'SMC_PIN_TRAINER_FMT': 'Zet een waypoint naar de %s-trainer.',
        'SMC_PIN_CLICK_HINT': 'Klik: kaartpin + /way #2393 (TomTom als je die hebt)',
    },
}
FILLS = {
    'deDE': {
        'SMC_PIN_GOTO_FMT': 'Setzt einen Wegpunkt zu %s.',
        'SMC_PIN_TRAINER_FMT': 'Setzt einen Wegpunkt zum %s-Lehrer.',
        'SMC_PIN_CLICK_HINT': 'Klick: Kartenmarkierung + /way #2393 (TomTom, falls vorhanden)',
    },
    'frFR': {
        'SMC_PIN_GOTO_FMT': 'Place un point de passage vers %s.',
        'SMC_PIN_TRAINER_FMT': 'Place un point de passage vers le ma\u00eetre de %s.',
        'SMC_PIN_CLICK_HINT': 'Clic : point sur la carte + /way #2393 (TomTom si tu l\u2019as)',
    },
    'esES': {
        'SMC_PIN_GOTO_FMT': 'Marca un punto de ruta hacia %s.',
        'SMC_PIN_TRAINER_FMT': 'Marca un punto de ruta hacia el maestro de %s.',
        'SMC_PIN_CLICK_HINT': 'Clic: marca en el mapa + /way #2393 (TomTom si lo tienes)',
    },
    'ptBR': {
        'SMC_PIN_GOTO_FMT': 'Marca um ponto de rota at\u00e9 %s.',
        'SMC_PIN_TRAINER_FMT': 'Marca um ponto de rota at\u00e9 o treinador de %s.',
        'SMC_PIN_CLICK_HINT': 'Clique: marca\u00e7\u00e3o no mapa + /way #2393 (TomTom se tiveres)',
    },
    'itIT': {
        'SMC_PIN_GOTO_FMT': 'Imposta un waypoint verso %s.',
        'SMC_PIN_TRAINER_FMT': 'Imposta un waypoint verso il maestro di %s.',
        'SMC_PIN_CLICK_HINT': 'Clic: segnalino sulla mappa + /way #2393 (TomTom se ce l\u2019hai)',
    },
}

for code, keys in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if ORDER[0] in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tPROFHUB_RESET_HINT = .*$', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    for k in ORDER:
        assert '"' not in keys[k], (code, k)
    block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER)
    t = t[:m.end()] + nl + block + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
if ORDER[0] in t:
    print('Translations2026: stond er al in')
else:
    nl = '\r\n' if '\r\n' in t else '\n'
    for code, keys in FILLS.items():
        for k in ORDER:
            assert '"' not in keys[k], (code, k)
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        block = nl.join('\t%s = "%s",' % (k, keys[k]) for k in ORDER) + nl
        t = t[:end] + block + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')
