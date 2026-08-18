"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Today: GTFO 6.8 landed. We harvested 6.7.2 into Modules/HazardData.lua. What is in
their files now that is NOT in ours, for the instances we care about? And which
entries carry a `desc` comment naming a boss -- that is the part 6.7.2 did not give
us for the two 12.1 delves.

Reports CANDIDATES only. GTFO is another addon, so nothing here is proof; the ids
still have to be put to the client. (CLAUDE.md: "andere addons zijn een plek om
kandidaten te vinden, nooit bewijs".)
"""

import io
import os
import re

GTFO = r"E:\World of Warcraft\_retail_\Interface\AddOns\GTFO\Spells"
HAZ = (r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
       r"\Modules\HazardData.lua")

# GTFO.SpellID["1287680"] = { ... instance = 3038; ... };
BLOCK = re.compile(r'GTFO\.SpellID\["(\d+)"\]\s*=\s*\{(.*?)\n\}', re.S)
INSTANCE = re.compile(r"instance\s*=\s*(\d+)")
DESC = re.compile(r"--\s*desc\s*=\s*\"([^\"]+)\"")
ENCOUNTER = re.compile(r"encounter\s*=\s*(\d+)")

# What ours knows: [3077] = { 1301863, ... }
OURS_BLOCK = re.compile(r"\[(\d+)\]\s*=\s*\{(.*?)\}", re.S)

theirs = {}   # instance -> {spellid: (desc, encounter)}
for fn in sorted(os.listdir(GTFO)):
    if not fn.endswith(".lua"):
        continue
    with io.open(os.path.join(GTFO, fn), "r", encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    for sid, body in BLOCK.findall(text):
        d = DESC.search(body)
        e = ENCOUNTER.search(body)
        for inst in INSTANCE.findall(body):
            theirs.setdefault(int(inst), {})[int(sid)] = (
                d.group(1) if d else "", int(e.group(1)) if e else 0)

with io.open(HAZ, "r", encoding="utf-8", errors="replace") as fh:
    ours_text = fh.read()
ours = {}
for inst, body in OURS_BLOCK.findall(ours_text):
    ids = set(int(x) for x in re.findall(r"\b(\d{4,})\b", body))
    ours[int(inst)] = ids

print("=" * 78)
print("GTFO 6.8 vs onze HazardData (geoogst uit 6.7.2)")
print("=" * 78)
print("wij kennen %d instances, GTFO noemt er %d" % (len(ours), len(theirs)))
print()

new_total = 0
for inst in sorted(set(ours) | set(theirs)):
    mine = ours.get(inst, set())
    their = theirs.get(inst, {})
    extra = set(their) - mine
    gone = mine - set(their)
    if not extra and not gone:
        continue
    print("-" * 78)
    print("instance %s   (wij %d ids, GTFO %d)" % (inst, len(mine), len(their)))
    for sid in sorted(extra):
        desc, enc = their[sid]
        new_total += 1
        print("   NIEUW  %-9d %s%s" % (
            sid, desc or "(geen desc)", ("   encounter %d" % enc) if enc else ""))
    for sid in sorted(gone):
        print("   alleen bij ons: %d" % sid)

print()
print("=" * 78)
print("Nieuwe kandidaten in totaal: %d" % new_total)
print("=" * 78)
print()
print("Bosnamen die GTFO noemt voor de instances die wij tonen:")
for inst in sorted(ours):
    for sid, (desc, enc) in sorted(theirs.get(inst, {}).items()):
        if enc:
            print("   instance %-6s encounter %-6s %s" % (inst, enc, desc or "(geen desc)"))
