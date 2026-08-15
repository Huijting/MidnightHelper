# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: three strings for the waypoint-click feedback, seven packs,
anchored on DELVE_REWARDS_UNMEASURED (added an hour ago, once per pack).

Format arguments, in order:
  WAY_SET_HERE      %s = label
  WAY_SET_ELSEWHERE %s = label, %s = target zone, %s = the zone you are in
  WAY_NO_PIN        %s = label, %s = target zone

Every language keeps its own %s ORDER identical to enUS — Lua's string.format
has no positional specifiers, so a translator who reorders them silently swaps
two zone names. Checked below.
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

K = {}
K['WAY_SET_HERE'] = {
    'enUS': 'Waypoint set: %s.',
    'nlNL': 'Waypoint gezet: %s.',
    'deDE': 'Wegpunkt gesetzt: %s.',
    'frFR': 'Point de repère posé : %s.',
    'esES': 'Punto marcado: %s.',
    'ptBR': 'Ponto marcado: %s.',
    'itIT': 'Waypoint impostato: %s.',
}
K['WAY_SET_ELSEWHERE'] = {
    'enUS': 'Waypoint set: %s, in %s. You are in %s — travel there first and the arrow will pick you up.',
    'nlNL': 'Waypoint gezet: %s, in %s. Jij staat in %s — ga daar eerst heen, dan pakt de pijl je op.',
    'deDE': 'Wegpunkt gesetzt: %s, in %s. Du bist in %s — reise erst dorthin, dann übernimmt der Pfeil.',
    'frFR': 'Point de repère posé : %s, dans %s. Tu es dans %s — va d’abord là-bas et la flèche prendra le relais.',
    'esES': 'Punto marcado: %s, en %s. Estás en %s — ve allí primero y la flecha te guiará.',
    'ptBR': 'Ponto marcado: %s, em %s. Estás em %s — vai lá primeiro e a seta trata do resto.',
    'itIT': 'Waypoint impostato: %s, in %s. Tu sei in %s — vacci prima, poi la freccia ti guida.',
}
K['WAY_NO_PIN'] = {
    'enUS': 'This map does not accept a waypoint without TomTom, so there is no arrow for %s in %s. The coordinates in the text are still correct.',
    'nlNL': 'Deze kaart accepteert geen waypoint zonder TomTom, dus er komt geen pijl voor %s in %s. De coördinaten in de tekst kloppen wel gewoon.',
    'deDE': 'Diese Karte akzeptiert ohne TomTom keinen Wegpunkt, also gibt es keinen Pfeil für %s in %s. Die Koordinaten im Text stimmen trotzdem.',
    'frFR': 'Cette carte n’accepte pas de point de repère sans TomTom, donc pas de flèche pour %s dans %s. Les coordonnées du texte restent correctes.',
    'esES': 'Este mapa no acepta un punto sin TomTom, así que no hay flecha para %s en %s. Las coordenadas del texto sí son correctas.',
    'ptBR': 'Este mapa não aceita um ponto sem o TomTom, por isso não há seta para %s em %s. As coordenadas no texto continuam certas.',
    'itIT': 'Questa mappa non accetta un waypoint senza TomTom, quindi niente freccia per %s in %s. Le coordinate nel testo restano corrette.',
}

# %s counts must match enUS exactly, or string.format errors / swaps arguments.
for key, table in K.items():
    want = table['enUS'].count('%s')
    for code, text in table.items():
        assert '"' not in text, (key, code)
        got = text.count('%s')
        assert got == want, ('%s/%s: %d van %d %%s' % (key, code, got, want))
print('placeholders kloppen: %s' % ', '.join('%s=%d' % (k, v['enUS'].count('%s')) for k, v in K.items()))

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]
ORDER = ['WAY_SET_HERE', 'WAY_SET_ELSEWHERE', 'WAY_NO_PIN']

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'WAY_SET_ELSEWHERE' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    for line in t.split(eol):
        out.append(line)
        if 'DELVE_REWARDS_UNMEASURED' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            for key in ORDER:
                out.append('%s%s = "%s",' % (indent, key, K[key][codes[added]]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d ankers — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d talen x 3 keys' % (name, added))
