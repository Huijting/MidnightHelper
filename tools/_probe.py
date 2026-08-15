# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: answer Cisca's question, which the page did not.

Rob: "Cisca lukt het maar niet om Temple strike te doen omdat ze geen idee van
hoe en waar." The article now says Strikes exist and that they build toward an
incursion — and never says how you find one or what you are looking for. That
is the difference between describing a system and helping someone use it, and
she is exactly the reader this addon is for.

Facts used, and where they come from:
  - Strikes show on the map and have no timer; they sit there until a group
    finishes them (method.gg, corroborated by Zygor's events guide having fixed
    start coordinates for each).
  - Six named Strikes with start points, from Zygor's ZygorEventsCommon.lua
    scenario blocks — the same file whose quest tips Rob photographed, so its
    wording is already proven against his client.
  - Three players are enough (method.gg, single source, flagged in the text by
    saying "a few" rather than a number).

⚠️ No respawn timer and no "every N minutes" for Strikes: sources disagree and
a wrong number sends someone to stand somewhere.
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
LANGS = ['enUS', 'itIT', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR']


def col(s):
    parts = s.split('%s')
    assert (len(parts) - 1) % 2 == 0, 'oneven aantal markers: %d' % (len(parts) - 1)
    out = [parts[0]]
    for i, chunk in enumerate(parts[1:]):
        out.append(W if i % 2 == 0 else R)
        out.append(chunk)
    return ''.join(out)


# The six Strike start points are identical in every language.
SPOTS = ('{WAY:2509:50.55:15.70:Cursed Depths} · {WAY:2509:47.36:46.17:Overflowing Venom} · '
         '{WAY:2509:47.67:46.34:Profane Pyres} · {WAY:2509:47.26:26.69:Purifying Earth and Sky} · '
         '{WAY:2509:39.32:39.92:Ruuk’Jar’s Clutch} · {WAY:2613:52.25:36.27:The Underbelly}')

NEW = {}

NEW['enUS'] = col(
    '|n• %sHow do I actually find a Temple Strike?%s Open your map inside the Vaults and look '
    'for the event icons — a Strike is marked there like any world event, and %sit has no '
    'timer%s: it sits and waits until a group finishes it, so you can take your time walking '
    'over. %sA few players is enough%s; you do not need a premade, and other people are '
    'usually already on it. There are six, and each starts in a fixed spot — click one to set '
    'a waypoint: ' + SPOTS + '.|nIf the map shows nothing, run Patrols for a while. Strikes '
    'appear because Patrols are being done, so the fastest way to make one exist is to keep '
    'playing.')

NEW['nlNL'] = col(
    '|n• %sHoe vind ik nou eigenlijk een Temple Strike?%s Open je kaart binnen de Vaults en '
    'kijk naar de event-iconen — een Strike staat daar net als elk ander wereld-event, en '
    '%shij heeft geen klok%s: hij blijft staan tot een groep hem afmaakt, dus je kunt er '
    'rustig heen lopen. %sEen paar spelers is genoeg%s; je hebt geen vooraf gemaakte groep '
    'nodig en meestal is er al iemand mee bezig. Er zijn er zes, elk met een vaste startplek '
    '— klik erop voor een waypoint: ' + SPOTS + '.|nStaat er niets op je kaart, doe dan een '
    'tijdje Patrols. Strikes verschijnen juist omdát er Patrols gedaan worden, dus doorspelen '
    'is de snelste manier om er één te laten ontstaan.')

NEW['deDE'] = col(
    '|n• %sWie finde ich denn nun einen Temple Strike?%s Öffne in den Vaults deine Karte und '
    'achte auf die Event-Symbole — ein Strike ist dort markiert wie jedes Weltereignis, und '
    '%ser hat keine Uhr%s: er bleibt stehen, bis eine Gruppe ihn beendet, du kannst also in '
    'Ruhe hinlaufen. %sEin paar Spieler reichen%s; du brauchst keine vorgefertigte Gruppe, und '
    'meist ist schon jemand dran. Es gibt sechs, jeder mit festem Startpunkt — klick einen an '
    'für einen Wegpunkt: ' + SPOTS + '.|nZeigt die Karte nichts, mach eine Weile Patrols. '
    'Strikes erscheinen, weil Patrols gemacht werden — weiterspielen ist also der schnellste '
    'Weg, einen entstehen zu lassen.')

NEW['frFR'] = col(
    '|n• %sComment trouver un Temple Strike, concrètement ?%s Ouvre ta carte dans les Vaults '
    'et cherche les icônes d’événement — un Strike y est marqué comme n’importe quel '
    'événement de zone, et %sil n’a pas de minuteur%s : il reste là jusqu’à ce qu’un groupe le '
    'termine, tu peux donc y aller tranquillement. %sQuelques joueurs suffisent%s ; pas besoin '
    'de groupe monté, et il y a généralement déjà du monde dessus. Il y en a six, chacun avec '
    'un point de départ fixe — clique pour poser un repère : ' + SPOTS + '.|nSi la carte '
    'n’affiche rien, fais des Patrols un moment. Les Strikes apparaissent parce que des '
    'Patrols sont faites : continuer à jouer est le plus rapide moyen d’en faire naître un.')

NEW['esES'] = col(
    '|n• %s¿Cómo encuentro realmente un Temple Strike?%s Abre el mapa dentro de las Vaults y '
    'busca los iconos de evento — un Strike aparece ahí como cualquier evento de zona, y %sno '
    'tiene temporizador%s: se queda esperando hasta que un grupo lo termina, así que puedes ir '
    'andando con calma. %sCon unos pocos jugadores basta%s; no hace falta grupo montado, y '
    'normalmente ya hay gente. Hay seis, cada uno con un punto de inicio fijo — pulsa para '
    'marcar: ' + SPOTS + '.|nSi el mapa no muestra nada, haz Patrols un rato. Los Strikes '
    'aparecen porque se están haciendo Patrols, así que seguir jugando es la forma más rápida '
    'de que surja uno.')

NEW['ptBR'] = col(
    '|n• %sComo é que encontro mesmo um Temple Strike?%s Abre o mapa dentro das Vaults e '
    'procura os ícones de evento — um Strike aparece lá como qualquer evento de zona, e %snão '
    'tem cronómetro%s: fica à espera até um grupo o terminar, por isso podes ir a pé com '
    'calma. %sUns poucos jogadores chegam%s; não precisas de grupo montado e normalmente já '
    'há gente. São seis, cada um com um ponto de partida fixo — clica para marcares: '
    + SPOTS + '.|nSe o mapa não mostrar nada, faz Patrols durante um bocado. Os Strikes '
    'aparecem porque há Patrols a serem feitas, portanto continuar a jogar é a forma mais '
    'rápida de fazer nascer um.')

NEW['itIT'] = col(
    '|n• %sMa come si trova davvero un Temple Strike?%s Apri la mappa dentro le Vaults e cerca '
    'le icone degli eventi — uno Strike è segnato lì come qualsiasi evento di zona, e %snon ha '
    'un timer%s: resta lì finché un gruppo non lo completa, quindi puoi andarci con calma. '
    '%sBastano pochi giocatori%s; non serve un gruppo organizzato e di solito c’è già qualcuno. '
    'Sono sei, ognuno con un punto di partenza fisso — cliccane uno per un waypoint: '
    + SPOTS + '.|nSe la mappa non mostra niente, fai Patrols per un po’. Gli Strike compaiono '
    'proprio perché si fanno Patrols, quindi continuare a giocare è il modo più rapido per '
    'farne nascere uno.')

for code, text in NEW.items():
    assert '"' not in text, code
    assert '%' not in text, code
    assert text.count('|cffffffff') == text.count('|r'), code

t = io.open(P, encoding='utf-8', newline='').read()
if 'Temple Strike?' in t or 'Temple Strike, concrètement' in t:
    print('staat er al')
    sys.exit(0)

eol = '\r\n' if '\r\n' in t else '\n'
lines, occurrence, changed = t.split(eol), 0, 0
out = []
for line in lines:
    if line.lstrip().startswith('CODEX_ATALUTEK_BODY = "'):
        lang = LANGS[occurrence]
        occurrence += 1
        assert line.rstrip().endswith('",'), lang
        line = line.rstrip()[:-2] + NEW[lang] + '",'
        changed += 1
        print('%s: ok' % lang)
    out.append(line)

if changed != 7:
    print('%d van 7 — NIETS geschreven' % changed)
    sys.exit(1)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
os.replace(P + '.tmp', P)
print('geschreven')
