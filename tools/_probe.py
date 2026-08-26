# -*- coding: utf-8 -*-
"""Hoeveel fill()-vertalingen zijn DOOD?

deDE.lua (regel 1103-1111) bouwt zijn pack door ELKE key uit ns._mhLocales.enUS
te kopiëren -- als Engelse waarde. fill(code, patch) zet een key alleen als het
pack hem MIST. Dus voor elke key die op dat moment al in enUS stond, kan fill
nooit meer iets schrijven.

Dit telt precies welke fills daardoor niets doen. Niet-bewezen conclusies gaan
daarna door tools/locale_probe.lua, die het echt draait.
"""
import io
import os
import re
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
sys.stdout.reconfigure(encoding="utf-8")

KEY = re.compile(r'(?:^|[,{\s])\[?"?([A-Z][A-Z0-9_]+)"?\]?\s*=\s*"((?:[^"\\]|\\.)*)"', re.M)
LANGS = ("deDE", "frFR", "esES", "ptBR", "itIT")


def read(fn):
    with io.open(os.path.join(ROOT, fn), "r", encoding="utf-8", errors="replace") as fh:
        return fh.read()


# --- 1. wie kopieert er uit enUS, en wie niet? ---------------------------------
print("=== welke packs kopiëren enUS in hun eigen tabel? ===")
copiers = []
for code in LANGS:
    txt = read(code + ".lua")
    if re.search(r'for\s+key,\s*value\s+in\s+pairs\(\s*en\s*\)', txt):
        copiers.append(code)
        print("  %s  KOPIEERT  -> fill() is dood voor elke key die dan al in enUS staat" % code)
    else:
        print("  %s  kopieert niet -> fill() werkt hier gewoon" % code)

# --- 2. wat stond er in enUS.lua op het moment dat het pack laadt? -------------
# enUS.lua staat vóór de packs in de .toc; de merge-bestanden (SettingsPage,
# Codex, DelveTips, ...) staan erna. Alleen enUS.lua telt dus voor de kopie.
en_base = dict(KEY.findall(read("enUS.lua")))
print("")
print("keys in enUS.lua op kopieermoment: %d" % len(en_base))

# --- 3. welke fills botsen daarmee? -------------------------------------------
print("")
print("=== dode fills per taal ===")
FILLFILES = [f for f in sorted(os.listdir(ROOT))
             if f.startswith("Translations") and f.endswith(".lua")]
print("fill-bestanden: %s" % ", ".join(FILLFILES))
print("")

dead_examples = []
for code in LANGS:
    filled = {}
    for fn in FILLFILES:
        for m in re.finditer(r'fill\s*\(\s*"%s"[^\n]*\n(.*?)^\}\)' % code,
                             read(fn), re.S | re.M):
            for k, v in KEY.findall(m.group(1)):
                filled[k] = (fn, v)
    if not filled:
        print("  %s  geen fills" % code)
        continue
    dead = sorted(k for k in filled if k in en_base)
    live = len(filled) - len(dead)
    mark = "🔴" if code in copiers else "  "
    print("  %s %s  %d fills: %d DOOD (key stond al in enUS.lua), %d levend"
          % (mark, code, len(filled), len(dead) if code in copiers else 0,
             len(filled) if code not in copiers else live))
    if code in copiers and dead:
        for k in dead[:4]:
            fn, v = filled[k]
            dead_examples.append(k)
            print("        %-34s %s -> %s" % (k, fn, v[:44]))

print("")
print("=== toets deze in de echte loader ===")
print("lua tools/locale_probe.lua " + " ".join(dict.fromkeys(dead_examples[:6])))
