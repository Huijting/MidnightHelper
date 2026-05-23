#!/usr/bin/env python3
"""Generate Locales/frFR.lua from enUS.lua (Phase B French shell)."""
from __future__ import annotations

import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "Locales" / "enUS.lua"
OUT_PATH = ROOT / "Locales" / "frFR.lua"
PACK_CODE = "frFR"

CLASS_GEAR = re.compile(
    r"^GUIDE_GEAR_(MAGE|DK|DH|PRIEST|PALADIN|ROGUE|SHAMAN|WARRIOR|MONK|HUNTER|DRUID|WARLOCK|EVOKER)_"
)

TOKEN_RE = re.compile(
    r"(\|c[0-9a-fA-F]{8}|"
    r"\|r|"
    r"\|n|"
    r"%[sdq.]+|"
    r"\{SPELL:[^}]+\}|"
    r"\{[^}]+\})"
)


def should_include(key: str) -> bool:
    if key.startswith("GUIDE_ADVISOR_"):
        return False
    if CLASS_GEAR.match(key):
        return False
    return True


def parse_enus(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    entries: dict[str, str] = {}
    key_re = re.compile(r"^\t([A-Z][A-Z0-9_]+) = (.+)$", re.M)
    for m in key_re.finditer(text):
        key = m.group(1)
        rest = m.group(2).strip()
        if rest.startswith('"'):
            val_m = re.match(r'^"(.*)"[,]?\s*$', rest, re.S)
            if val_m:
                entries[key] = val_m.group(1)
            continue
        start = m.end()
        chunk = text[start:]
        lines = []
        for line in chunk.splitlines():
            if line.strip() == "}," or (
                re.match(r"^\t[A-Z][A-Z0-9_]+ = ", line) and lines
            ):
                break
            lines.append(line)
        body = "\n".join(lines)
        parts = re.findall(r'"([^"]*)"', body)
        joined = "".join(parts)
        if joined:
            entries[key] = joined
    return entries


def protect(s: str) -> tuple[str, list[str]]:
    tokens: list[str] = []

    def repl(m: re.Match[str]) -> str:
        tokens.append(m.group(0))
        return f"__TK{len(tokens) - 1}__"

    return TOKEN_RE.sub(repl, s), tokens


def restore(s: str, tokens: list[str]) -> str:
    for i, tok in enumerate(tokens):
        s = s.replace(f"__TK{i}__", tok)
    return s


def translate_batch(texts: list[str], translator) -> list[str]:
    out: list[str] = []
    for t in texts:
        if not t.strip():
            out.append(t)
            continue
        protected, tokens = protect(t)
        try:
            fr = translator.translate(protected)
        except Exception:
            fr = protected
        out.append(restore(fr, tokens))
        time.sleep(0.05)
    return out


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def lua_string(s: str) -> str:
    if "\n" in s:
        parts = s.split("\n")
        lines = ['\t"' + lua_escape(parts[0]) + '"']
        for p in parts[1:]:
            lines.append('\t\t.. "' + lua_escape(p) + '"')
        return "\n".join(lines)
    return '"' + lua_escape(s) + '"'


def main() -> None:
    from deep_translator import GoogleTranslator

    entries = parse_enus(EN_PATH)
    keys = [k for k in entries if should_include(k)]
    print(f"Translating {len(keys)} keys to French…")

    translator = GoogleTranslator(source="en", target="fr")
    translated: dict[str, str] = {}
    batch_size = 40
    for i in range(0, len(keys), batch_size):
        batch_keys = keys[i : i + batch_size]
        batch_vals = [entries[k] for k in batch_keys]
        batch_fr = translate_batch(batch_vals, translator)
        for k, v in zip(batch_keys, batch_fr):
            translated[k] = v
        print(f"  {min(i + batch_size, len(keys))}/{len(keys)}")
        time.sleep(0.3)

    fixes = {
        "PRINT_PREFIX": "Midnight Helper :",
        "MAIN_TITLE": "Midnight Helper",
        "LOCALE_NAME_NL": "Nederlands (addon)",
        "LOCALE_AUTO_HINT": "Suit la langue du client WoW si une traduction existe ; sinon anglais. Nederlands toujours manuel.",
        "LANG_SLASH_HINT": "Utilise : /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang fr  |  /mh lang es  |  /mh lang nl",
        "UNKNOWN_COMMAND": "Commande inconnue %q. Utilise : /mh, /mh coach, /mh debug, /mh guide, /mh settings, /mh lang auto|en|fr|de|nl.",
        "LANG_ROW_FR_TOOLTIP": "Français",
        "TAB_DELVES": "Gouffres & Grande chambre forte",
        "DELVES_BTN_BOUNTIFUL": "Trouver le gouffre abondant le plus proche",
        "DELVES_ROW_ROUTE_BTN": "Clic sur la ligne : route vers ce gouffre abondant (TomTom).",
        "DELVES_BOUNTIFUL_ROUTE": "|cffffff78Midnight Helper :|r TomTom : gouffre abondant le plus proche — %s",
        "DELVES_TITLE": "Gouffres Midnight",
        "DELVES_ACC_MIDNIGHT": "Gouffres Midnight",
        "DELVES_ACC_VAULT": "Grande chambre forte (Monde)",
        "DELVES_JOURNEY_RANK": "Périple du gouffre : rang %d (%d / %d)",
        "DELVES_HINT_SHIFT_J": "Appuie sur |cffffff00MAJ-J|r — Guide d'aventure (Grande chambre forte, |cff00ffffPériple du gouffre|r, Gouffres, Proie).",
        "ALT_OVERVIEW_HINT": "Enregistré par personnage à la connexion / mise à jour des monnaies.",
        "ALT_SNAPSHOT_SORT_LEVEL": "Tri : niveau",
        "ALT_SNAPSHOT_SORT_NAME": "Tri : perso",
        "ALT_SNAPSHOT_SORT_KEYS": "Tri : clés",
        "ALT_SNAPSHOT_SORT_SHARDS": "Tri : shards",
        "ALT_SNAPSHOT_SORT_UNDER": "Tri : undercoins",
        "ALT_SNAPSHOT_SORT_UPDATED": "Tri : maj",
        "ALT_SNAPSHOT_FILTER_STALE": "Relog requis",
        "ALT_SNAPSHOT_FILTER_STALE_ON": "Relog requis : OUI",
        "ALT_SNAPSHOT_FILTER_KEYS": "Avec clés",
        "ALT_SNAPSHOT_FILTER_KEYS_ON": "Avec clés : OUI",
        "ALT_VAULT_RAIDS": "Raids",
        "ALT_VAULT_TOOLTIP_TITLE": "Grande chambre forte",
        "ALT_TOOLTIP_KEYS": "Clé de coffret réparée : %d",
        "ALT_COL_KEYS_HINT": "Clés de coffret réparées dans le portefeuille de ce personnage (sauvegardé à la dernière connexion).",
        "VAULT_REMINDER_TOOLTIP_TITLE": "Grande chambre forte — récupérer ou vérifier",
        "VAULT_REMINDER_TOOLTIP_OPEN_HINT": "MAJ-J → Guide d'aventure → Grande chambre forte",
        "DELVE_COACH_PICKER_TITLE": "Choisir un gouffre",
    }
    translated.update(fixes)

    lines = [
        "--[[",
        "\tMidnight Helper — French locale shell (Phase B).",
        "\tLoad order: after deDE.lua, before nlNL.lua.",
        "",
        "\tNon-advisor keys inherit from enUS where not overridden.",
        "\tGUIDE_ADVISOR_* and per-spec GUIDE_GEAR_* stay English until Phase C.",
        "\tDelve tip bodies: DelveTips.lua (EN fallback for frFR).",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "ns._mhLocales = ns._mhLocales or {}",
        "",
        "local OVERRIDES = {",
    ]
    for k in keys:
        v = translated[k]
        if "\n" in v:
            lines.append(f"\t{k} =")
            lines.append(lua_string(v) + ",")
        else:
            lines.append(f"\t{k} = {lua_string(v)},")
    lines += [
        "}",
        "",
        "local function shouldCopyFromEnUS(key)",
        '\tif type(key) ~= "string" then',
        "\t\treturn false",
        "\tend",
        '\tif key:match("^GUIDE_ADVISOR_") then',
        "\t\treturn false",
        "\tend",
        '\tif key:match("^GUIDE_GEAR_(MAGE|DK|DH|PRIEST|PALADIN|ROGUE|SHAMAN|WARRIOR|MONK|HUNTER|DRUID|WARLOCK|EVOKER)_") then',
        "\t\treturn false",
        "\tend",
        "\treturn true",
        "end",
        "",
        "local pack = {}",
        "local en = ns._mhLocales.enUS",
        "if type(en) == \"table\" then",
        "\tfor key, value in pairs(en) do",
        "\t\tif shouldCopyFromEnUS(key) and type(value) == \"string\" then",
        "\t\t\tpack[key] = OVERRIDES[key] or value",
        "\t\tend",
        "\tend",
        "end",
        "for key, value in pairs(OVERRIDES) do",
        "\tpack[key] = value",
        "end",
        "",
        f"ns._mhLocales.{PACK_CODE} = pack",
        "",
    ]
    OUT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_PATH} ({len(translated)} overrides)")


if __name__ == "__main__":
    main()
