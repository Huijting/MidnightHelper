# -*- coding: utf-8 -*-
"""Wat gebeurde er TUSSEN de loot-momenten? (= alles wat geen loot is)"""
import io
import re
import sys

PATH = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
        r"\SavedVariables\MidnightHelper.lua")

sys.stdout.reconfigure(encoding="utf-8")

with io.open(PATH, "r", encoding="utf-8", errors="replace") as fh:
    lines = fh.read().split("\n")

start = next((i for i, l in enumerate(lines) if '["chunkLog"]' in l), None)
depth, end = 0, start
for i in range(start, len(lines)):
    depth += lines[i].count("{") - lines[i].count("}")
    if depth == 0 and i > start:
        end = i
        break

events, cur = [], None
for line in lines[start:end + 1]:
    if '["items"]' in line:
        cur = {"items": [], "gained": 0, "before": None, "after": None}
        events.append(cur)
        continue
    if cur is None:
        continue
    m = re.search(r'\["name"\] = "(.*?)"', line)
    if m:
        cur["items"].append(m.group(1))
    m = re.search(r'\["(gained|before|after)"\] = (-?\d+)', line)
    if m:
        cur[m.group(1)] = int(m.group(2))

# Echte winst per GROEP (rijen die dezelfde before+after delen tellen 1x).
groups, i = [], 0
while i < len(events):
    j = i
    while (j + 1 < len(events)
           and events[j + 1]["before"] == events[i]["before"]
           and events[j + 1]["after"] == events[i]["after"]):
        j += 1
    groups.append(events[i:j + 1])
    i = j + 1

real_loot = sum(g[0]["gained"] for g in groups)
span = events[-1]["after"] - events[0]["before"]

print("loot-momenten (rijen)      : %d" % len(events))
print("werkelijke loot-gebeurtenissen: %d" % len(groups))
print("")
print("winst DOOR loot (ontdubbeld): %d" % real_loot)
print("totale winst in de run      : %d" % span)
print("winst BUITEN loot om        : %d" % (span - real_loot))
print("")

print("--- sprongen tussen twee loot-momenten (dus geen loot) ---")
gaps = []
for k in range(1, len(events)):
    d = events[k]["before"] - events[k - 1]["after"]
    if d > 0:
        gaps.append(d)
        note = ""
        if d % 13 == 0:
            note = "  (= %d x 13)" % (d // 13)
        print("  na rij %2d: +%-7d%s" % (k, d, note))

print("")
print("aantal sprongen: %d" % len(gaps))
print("som            : %d" % sum(gaps))
small = [g for g in gaps if g < 1000]
big = [g for g in gaps if g >= 1000]
print("")
print("kleine sprongen (<1000): %d stuks, som %d" % (len(small), sum(small)))
if small:
    print("  waarden: %s" % ", ".join(str(g) for g in sorted(set(small))))
    print("  allemaal deelbaar door 13? %s" % all(g % 13 == 0 for g in small))
print("grote sprongen (>=1000): %s" % (", ".join(str(g) for g in big) or "geen"))
