#!/usr/bin/env python3
"""One-off: extract tip texts from GuideData.lua for locale migration."""
import re
import pathlib

root = pathlib.Path(__file__).resolve().parents[1]
path = root / "Addons" / "GuideData.lua"
text = path.read_text(encoding="utf-8")

# Match: { spell = 123, text = "..." } with escaped quotes inside
pattern = re.compile(
    r"\{\s*spell\s*=\s*(\d+)\s*,\s*text\s*=\s*\"((?:[^\"\\]|\\.)*)\"\s*\}",
    re.MULTILINE,
)

matches = list(pattern.finditer(text))
spos = sorted({m.start() for m in matches})
print(f"Found {len(matches)} matches, {len(spos)} unique start positions (expected ~100)")
if len(matches) != len(spos):
    print("WARNING: overlapping duplicate matches")

for i, m in enumerate(matches, 1):
    sid = m.group(1)
    raw = m.group(2)
    # Unescape Lua string
    s = raw.replace("\\\"", "\"").replace("\\n", "\n")
    key = f"GUIDE_TIP_{i:03d}"
    print(f"{key}\tspell={sid}\t{s[:60]}...")
