#!/usr/bin/env python3
"""🔴 DO NOT RUN. This script is what produced the broken translations.

It machine-translated all 88 DelveTips keys into deDE and frFR through GoogleTranslator, and
that output shipped. What it cost, measured 30-31 Aug 2026: 92 suspect German lines
("Unterbrechen du ... wann immer du können"), grues rendered as sadness in Portuguese, wipe
risk INVERTED into "eliminates the risk" in two languages, three {SPELL:@...} placeholders
misspelled into tokens that can never resolve, and the word "delve" translated thirteen times
across five different words in one file.

⚠️ It is kept, disabled, because the name describes exactly what a future session will want
("append delve tips for a language") and deleting it would only mean writing it again. The
trap is the name, so the warning has to live here.

Use tools/apply_agent_translation.py instead: a language expert translates from the English,
writes KEY/TEXT blocks, and the checker validates markup and placeholders before any of it
becomes Lua. That pipeline is why the `-&gt;` HTML escape was caught in review rather than in
Rob's game.
"""
import re
import sys
from pathlib import Path

print(__doc__)
sys.exit("refusing to run: see the header, and use apply_agent_translation.py")

from deep_translator import GoogleTranslator  # noqa: E402  (unreachable, kept for history)

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / "Locales" / "DelveTips.lua"
text = path.read_text(encoding="utf-8")
if "merge(ns._mhLocales and ns._mhLocales.deDE" in text:
    print("deDE merge already present")
    raise SystemExit(0)

start = text.find("merge(ns._mhLocales and ns._mhLocales.enUS, {")
end = text.find("\n})", start)
en_block = text[start:end] if start >= 0 and end > start else ""
pairs = re.findall(r"^\t(DELVE_[A-Z0-9_]+) = \"((?:[^\"\\]|\\.)*)\"\s*,?\s*$", en_block, re.M)


def unescape(s: str) -> str:
    return s.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\").replace("|n", "\n")


def escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "|n")


def translate_all(pairs_list, tr, label):
    out = []
    batch = 20
    for i in range(0, len(pairs_list), batch):
        chunk = pairs_list[i : i + batch]
        vals = [unescape(v) for _, v in chunk]
        translated = tr.translate_batch(vals)
        for (key, _), fr in zip(chunk, translated):
            out.append((key, escape(fr or "")))
        print(f"  {label} {min(i + batch, len(pairs_list))}/{len(pairs_list)}")
    return out


def block(code, pair_list):
    lines = [f"merge(ns._mhLocales and ns._mhLocales.{code}, {{"]
    for k, v in pair_list:
        lines.append(f'\t["{k}"] = "{v}",')
    lines.append("})")
    return "\n".join(lines)


print(f"Translating {len(pairs)} keys…")
de_pairs = translate_all(pairs, GoogleTranslator(source="en", target="de"), "DE")
fr_pairs = translate_all(pairs, GoogleTranslator(source="en", target="fr"), "FR")

append = "\n\n" + block("deDE", de_pairs) + "\n\n" + block("frFR", fr_pairs) + "\n"
path.write_text(text.rstrip() + append, encoding="utf-8")
print("Done")
