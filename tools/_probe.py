# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: give the Vaults article hierarchy instead of only air.

Blank lines between bullets helped, but nine equally-weighted bullets in a
row still give the eye no map. Rob: "kijk er zelf als een nitwit naar." A
nitwit arriving with one question wants to know which THIRD of the page to
read, and right now every bullet advertises itself equally loudly.

Three section headings, in the blue this addon already uses for section
labels in /mh atal — so the colour means the same thing in both places:

    Getting started   what it is, how you get in
    What you do here  the loop, finding a Strike, moving around, the weekly
    Coin and Soul     the two tokens and where they go

The third heading is deliberately NOT "the two currencies". Corrosive Soul
is not a currency — the bullet underneath exists to say exactly that — so a
heading claiming otherwise would contradict its own section. Both names are
Blizzard's, so that heading is identical in all seven languages.
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
KEY = 'CODEX_ATALUTEK_BODY'
BLUE = '|cff8fd3ff%s|r'

# The merge blocks appear in this fixed order in Codex.lua; verified by grep
# before writing, and asserted below by counting hits.
ORDER = ('enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR')

HEAD = {
    'enUS': ('Getting started', 'What you do here'),
    'itIT': ('Per cominciare', 'Cosa si fa qui'),
    'nlNL': ('Om te beginnen', 'Wat je hier doet'),
    'deDE': ('Zum Einstieg', 'Was du hier machst'),
    'frFR': ('Pour commencer', 'Ce que tu fais ici'),
    'esES': ('Para empezar', u'Qu\u00e9 se hace aqu\u00ed'),
    'ptBR': (u'Para come\u00e7ar', u'O que se faz aqui'),
}
COIN = 'Coin and Soul'   # both proper nouns — untranslated everywhere

t = io.open(P, encoding='utf-8', newline='').read()
if '|cff8fd3ff' in t:
    print('koppen staan er al')
    sys.exit(0)

eol = '\r\n' if '\r\n' in t else '\n'
out = []
seen = 0

for line in t.split(eol):
    stripped = line.lstrip()
    if not stripped.startswith(KEY + ' = "'):
        out.append(line)
        continue

    lang = ORDER[seen] if seen < len(ORDER) else None
    seen += 1
    if lang is None:
        print('MEER dan 7 treffers — niets geschreven')
        sys.exit(1)

    indent = line[:len(line) - len(line.lstrip())]
    body = stripped[len(KEY) + 4:]
    assert body.endswith('",'), lang
    body = body[:-2]

    parts = body.split('|n|n•')
    bullets = [parts[0]] + ['•' + p for p in parts[1:]]
    if len(bullets) != 9:
        print('%s heeft %d bullets, verwacht 9 — niets geschreven'
              % (lang, len(bullets)))
        sys.exit(1)

    a, b = HEAD[lang]
    # Insert from the back so the earlier index stays valid.
    bullets.insert(6, BLUE % COIN)
    bullets.insert(2, BLUE % b)
    bullets.insert(0, BLUE % a)

    out.append('%s%s = "%s",' % (indent, KEY, '|n|n'.join(bullets)))
    print('%-6s koppen: %s / %s / %s' % (lang, a, b, COIN))

if seen != 7:
    print('%d van 7 — niets geschreven' % seen)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
