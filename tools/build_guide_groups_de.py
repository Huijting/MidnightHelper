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
tr = GoogleTranslator(source="en", target="de")

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
        de = tr.translate(v)
        de = de.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'\t{k} = "{de}",')
        time.sleep(0.08)
    lines.append("}")
    return "\n".join(lines)

shared_de = translate_block("SHARED_DE", shared)
group_de = translate_block("GROUP_DE", group)
snippet = shared_de + "\n\n" + group_de + "\n"
out = ROOT / "tools" / "_guide_groups_de.lua"
out.write_text(snippet, encoding="utf-8")
print("Wrote", out)
