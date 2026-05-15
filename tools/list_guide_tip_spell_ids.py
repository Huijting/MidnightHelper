#!/usr/bin/env python3
"""Print sorted unique spell IDs used in GuideData leveling tips (textKey rows only)."""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]
text = (ROOT / "Addons" / "GuideData.lua").read_text(encoding="utf-8")
pat = re.compile(
    r'\{\s*spell\s*=\s*(\d+)\s*,\s*textKey\s*=\s*"(GUIDE_TIP_\d+)"\s*\}'
)
pairs = [(int(a), b) for a, b in pat.findall(text)]
ids = sorted({s for s, _ in pairs})
print("pairs", len(pairs))
print("unique_spell_ids", len(ids))
print(json.dumps(ids, indent=2))
