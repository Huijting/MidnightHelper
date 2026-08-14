"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: replace the Er'inye line with what Rob photographed on 14 Aug. Coins
go two ways, and the corrode price climbs — 1500 then 2000 in his own two
screenshots, against 1000 in a guide.

Per-language anchors again: each language puts its own article in front of the
English name, and a single anchor found 2 of 7 last time.
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

OLD = {
    'enUS': '• %sWhere the coins go:%s' % (W, R),
    'nlNL': '• %sWaar de munten heen gaan:%s' % (W, R),
    'deDE': '• %sWohin die M\u00fcnzen gehen:%s' % (W, R),
    'frFR': '• %sO\u00f9 vont les pi\u00e8ces :%s' % (W, R),
    'esES': '• %sAd\u00f3nde van las monedas:%s' % (W, R),
    'ptBR': '• %sPara onde v\u00e3o as moedas:%s' % (W, R),
    'itIT': '• %sDove finiscono le monete:%s' % (W, R),
}

NEW = {
    'enUS': '• %sWhere the coins go \u2014 two places, both at Er\u2019inye%s at %s51.10, 62.76%s. Talking to him buys %sCorrode Spirit%s, which is what feeds the Altar tree; beside him the %sSkull of Er\u2019inye%s is a merchant with three pages of mounts, pets, ensembles and recipes, priced from 500 to 25,000 coin. %sThe corrode price climbs every time you buy it%s \u2014 seen at 1,500 and then 2,000 on one visit \u2014 so read the window rather than saving up for a number.' % (W, R, W, R, W, R, W, R, W, R),
    'nlNL': '• %sWaar de munten heen gaan \u2014 twee plekken, allebei bij Er\u2019inye%s op %s51.10, 62.76%s. Met hem praten koopt %sCorrode Spirit%s, en dat is wat de Altar-boom voedt; naast hem is de %sSkull of Er\u2019inye%s een handelaar met drie pagina\u2019s mounts, pets, ensembles en recepten, van 500 tot 25.000 munt. %sDe corrode-prijs loopt elke keer op%s \u2014 gezien op 1.500 en daarna 2.000 in \u00e9\u00e9n bezoek \u2014 dus lees het venster in plaats van te sparen voor een bedrag.' % (W, R, W, R, W, R, W, R, W, R),
    'deDE': '• %sWohin die M\u00fcnzen gehen \u2014 zwei Stellen, beide bei Er\u2019inye%s bei %s51.10, 62.76%s. Mit ihm zu reden kauft %sCorrode Spirit%s, und das speist den Altar-Baum; neben ihm ist der %sSkull of Er\u2019inye%s ein H\u00e4ndler mit drei Seiten Reittiere, Haustiere, Ensembles und Rezepte, von 500 bis 25.000 M\u00fcnzen. %sDer Corrode-Preis steigt bei jedem Kauf%s \u2014 bei einem Besuch 1.500 und dann 2.000 gesehen \u2014 lies also das Fenster, statt auf eine Zahl zu sparen.' % (W, R, W, R, W, R, W, R, W, R),
    'frFR': '• %sO\u00f9 vont les pi\u00e8ces \u2014 deux endroits, tous deux chez Er\u2019inye%s en %s51.10, 62.76%s. Lui parler ach\u00e8te %sCorrode Spirit%s, qui alimente l\u2019arbre de l\u2019autel ; \u00e0 c\u00f4t\u00e9 de lui, le %sSkull of Er\u2019inye%s est un marchand avec trois pages de montures, mascottes, ensembles et recettes, de 500 \u00e0 25 000 pi\u00e8ces. %sLe prix du corrode monte \u00e0 chaque achat%s \u2014 vu \u00e0 1 500 puis 2 000 en une visite \u2014 lis donc la fen\u00eatre au lieu d\u2019\u00e9conomiser pour un montant.' % (W, R, W, R, W, R, W, R, W, R),
    'esES': '• %sAd\u00f3nde van las monedas \u2014 dos sitios, ambos en Er\u2019inye%s en %s51.10, 62.76%s. Hablar con \u00e9l compra %sCorrode Spirit%s, que alimenta el \u00e1rbol del altar; a su lado, la %sSkull of Er\u2019inye%s es un mercader con tres p\u00e1ginas de monturas, mascotas, conjuntos y recetas, de 500 a 25.000 monedas. %sEl precio del corrode sube cada vez que lo compras%s \u2014 visto a 1.500 y luego 2.000 en una visita \u2014 as\u00ed que lee la ventana en vez de ahorrar para una cifra.' % (W, R, W, R, W, R, W, R, W, R),
    'ptBR': '• %sPara onde v\u00e3o as moedas \u2014 dois s\u00edtios, ambos em Er\u2019inye%s em %s51.10, 62.76%s. Falar com ele compra %sCorrode Spirit%s, que alimenta a \u00e1rvore do altar; ao lado dele, a %sSkull of Er\u2019inye%s \u00e9 um mercador com tr\u00eas p\u00e1ginas de montarias, mascotes, conjuntos e receitas, de 500 a 25.000 moedas. %sO pre\u00e7o do corrode sobe a cada compra%s \u2014 visto a 1.500 e depois 2.000 numa visita \u2014 por isso l\u00ea a janela em vez de poupar para um valor.' % (W, R, W, R, W, R, W, R, W, R),
    'itIT': '• %sDove finiscono le monete \u2014 due posti, entrambi da Er\u2019inye%s a %s51.10, 62.76%s. Parlargli compra %sCorrode Spirit%s, che alimenta l\u2019albero dell\u2019altare; accanto a lui lo %sSkull of Er\u2019inye%s \u00e8 un mercante con tre pagine di cavalcature, mascotte, completi e ricette, da 500 a 25.000 monete. %sIl prezzo del corrode sale a ogni acquisto%s \u2014 visto a 1.500 e poi 2.000 in una visita \u2014 quindi leggi la finestra invece di risparmiare per una cifra.' % (W, R, W, R, W, R, W, R, W, R),
}

for text in NEW.values():
    assert '"' not in text, text[:50]

t = open(P, encoding='utf-8', newline='').read()

# Each old line runs from its opening to the |n that ends the bullet.
changed = 0
for code in OLD:
    start = t.find(OLD[code])
    if start == -1:
        print('%s: opening niet gevonden' % code)
        continue
    end = t.find('|n', start + len(OLD[code]))
    if end == -1:
        print('%s: einde niet gevonden' % code)
        continue
    t = t[:start] + NEW[code] + t[end:]
    changed += 1
    print('%s: ok' % code)

print('%d van %d' % (changed, len(OLD)))
if changed == len(OLD):
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('NIETS geschreven — alles of niets')
