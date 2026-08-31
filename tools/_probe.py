#!/usr/bin/env python3
"""Which /mh commands are ROUTED but not LISTED?

Linter check [10] asks the other direction -- everything listed must be routed -- and passes
clean while `/mh discord` is invisible to our own search box. NavSearch builds its index
solely from ns.MH_COMMANDS (NavSearch.lua), so a routed-but-unlisted command cannot be found
by typing its own name.

Routed = a `msg == "x"` or `msg:match("^x%s")` test in Core.lua's slash handler.
Listed  = a cmd entry in Modules/CommandList.lua.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
core = io.open(os.path.join(REPO, "Core.lua"), encoding="utf-8", errors="replace").read()
clist = io.open(os.path.join(REPO, "Modules", "CommandList.lua"), encoding="utf-8", errors="replace").read()

routed = set()
for m in re.finditer(r'msg\s*==\s*"([a-z0-9_]+)"', core):
    routed.add(m.group(1))
for m in re.finditer(r'msg:match\(\s*"\^([a-z0-9_]+)', core):
    routed.add(m.group(1))

listed = set()
for m in re.finditer(r'cmd\s*=\s*"/mh\s+([a-z0-9_]+)', clist):
    listed.add(m.group(1))
for m in re.finditer(r'cmd\s*=\s*"([a-z0-9_]+)"', clist):
    listed.add(m.group(1))

print("routed: %d   listed: %d\n" % (len(routed), len(listed)))
missing = sorted(routed - listed)
print("ROUTED BUT NOT LISTED (%d) — invisible to NavSearch:" % len(missing))
for c in missing:
    print("   /mh %s" % c)

extra = sorted(listed - routed)
print("\nLISTED BUT NOT ROUTED (%d) — what check [10] already covers:" % len(extra))
for c in extra:
    print("   /mh %s" % c)

# The keyword blocks NavSearch carries for commands it can never reach.
print("\nNavSearch keyword blocks:")
nav = io.open(os.path.join(REPO, "Modules", "NavSearch.lua"), encoding="utf-8", errors="replace").read()
for m in re.finditer(r'^\s*(\w+)\s*=\s*"([^"]{0,90})"', nav, re.M):
    if any(w in m.group(2).lower() for w in ("discord", "community", "translate")):
        print("   %s = %s" % (m.group(1), m.group(2)[:80]))
