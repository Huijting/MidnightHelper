# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: add the tenth quest — the Silvermoon weekly meta — to the article.

It returned no title on the first /mh atal and its full title on the second,
which is what a cache miss looks like and not what a wrong id looks like. Ten
of ten now match the addon's labels character for character.

Appended to the repeatables bullet (index 7 of twelve) in all seven languages.
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
ORDER = ('enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR')

META = "|cffffffffMidnight: Vaults of Atal'Utek|r"
CITY = '|cffffffffSilvermoon|r'

ADD = {
    'enUS': (u' And one you would never find by being here: ' + META
             + u' is a weekly meta for this place that you pick up in ' + CITY + u'.'),
    'itIT': (u' E una che qui non troveresti mai: ' + META
             + u' \u00e8 una meta settimanale di questo posto che si prende a ' + CITY + u'.'),
    'nlNL': (u' En \u00e9\u00e9n die je hier nooit vindt: ' + META
             + u' is een weekly meta voor deze plek die je in ' + CITY + u' ophaalt.'),
    'deDE': (u' Und eine, die du hier unten nie findest: ' + META
             + u' ist eine Wochen-Meta f\u00fcr diesen Ort, die du in ' + CITY + u' abholst.'),
    'frFR': (u' Et une que tu ne trouveras jamais en restant ici : ' + META
             + u' est une m\u00e9ta hebdomadaire pour cet endroit, \u00e0 r\u00e9cup\u00e9rer \u00e0 '
             + CITY + u'.'),
    'esES': (u' Y una que nunca encontrar\u00e1s estando aqu\u00ed: ' + META
             + u' es una meta semanal de este lugar que se recoge en ' + CITY + u'.'),
    'ptBR': (u' E uma que voc\u00ea nunca encontraria estando aqui: ' + META
             + u' \u00e9 uma meta semanal deste lugar que voc\u00ea pega em ' + CITY + u'.'),
}

t = io.open(P, encoding='utf-8', newline='').read()
if 'Midnight: Vaults of Atal' in t:
    print('de meta staat er al')
    sys.exit(0)

eol = '\r\n' if '\r\n' in t else '\n'
out, seen = [], 0

for line in t.split(eol):
    stripped = line.lstrip()
    if not stripped.startswith(KEY + ' = "'):
        out.append(line)
        continue

    lang = ORDER[seen]
    seen += 1
    indent = line[:len(line) - len(line.lstrip())]
    body = stripped[len(KEY) + 4:]
    assert body.endswith('",'), lang
    parts = body[:-2].split('|n|n')
    if len(parts) != 12:
        print('%s heeft %d blokken, verwacht 12 — niets geschreven' % (lang, len(parts)))
        sys.exit(1)
    if 'Essence of Malice' not in parts[7]:
        print('%s: blok 7 is niet de repeatables — niets geschreven' % lang)
        sys.exit(1)

    parts[7] = parts[7] + ADD[lang]
    out.append('%s%s = "%s",' % (indent, KEY, '|n|n'.join(parts)))
    print('%-6s aangevuld' % lang)

if seen != 7:
    print('%d van 7 — niets geschreven' % seen)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
