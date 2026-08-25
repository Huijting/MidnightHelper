# -*- coding: utf-8 -*-
"""Vult de Manaflux-regel aan in alle zeven packs.

GEMETEN 25 aug 2026 op Robs scherm: de currency-tooltip toont "Total Maximum: 1/8"
plus een lijst per personage (Purlymixanox 1, Earthshammy 1, Twelveinchy 1,
Warlockie 1, ...) met 7 over alle characters samen. Het is dus PER PERSONAGE, met
een plafond van 8 -- niet account-breed zoals ik aannam.

Dat maakt de oude zin onvolledig op een manier die geld kost: wie niet weet dat het
per character opbouwt, laat zes voorraadjes stilstaan; wie niet weet van het plafond,
verliest opbouw zodra een character vol zit.
"""
import io
import os
import re
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
sys.stdout.reconfigure(encoding="utf-8")

OLD = {
"enUS": "and you gain one roughly every two weeks. A charge is precious.",
"nlNL": "en je krijgt er ongeveer één per twee weken. Een charge is dus kostbaar.",
"deDE": "und du bekommst etwa alle zwei Wochen einen. Eine Ladung ist also kostbar.",
"frFR": "et vous en gagnez un environ toutes les deux semaines. Une charge est donc précieuse.",
"esES": "y consigues uno cada dos semanas aproximadamente. Una carga es valiosa.",
"ptBR": "e você ganha um a cada duas semanas mais ou menos. Uma carga é preciosa.",
"itIT": "e ne ottieni uno circa ogni due settimane. Una carica è preziosa.",
}

NEW = {
"enUS": "and you gain one roughly every two weeks.|n• ⚠️ Every character builds their OWN supply, up to 8. So your alts are quietly saving charges too - and a character sitting at 8 has stopped gaining, which is the one way to waste them.",
"nlNL": "en je krijgt er ongeveer één per twee weken.|n• ⚠️ Elk personage bouwt zijn EIGEN voorraad op, tot 8. Je alts sparen dus stilletjes mee - en een character dat op 8 staat wint niets meer, en dat is de enige manier om ze te verspillen.",
"deDE": "und du bekommst etwa alle zwei Wochen einen.|n• ⚠️ Jeder Charakter baut seinen EIGENEN Vorrat auf, bis 8. Deine Twinks sammeln also still mit - und ein Charakter bei 8 gewinnt nichts mehr dazu, und genau so verschenkt man sie.",
"frFR": "et vous en gagnez un environ toutes les deux semaines.|n• ⚠️ Chaque personnage constitue sa PROPRE réserve, jusqu'à 8. Vos rerolls accumulent donc aussi - et un personnage à 8 ne gagne plus rien, ce qui est la seule façon d'en perdre.",
"esES": "y consigues uno cada dos semanas aproximadamente.|n• ⚠️ Cada personaje acumula su PROPIA reserva, hasta 8. Tus alts también van guardando - y un personaje que está en 8 ha dejado de ganar, que es la única forma de desperdiciarlas.",
"ptBR": "e você ganha um a cada duas semanas mais ou menos.|n• ⚠️ Cada personagem acumula a PRÓPRIA reserva, até 8. Seus alts também vão guardando - e um personagem parado em 8 não ganha mais nada, que é o único jeito de desperdiçar.",
"itIT": "e ne ottieni uno circa ogni due settimane.|n• ⚠️ Ogni personaggio accumula la SUA riserva, fino a 8. Anche i tuoi alt stanno mettendo da parte - e un personaggio fermo a 8 non guadagna più nulla, che è l'unico modo per sprecarle.",
}

for code in OLD:
    p = os.path.join(ROOT, code + ".lua")
    with io.open(p, "r", encoding="utf-8", newline="") as fh:
        txt = fh.read()
    if OLD[code] not in txt:
        print("  %s: oude zin NIET gevonden -- overgeslagen" % code)
        continue
    txt = txt.replace(OLD[code], NEW[code], 1)
    io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(txt)
    os.replace(p + ".tmp", p)
    print("  %s: bijgewerkt" % code)
