#!/usr/bin/env python3
"""Read ns.db.auraSpellProbe: what did the out-of-combat pass record, and what came back
in combat? The whole question is whether a spell we KNOW is on the player answers `false`
(the API lying) or `nil` (the API refusing). Only the first is dangerous."""
import io
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
text = io.open(SV, encoding="utf-8", errors="replace").read()

i = text.find("auraSpellProbe")
if i < 0:
    print("auraSpellProbe is NOT in the file.")
    print("Either the probe has not run, or the reload that flushes SavedVariables")
    print("has not happened since. The probe stores in memory; only /reload or logout writes it.")
    sys.exit(0)

start = text.find("{", i)
depth, j, in_str = 0, start, False
while j < len(text):
    c = text[j]
    if in_str:
        if c == "\\":
            j += 2
            continue
        if c == '"':
            in_str = False
    elif c == '"':
        in_str = True
    elif c == "{":
        depth += 1
    elif c == "}":
        depth -= 1
        if depth == 0:
            break
    j += 1

print(text[start:j + 1])
