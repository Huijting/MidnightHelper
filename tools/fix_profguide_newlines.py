#!/usr/bin/env python3
"""Fix PROFGUIDE strings: \\n -> |n for WoW UI."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

for name in ("enUS.lua", "nlNL.lua"):
    path = ROOT / "Locales" / name
    text = path.read_text(encoding="utf-8")

    def fix_line(m: re.Match) -> str:
        line = m.group(0)
        line = line.replace("\\\\n\\\\n", "|n|n")
        line = line.replace("\\\\n", "|n")
        return line

    new = re.sub(
        r'^\tPROFGUIDE_[A-Z0-9_]+ = ".*",?\s*$',
        fix_line,
        text,
        flags=re.MULTILINE,
    )
    if new != text:
        path.write_text(new, encoding="utf-8")
        print("fixed", path.name)
    else:
        print("unchanged", path.name)
