# -*- coding: utf-8 -*-
"""Herschrijft de Catalyst-Unbound-regel in alle zeven packs.

GEMETEN 25 aug 2026 via /mh ach id 61519 op Robs client:
  name        = Midnight Season 1: Catalyst Unbound
  description = Unlocked your class set bonuses during Midnight Season 1.
  reward      = Dawnlight Manaflux can drop from additional sources.
  completed   = yes, 14-7-26

Dus de feat komt VAN je set-bonussen; hij is geen aparte voorwaarde vooraf. De zin
die ik vanmiddag schreef noemde alleen de feat bij naam en liet de speler met precies
de vraag zitten die Rob meteen stelde: hoe ontgrendel ik dat dan.

De oude tekst ("zodra je 4-set hebt") had dit al goed te pakken in gewone taal. Deze
versie houdt die uitleg en voegt de naam toe, in plaats van de naam ervoor in de
plaats te zetten.
"""
import io
import os
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
sys.stdout.reconfigure(encoding="utf-8")

OLD = {
"enUS": "• After you unlock the Season 2 Catalyst Unbound feat, extra charges also come from Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP.",
"nlNL": "• Zodra je de Season 2 Catalyst Unbound-feat hebt, komen er ook charges uit Mythic Keystones, Venomous Abyss-bosses, Bountiful Delves en rated PvP.",
"deDE": "• Sobald du das Feat \\\"Season 2 Catalyst Unbound\\\" freigeschaltet hast, kommen Ladungen auch aus Mythic Keystones, Venomous-Abyss-Bossen, Bountiful Delves und gewertetem PvP.",
"frFR": "• Une fois le haut fait \\\"Season 2 Catalyst Unbound\\\" débloqué, des charges tombent aussi des Mythic Keystones, des boss de Venomous Abyss, des Bountiful Delves et du PvP coté.",
"esES": "• Cuando desbloquees la proeza \\\"Season 2 Catalyst Unbound\\\", también caen cargas de Mythic Keystones, jefes de Venomous Abyss, Bountiful Delves y PvP con clasificación.",
"ptBR": "• Depois de desbloquear o feito \\\"Season 2 Catalyst Unbound\\\", cargas também vêm de Mythic Keystones, chefes da Venomous Abyss, Bountiful Delves e PvP ranqueado.",
"itIT": "• Una volta sbloccata l'impresa \\\"Season 2 Catalyst Unbound\\\", le cariche arrivano anche da Mythic Keystone, boss della Venomous Abyss, Bountiful Delve e PvP classificato.",
}

NEW = {
"enUS": "• Mythic Keystones, Venomous Abyss bosses, Bountiful Delves and rated PvP drop extra charges too - but only once your class set bonuses are running. That is the Catalyst Unbound feat, and it is a reward for getting there, not a hoop to jump through first.",
"nlNL": "• Mythic Keystones, Venomous Abyss-bosses, Bountiful Delves en rated PvP geven ook extra charges - maar pas zodra je set-bonussen draaien. Dat is de Catalyst Unbound-feat: een beloning voor het bereiken van je set, geen hoepel vooraf.",
"deDE": "• Mythic Keystones, Venomous-Abyss-Bosse, Bountiful Delves und gewertetes PvP geben ebenfalls Ladungen - aber erst, wenn deine Klassenset-Boni laufen. Das ist das Feat Catalyst Unbound: eine Belohnung dafür, dass du dein Set hast, keine Hürde davor.",
"frFR": "• Les Mythic Keystones, les boss de Venomous Abyss, les Bountiful Delves et le PvP coté donnent aussi des charges - mais seulement une fois vos bonus de set actifs. C'est le haut fait Catalyst Unbound : une récompense pour y être arrivé, pas un obstacle préalable.",
"esES": "• Mythic Keystones, jefes de Venomous Abyss, Bountiful Delves y PvP con clasificación también dan cargas - pero solo cuando tus bonus de conjunto estén activos. Esa es la proeza Catalyst Unbound: una recompensa por haber llegado, no un requisito previo.",
"ptBR": "• Mythic Keystones, chefes da Venomous Abyss, Bountiful Delves e PvP ranqueado também dão cargas - mas só depois que seus bônus de conjunto estiverem ativos. Esse é o feito Catalyst Unbound: uma recompensa por ter chegado lá, não um obstáculo antes.",
"itIT": "• Mythic Keystone, boss della Venomous Abyss, Bountiful Delve e PvP classificato danno anche cariche - ma solo quando i bonus del set sono attivi. È l'impresa Catalyst Unbound: una ricompensa per esserci arrivato, non un ostacolo prima.",
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
