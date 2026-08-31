#!/usr/bin/env python3
"""Read ns.db.unlearnedDump and build a per-category list with sources.

Generic this time: yesterday's version hardcoded the Enchanting category ids, which was
fine for a one-off and useless the moment the professions changed. Groups by whatever
categories the dump actually contains.
"""
import io
import os
import re
import sys
from collections import defaultdict

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
OUT = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\docs\UNLEARNED_SHAMAN.md"

text = io.open(SV, encoding="utf-8", errors="replace").read()


def brace_block(s, at):
    start = s.find("{", at)
    depth, j, in_str = 0, start, False
    while j < len(s):
        c = s[j]
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
                return s[start:j + 1]
        j += 1
    return ""


def entries(block):
    out, k = [], 1
    while True:
        nxt = block.find("{", k)
        if nxt < 0:
            return out
        e = brace_block(block, nxt)
        if not e:
            return out
        out.append(e)
        k = nxt + len(e)


i = text.find("unlearnedDump")
if i < 0:
    print("auraSpellProbe-style miss: unlearnedDump not in the file.")
    print("The probe stores in memory; only /reload or logout writes SavedVariables.")
    sys.exit(0)
dump = brace_block(text, i)

when = re.search(r'\["when"\]\s*=\s*"([^"]*)"', dump)
print("dump written: %s" % (when.group(1) if when else "?"))

cat = {}
cb = brace_block(dump, dump.find('["categories"]'))
for e in entries(cb):
    a = re.search(r'\["id"\]\s*=\s*(\d+)', e)
    b = re.search(r'\["name"\]\s*=\s*"([^"]*)"', e)
    if a:
        cat[int(a.group(1))] = b.group(1) if b else None


def clean(s):
    s = s.replace("\\r\\n", " · ").replace("\\n", " · ").replace("|n", " · ")
    s = re.sub(r"\|c[0-9A-Fa-f]{8}", "", s).replace("|r", "")
    s = re.sub(r"\|H.*?\|h\[?(.*?)\]?\|h", r"\1", s)
    s = re.sub(r"\|T.*?\|t", "", s)
    s = re.sub(r"\s*·\s*·\s*", " · ", s)
    return re.sub(r"\s+", " ", s).strip(" ·")


groups, total = defaultdict(list), 0
for e in entries(brace_block(dump, dump.find('["recipes"]'))):
    total += 1
    cid = re.search(r'\["categoryID"\]\s*=\s*(\d+)', e)
    nm = re.search(r'\["name"\]\s*=\s*"([^"]*)"', e)
    src = re.search(r'\["source"\]\s*=\s*"((?:[^"\\]|\\.)*)"', e)
    c = int(cid.group(1)) if cid else 0
    groups[c].append((nm.group(1) if nm else "?", clean(src.group(1)) if src else None))

print("%d unlearned recipes across %d categories\n" % (total, len(groups)))
lines = ["# Onaangeleerde recepten — Robs shaman\n",
         "Uit de client met `/mh unlearned` (`C_TradeSkillUI.GetRecipeSourceText`). "
         "**Niet met de hand bijwerken.**\n",
         "⚠️ Dit is één personage op één moment.\n",
         "**%d recepten** in %d categorieën.\n" % (total, len(groups))]
for c in sorted(groups, key=lambda k: (cat.get(k) or "zzz")):
    name = cat.get(c) or ("categorie %d" % c)
    print("   %-6s %-32s %d" % (c, name, len(groups[c])))
    lines.append("\n## %s\n" % name)
    lines.append("| recept | waar je het leert |")
    lines.append("|---|---|")
    for n, s in sorted(groups[c]):
        lines.append("| %s | %s |" % (n, s or "— *(de client zegt het niet)*"))

io.open(OUT, "w", encoding="utf-8", newline="\n").write("\n".join(lines) + "\n")
print("\nwritten:", OUT)
