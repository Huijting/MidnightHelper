#!/usr/bin/env python3
"""Append deDE + frFR GUIDE_TIP merges to Locales/GuideTips.lua (batch translate)."""
import re
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / "Locales" / "GuideTips.lua"
text = path.read_text(encoding="utf-8")
if "merge(ns._mhLocales and ns._mhLocales.deDE" in text:
    print("deDE merge already present")
    raise SystemExit(0)

en_block = re.search(r"merge\(ns\._mhLocales and ns\._mhLocales\.enUS, \{([^}]+)\}", text, re.S)
tips = re.findall(r'\["(GUIDE_TIP_\d+)"\] = "((?:[^"\\]|\\.)*)"', en_block.group(1))


def unescape(s: str) -> str:
    return s.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\")


def escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def translate_all(tips_list, tr, label):
    out = []
    batch = 45
    for i in range(0, len(tips_list), batch):
        chunk = tips_list[i : i + batch]
        vals = [unescape(t[1]) for t in chunk]
        translated = tr.translate_batch(vals)
        for (key, _), fr in zip(chunk, translated):
            out.append((key, escape(fr or "")))
        print(f"  {label} {min(i + batch, len(tips_list))}/{len(tips_list)}")
    return out


def block(code, pairs):
    lines = [f"merge(ns._mhLocales and ns._mhLocales.{code}, {{"]
    for k, v in pairs:
        lines.append(f'\t["{k}"] = "{v}",')
    lines.append("})")
    return "\n".join(lines)


print("Translating DE…")
de_pairs = translate_all(tips, GoogleTranslator(source="en", target="de"), "DE")
print("Translating FR…")
fr_pairs = translate_all(tips, GoogleTranslator(source="en", target="fr"), "FR")

append = "\n\n" + block("deDE", de_pairs) + "\n\n" + block("frFR", fr_pairs) + "\n"
path.write_text(text.rstrip() + append, encoding="utf-8")
print("Done")
