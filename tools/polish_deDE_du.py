#!/usr/bin/env python3
"""Informal du polish for deDE.lua (Sie/Ihr -> du/dein)."""
import re
from pathlib import Path

path = Path(__file__).resolve().parents[1] / "Locales" / "deDE.lua"
text = path.read_text(encoding="utf-8")

# Order matters: longer phrases first
replacements = [
    ("TAB_DELVES = \"Delves & Vault\"", "TAB_DELVES = \"Tiefen & Schatzkammer\""),
    ("SEARCH_CHAT_TAB_DELVES = \"Geöffneter Tab: Delves & Vault\"", "SEARCH_CHAT_TAB_DELVES = \"Tab geöffnet: Tiefen & Schatzkammer\""),
    ("LANG_SLASH_HINT = \"Nutze: /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang nl",
     "LANG_SLASH_HINT = \"Nutze: /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang fr  |  /mh lang nl"),
    ("Öffnen Sie", "Öffne"),
    ("Verwenden Sie", "Nutze"),
    ("Wählen Sie", "Wähle"),
    ("Klicken Sie", "Klicke"),
    ("Drücken Sie", "Drücke"),
    ("Sagen Sie", "Sag"),
    ("Probieren Sie", "Probiere"),
    ("Geben Sie", "Gib"),
    ("Warten Sie", "Warte"),
    ("Schließen Sie", "Schließe"),
    ("Ziehen Sie", "Ziehe"),
    ("Scrollen Sie", "Scrolle"),
    ("Bewegen Sie", "Bewege"),
    ("Melden Sie", "Logge"),
    ("Entfernen Sie", "Entferne"),
    ("Setzen Sie", "Setze"),
    ("Optimieren Sie", "Stelle ein"),
    ("Stellen Sie sich", "Stell dich"),
    ("Ihre Aufgabe", "Deine Aufgabe"),
    ("Ihre ", "Deine "),
    ("Ihr ", "Dein "),
    ("Ihnen ", "dir "),
    (" Sie ", " du "),
    (" sie ", " du "),  # after Ihr fix, rare
]

for old, new in replacements:
    text = text.replace(old, new)

# Fix double-du accidents from "sie" in words (minimal)
text = re.sub(r"\bdu kannst du\b", "du kannst", text)

path.write_text(text, encoding="utf-8")
print("Polished", path)
