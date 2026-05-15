#!/usr/bin/env python3
"""Re-translate any enUS GUIDE_TIP_* values that still look Dutch."""

import pathlib
import re
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
PATH = ROOT / "Locales" / "GuideTips.lua"

DUTCH = re.compile(
    r"|".join(
        [
            r"\bde\b",
            r"\bhet\b",
            r"\been\b",
            r"\bvan\b",
            r"\bvoor\b",
            r"\bje\b",
            r"\bvijand",
            r"vijanden",
            r"\bGebruik\b",
            r"\bstopt\b",
            r"\bvijandelijk",
            r"\bjouw\b",
            r"\bniet\b",
            r"schade\b",
            r"houdt groepen",
            r"\bkerkers\b",
            r"\btover",
            r"bondgenoten",
            r"genezing",
            r"bepantsering",
        ]
    ),
    re.I,
)


def lua_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def main() -> int:
    try:
        from deep_translator import GoogleTranslator  # type: ignore
    except ImportError:
        print("pip install deep-translator", file=sys.stderr)
        return 1

    tr = GoogleTranslator(source="nl", target="en")
    text = PATH.read_text(encoding="utf-8")
    # Grab first merge(...) enUS table only
    m = re.search(r"merge\(ns\._mhLocales and ns\._mhLocales\.enUS,\s*\{([\s\S]*?)\}\)", text)
    if not m:
        print("Could not find enUS merge block.", file=sys.stderr)
        return 1
    block = m.group(1)
    line_re = re.compile(r'\[\s*"([^"]+)"\s*\]\s*=\s*"((?:[^"\\]|\\.)*)"')
    replacements = []
    for lm in line_re.finditer(block):
        key, raw = lm.group(1), lm.group(2)
        inner = raw.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\")
        if not key.startswith("GUIDE_TIP_"):
            continue
        if not DUTCH.search(inner):
            continue
        try:
            new_en = tr.translate(inner)
        except Exception as e:
            print(key, e, file=sys.stderr)
            continue
        replacements.append((key, new_en))
        time.sleep(0.06)
        print(key, "->", new_en[:60], "...")

    full = text
    for key, new_en in replacements:
        esc = lua_escape(new_en)
        pat = rf'(\[\s*"{re.escape(key)}"\s*\]\s*=\s*")(?:[^"\\]|\\.)*(")'
        full, n = re.subn(pat, rf"\g<1>{esc}\2", full, count=1)
        if n != 1:
            print("WARN replace failed", key, file=sys.stderr)

    PATH.write_text(full, encoding="utf-8")
    print(f"Patched {len(replacements)} strings.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
