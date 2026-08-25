# -*- coding: utf-8 -*-
"""Zet de twee Manaflux-tooltipregels in de vijf packs, direct na ALT_TOOLTIP_KEYS.

Die staan in de packs zelf en niet in Translations2026.lua -- eerst gecontroleerd
in plaats van aangenomen, want de vorige poging schreef naar het verkeerde bestand.

"Venomblight Manaflux" blijft in elke taal Engels: het is een currency-naam, en die
staan volgens CLAUDE.md nooit vertaald.
"""
import io
import os
import re
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
sys.stdout.reconfigure(encoding="utf-8")

NEW = {
"deDE": ('Venomblight Manaflux: %d/%d (Catalyst-Ladungen)',
         'Voll - dieser Charakter gewinnt nichts mehr dazu. Gib eine aus, damit die Uhr wieder läuft.'),
"frFR": ('Venomblight Manaflux : %d/%d (charges du Catalyst)',
         "Plein - ce personnage ne gagne plus rien. Dépensez-en une pour relancer le compteur."),
"esES": ('Venomblight Manaflux: %d/%d (cargas del Catalyst)',
         'Lleno - este personaje ya no gana más. Gasta una para que vuelva a contar.'),
"ptBR": ('Venomblight Manaflux: %d/%d (cargas do Catalyst)',
         'Cheio - este personagem parou de ganhar. Gaste uma para o relógio voltar a correr.'),
"itIT": ('Venomblight Manaflux: %d/%d (cariche del Catalyst)',
         'Pieno - questo personaggio non guadagna più nulla. Spendine una per far ripartire il conto.'),
}

for code, (fmt, capped) in NEW.items():
    p = os.path.join(ROOT, code + ".lua")
    with io.open(p, "r", encoding="utf-8", newline="") as fh:
        txt = fh.read()
    if "ALT_TOOLTIP_MANAFLUX_FMT" in txt:
        print("  %s: staat er al" % code)
        continue
    m = re.search(r'\tALT_TOOLTIP_KEYS = "[^"]*",\r?\n', txt)
    if not m:
        print("  %s: anker niet gevonden" % code)
        continue
    nl = "\r\n" if m.group(0).endswith("\r\n") else "\n"
    ins = ('\tALT_TOOLTIP_MANAFLUX_FMT = "%s",%s'
           '\tALT_TOOLTIP_MANAFLUX_CAPPED = "%s",%s' % (fmt, nl, capped, nl))
    txt = txt[:m.end()] + ins + txt[m.end():]
    io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(txt)
    os.replace(p + ".tmp", p)
    print("  %s: toegevoegd" % code)
