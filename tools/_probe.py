# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: split CODEX_ATALUTEK_BODY into three articles, in place, in all
seven languages — without rewriting a word. Second attempt: the first shipped
curly apostrophes in the itIT/frFR anchors where the file has straight ones
(this afternoon's rewrite wrote them straight), and the all-or-nothing guard
stopped everything before damage.

  1. main — what it is, the quest chain, the two currencies, Er'inye
  2. disc — the Altar bullet (four keys) + the Er'inye-hint paragraph
  3. dead — the Honored Dead walk, the Underbelly, the three rares
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
W, R = '|cffffffff', '|r'

ALTAR_ANCHOR = {
    'enUS': "• %sThe Altar of Corrosion%s is the node tree" % (W, R),
    'itIT': "• %sL'Altar of Corrosion%s è l'albero" % (W, R),
    'nlNL': "• %sThe Altar of Corrosion%s is de boom" % (W, R),
    'deDE': "• %sDer Altar of Corrosion%s ist der Knotenbaum" % (W, R),
    'frFR': "• %sL'Altar of Corrosion%s est l'arbre" % (W, R),
    'esES': "• %sEl Altar of Corrosion%s es el árbol" % (W, R),
    'ptBR': "• %sO Altar of Corrosion%s é a árvore" % (W, R),
}

TITLES_DISC = {
    'enUS': 'Altar of Corrosion: the four keys',
    'nlNL': 'Altar of Corrosion: de vier sleutels',
    'deDE': 'Altar of Corrosion: die vier Schlüssel',
    'frFR': 'Altar of Corrosion : les quatre clés',
    'esES': 'Altar of Corrosion: las cuatro llaves',
    'ptBR': 'Altar of Corrosion: as quatro chaves',
    'itIT': 'Altar of Corrosion: le quattro chiavi',
}
TITLES_DEAD = {
    'enUS': 'The Honored Dead & the rares',
    'nlNL': 'The Honored Dead & de rares',
    'deDE': 'The Honored Dead & die Rares',
    'frFR': 'The Honored Dead & les rares',
    'esES': 'The Honored Dead y los raros',
    'ptBR': 'The Honored Dead e os raros',
    'itIT': 'The Honored Dead e i rari',
}

for tbl in (TITLES_DISC, TITLES_DEAD):
    for v in tbl.values():
        assert '"' not in v

LANG_ORDER = ['enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR']  # file order

t = io.open(P, encoding='utf-8', newline='').read()
if 'CODEX_ATALUTEK_DISC_BODY' in t:
    print('staat er al — niets gedaan')
    sys.exit(0)
eol = '\r\n' if '\r\n' in t else '\n'
lines = t.split(eol)

occurrence = 0
changed = 0
out = []
for line in lines:
    stripped = line.lstrip()
    if stripped.startswith('CODEX_ATALUTEK_BODY = "'):
        lang = LANG_ORDER[occurrence]
        occurrence += 1
        indent = line[:len(line) - len(line.lstrip())]
        body = stripped[len('CODEX_ATALUTEK_BODY = "'):]
        assert body.endswith('",'), lang
        body = body[:-2]

        ai = body.find(ALTAR_ANCHOR[lang])
        hi = body.find('The Honored Dead')
        if ai == -1 or hi == -1 or hi < ai:
            print('%s: ankers niet gevonden (altar %d, honored %d) — NIETS geschreven' % (lang, ai, hi))
            sys.exit(1)
        hcut = body.rfind('|n•', 0, hi)
        if hcut == -1:
            print('%s: bullet-grens voor Honored Dead niet gevonden' % lang)
            sys.exit(1)

        main = body[:ai].rstrip()
        if main.endswith('|n'):
            main = main[:-2]
        disc = body[ai:hcut]
        dead = body[hcut + 2:]  # de '|n' overslaan, de '•' houden

        out.append('%sCODEX_ATALUTEK_BODY = "%s",' % (indent, main))
        out.append('%sCODEX_ATALUTEK_DISC_TITLE = "%s",' % (indent, TITLES_DISC[lang]))
        out.append('%sCODEX_ATALUTEK_DISC_BODY = "%s",' % (indent, disc))
        out.append('%sCODEX_ATALUTEK_DEAD_TITLE = "%s",' % (indent, TITLES_DEAD[lang]))
        out.append('%sCODEX_ATALUTEK_DEAD_BODY = "%s",' % (indent, dead))
        changed += 1
        print('%s: gesplitst (%d / %d / %d tekens)' % (lang, len(main), len(disc), len(dead)))
    else:
        out.append(line)

if changed != 7:
    print('%d van 7 — NIETS geschreven' % changed)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
