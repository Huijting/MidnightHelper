"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: tell the Codex where Corrosive Coins go. Er'inye, measured by Rob at
2509 51.10 / 62.76 on 14 Aug.

Inserted before the Altar bullet in each language, so the reader meets the coin's
destination just before the tree it feeds. The PRICE is deliberately absent: the
game's own tooltip names Er'inye, but "1000" comes from a guide and nobody has
photographed that window yet.
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
W, R, N = '|cffffffff', '|r', '|n'

# Anchor: the first words of the Altar bullet, per language.
ANCHORS = {
    'en': '• %sThe Altar of Corrosion%s is the node tree' % (W, R),
    'nl': '• %sThe Altar of Corrosion%s is de boom met nodes' % (W, R),
    'it': '• %sThe Altar of Corrosion%s' % (W, R),
    'de': '• %sThe Altar of Corrosion%s',
    'fr': '• %sThe Altar of Corrosion%s',
    'es': '• %sThe Altar of Corrosion%s',
    'pt': '• %sThe Altar of Corrosion%s',
}

LINE = {
    'enUS': '• %sWhere the coins go:%s %sEr\u2019inye%s, at %s51.10, 62.76%s on the Vaults map, beside the Altar. Talk to him and he corrodes your spirit in exchange for coin \u2014 that is what feeds the tree. His window names the price; this page does not, because nobody has read it yet.' % (W, R, W, R, W, R),
    'nlNL': '• %sWaar de munten heen gaan:%s %sEr\u2019inye%s, op %s51.10, 62.76%s op de Vaults-kaart, naast de Altar. Praat met hem en hij corrodeert je geest in ruil voor munten \u2014 dat is wat de boom voedt. Zijn venster noemt de prijs; deze pagina niet, want niemand heeft hem gelezen.' % (W, R, W, R, W, R),
    'deDE': '• %sWohin die M\u00fcnzen gehen:%s %sEr\u2019inye%s, bei %s51.10, 62.76%s auf der Vaults-Karte, neben dem Altar. Sprich mit ihm, und er zersetzt deinen Geist gegen M\u00fcnzen \u2014 das ist es, was den Baum speist. Sein Fenster nennt den Preis; diese Seite nicht, denn niemand hat ihn gelesen.' % (W, R, W, R, W, R),
    'frFR': '• %sO\u00f9 vont les pi\u00e8ces :%s %sEr\u2019inye%s, en %s51.10, 62.76%s sur la carte des Vaults, \u00e0 c\u00f4t\u00e9 de l\u2019autel. Parle-lui et il corrode ton esprit contre des pi\u00e8ces \u2014 c\u2019est ce qui alimente l\u2019arbre. Sa fen\u00eatre annonce le prix ; pas cette page, car personne ne l\u2019a lu.' % (W, R, W, R, W, R),
    'esES': '• %sAd\u00f3nde van las monedas:%s %sEr\u2019inye%s, en %s51.10, 62.76%s del mapa de las Vaults, junto al altar. Habla con \u00e9l y corroe tu esp\u00edritu a cambio de monedas \u2014 eso es lo que alimenta el \u00e1rbol. Su ventana dice el precio; esta p\u00e1gina no, porque nadie lo ha le\u00eddo.' % (W, R, W, R, W, R),
    'ptBR': '• %sPara onde v\u00e3o as moedas:%s %sEr\u2019inye%s, em %s51.10, 62.76%s no mapa das Vaults, ao lado do altar. Fala com ele e ele corr\u00f3i o teu esp\u00edrito em troca de moedas \u2014 \u00e9 isso que alimenta a \u00e1rvore. A janela dele diz o pre\u00e7o; esta p\u00e1gina n\u00e3o, porque ningu\u00e9m o leu.' % (W, R, W, R, W, R),
    'itIT': '• %sDove finiscono le monete:%s %sEr\u2019inye%s, a %s51.10, 62.76%s sulla mappa delle Vaults, accanto all\u2019altare. Parlagli e corrode il tuo spirito in cambio di monete \u2014 \u00e8 questo che alimenta l\u2019albero. La sua finestra dice il prezzo; questa pagina no, perch\u00e9 nessuno l\u2019ha letta.' % (W, R, W, R, W, R),
}

for text in LINE.values():
    assert '"' not in text, text[:50]

t = open(P, encoding='utf-8', newline='').read()

# ⚠️ The article name stays English but each language puts its OWN article in front
# of it -- L', Der, El, O. A single anchor found 2 of 7, which the assert caught;
# guessing one anchor for seven languages is how a locale edit half-lands.
# File order verified by reading the merge blocks.
ORDER = [
    ('enUS', '|n• %sThe Altar of Corrosion%s is the node tree' % (W, R)),
    # itIT and frFR both open with L', so each needs enough of its own sentence.
    ('itIT', "|n• %sL'Altar of Corrosion%s è l'albero" % (W, R)),
    ('nlNL', '|n• %sThe Altar of Corrosion%s is de boom' % (W, R)),
    ('deDE', '|n• %sDer Altar of Corrosion%s' % (W, R)),
    ('frFR', "|n• %sL'Altar of Corrosion%s est" % (W, R)),
    ('esES', '|n• %sEl Altar of Corrosion%s' % (W, R)),
    ('ptBR', '|n• %sO Altar of Corrosion%s' % (W, R)),
]

for code, anchor in ORDER:
    n = t.count(anchor)
    if n != 1:
        print('%s: %d treffers voor het anker — NIETS geschreven' % (code, n))
        raise SystemExit(1)

t2, i = t, 0
for code, anchor in ORDER:
    t2 = t2.replace(anchor, '|n' + LINE[code] + anchor, 1)
    i += 1
    print('%s: ok' % code)
print('%d regels ingevoegd' % i)
if i == 7:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t2)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('NIETS geschreven')
