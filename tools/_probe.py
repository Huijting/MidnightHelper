# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: DELVE_REWARDS_UNMEASURED in all seven packs, anchored on
DELVE_TIP_UNMEASURED (added yesterday, so present exactly once per pack).

The sentence has to do two things at once: admit we do not know, and tell the
reader where the real number is (their own loot). Season names are not
translated; "Season 2" stays English per the house rules.
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
    'enUS': 'Season 2 changed these item levels and Midnight Helper has not measured the new ones yet. Rather than show you Season 1 numbers that are now too low, this list stays empty until a real run fills it in. Your end-of-delve chest and your Great Vault are the honest answer.',
    'nlNL': 'Season 2 heeft deze item levels veranderd en Midnight Helper heeft de nieuwe nog niet gemeten. In plaats van Season 1-getallen te tonen die nu te laag zijn, blijft deze lijst leeg tot een echte run hem vult. Je eindkist en je Great Vault zijn het eerlijke antwoord.',
    'deDE': 'Season 2 hat diese Gegenstandsstufen geändert, und Midnight Helper hat die neuen noch nicht gemessen. Statt dir Season-1-Zahlen zu zeigen, die jetzt zu niedrig sind, bleibt diese Liste leer, bis ein echter Durchlauf sie füllt. Deine Endtruhe und dein Great Vault sind die ehrliche Antwort.',
    'frFR': 'La Season 2 a changé ces niveaux d’objet et Midnight Helper n’a pas encore mesuré les nouveaux. Plutôt que de t’afficher des chiffres de Season 1 désormais trop bas, cette liste reste vide jusqu’à ce qu’un vrai run la remplisse. Ton coffre de fin et ton Great Vault sont la réponse honnête.',
    'esES': 'La Season 2 cambió estos niveles de objeto y Midnight Helper aún no ha medido los nuevos. En lugar de enseñarte cifras de Season 1 que ahora se quedan cortas, esta lista permanece vacía hasta que una partida real la rellene. Tu cofre final y tu Great Vault son la respuesta honesta.',
    'ptBR': 'A Season 2 alterou estes níveis de item e o Midnight Helper ainda não mediu os novos. Em vez de te mostrar números da Season 1 que agora ficam aquém, esta lista fica vazia até que uma run a preencha. A tua arca final e o teu Great Vault são a resposta honesta.',
    'itIT': 'La Season 2 ha cambiato questi livelli oggetto e Midnight Helper non ha ancora misurato i nuovi. Invece di mostrarti numeri della Season 1 ormai troppo bassi, questa lista resta vuota finché una run vera non la riempie. Il tuo forziere finale e il tuo Great Vault sono la risposta onesta.',
}

for text in NEW.values():
    assert '"' not in text, text[:50]

TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    if 'DELVE_REWARDS_UNMEASURED' in t:
        print('%s: staat er al' % name)
        continue
    eol = '\r\n' if '\r\n' in t else '\n'
    out, added = [], 0
    for line in t.split(eol):
        out.append(line)
        if 'DELVE_TIP_UNMEASURED' in line and added < len(codes):
            indent = line[:len(line) - len(line.lstrip())]
            out.append('%sDELVE_REWARDS_UNMEASURED = "%s",' % (indent, NEW[codes[added]]))
            added += 1
    if added != len(codes):
        print('%s: %d van %d ankers — NIETS geschreven' % (name, added, len(codes)))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(path + '.tmp', path)
    print('%s: %d toegevoegd' % (name, added))
