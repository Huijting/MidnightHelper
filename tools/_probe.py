# -*- coding: utf-8 -*-
"""Vult de Catalyst-regel aan: het item level blijft óók behouden.

GEMETEN 25 aug 2026. Rob zette een Champion-schouder om en het tier-stuk kwam eruit
met hetzelfde item level. De currency-omschrijving belooft alleen dat de secondary
stats meegaan en zwijgt over ilvl -- dus dit was niet af te leiden, alleen te meten.

Waarom het ertoe doet: als er precies hetzelfde uitkomt, alleen nu als setstuk, dan
is de natuurlijke reflex fout. Iedereen bewaart zijn beste stuk en voert de Catalyst
een reservestuk. Dat levert een reservestuk met een setbonus op.
"""
import io
import os
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
sys.stdout.reconfigure(encoding="utf-8")

OLD = {
"enUS": "The new piece keeps the |cffffffffsecondary stats of the piece you put in|r. You are changing what the item IS, not what it rolled — so feed it something whose stats already suit you.",
"nlNL": "Het nieuwe stuk behoudt de |cffffffffsecondary stats van het stuk dat je erin stopt|r. Je verandert WAT het item is, niet wat het gerold heeft — stop er dus iets in waarvan de stats je al bevallen.",
"deDE": "Das neue Teil behält die |cffffffffSekundärwerte des Teils, das du hineingibst|r. Du änderst, WAS der Gegenstand ist, nicht was er gewürfelt hat — gib also etwas hinein, dessen Werte dir schon passen.",
"frFR": "La nouvelle pièce conserve les |cffffffffstatistiques secondaires de la pièce que vous donnez|r. Vous changez CE QU'EST l'objet, pas ce qu'il a tiré — donnez donc quelque chose dont les stats vous conviennent déjà.",
"esES": "La pieza nueva conserva las |cffffffffestadísticas secundarias de la pieza que metes|r. Cambias LO QUE ES el objeto, no lo que ha salido — así que mete algo cuyas estadísticas ya te vengan bien.",
"ptBR": "A peça nova mantém os |cffffffffatributos secundários da peça que você coloca|r. Você muda O QUE o item é, não o que ele rolou — então coloque algo cujos atributos já sirvam para você.",
"itIT": "Il pezzo nuovo mantiene le |cffffffffstatistiche secondarie del pezzo che ci metti|r. Cambi COSA è l'oggetto, non cosa ha tirato — quindi mettici qualcosa le cui statistiche ti vanno già bene.",
}

NEW = {
"enUS": "The new piece keeps |cffffffffboth the item level and the secondary stats|r of what you put in. What goes in is what comes back, only now it counts towards the set - so feed it your BEST piece in that slot, never a spare. Saving the good one and converting a leftover just gives you a leftover with a set bonus.",
"nlNL": "Het nieuwe stuk behoudt |cffffffffzowel het item level als de secondary stats|r van wat je erin stopt. Er komt precies hetzelfde uit, alleen telt het nu mee voor de set - stop er dus je BESTE stuk in dat slot in, nooit een reserve. Het goede bewaren en een restje omzetten levert je een restje met een setbonus op.",
"deDE": "Das neue Teil behält |cffffffffsowohl die Gegenstandsstufe als auch die Sekundärwerte|r dessen, was du hineingibst. Es kommt genau dasselbe heraus, nur zählt es jetzt für das Set - gib also dein BESTES Teil in diesem Slot hinein, nie ein Reserveteil. Das gute aufheben und einen Rest umwandeln bringt dir einen Rest mit Set-Bonus.",
"frFR": "La nouvelle pièce conserve |cffffffffà la fois le niveau d'objet et les statistiques secondaires|r de ce que vous donnez. Ce qui entre ressort à l'identique, mais compte désormais pour le set - donnez donc votre MEILLEURE pièce sur cet emplacement, jamais une pièce de rechange. Garder la bonne et convertir un reste vous donne un reste avec un bonus de set.",
"esES": "La pieza nueva conserva |cfffffffftanto el nivel de objeto como las estadísticas secundarias|r de lo que metes. Sale exactamente lo mismo, solo que ahora cuenta para el conjunto - así que mete tu MEJOR pieza de esa ranura, nunca una de repuesto. Guardar la buena y convertir una sobra te da una sobra con bonus de conjunto.",
"ptBR": "A peça nova mantém |cffffffffo nível de item E os atributos secundários|r do que você coloca. Sai exatamente o mesmo, só que agora conta para o conjunto - então coloque a sua MELHOR peça daquele espaço, nunca uma reserva. Guardar a boa e converter uma sobra te dá uma sobra com bônus de conjunto.",
"itIT": "Il pezzo nuovo mantiene |cffffffffsia il livello oggetto sia le statistiche secondarie|r di quello che ci metti. Esce esattamente lo stesso, solo che ora conta per il set - quindi mettici il tuo pezzo MIGLIORE per quello slot, mai un ricambio. Tenere quello buono e convertire un avanzo ti dà un avanzo con un bonus set.",
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
