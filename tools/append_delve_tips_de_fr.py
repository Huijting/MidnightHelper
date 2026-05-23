#!/usr/bin/env python3
"""Append deDE + frFR DelveTips merges (batch translate from enUS block)."""
import re
from pathlib import Path
from deep_translator import GoogleTranslator

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
