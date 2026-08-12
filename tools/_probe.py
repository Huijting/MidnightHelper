"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: PROFHUB_RESET_HINT in seven languages.
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
KEY = 'PROFHUB_RESET_HINT'

PACK = {
    'enUS': 'Changed your mind? Theremis in Silvermoon (Bazaar, by the crafting orders) '
            'resets one profession\u2019s Midnight specializations and hands your Knowledge '
            'back. The game\u2019s own warning: you lose every recipe tied to those choices, '
            'and it can only be done ONCE per profession.',
    'nlNL': 'Toch anders willen? Theremis in Silvermoon (Bazaar, bij de crafting orders) '
            'reset de Midnight-specializations van \u00e9\u00e9n beroep en geeft je Knowledge terug. '
            'De waarschuwing van het spel zelf: je verliest elk recept dat aan die keuzes '
            'hing, en het kan MAAR \u00c9\u00c9N KEER per beroep.',
}
FILLS = {
    'deDE': 'Anders \u00fcberlegt? Theremis in Silbermond (Basar, bei den Handwerksauftr\u00e4gen) '
            'setzt die Midnight-Spezialisierungen EINES Berufs zur\u00fcck und gibt dir dein '
            'Wissen wieder. Die Warnung des Spiels selbst: du verlierst jedes Rezept, das an '
            'diesen Entscheidungen hing, und es geht nur EINMAL pro Beruf.',
    'frFR': 'Tu as chang\u00e9 d\u2019avis ? Theremis \u00e0 Lune-d\u2019argent (Bazar, pr\u00e8s des commandes '
            'd\u2019artisanat) r\u00e9initialise les sp\u00e9cialisations Midnight d\u2019UN m\u00e9tier et te rend '
            'tes Connaissances. L\u2019avertissement du jeu lui-m\u00eame : tu perds toutes les '
            'recettes li\u00e9es \u00e0 ces choix, et cela ne peut se faire qu\u2019UNE SEULE FOIS par m\u00e9tier.',
    'esES': '\u00bfCambiaste de idea? Theremis en Ciudad Lunargenta (Bazar, junto a los encargos '
            'de artesan\u00eda) reinicia las especializaciones Midnight de UNA profesi\u00f3n y te '
            'devuelve el Conocimiento. El aviso del propio juego: pierdes todas las recetas '
            'ligadas a esas elecciones, y solo se puede hacer UNA VEZ por profesi\u00f3n.',
    'ptBR': 'Mudaste de ideia? Theremis em Luaprata (Bazar, junto \u00e0s encomendas de '
            'profiss\u00e3o) reinicia as especializa\u00e7\u00f5es Midnight de UMA profiss\u00e3o e devolve o teu '
            'Conhecimento. O aviso do pr\u00f3prio jogo: perdes todas as receitas ligadas a essas '
            'escolhas, e s\u00f3 pode ser feito UMA VEZ por profiss\u00e3o.',
    'itIT': 'Cambiato idea? Theremis a Lunargenta (Bazaar, vicino agli ordini di '
            'artigianato) azzera le specializzazioni Midnight di UNA professione e ti '
            'restituisce la Conoscenza. L\u2019avviso del gioco stesso: perdi ogni ricetta legata '
            'a quelle scelte, e si pu\u00f2 fare SOLO UNA VOLTA per professione.',
}

for code, text in PACK.items():
    p = os.path.join(BASE, '%s.lua' % code)
    t = open(p, encoding='utf-8', newline='').read()
    if KEY in t:
        print('%s: stond er al in' % code)
        continue
    nl = '\r\n' if '\r\n' in t else '\n'
    m = re.compile(r'^\tPROFHUB_ACCESSORY_HINT_FMT = .*$', re.M).search(t)
    if not m:
        print('%s: geen anker' % code)
        continue
    assert '"' not in text, code
    t = t[:m.end()] + nl + '\t%s = "%s",' % (KEY, text) + t[m.end():]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('%s: ok' % code)

p = os.path.join(BASE, 'Translations2026.lua')
t = open(p, encoding='utf-8', newline='').read()
if KEY in t:
    print('Translations2026: stond er al in')
else:
    nl = '\r\n' if '\r\n' in t else '\n'
    for code, text in FILLS.items():
        assert '"' not in text, code
        marker = 'fill("%s", {' % code
        start = t.rindex(marker)
        end = t.index('})', start)
        t = t[:end] + '\t%s = "%s",%s' % (KEY, text, nl) + t[end:]
    io.open(p + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(p + '.tmp', p)
    print('Translations2026: 5 talen')
