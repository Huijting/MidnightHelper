#!/usr/bin/env python3
import re
import time
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / "Locales" / "GuideGroups.lua"
text = path.read_text(encoding="utf-8")
shared = re.search(r"local SHARED_EN = \{([^}]+)\}", text, re.S).group(1)
group = re.search(r"local GROUP_EN = \{([^}]+)\}", text, re.S).group(1)
tr = GoogleTranslator(source="en", target="fr")

def translate_block(name: str, body: str) -> str:
    pairs = []
    for line in body.splitlines():
        if " = \"" not in line:
            continue
        m = re.match(r"\t([A-Z0-9_]+) = \"(.+)\"\s*,?\s*$", line)
        if m:
            pairs.append((m.group(1), m.group(2).replace('\\"', '"')))
    lines = [f"local {name} = {{"]
    for k, v in pairs:
        fr = tr.translate(v)
        fr = fr.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'\t{k} = "{fr}",')
        time.sleep(0.08)
    lines.append("}")
    return "\n".join(lines)

out = ROOT / "tools" / "_guide_groups_fr_snippet.txt"
out.write_text(
    translate_block("SHARED_FR", shared) + "\n\n" + translate_block("GROUP_FR", group) + "\n",
    encoding="utf-8",
)
print("Wrote", out)
