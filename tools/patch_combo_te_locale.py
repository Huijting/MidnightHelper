#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "Locales"

REPLACEMENTS = {
    "enUS.lua": [
        (
            "• Split KP early — do not dump everything into one tree. Lean Enchanting if you want gold and raid power.|n",
            "• Each profession has its own KP — Enchanting KP only spends in Enchanting, Tailoring KP only in Tailoring.|n",
        ),
        (
            "|n|n|cffffcc00Mistakes to avoid|r|n|n• All KP on Tailoring, none left for enchants you need.|n• Crafting random tailoring nobody buys.|n• Skipping Patron Orders — they are steady KP.|n|n|cffffcc00More detail|r|nOpen |cffffff00Enchanting|r or |cffffff00Tailoring|r below. Wowhead links on those pages.",
            "|n|n|cffffcc00Mistakes to avoid|r|n|n• Ignoring Enchanting for weeks — separate KP and weekly quests from Tailoring.|n• Dumping all Tailoring KP into one branch that does not help gear you wear.|n• Crafting random tailoring nobody buys.|n• Skipping Patron Orders on either profession — steady KP on each.",
        ),
    ],
    "nlNL.lua": [
        (
            "• Verdeel KP — niet alles in één boom. Meer Enchanting als je goud en raid-power wilt.|n",
            "• Elke profession heeft eigen KP — Enchanting-KP alleen in Enchanting, Tailoring-KP alleen in Tailoring.|n",
        ),
        (
            "|n|n|cffffcc00Fouten om te vermijden|r|n|n• Alle KP in Tailoring, niets over voor enchants die je nodig hebt.|n• Random tailoring craften die niemand koopt.|n• Patron Orders overslaan — dat is je vaste KP.|n|n|cffffcc00Meer uitleg|r|nOpen |cffffff00Enchanting|r of |cffffff00Tailoring|r hieronder. Wowhead-links staan daar.",
            "|n|n|cffffcc00Fouten om te vermijden|r|n|n• Enchanting weken overslaan — eigen KP en weekly quests, los van Tailoring.|n• Alle Tailoring-KP in één tak die geen gear geeft die je draagt.|n• Random tailoring craften die niemand koopt.|n• Patron Orders op één van beide overslaan — op elke profession vaste KP.",
        ),
    ],
}

for fname, pairs in REPLACEMENTS.items():
    path = ROOT / fname
    text = path.read_text(encoding="utf-8")
    for old, new in pairs:
        if old not in text:
            print(fname, "MISSING:", old[:60], "...")
        else:
            text = text.replace(old, new, 1)
    path.write_text(text, encoding="utf-8")
    print("patched", fname)
