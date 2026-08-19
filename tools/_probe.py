"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Our Coiled Isle rare coordinates carry a warning we wrote ourselves: "PTR coordinates
can still move before the 11th. Verify on live before trusting." HandyNotes_Midnight
154 is live-sourced and CLAUDE.md trusts its coordinates. So pair them up and show
the distance -- which is the check our own comment asked for and nobody has run.

⚠️ THIRD FORMAT. Two earlier passes reported nonsense because they assumed one way of
writing a coordinate. Ours are positional: { questID, mapID, x, y, "Name", npcID, ... }
Theirs are a packed integer. Neither looks like `x = 1.23`.

Matching is by NEAREST NEIGHBOUR, not by name -- their file names nodes in trailing
comments we cannot parse reliably. A pairing is only shown when it is close enough to
be the same rare; anything far away is listed as unmatched instead of forced.
"""

import io
import math
import os
import re

HN = (r"E:\World of Warcraft\_retail_\Interface\AddOns\HandyNotes_Midnight"
      r"\zones\coiled_isles.lua")
OURS = (r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
        r"\Modules\Rares.lua")

NODE = re.compile(r"\w+\.nodes\[(\d{8})\]\s*=\s*(Rare|RareElite)\(")
MINE = re.compile(r"\{\s*(\d+),\s*2512,\s*(\d{1,2}\.\d+),\s*(\d{1,2}\.\d+),\s*\"([^\"]+)\"")


def unpack(n):
    s = str(n)
    return float(s[:4]) / 100.0, float(s[4:]) / 100.0


theirs = []
with io.open(HN, "r", encoding="utf-8", errors="replace") as fh:
    for lineno, line in enumerate(fh, 1):
        m = NODE.search(line)
        if m:
            x, y = unpack(m.group(1))
            theirs.append((x, y, m.group(2), lineno))

mine = []
with io.open(OURS, "r", encoding="utf-8", errors="replace") as fh:
    for lineno, line in enumerate(fh, 1):
        m = MINE.search(line)
        if m:
            mine.append((float(m.group(2)), float(m.group(3)), m.group(4), lineno))

print("=" * 78)
print("Coiled Isle rares: onze %d tegen HandyNotes 154's %d" % (len(mine), len(theirs)))
print("=" * 78)
print("%-30s %-14s %-14s %s" % ("rare (onze naam)", "onze coord", "HandyNotes", "afstand"))
print("-" * 78)

used = set()
far = []
for x, y, name, lineno in sorted(mine, key=lambda r: r[2]):
    best, bestd = None, 1e9
    for i, (tx, ty, kind, tl) in enumerate(theirs):
        d = math.hypot(tx - x, ty - y)
        if d < bestd:
            best, bestd = i, d
    if best is None or bestd > 2.0:
        far.append((name, x, y, bestd))
        continue
    used.add(best)
    tx, ty, kind, tl = theirs[best]
    flag = "" if bestd < 0.30 else ("  <-- >0.3" if bestd < 1.0 else "  <-- GROOT")
    print("%-30s %5.2f/%-6.2f  %5.2f/%-6.2f  %5.2f%s" % (name[:30], x, y, tx, ty, bestd, flag))

if far:
    print()
    print("Bij ons, geen buur binnen 2.0 bij HandyNotes:")
    for name, x, y, d in far:
        print("   %-30s %5.2f/%-6.2f   (dichtstbij %.1f)" % (name[:30], x, y, d))

left = [t for i, t in enumerate(theirs) if i not in used]
if left:
    print()
    print("Bij HandyNotes, door ons niet geclaimd: %d" % len(left))
    for tx, ty, kind, tl in left:
        print("   %-12s %5.2f/%-6.2f  (regel %d)" % (kind, tx, ty, tl))
