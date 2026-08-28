#!/usr/bin/env python3
"""The Venomous Abyss loot, per boss, in the five tier slots.

Parse each {...} item table and read its fields independently -- the previous pass wanted
armorType/itemID/slot/encounterID/name adjacent, and an optional ["setLine"] sits between
them on armour, which is exactly the 115 entries that matter here.
"""
import io
import os
import re

SV = os.path.join("E:\\", "World of Warcraft", "_retail_", "WTF", "Account",
                  "JOEYWHATEVER", "SavedVariables", "MidnightHelper.lua")
text = io.open(SV, encoding="utf-8", errors="replace").read()


def block_from(s, i):
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "{":
            depth += 1
        elif s[j] == "}":
            depth -= 1
            if depth == 0:
                return s[i:j + 1]
    return None


m = re.search(r'\["ejCapture"\]\s*=\s*\{', text)
cap = block_from(text, m.end() - 1)

m = re.search(r'\["name"\]\s*=\s*"The Venomous Abyss",\s*\["id"\]\s*=\s*1320,\s*\["bosses"\]\s*=\s*\{', cap)
if not m:
    raise SystemExit("Venomous Abyss bosses block not found")
blk = block_from(cap, m.end() - 1)
print("Venomous Abyss bosses block: %d chars" % len(blk))

ARMOUR = {"Cloth", "Leather", "Mail", "Plate"}
TIER_SLOTS = ["Head", "Shoulder", "Chest", "Hands", "Legs"]

rows = []
for im in re.finditer(r'\{[^{}]*\["itemID"\][^{}]*\}', blk):
    frag = im.group(0)

    def f(name):
        mm = re.search(r'\["%s"\]\s*=\s*"((?:[^"\\]|\\.)*)"' % name, frag)
        if mm:
            return mm.group(1)
        mm = re.search(r'\["%s"\]\s*=\s*(\d+)' % name, frag)
        return mm.group(1) if mm else ""

    rows.append((f("armorType"), f("slot"), f("encounterID"), f("itemID"), f("name")))

print("items: %d" % len(rows))
tier = [r for r in rows if r[0] in ARMOUR and r[1] in TIER_SLOTS]
print("armour in the five tier slots: %d\n" % len(tier))

for enc in sorted({r[2] for r in tier}, key=int):
    print("encounter %s:" % enc)
    for a, s, e, i, n in tier:
        if e == enc:
            print("   %-8s %-9s %-7s %s" % (a, s, i, n))
    print()

print("--- shared phrases per armour type (a set name would repeat across slots) ---")
for armor in sorted(ARMOUR):
    names = [n for a, s, e, i, n in tier if a == armor]
    counts = {}
    for n in names:
        w = n.split()
        for size in (2, 3):
            for k in range(len(w) - size + 1):
                p = " ".join(w[k:k + size])
                counts[p] = counts.get(p, 0) + 1
    top = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:6]
    print("%-8s (%2d): %s" % (armor, len(names),
                              ", ".join("%s x%d" % (p, c) for p, c in top) or "-"))
