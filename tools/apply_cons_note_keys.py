#!/usr/bin/env python3
"""Replace noteEn with noteKey in ConsumablesWowheadData.lua."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / "Modules" / "ConsumablesWowheadData.lua"
text = path.read_text(encoding="utf-8")
notes = sorted(set(re.findall(r'noteEn = "([^"]+)"', text)))
key_by_note = {n: f"CONS_NOTE_{i:02d}" for i, n in enumerate(notes, 1)}
for note, key in key_by_note.items():
    text = text.replace(f'noteEn = "{note}"', f'noteKey = "{key}"')
path.write_text(text, encoding="utf-8")
print("Keys:", key_by_note)
