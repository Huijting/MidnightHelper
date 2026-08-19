"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Does a sixth Midnight renown faction exist? MountProgress.lua lists five; a mount
guide describes two mounts from a faction it calls "Zul'jara's Forces". Rob's client
just dumped every Renown faction it knows into ns.db.atalProbe.factions.

The count is the measurement, not the name -- that transcript writes Tokka's Landing
as "Tucker's Landing".
"""

import io
import re

SV = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
      r"\SavedVariables\MidnightHelper.lua")

OURS = {
    2696: "Amani",
    2704: "Hara'ti",
    2710: "Silvermoon",
    2699: "Singularity",
    2792: "Ritual",
}

text = io.open(SV, "r", encoding="utf-8", errors="replace").read()

start = text.find('["factions"] = {')
if start < 0:
    raise SystemExit("no factions block in the SavedVariables")

# Read forward until the block closes; entries are {id=, name=, renown=}.
chunk = text[start:start + 20000]
ENTRY = re.compile(
    r'\["id"\]\s*=\s*(\d+),\s*\n\["name"\]\s*=\s*"([^"]*)",\s*\n\["renown"\]\s*=\s*(\d+)')

rows = [(int(i), n, int(r)) for i, n, r in ENTRY.findall(chunk)]

print("=" * 70)
print("Renown-facties die de client kent: %d" % len(rows))
print("=" * 70)

# Midnight ids sit in the 26xx-27xx band; print everything above the TWW block so
# nothing is filtered away on a guess about where the band starts.
print("%-7s %-34s %s" % ("id", "naam", "renown"))
print("-" * 70)
for fid, name, renown in rows:
    if fid < 2650:
        continue
    mark = ""
    if fid in OURS:
        mark = "  <-- wij: " + OURS[fid]
    print("%-7d %-34s %-6d%s" % (fid, name, renown, mark))

print()
have = {fid for fid, _, _ in rows}
missing = [f for f in OURS if f not in have]
extra = [(fid, name) for fid, name, _ in rows if fid >= 2650 and fid not in OURS]

print("Onze vijf, gevonden op de client : %d van 5" % (5 - len(missing)))
if missing:
    print("   NIET gevonden:", ", ".join("%d (%s)" % (f, OURS[f]) for f in missing))
print("Facties >=2650 die wij NIET listen: %d" % len(extra))
for fid, name in extra:
    print("   %-7d %s" % (fid, name))
