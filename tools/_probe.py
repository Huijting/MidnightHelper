#!/usr/bin/env python3
"""Run the packs for the two keys, then mark them and re-run the drift report.

Running is the check: a broken quote or a stray brace shows up here as a Lua error, and
the linter cannot see that because it never executes the file.
"""
import os
import subprocess
import sys

# Force UTF-8 on stdout, like tools/lint_addon.py does: the console is cp1252 and the
# replacement character in the probe's own output would otherwise crash the print, not
# the check. Fixing it in the script keeps the command line identical.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")
CHECK = os.path.join(REPO, "tools", "check_drift.py")
KEYS = ["TIER_GUIDE_BODY", "DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE"]

r = subprocess.run([LUA, os.path.join(REPO, "tools", "locale_probe.lua")] + KEYS,
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print("LUA EXIT %d" % r.returncode)
    print(r.stderr.rstrip())
    sys.exit(1)

print()
for argv in ([CHECK, "--mark"] + KEYS, [CHECK, "--write-report"]):
    p = subprocess.run([sys.executable] + argv, capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=REPO)
    print(p.stdout.rstrip())
    if p.returncode != 0:
        print(p.stderr.rstrip())
    print()
