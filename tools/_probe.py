# -*- coding: utf-8 -*-
"""Welke EditBoxes kunnen het toetsenbord vasthouden?

WoWNext 2.0.3 (27 aug 2026) was een hotfix hiervoor: hun invoervelden hielden focus
vast en slikten daarna bewegingstoetsen op. Hun eigen conclusie: "No WoWNext key
binding to A was found; the issue was caused by retained EditBox focus."

Een EditBox met focus vangt elke toetsaanslag. Laat hij niet los, dan is de speler zijn
A-toets kwijt en wijst niets naar ons -- er IS namelijk geen keybind om te vinden.

Drie dingen maken een veld veilig:
  SetAutoFocus(false)   pakt de focus niet zomaar
  OnEscapePressed       + ClearFocus
  ClearFocus bij Hide   (of op OnEditFocusLost / de sluitknop)

Dit telt per bestand hoeveel EditBoxes er zijn en welke van die drie ontbreken.
"""
import io
import os
import re
import sys

ROOT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
sys.stdout.reconfigure(encoding="utf-8")

SKIP = (os.sep + "tools" + os.sep, os.sep + "docs" + os.sep, os.sep + ".git" + os.sep)

rows = []
for base, _dirs, files in os.walk(ROOT):
    if any(s in base + os.sep for s in SKIP):
        continue
    for fn in sorted(files):
        if not fn.endswith(".lua"):
            continue
        p = os.path.join(base, fn)
        with io.open(p, "r", encoding="utf-8", errors="replace") as fh:
            txt = fh.read()
        n = len(re.findall(r'CreateFrame\(\s*"EditBox"', txt))
        if n == 0:
            continue
        rows.append({
            "file": os.path.relpath(p, ROOT).replace("\\", "/"),
            "n": n,
            "autofocus": len(re.findall(r"SetAutoFocus\(\s*false\s*\)", txt)),
            "escape": len(re.findall(r'"OnEscapePressed"', txt)),
            "clear": len(re.findall(r"ClearFocus\(", txt)),
        })

print("EditBoxes in Midnight Helper — kan er eentje het toetsenbord vasthouden?\n")
print("%-44s %5s %9s %7s %6s  %s" % ("bestand", "boxen", "autofocus", "escape", "clear", "risico"))
bad = 0
for r in sorted(rows, key=lambda r: -r["n"]):
    missing = []
    if r["autofocus"] < r["n"]:
        missing.append("autofocus")
    if r["escape"] < r["n"]:
        missing.append("escape")
    if r["clear"] == 0:
        missing.append("clear")
    if missing:
        bad += 1
    print("%-44s %5d %9d %7d %6d  %s"
          % (r["file"], r["n"], r["autofocus"], r["escape"], r["clear"],
             ", ".join(missing) if missing else "-"))

print("\n%d van %d bestanden missen minstens een van de drie." % (bad, len(rows)))
print("⚠️ Dit is een AANWIJZING, geen bewijs: het telt patronen per bestand, niet per veld.")
print("   Een bestand met twee boxen waarvan er een netjes is, kan hier schoon lijken.")
