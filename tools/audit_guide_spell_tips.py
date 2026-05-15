#!/usr/bin/env python3
"""
Validate GuideData.lua leveling tips against Locales/GuideTips.lua (enUS strings).

Checks:
  - Every { spell, textKey } row resolves to a non-empty GUIDE_TIP_* string in GuideTips.lua
  - GUIDE_TIP_* keys used by GuideData exist (first occurrence wins — enUS table is first)

Optional spell/icon consistency pass:
  - Pass --spell-names tools/guide_spell_names.json ({"123": "Spell Name", ...})
  - Generated when Wowhead allows scripted access:
      python tools/fetch_guide_spell_names.py

Exit code 1 if structural errors exist (missing tip strings / missing keys).
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
GUIDE_DATA = ROOT / "Addons" / "GuideData.lua"
GUIDE_TIPS = ROOT / "Locales" / "GuideTips.lua"

ROW_RE = re.compile(
    r'\{\s*spell\s*=\s*(\d+)\s*,\s*textKey\s*=\s*"(GUIDE_TIP_\d+)"\s*\}'
)
TIP_EN_RE = re.compile(r'\["(GUIDE_TIP_\d+)"\]\s*=\s*"((?:[^"\\]|\\.)*)"')


def _unescape_lua_string(s: str) -> str:
    return s.replace('\\"', '"').replace("\\n", "\n")


def load_guide_tip_en() -> dict[str, str]:
    text = GUIDE_TIPS.read_text(encoding="utf-8")
    out: dict[str, str] = {}
    for m in TIP_EN_RE.finditer(text):
        key, raw = m.group(1), m.group(2)
        if key not in out:
            out[key] = _unescape_lua_string(raw)
    return out


def load_pairs() -> list[tuple[int, str]]:
    gd = GUIDE_DATA.read_text(encoding="utf-8")
    return [(int(spell), key) for spell, key in ROW_RE.findall(gd)]


def tip_matches_spell(tip: str, spell_name: str) -> bool:
    t = tip.lower()
    sn = spell_name.lower()
    if sn and sn in t:
        return True
    parts = re.split(r"[\s:/'-]+", spell_name)
    significant = [p for p in parts if len(p) >= 4]
    hits = sum(1 for p in significant if p.lower() in t)
    # Avoid accepting overly-generic tokens only (e.g. "strike").
    return hits >= 2 or (len(significant) == 1 and significant[0].lower() in t)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--spell-names",
        type=pathlib.Path,
        default=None,
        help="Optional JSON spell-id→English-name map for heuristic spell/text checks.",
    )
    args = ap.parse_args()

    tips_en = load_guide_tip_en()
    pairs = load_pairs()

    missing_strings = [(sid, k) for sid, k in pairs if not (tips_en.get(k) or "").strip()]
    missing_keys = [k for _, k in pairs if k not in tips_en]

    print(f"Guide tip rows: {len(pairs)}")
    print(f"Missing GUIDE_TIP_* definitions (GuideTips.lua): {len(missing_keys)}")
    print(f"Empty GUIDE_TIP_* strings: {len(missing_strings)}")

    spell_db: dict[str, str] = {}
    if args.spell_names:
        if not args.spell_names.is_file():
            print(f"Spell DB file not found: {args.spell_names}", file=sys.stderr)
            return 2
        spell_db = json.loads(args.spell_names.read_text(encoding="utf-8"))

    mismatches: list[tuple[int, str, str, str]] = []
    if spell_db:
        for sid, key in pairs:
            tip = tips_en.get(key, "")
            name = (spell_db.get(str(sid)) or "").strip()
            if not name:
                mismatches.append((sid, key, tip[:140], "<missing spell name in DB>"))
                continue
            if not tip_matches_spell(tip, name):
                mismatches.append((sid, key, tip[:140], name))

        print(f"Heuristic spell↔text mismatches (needs manual judgement): {len(mismatches)}")
        for sid, key, tip_snip, name in mismatches[:120]:
            print(f"\nspell={sid} ({name}) {key}")
            print(f"  tip: {tip_snip}")
        if len(mismatches) > 120:
            print(f"\n... plus {len(mismatches) - 120} more")

    if missing_keys or missing_strings:
        for sid, k in missing_strings[:40]:
            print(f"missing/empty: spell={sid} {k}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
