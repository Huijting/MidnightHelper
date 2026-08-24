# -*- coding: utf-8 -*-
"""GTFO 6.9 shipped this morning. Does its Midnight hazard list know spells we do not?

GTFO is a CANDIDATE source, never proof (CLAUDE.md): it guards entries behind `if`, it goes
stale, and its numbers still have to be confirmed in the client before we act on them. What
this answers is only "is there anything new to look AT", which is the right question for a
morning update check.

Positive control: it also prints how many ids each side has. If either is ~0 the comparison
proved nothing and the paths are wrong -- the failure mode that made the last two probes
report a reassuring blank.
"""
import io
import os
import re

ADDONS = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GTFO_MN = os.path.join(ADDONS, "GTFO", "Spells", "GTFO_Spells_MN.lua")
OURS = os.path.join(ADDONS, "MidnightHelper", "Modules", "HazardData.lua")


def read(p):
    try:
        return io.open(p, encoding="utf-8", errors="replace").read()
    except IOError:
        return ""


gtfo_text = read(GTFO_MN)
# ⚠️ GTFO writes GTFO.SpellID["1225385"] = { ... } -- a STRING key on a named table, not the
# [123456] = form I assumed. The guess produced 0 matches, which without the count below
# would have read as "GTFO has nothing new". Third time in two days that a probe's own path
# or pattern was the finding.
gtfo_ids = set(int(m) for m in re.findall(r'GTFO\.SpellID\[\s*"?(\d{4,7})"?\s*\]', gtfo_text))

ours_text = read(OURS)
ours_ids = set(int(m) for m in re.findall(r"\b(\d{4,7})\b", ours_text))

print("GTFO_Spells_MN.lua : %d spell ids" % len(gtfo_ids))
print("HazardData.lua     : %d numbers (superset -- any digit run, deliberately loose)"
      % len(ours_ids))
if not gtfo_ids or not ours_ids:
    raise SystemExit("\nOne side is empty, so this comparison proves nothing. Check paths.")

missing = sorted(gtfo_ids - ours_ids)
print("\nIn GTFO's Midnight list, not mentioned anywhere in HazardData: %d" % len(missing))
for sid in missing[:40]:
    # Pull the line so the id arrives with whatever GTFO says about it.
    # GTFO comments the human name out on the line after the key -- that is the useful bit.
    m = re.search(r'GTFO\.SpellID\[\s*"?%d"?\s*\]\s*=\s*\{\s*\n?\s*--desc\s*=\s*"([^"]*)"' % sid,
                  gtfo_text)
    print("   %-9d %s" % (sid, (m.group(1) if m else "(no desc)")))
if len(missing) > 40:
    print("   ... and %d more" % (len(missing) - 40))
