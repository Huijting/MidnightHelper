# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: two enrichments the second research pass earned.

1. WHY the Windcallers exist. You cannot fly inside the Vaults. Without that
   sentence the flight-hop bullet reads as a convenience; with it, it is the
   answer to "why does crossing this place take so long".

2. WHY you spend coin early. The tree's first four nodes are free and give
   +25/50/75/100% Corrosive Coin, so the tree pays for itself and every lap
   after the first is richer. That single fact reorders a player's whole first
   evening, and it was nowhere on the page.

Also records the asymmetry that explains the zone's pacing: coin is uncapped,
souls are throttled. Chasing souls is how you end up frustrated.

⚠️ The Corrode Spirit cost curve is NOT added and the one already in
docs/VAULTS_DISCOVERIES.md is now suspect: the second pass checked the
arithmetic on the published ladder and its own fourteen values sum to 98,000
against the 95,500 the same pages claim, with a third figure of 115,000 in
circulation. Three mutually inconsistent numbers from one lineage of sources.
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


def col(s):
    """Alternate %s markers into open/close colour codes; refuse odd counts."""
    parts = s.split('%s')
    assert (len(parts) - 1) % 2 == 0, 'oneven aantal markers: %d' % (len(parts) - 1)
    out = [parts[0]]
    for i, chunk in enumerate(parts[1:]):
        out.append(W if i % 2 == 0 else R)
        out.append(chunk)
    return ''.join(out)


# ---- 1. "no flying" into the Windcaller bullet ------------------------------
FLY = {
    'enUS': ('The place is bigger than it looks and walking it is the slow way.',
             'You cannot fly inside the Vaults, which is exactly why they are there — '
             'the place is bigger than it looks and walking it is the slow way.'),
    'nlNL': ('Het is er groter dan het lijkt en lopen is de trage manier.',
             'Vliegen kan niet binnen de Vaults, en daarom bestaan ze — het is er groter '
             'dan het lijkt en lopen is de trage manier.'),
    'deDE': ('Es ist größer, als es aussieht, und laufen ist der langsame Weg.',
             'Fliegen geht in den Vaults nicht, und genau deshalb gibt es sie — es ist '
             'größer, als es aussieht, und laufen ist der langsame Weg.'),
    'frFR': ('C’est plus grand que ça n’en a l’air, et marcher est la manière lente.',
             'On ne peut pas voler dans les Vaults, et c’est précisément pour ça qu’ils '
             'existent — c’est plus grand que ça n’en a l’air, et marcher est la manière lente.'),
    'esES': ('Es más grande de lo que parece, y andar es la forma lenta.',
             'No se puede volar dentro de las Vaults, y por eso están ahí — es más grande '
             'de lo que parece, y andar es la forma lenta.'),
    'ptBR': ('É maior do que parece, e andar a pé é o caminho lento.',
             'Não se pode voar dentro das Vaults, e é precisamente por isso que existem — '
             'é maior do que parece, e andar a pé é o caminho lento.'),
    'itIT': ('È più grande di quanto sembri, e andare a piedi è la via lenta.',
             'Dentro le Vaults non si può volare, ed è esattamente per questo che ci sono — '
             'è più grande di quanto sembri, e andare a piedi è la via lenta.'),
}

# ---- 2. the tree pays for itself, appended to the Discoveries article -------
TREE = {
    'enUS': col(
        '|n• %sSpend your first coin on the tree straight away.%s Its first four nodes cost '
        'nothing and unlock as you spend elsewhere, and they raise the Corrosive Coin you '
        'earn by %s25, 50, 75 and finally 100 percent%s. The tree pays for itself, so every '
        'lap after the first one is richer — saving up is the expensive choice. And note the '
        'asymmetry that sets this zone’s pace: %scoin has no cap%s, while Corrosive Souls are '
        'rationed. Farm coin freely; do not plan an evening around souls.'),
    'nlNL': col(
        '|n• %sGeef je eerste munten meteen uit aan de boom.%s De eerste vier nodes kosten '
        'niets en gaan vanzelf open naarmate je elders uitgeeft, en ze verhogen de Corrosive '
        'Coin die je verdient met %s25, 50, 75 en uiteindelijk 100 procent%s. De boom betaalt '
        'zichzelf terug, dus elke ronde ná de eerste levert meer op — sparen is juist de dure '
        'keuze. En let op de scheefheid die het tempo van deze zone bepaalt: %sop munten zit '
        'geen cap%s, op Corrosive Souls wel. Farm munten gerust; plan je avond niet rond souls.'),
    'deDE': col(
        '|n• %sGib deine ersten Münzen sofort im Baum aus.%s Seine ersten vier Knoten kosten '
        'nichts und öffnen sich, während du anderswo ausgibst, und sie erhöhen die Corrosive '
        'Coin, die du verdienst, um %s25, 50, 75 und schließlich 100 Prozent%s. Der Baum zahlt '
        'sich selbst, also ist jede Runde nach der ersten ergiebiger — sparen ist die teure '
        'Wahl. Und beachte die Schieflage, die das Tempo dieser Zone bestimmt: %sMünzen haben '
        'keine Grenze%s, Corrosive Souls dagegen schon. Farme Münzen frei; plane keinen Abend '
        'um Souls herum.'),
    'frFR': col(
        '|n• %sDépense tes premières pièces dans l’arbre tout de suite.%s Ses quatre premiers '
        'nœuds ne coûtent rien et s’ouvrent à mesure que tu dépenses ailleurs, et ils '
        'augmentent la Corrosive Coin que tu gagnes de %s25, 50, 75 puis 100 pour cent%s. '
        'L’arbre se rembourse tout seul : chaque tour après le premier rapporte plus — '
        'économiser est le choix coûteux. Note aussi l’asymétrie qui donne son rythme à la '
        'zone : %sles pièces n’ont pas de plafond%s, les Corrosive Souls si. Farme les pièces '
        'librement ; ne planifie pas une soirée autour des souls.'),
    'esES': col(
        '|n• %sGasta tus primeras monedas en el árbol de inmediato.%s Sus cuatro primeros '
        'nodos no cuestan nada y se abren mientras gastas en otra parte, y aumentan la '
        'Corrosive Coin que ganas un %s25, 50, 75 y finalmente 100 por ciento%s. El árbol se '
        'paga solo, así que cada vuelta después de la primera rinde más — ahorrar es la '
        'opción cara. Y fíjate en la asimetría que marca el ritmo de la zona: %slas monedas no '
        'tienen tope%s, las Corrosive Souls sí. Farmea monedas sin miedo; no planees una noche '
        'alrededor de las souls.'),
    'ptBR': col(
        '|n• %sGasta as tuas primeiras moedas na árvore já.%s Os quatro primeiros nós não '
        'custam nada e abrem à medida que gastas noutro sítio, e aumentam a Corrosive Coin que '
        'ganhas em %s25, 50, 75 e por fim 100 por cento%s. A árvore paga-se a si própria, por '
        'isso cada volta depois da primeira rende mais — poupar é a escolha cara. E repara na '
        'assimetria que define o ritmo da zona: %sas moedas não têm limite%s, as Corrosive '
        'Souls têm. Farma moedas à vontade; não planeies uma noite à volta das souls.'),
    'itIT': col(
        '|n• %sSpendi subito le prime monete nell’albero.%s I suoi primi quattro nodi non '
        'costano nulla e si aprono mentre spendi altrove, e alzano la Corrosive Coin che '
        'guadagni del %s25, 50, 75 e infine 100 per cento%s. L’albero si ripaga da solo, '
        'quindi ogni giro dopo il primo rende di più — risparmiare è la scelta costosa. E nota '
        'l’asimmetria che detta il ritmo della zona: %sle monete non hanno tetto%s, le '
        'Corrosive Souls sì. Farma monete liberamente; non pianificare una serata intorno alle '
        'souls.'),
}

for tbl in (TREE,):
    for code, text in tbl.items():
        assert '"' not in text, code
        assert '%' not in text, code

t = io.open(P, encoding='utf-8', newline='').read()
if 'Spend your first coin' in t or 'eerste munten meteen' in t:
    print('staat er al')
    sys.exit(0)

# 1. the flying sentence, per language, one hit each
for code, (old, new) in FLY.items():
    n = t.count(old)
    if n != 1:
        print('%s: vlieg-anker %d keer (verwacht 1) — NIETS geschreven' % (code, n))
        sys.exit(1)
    t = t.replace(old, new)
print('vliegzin: 7 van 7')

# 2. the tree bullet, appended to each DISC body (ends with `.",`)
LANGS = ['enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR']
eol = '\r\n' if '\r\n' in t else '\n'
lines, occurrence, changed = t.split(eol), 0, 0
out = []
for line in lines:
    if line.lstrip().startswith('CODEX_ATALUTEK_DISC_BODY = "'):
        lang = LANGS[occurrence]
        occurrence += 1
        assert line.rstrip().endswith('",'), lang
        cut = line.rstrip()[:-2]
        line = cut + TREE[lang] + '",'
        changed += 1
        print('%s: boom-bullet toegevoegd' % lang)
    out.append(line)

if changed != 7:
    print('%d van 7 — NIETS geschreven' % changed)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
