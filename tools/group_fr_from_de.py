#!/usr/bin/env python3
import re
import time
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
text = (ROOT / "Locales" / "GuideGroups.lua").read_text(encoding="utf-8")
shared_de = re.search(r"local SHARED_DE = \{([^}]+)\}", text, re.S).group(1)
group_de = re.search(r"local GROUP_DE = \{([^}]+)\}", text, re.S).group(1)
tr = GoogleTranslator(source="de", target="fr")

FIXES = {
    "Tiefen": "Gouffres",
    "tiefen": "gouffres",
    "Delves": "Gouffres",
    "Fouilles": "Gouffres",
    "fouilles": "gouffres",
    "Réservoir": "tank",
    "réservoir": "tank",
    "char": "tank",
    "Char": "tank",
}


def translate_block(name: str, body: str) -> str:
    lines = [f"local {name} = {{"]
    for line in body.splitlines():
        m = re.match(r"\t([A-Z0-9_]+) = \"(.+)\"\s*,?\s*$", line)
        if not m:
            continue
        v = m.group(2).replace('\\"', '"')
        fr = tr.translate(v)
        for a, b in FIXES.items():
            fr = fr.replace(a, b)
        fr = fr.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'\t{m.group(1)} = "{fr}",')
        time.sleep(0.05)
    lines.append("}")
    return "\n".join(lines)


out = translate_block("SHARED_FR", shared_de) + "\n\n" + translate_block("GROUP_FR", group_de) + "\n"
(ROOT / "tools" / "_guide_groups_fr_snippet.txt").write_text(out, encoding="utf-8")
print("Wrote snippet", len(out))
