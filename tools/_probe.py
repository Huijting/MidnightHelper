#!/usr/bin/env python3
"""Which character has which professions? MH already knows -- charCurrencies stores it.

Rob was right: no need to ask him to remember. This turns "log in on everything" into a named
shortlist, and shows which of the eleven professions nobody covers.
"""
import io
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
text = io.open(SV, encoding="utf-8", errors="replace").read()

m = re.search(r'^\["charCurrencies"\]\s*=\s*\{', text, re.M)
start = m.end() - 1
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
blob = text[start:j + 1]

chars = []
for pm in re.finditer(r'\["(Player-\d+-[0-9A-F]+)"\]\s*=\s*\{', blob):
    s = pm.end() - 1
    d2, k, ins = 0, s, False
    while k < len(blob):
        c = blob[k]
        if ins:
            if c == "\\":
                k += 2
                continue
            if c == '"':
                ins = False
        elif c == '"':
            ins = True
        elif c == "{":
            d2 += 1
        elif c == "}":
            d2 -= 1
            if d2 == 0:
                break
        k += 1
    b = blob[s:k + 1]
    g = lambda p: (re.search(p, b).group(1) if re.search(p, b) else None)
    chars.append({
        "name": g(r'\["name"\]\s*=\s*"([^"]*)"'),
        "realm": g(r'\["realm"\]\s*=\s*"([^"]*)"'),
        "level": g(r'\["level"\]\s*=\s*(\d+)'),
        "profs": g(r'\["professionsFull"\]\s*=\s*"([^"]*)"') or g(r'\["professions"\]\s*=\s*"([^"]*)"'),
    })

ALL = ["Alchemy", "Blacksmithing", "Enchanting", "Engineering", "Herbalism", "Inscription",
       "Jewelcrafting", "Leatherworking", "Mining", "Skinning", "Tailoring"]
have = set()
print("%-16s %-14s %-5s %s" % ("character", "realm", "lvl", "professions"))
print("-" * 74)
for c in sorted(chars, key=lambda x: -(int(x["level"] or 0))):
    p = c["profs"] or ""
    for a in ALL:
        if a in p:
            have.add(a)
    print("%-16s %-14s %-5s %s" % (c["name"] or "?", c["realm"] or "?", c["level"] or "?", p or "—"))

print("\ncovered  (%d/11): %s" % (len(have), ", ".join(sorted(have))))
print("MISSING  (%d/11): %s" % (11 - len(have), ", ".join(a for a in ALL if a not in have)))
