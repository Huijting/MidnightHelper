#!/usr/bin/env python3
"""
Replace tip rows in GuideData.lua with textKey = GUIDE_TIP_NNN.
Generate Locales/GuideTips.lua with enUS + nlNL strings (machine-assisted translation).

Requires: pip install deep-translator

Run: python tools/migrate_guide_tips_to_locale.py
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
GUIDE_DATA = ROOT / "Addons" / "GuideData.lua"
OUT_LUA = ROOT / "Locales" / "GuideTips.lua"
BACKUP = ROOT / "Addons" / "GuideData.lua.bak_tips"

ROW_RE = re.compile(
    r'(\{\s*spell\s*=\s*\d+\s*,\s*)text\s*=\s*"((?:[^"\\]|\\.)*)"\s*(\}\s*,)'
)

ENG_HINT = re.compile(
    r"\b(Use |Keep |Always |Never |Your |your |the |The |for |Damage |damage)\b"
)
DUTCH_HINT = re.compile(
    r"\b(Gebruik|Houd |Benut|Altijd |Nooit | je | voor | niet |schade|vijand|handig|geneest|trekken)\b"
)


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def lua_unescape(raw: str) -> str:
    return raw.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\")


def classify(s: str) -> str:
    """Return 'en' if likely English tooltip, else 'nl'."""
    if DUTCH_HINT.search(s):
        return "nl"
    if ENG_HINT.search(s) and len(s.split()) >= 4:
        return "en"
    # Short ability blurbs often English without "Use"
    if re.match(r"^[A-Za-z]", s) and not DUTCH_HINT.search(s):
        return "en"
    return "nl"


def main() -> int:
    try:
        from deep_translator import GoogleTranslator  # type: ignore
    except ImportError:
        print("Install: pip install deep-translator", file=sys.stderr)
        return 1

    tr_nl_en = GoogleTranslator(source="nl", target="en")
    tr_en_nl = GoogleTranslator(source="en", target="nl")

    raw = GUIDE_DATA.read_text(encoding="utf-8")
    matches = list(ROW_RE.finditer(raw))
    if not matches:
        print("No matches — check ROW_RE vs GuideData.lua format.", file=sys.stderr)
        return 1

    tips_en: list[str] = []
    tips_nl: list[str] = []

    for i, m in enumerate(matches, start=1):
        inner = lua_unescape(m.group(2))
        lang = classify(inner)
        try:
            if lang == "en":
                tips_en.append(inner)
                tips_nl.append(tr_en_nl.translate(inner))
            else:
                tips_nl.append(inner)
                tips_en.append(tr_nl_en.translate(inner))
        except Exception as e:
            print(f"Translate failed #{i}: {e}", file=sys.stderr)
            tips_en.append(inner)
            tips_nl.append(inner)
        time.sleep(0.08)
        if i % 40 == 0:
            print(f"... {i}/{len(matches)}", flush=True)

    # Rewrite GuideData.lua
    new_parts: list[str] = []
    pos = 0
    for i, m in enumerate(matches):
        key = f"GUIDE_TIP_{i + 1:03d}"
        prefix, _, suffix = m.group(1), m.group(2), m.group(3)
        new_parts.append(raw[pos : m.start()])
        new_parts.append(f'{prefix}textKey = "{key}" {suffix}')
        pos = m.end()
    new_parts.append(raw[pos:])
    new_text = "".join(new_parts)

    BACKUP.write_text(raw, encoding="utf-8")
    GUIDE_DATA.write_text(new_text, encoding="utf-8")

    lines = [
        "--[[",
        "\tMidnight Helper — Leveling guide tip strings (GUIDE_TIP_*).",
        "\tAuto-generated; nl=en mirror policy from migrate_guide_tips_to_locale.py.",
        "]]",
        "",
        "local _, ns = ...",
        "",
        "local function merge(target, patch)",
        "\tif not target or not patch then",
        "\t\treturn",
        "\tend",
        "\tfor k, v in pairs(patch) do",
        "\t\ttarget[k] = v",
        "\tend",
        "end",
        "",
        "merge(ns._mhLocales and ns._mhLocales.enUS, {",
    ]
    for i, s in enumerate(tips_en):
        lines.append(f'\t["GUIDE_TIP_{i + 1:03d}"] = "{lua_escape(s)}",')
    lines.append("})")
    lines.append("")
    lines.append("merge(ns._mhLocales and ns._mhLocales.nlNL, {")
    for i, s in enumerate(tips_nl):
        lines.append(f'\t["GUIDE_TIP_{i + 1:03d}"] = "{lua_escape(s)}",')
    lines.append("})")
    lines.append("")
    OUT_LUA.write_text("\n".join(lines) + "\n", encoding="utf-8")

    meta = ROOT / "tools" / "guide_tips_extracted.json"
    meta.write_text(
        json.dumps(
            [{"i": i, "en": tips_en[i], "nl": tips_nl[i]} for i in range(len(tips_en))],
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    print(f"OK: {len(matches)} tips. Backup {BACKUP.name}. Wrote {OUT_LUA.name}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
