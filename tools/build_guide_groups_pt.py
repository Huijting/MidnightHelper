#!/usr/bin/env python3
"""Generate SHARED_PT + GROUP_PT snippet for GuideGroups.lua."""
import re
import time
from pathlib import Path
from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / "Locales" / "GuideGroups.lua"
text = path.read_text(encoding="utf-8")
shared = re.search(r"local SHARED_EN = \{([^}]+)\}", text, re.S).group(1)
group = re.search(r"local GROUP_EN = \{([^}]+)\}", text, re.S).group(1)
tr = GoogleTranslator(source="en", target="pt")


def translate_block(name: str, body: str) -> str:
    pairs = []
    for line in body.splitlines():
        if ' = "' not in line:
            continue
        m = re.match(r"\t([A-Z0-9_]+) = \"(.+)\"\s*,?\s*$", line)
        if m:
            pairs.append((m.group(1), m.group(2).replace('\\"', '"')))
    lines = [f"local {name} = {{"]
    for k, v in pairs:
        pt = tr.translate(v)
        if k == "GUIDE_LEVEL_ADVISOR_TAB_GROUPS":
            pt = "Em grupo"
        if k == "GUIDE_GROUPS_MELEE_80_3":
            pt = "Profundidades são um passo mais suave antes de procurar masmorras no LFG."
        pt = pt.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'\t{k} = "{pt}",')
        time.sleep(0.08)
    lines.append("}")
    return "\n".join(lines)


snippet = translate_block("SHARED_PT", shared) + "\n\n" + translate_block("GROUP_PT", group) + "\n"
out = ROOT / "tools" / "_guide_groups_pt_snippet.txt"
out.write_text(snippet, encoding="utf-8")
print("Wrote", out)
