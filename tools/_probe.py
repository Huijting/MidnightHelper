#!/usr/bin/env python3
"""Read ns.db.unlearnedDump out of the SavedVariables file.

3.3 MB of Lua, so this seeks the key and walks braces rather than loading the lot. The
sample table matters most: it is the client's own field list for a recipe, which decides
whether "where do I learn this" is answerable at all.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"

text = io.open(SV, encoding="utf-8", errors="replace").read()
i = text.find("unlearnedDump")
if i < 0:
    print("unlearnedDump NOT in the file.")
    print("Either /mh unlearned did not run, or the reload that writes the file has not")
    print("happened yet. The probe stores in memory; only a reload or logout flushes it.")
    sys.exit(0)

# Walk from the opening brace after the key to its match.
start = text.find("{", i)
depth, j = 0, start
while j < len(text):
    c = text[j]
    if c == "{":
        depth += 1
    elif c == "}":
        depth -= 1
        if depth == 0:
            break
    j += 1
block = text[start:j + 1]
print("block: %d chars" % len(block))

for label, pat in (("when", r'\["when"\]\s*=\s*"([^"]*)"'),
                   ("learned", r'\["learned"\]\s*=\s*(\d+)'),
                   ("unreadable", r'\["unreadable"\]\s*=\s*(\d+)')):
    m = re.search(pat, block)
    print("%-11s %s" % (label, m.group(1) if m else "-"))

for label in ("apiPresent", "apiAbsent"):
    m = re.search(r'\["' + label + r'"\]\s*=\s*\{(.*?)\}', block, re.S)
    if m:
        names = re.findall(r'"([^"]+)"', m.group(1))
        print("%-11s %s" % (label, ", ".join(names) or "-"))

print("\n--- sample (the client's own field names for one unlearned recipe) ---")
m = re.search(r'\["sample"\]\s*=\s*\{(.*?)\n\t*\},', block, re.S)
if m:
    for line in m.group(1).splitlines():
        line = line.strip()
        if line:
            print("   " + line)
else:
    print("   (no sample captured)")

# How many recipes, and the first handful with whatever source fields survived.
recs = re.search(r'\["recipes"\]\s*=\s*\{(.*)\n\t*\},?\s*$', block, re.S)
if recs:
    entries = re.findall(r'\{(.*?)\n\t*\},', recs.group(1), re.S)
    print("\nrecipes captured: %d" % len(entries))
    for e in entries[:12]:
        flat = " ".join(x.strip() for x in e.splitlines() if x.strip())
        print("   " + flat[:220])
    if len(entries) > 12:
        print("   ... and %d more" % (len(entries) - 12))
