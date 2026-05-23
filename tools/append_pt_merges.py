#!/usr/bin/env python3
"""Append ptBR GUIDE_TIP and DelveTips merges (batch translate from enUS)."""
import re
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
tr = GoogleTranslator(source="en", target="pt")


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
        translated = tr.translate_batch(vals)
        for (key, _), pt in zip(chunk, translated):
            out.append((key, esc(pt or "")))
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
    if "merge(ns._mhLocales and ns._mhLocales.ptBR" in guide_text:
        print("GuideTips ptBR already present")
    else:
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
        pt_guide = translate_pairs(tips, unescape, escape_guide, "guide")
        guide_path.write_text(
            guide_text.rstrip() + "\n\n" + block("ptBR", pt_guide) + "\n",
            encoding="utf-8",
        )
        print("Wrote GuideTips ptBR merge")

    delve_path = ROOT / "Locales" / "DelveTips.lua"
    delve_text = delve_path.read_text(encoding="utf-8")
    if "merge(ns._mhLocales and ns._mhLocales.ptBR" in delve_text:
        print("DelveTips ptBR already present")
    else:
        start = delve_text.find("merge(ns._mhLocales and ns._mhLocales.enUS, {")
        end = delve_text.find("\n})", start)
        en_block = delve_text[start:end]
        pairs = re.findall(
            r"^\t(DELVE_[A-Z0-9_]+) = \"((?:[^\"\\]|\\.)*)\"\s*,?\s*$",
            en_block,
            re.M,
        )
        print(f"DelveTips: {len(pairs)} keys…")
        pt_delve = translate_pairs(pairs, unescape, escape_delve, "delve")
        delve_path.write_text(
            delve_text.rstrip() + "\n\n" + block("ptBR", pt_delve) + "\n",
            encoding="utf-8",
        )
        print("Wrote DelveTips ptBR merge")


if __name__ == "__main__":
    main()
