# -*- coding: utf-8 -*-
"""JustAC 5.3.7 landed today (was 5.3.4). Did anything we rely on move?

We check interrupt and dispel spell ids against this addon (memory: alsoStop tags for
Paladin were JustAC-verified). It is a CANDIDATE source, never proof -- but a changed id
there is a reason to go and ask the client.

Compares JustAC's interrupt ids against the ones our own KeybindRoles files carry, and
prints both counts first: if either side is ~0 the comparison proves nothing.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

ADDONS = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
JA = os.path.join(ADDONS, "JustAC", "Data", "InterruptAbilities.lua")
MH = os.path.join(ADDONS, "MidnightHelper", "Modules")

try:
    ja_text = io.open(JA, encoding="utf-8", errors="replace").read()
except IOError:
    raise SystemExit("JustAC InterruptAbilities.lua not found -- path changed?")

print("--- JustAC/Data/InterruptAbilities.lua: first 30 lines ---")
for line in ja_text.splitlines()[:30]:
    print("   " + line)

ja_ids = set(int(m) for m in re.findall(r"\b(\d{3,7})\b", ja_text))
print("\nnumbers in JustAC's interrupt file: %d" % len(ja_ids))

ours = set()
for name in sorted(os.listdir(MH)):
    if name.startswith("KeybindRoles_") and name.endswith(".lua"):
        t = io.open(os.path.join(MH, name), encoding="utf-8", errors="replace").read()
        ours |= set(int(m) for m in re.findall(r"\b(\d{4,7})\b", t))
print("numbers across our KeybindRoles files: %d" % len(ours))

if not ja_ids or not ours:
    raise SystemExit("\nOne side is empty -- this comparison proves nothing.")

print("\nJustAC interrupt ids we do NOT carry anywhere in KeybindRoles: %d"
      % len(ja_ids - ours))
for sid in sorted(ja_ids - ours)[:30]:
    ctx = re.search(r"^.*\b%d\b.*$" % sid, ja_text, re.M)
    print("   %-9d %s" % (sid, (ctx.group(0).strip()[:100] if ctx else "")))
