#!/usr/bin/env python3
"""Are the Season 2 tier TOKENS in Rob's own capture after all?

Research says the sets are token goods, not boss drops: five per-slot token families from
five of the eight Venomous Abyss bosses, plus an omni-token from Ula'tek. My earlier analysis
only looked at items whose slot was one of Head/Shoulder/Chest/Hands/Legs -- and a token has
no slot. There were 50 items with an empty slot in the capture and I discarded every one.

So: list the empty-slot items per class, and look for the token names and IDs the research
named. This either confirms the finding from Rob's own client or exposes a real gap.
"""
import io
import os
import re

SV = os.path.join("E:\\", "World of Warcraft", "_retail_", "WTF", "Account",
                  "JOEYWHATEVER", "SavedVariables", "MidnightHelper.lua")
text = io.open(SV, encoding="utf-8", errors="replace").read()


def block(name, src=None):
    s = src if src is not None else text
    m = re.search(r'\["%s"\]\s*=\s*\{' % re.escape(name), s)
    if not m:
        return None
    i = m.end() - 1
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "{":
            depth += 1
        elif s[j] == "}":
            depth -= 1
            if depth == 0:
                return s[i:j + 1]
    return None


scan = block("tierScan")
classes = block("classes", scan) if scan else None
if not classes:
    raise SystemExit("no tierScan/classes in SavedVariables")

CANDIDATE_WORDS = ("Venomwoven", "Venomcured", "Slumbering", "Curio", "Relic", "Idol",
                   "Effigy", "Remnant", "Icon")

print("=== items with NO slot, per class (the ones my first pass threw away) ===")
found_any = False
for m in re.finditer(r'\["([A-Z]+)"\]\s*=\s*\{', classes):
    cls = m.group(1)
    b = block(cls, classes)
    if not b:
        continue
    rows = []
    for im in re.finditer(r'\{[^{}]*\["itemID"\][^{}]*\}', b):
        frag = im.group(0)

        def f(k):
            mm = re.search(r'\["%s"\]\s*=\s*"((?:[^"\\]|\\.)*)"' % k, frag)
            if mm:
                return mm.group(1)
            mm = re.search(r'\["%s"\]\s*=\s*(\d+)' % k, frag)
            return mm.group(1) if mm else ""

        if f("slot") == "" and f("armorType") == "":
            rows.append((f("itemID"), f("encounterID"), f("name")))
    # unique by itemID, keep order
    seen, uniq = set(), []
    for r in rows:
        if r[0] not in seen:
            seen.add(r[0])
            uniq.append(r)
    print("\n%s — %d slotless items:" % (cls, len(uniq)))
    for iid, enc, name in uniq:
        mark = "  <<<" if any(w.lower() in name.lower() for w in CANDIDATE_WORDS) else ""
        if mark:
            found_any = True
        print("   %-8s enc=%-6s %s%s" % (iid, enc, name, mark))

print("\n=== the specific item IDs the research named ===")
for iid in ("270909", "270910", "270911", "270912", "270913", "270916", "270917",
            "270920", "270921", "270924", "270925", "270928", "270929"):
    hits = re.findall(r'\["itemID"\]\s*=\s*%s,\s*\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)"' % iid, text)
    if not hits:
        hits = re.findall(r'\["name"\]\s*=\s*"((?:[^"\\]|\\.)*)",[^{}]*\["itemID"\]\s*=\s*%s' % iid, text)
    print("   %s -> %s" % (iid, hits[0] if hits else "not in this file"))

if not found_any:
    print("\nNo token-looking names found. That is a real discrepancy, not a filtering "
          "mistake, and it belongs in the notes as such.")
