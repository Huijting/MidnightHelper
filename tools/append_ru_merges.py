#!/usr/bin/env python3
"""Append ruRU GUIDE_TIP and DelveTips merges."""
import re
import time
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
tr = GoogleTranslator(source="en", target="ru")


def unescape(s: str) -> str:
    return s.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\").replace("|n", "\n")


def escape_guide(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def escape_delve(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "|n")


def translate_pairs(pairs, unesc, esc, label):
    out = []
    batch = 25
    for i in range(0, len(pairs), batch):
        chunk = pairs[i : i + batch]
        vals = [unesc(v) for _, v in chunk]
        try:
            translated = tr.translate_batch(vals)
        except Exception:
            translated = []
            for v in vals:
                try:
                    translated.append(tr.translate(v))
                except Exception:
                    translated.append(v)
                time.sleep(0.08)
        for (key, _), ru in zip(chunk, translated):
            out.append((key, esc(ru or "")))
        print(f"  {label} {min(i + batch, len(pairs))}/{len(pairs)}")
    return out


def block(code, pair_list):
    lines = [f"merge(ns._mhLocales and ns._mhLocales.{code}, {{"]
    for k, v in pair_list:
        lines.append(f'\t["{k}"] = "{v}",')
    lines.append("})")
    return "\n".join(lines)


def main() -> None:
    guide_path = ROOT / "Locales" / "GuideTips.lua"
    guide_text = guide_path.read_text(encoding="utf-8")
    if "merge(ns._mhLocales and ns._mhLocales.ruRU" not in guide_text:
        en_block = re.search(
            r"merge\(ns\._mhLocales and ns\._mhLocales\.enUS, \{([^}]+)\}",
            guide_text,
            re.S,
        )
        tips = re.findall(
            r'\["(GUIDE_TIP_\d+)"\] = "((?:[^"\\]|\\.)*)"',
            en_block.group(1),
        )
        print(f"GuideTips: {len(tips)} keys…")
        ru_guide = translate_pairs(tips, unescape, escape_guide, "guide")
        guide_path.write_text(
            guide_text.rstrip() + "\n\n" + block("ruRU", ru_guide) + "\n",
            encoding="utf-8",
        )
        print("Wrote GuideTips ruRU merge")

    delve_path = ROOT / "Locales" / "DelveTips.lua"
    delve_text = delve_path.read_text(encoding="utf-8")
    if "merge(ns._mhLocales and ns._mhLocales.ruRU" not in delve_text:
        start = delve_text.find("merge(ns._mhLocales and ns._mhLocales.enUS, {")
        end = delve_text.find("\n})", start)
        en_block = delve_text[start:end]
        pairs = re.findall(
            r"^\t(DELVE_[A-Z0-9_]+) = \"((?:[^\"\\]|\\.)*)\"\s*,?\s*$",
            en_block,
            re.M,
        )
        print(f"DelveTips: {len(pairs)} keys…")
        ru_delve = translate_pairs(pairs, unescape, escape_delve, "delve")
        delve_path.write_text(
            delve_text.rstrip() + "\n\n" + block("ruRU", ru_delve) + "\n",
            encoding="utf-8",
        )
        print("Wrote DelveTips ruRU merge")


if __name__ == "__main__":
    main()
