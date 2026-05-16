#!/usr/bin/env python3
"""Generate Modules/TeamMacrosData.lua from Gemini-style team macro JSON."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CLASS_TO_TOKEN = {
    "Death Knight": "DEATHKNIGHT",
    "Demon Hunter": "DEMONHUNTER",
    "Druid": "DRUID",
    "Evoker": "EVOKER",
    "Hunter": "HUNTER",
    "Mage": "MAGE",
    "Monk": "MONK",
    "Paladin": "PALADIN",
    "Priest": "PRIEST",
    "Rogue": "ROGUE",
    "Shaman": "SHAMAN",
    "Warlock": "WARLOCK",
    "Warrior": "WARRIOR",
}

# Retail spec order per class (GetSpecialization index).
SPEC_TO_INDEX = {
    "DEATHKNIGHT": {"Blood": 1, "Frost": 2, "Unholy": 3},
    "DEMONHUNTER": {"Havoc": 1, "Vengeance": 2},
    "DRUID": {"Balance": 1, "Feral": 2, "Guardian": 3, "Restoration": 4},
    "EVOKER": {"Devastation": 1, "Preservation": 2, "Augmentation": 3},
    "HUNTER": {"Beast Mastery": 1, "Marksmanship": 2, "Survival": 3},
    "MAGE": {"Arcane": 1, "Fire": 2, "Frost": 3},
    "MONK": {"Brewmaster": 1, "Mistweaver": 2, "Windwalker": 3},
    "PALADIN": {"Holy": 1, "Protection": 2, "Retribution": 3},
    "PRIEST": {"Discipline": 1, "Holy": 2, "Shadow": 3},
    "ROGUE": {"Assassination": 1, "Outlaw": 2, "Subtlety": 3},
    "SHAMAN": {"Elemental": 1, "Enhancement": 2, "Restoration": 3},
    "WARLOCK": {"Affliction": 1, "Demonology": 2, "Destruction": 3},
    "WARRIOR": {"Arms": 1, "Fury": 2, "Protection": 3},
}


# Dutch description -> English (utility macro panel).
EN_BY_NL: dict[str, str] = {
    "Activeert Ice Block en heft het direct op bij de volgende klik.": (
        "Activates Ice Block and cancels it on the next press."
    ),
    "Cast Blessing of Protection snel via je muis.": (
        "Cast Blessing of Protection quickly via your mouse."
    ),
    "Cast Eruption direct op de vijand onder je muis.": (
        "Cast Eruption on the enemy under your cursor."
    ),
    "Cast Fear op je focus doelwit.": "Cast Fear on your focus target.",
    "Cast Leap of Faith om het teamlid onder je muis te redden.": (
        "Cast Leap of Faith to pull the teammate under your cursor to safety."
    ),
    "Cast Rejuvenation op het doel onder je muis.": (
        "Cast Rejuvenation on the target under your cursor."
    ),
    "Geeft direct je dreiging (threat) aan de tank onder je muis.": (
        "Hands threat to the tank under your cursor."
    ),
    "Geeft direct je dreiging aan de tank onder je muis.": (
        "Hands threat to the tank under your cursor."
    ),
    "Gooit Blind op je focus doelwit zonder je huidige target kwijt te raken.": (
        "Cast Blind on your focus without losing your current target."
    ),
    "Gooit Holy Word: Sanctify direct op je muispositie.": (
        "Cast Holy Word: Sanctify at your cursor."
    ),
    "Gooit Rain of Fire direct op je muiscursor.": (
        "Cast Rain of Fire at your cursor."
    ),
    "Gooit Ravager of Bladestorm direct op je muispositie.": (
        "Cast Ravager or Bladestorm at your cursor."
    ),
    "Gooit Volley direct op je muispositie.": "Cast Volley at your cursor.",
    "Gooit de bijl van je pet direct op je muispositie.": (
        "Throws your pet's axe at your cursor."
    ),
    "Gooit een vuurzee direct op je muispositie.": (
        "Cast Flamestrike at your cursor."
    ),
    "Gooit je speer/ravager direct op je muispositie.": (
        "Throw your spear or Ravager at your cursor."
    ),
    "Gooit je vallen direct op je muiscursor.": (
        "Place traps at your cursor."
    ),
    "Heal een teamlid met je Predatory Swiftness proc zonder je target te verliezen.": (
        "Heal a teammate with Predatory Swiftness without swapping your target."
    ),
    "Healt de groep onder je muiscursor.": (
        "Heal the group under your cursor."
    ),
    "Laat je pet direct zijn Abomination Hook gebruiken op je focus doel.": (
        "Commands your pet to use Abomination Hook on your focus target."
    ),
    "Misdirection op je focus (tank) indien aanwezig, anders op je pet.": (
        "Misdirection on focus (tank) if set, otherwise on your pet."
    ),
    "Plaatst Blizzard direct op je muiscursor.": "Cast Blizzard at your cursor.",
    "Plaatst Capacitor Totem direct op je muispositie.": (
        "Place Capacitor Totem at your cursor."
    ),
    "Plaatst Death and Decay direct op je muispositie.": (
        "Cast Death and Decay at your cursor."
    ),
    "Plaatst Earthquake direct onder je muis.": (
        "Cast Earthquake under your cursor."
    ),
    "Plaatst Execution Sentence of Final Reckoning direct op je muis.": (
        "Cast Execution Sentence or Final Reckoning at your cursor."
    ),
    "Plaatst Havoc op de vijand waar je met je muis over zweeft.": (
        "Cast Havoc on the enemy under your cursor."
    ),
    "Plaatst Healing Rain direct op je muis.": (
        "Cast Healing Rain at your cursor."
    ),
    "Plaatst Power Word: Shield direct via je muis.": (
        "Cast Power Word: Shield via your cursor."
    ),
    "Plaatst Sigil of Flame direct op je muispositie.": (
        "Place Sigil of Flame at your cursor."
    ),
    "Plaatst Starfall direct op je muispositie.": (
        "Cast Starfall at your cursor."
    ),
    "Plaatst Ursol's Vortex direct onder je muis.": (
        "Cast Ursol's Vortex under your cursor."
    ),
    "Plaatst Vile Taint direct op je muispositie.": (
        "Cast Vile Taint at your cursor."
    ),
    "Plaatst Windfury of Capacitor Totem direct op je muispositie.": (
        "Place Windfury or Capacitor Totem at your cursor."
    ),
    "Plaatst al je Sigils direct op je muispositie zonder richtcirkel.": (
        "Place sigils at your cursor without the targeting circle."
    ),
    "Plaatst de Ox Statue direct op je muispositie.": (
        "Summon the Black Ox Statue at your cursor."
    ),
    "Plaatst de Ring of Peace direct op je muiscursor.": (
        "Cast Ring of Peace at your cursor."
    ),
    "Plaatst de bloem direct op je muispositie.": (
        "Cast Emerald Blossom at your cursor."
    ),
    "Plaatst de healing cirkel direct op je muispositie.": (
        "Cast the healing circle at your cursor."
    ),
    "Plaatst de healing koepel direct op je muispositie.": (
        "Cast the healing dome at your cursor."
    ),
    "Plaatst je healing standbeeld direct op je muispositie.": (
        "Summon your healing statue at your cursor."
    ),
    "Riptide op vrienden, Flame Shock op vijanden.": (
        "Riptide on friends, Flame Shock on enemies."
    ),
    "Schiethaken naar de vijand onder je muis.": (
        "Harpoon the enemy under your cursor."
    ),
    "Sleutelmacro: Gooit Shadow Crash direct op je muis om snel Dots te verspreiden.": (
        "Key macro: cast Shadow Crash at your cursor to spread DoTs quickly."
    ),
    "Slingert je direct naar je muispositie.": (
        "Grapple to your cursor."
    ),
    "Snoeft direct naar het teamlid onder je muis om schade op te vangen.": (
        "Intervene to the teammate under your cursor to soak damage."
    ),
    "Spookt vijanden aan via je muiscursor of frames.": (
        "Taunt enemies via your cursor or unit frames."
    ),
    "Spookt vijanden aan via je muiscursor.": (
        "Taunt enemies via your cursor."
    ),
    "Springt direct naar de locatie van je muis.": (
        "Leap to your cursor."
    ),
    "Springt direct naar je muispositie voor Metamorphosis.": (
        "Leap to your cursor for Metamorphosis."
    ),
    "Taunt vijanden via je muiscursor.": "Taunt enemies via your cursor.",
    "Trekt de vijand naar je toe waar je met je muis over zweeft.": (
        "Pull the enemy under your cursor to you."
    ),
    "Verandert je focus doelwit in een schaap.": (
        "Polymorph your focus target into a sheep."
    ),
    "Verwijdert vloeken van groepsleden via je muis.": (
        "Remove curses from party members via your cursor."
    ),
    "Vivify op vrienden, Tiger Palm op vijanden.": (
        "Vivify on friends, Tiger Palm on enemies."
    ),
    "Vliegt direct in een rechte lijn naar je muispositie.": (
        "Fly in a straight line to your cursor."
    ),
    "Vliegt direct naar het teamlid onder je muis om ze te verplaatsen.": (
        "Fly to the teammate under your cursor to reposition them."
    ),
    "Vliegt naar een teamlid toe om ze te beschermen.": (
        "Intervene to a teammate to protect them."
    ),
    "Zet Beacon of Light direct op het teamlid onder je muis.": (
        "Cast Beacon of Light on the teammate under your cursor."
    ),
    "Zet Divine Shield direct aan en uit om door te kunnen dps'en.": (
        "Toggle Divine Shield on and off so you can keep DPSing."
    ),
    "Zet Divine Shield direct aan en uit om mechanics te skippen.": (
        "Toggle Divine Shield on and off to skip mechanics."
    ),
    "Zet Hover aan, of stopt het direct bij een tweede klik om snel te landen.": (
        "Toggle Hover on, or cancel it on a second press to land quickly."
    ),
    "Zet je schild aan en direct uit bij een tweede klik om weer te kunnen aanvalen.": (
        "Toggle your defensive on and off so you can attack again."
    ),
}


def translate_desc_nl_to_en(nl: str) -> str:
    en = EN_BY_NL.get(nl)
    if en:
        return en
    if nl:
        print(f"Warning: no EN translation for: {nl!r}", file=sys.stderr)
    return nl


def slugify(name: str) -> str:
    s = re.sub(r"[^a-zA-Z0-9]+", "_", name.strip().lower()).strip("_")
    return s or "macro"


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def lua_long_string(s: str, var: str) -> str:
    """Use [[]] if no ]], else quoted string with escapes."""
    if "]]" not in s:
        return f'\t\t\tmacro = [=[{s}]=],'
    body = lua_escape(s)
    return f'\t\t\tmacro = "{body}",'


def main() -> int:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "data" / "team_macros_gemini.json"
    out = ROOT / "Modules" / "TeamMacrosData.lua"
    if not src.is_file():
        print(f"Missing input: {src}", file=sys.stderr)
        return 1

    data = json.loads(src.read_text(encoding="utf-8"))
    nested: dict[str, dict[int, list]] = {}

    for class_name, specs in data.items():
        token = CLASS_TO_TOKEN.get(class_name)
        if not token:
            print(f"Skip unknown class: {class_name}", file=sys.stderr)
            continue
        spec_map = SPEC_TO_INDEX.get(token, {})
        nested.setdefault(token, {})
        for spec_name, macros in specs.items():
            idx = spec_map.get(spec_name)
            if not idx:
                print(f"Skip unknown spec {class_name} / {spec_name}", file=sys.stderr)
                continue
            nested[token].setdefault(idx, [])
            for m in macros:
                nested[token][idx].append(
                    {
                        "id": slugify(m["name"]),
                        "name": m["name"],
                        "descNl": m.get("description", ""),
                        "descEn": m.get("descriptionEn")
                        or translate_desc_nl_to_en(m.get("description", "")),
                        "macro": m["macro"],
                    }
                )

    lines = [
        "--[[",
        "\tTeam utility macros (cursor / mouseover / focus) per class + spec index.",
        "\tGenerated by tools/generate_team_macros_lua.py — edit JSON and re-run to refresh.",
        "]]",
        "",
        "local addonName, ns = ...",
        "",
        "ns.TeamMacrosByClassSpec = {",
    ]

    for token in sorted(nested.keys()):
        lines.append(f"\t{token} = {{")
        for spec_idx in sorted(nested[token].keys()):
            entries = nested[token][spec_idx]
            lines.append(f"\t\t[{spec_idx}] = {{")
            for e in entries:
                lines.append("\t\t\t{")
                lines.append(f'\t\t\tid = "{lua_escape(e["id"])}",')
                lines.append(f'\t\t\tname = "{lua_escape(e["name"])}",')
                lines.append(f'\t\t\tdescNl = "{lua_escape(e["descNl"])}",')
                lines.append(f'\t\t\tdescEn = "{lua_escape(e["descEn"])}",')
                lines.append(lua_long_string(e["macro"], "macro"))
                lines.append("\t\t\t},")
            lines.append("\t\t},")
        lines.append("\t},")
    lines.append("}")
    lines.append("")

    out.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"Wrote {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
