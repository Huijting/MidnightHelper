#!/usr/bin/env python3
"""Generate Locales/deDE.lua from enUS.lua (Phase B German shell)."""
from __future__ import annotations

import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_PATH = ROOT / "Locales" / "enUS.lua"
OUT_PATH = ROOT / "Locales" / "deDE.lua"

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
    pos = 0
    for m in key_re.finditer(text):
        key = m.group(1)
        rest = m.group(2).strip()
        if rest.startswith('"'):
            # single-line string
            val_m = re.match(r'^"(.*)"[,]?\s*$', rest, re.S)
            if val_m:
                entries[key] = val_m.group(1)
            continue
        # multiline: collect until closing ,
        start = m.end()
        chunk = text[start:]
        lines = []
        for line in chunk.splitlines():
            if line.strip() == "}," or line.strip().startswith("GUIDE_") and " = " in line and lines:
                break
            if re.match(r"^\t[A-Z][A-Z0-9_]+ = ", line) and lines:
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
            de = translator.translate(protected)
        except Exception:
            de = protected
        out.append(restore(de, tokens))
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
    print(f"Translating {len(keys)} keys…")

    translator = GoogleTranslator(source="en", target="de")
    batch_size = 40
    translated: dict[str, str] = {}
    for i in range(0, len(keys), batch_size):
        batch_keys = keys[i : i + batch_size]
        batch_vals = [entries[k] for k in batch_keys]
        batch_de = translate_batch(batch_vals, translator)
        for k, v in zip(batch_keys, batch_de):
            translated[k] = v
        print(f"  {min(i + batch_size, len(keys))}/{len(keys)}")
        time.sleep(0.3)

    # Manual fixes (WoW terms / brand)
    fixes = {
        "PRINT_PREFIX": "Midnight Helper:",
        "MAIN_TITLE": "Midnight Helper",
        "LOCALE_NAME_NL": "Nederlands (Addon)",
        "LOCALE_AUTO_HINT": "Folgt der WoW-Client-Sprache, wenn eine Übersetzung existiert; sonst Englisch. Nederlands immer manuell wählen.",
        "LANG_SLASH_HINT": "Nutze: /mh lang auto  |  /mh lang en  |  /mh lang de  |  /mh lang fr  |  /mh lang es  |  /mh lang nl  (auto = WoW-Client-Sprache)",
        "UNKNOWN_COMMAND": 'Unbekannter Befehl %q. Nutze: /mh zum Umschalten, /mh coach, /mh debug, /mh guide (Layout), /mh settings, /mh lang auto|en|de|nl.',
        "ABOUT_WINDOW_BODY": "Autoren: TwelveInchy & Claude\n\nAlles-in-einem-Midnight-Nachschlag: Delves & Vault, Delve Coach & Gruppenteilen, Delve-Items-Popup, Account-Snapshot, SMC City Guide, Berufe (KP + Schätze), Leveling Guides, gebündelte Tools — English / Deutsch / Nederlands.",
        "LANG_ROW_DE_TOOLTIP": "Deutsch",
        "DELVES_BTN_BOUNTIFUL": "Nächste großzügige Tiefe finden",
        "DELVES_ROW_ROUTE_BTN": "Zeile klicken: Route zu dieser großzügigen Tiefe (TomTom).",
        "DELVES_BOUNTIFUL_ROUTE": "|cffffff78Midnight Helper:|r TomTom: nächste großzügige Tiefe — %s",
        "ALT_OVERVIEW_HINT": "Pro Charakter bei Login / Währungs-Updates gespeichert.",
        "ALT_SNAPSHOT_SORT_LEVEL": "Sort.: Stufe",
        "ALT_SNAPSHOT_SORT_NAME": "Sort.: Charakter",
        "ALT_SNAPSHOT_SORT_KEYS": "Sort.: Keys",
        "ALT_SNAPSHOT_SORT_SHARDS": "Sort.: Shards",
        "ALT_SNAPSHOT_SORT_UNDER": "Sort.: Undercoins",
        "ALT_SNAPSHOT_SORT_UPDATED": "Sort.: Update",
        "ALT_SNAPSHOT_FILTER_STALE": "Relog nötig",
        "ALT_SNAPSHOT_FILTER_STALE_ON": "Relog nötig: AN",
        "ALT_SNAPSHOT_FILTER_KEYS": "Mit Keys",
        "ALT_SNAPSHOT_FILTER_KEYS_ON": "Mit Keys: AN",
        "DELVES_TITLE": "Midnight-Tiefen",
        "DELVES_ACC_MIDNIGHT": "Midnight-Tiefen",
        "DELVES_ACC_VAULT": "Große Schatzkammer (Welt)",
        "DELVES_JOURNEY_RANK": "Reise des Tiefenforschers: Rang %d (%d / %d)",
        "ALT_VAULT_RAIDS": "Schlachtzüge",
        "ALT_VAULT_TOOLTIP_TITLE": "Große Schatzkammer",
        "ALT_TOOLTIP_KEYS": "Restaurierter Kastenschlüssel: %d",
    }
    translated.update(fixes)

    lines = [
        "--[[",
        "\tMidnight Helper — German locale shell (Phase B).",
        "\tLoad order: after enUS.lua, before Locale.lua.",
        "",
        "\tNon-advisor keys inherit from enUS where not overridden.",
        "\tGUIDE_ADVISOR_* and per-spec GUIDE_GEAR_* stay English until Phase C.",
        "\tDelve tip bodies: see Locales/DelveTips.lua (EN fallback for deDE).",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "ns._mhLocales = ns._mhLocales or {}",
        "",
        "local OVERRIDES = {",
    ]
    for k in sorted(translated.keys(), key=lambda x: keys.index(x) if x in keys else 9999):
        # preserve original key order from enUS
        pass
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
        "ns._mhLocales.deDE = pack",
        "",
    ]
    OUT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_PATH} ({len(translated)} overrides)")


if __name__ == "__main__":
    main()
