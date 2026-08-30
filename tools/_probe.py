#!/usr/bin/env python3
"""Run the packs for the corrected chapter, then mark it so the drift list stays honest."""
import os
import subprocess
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")
CHECK = os.path.join(REPO, "tools", "check_drift.py")
KEY = "PROFACAD_CH_ENCHANTING_ADVANCED"

r = subprocess.run([LUA, os.path.join(REPO, "tools", "locale_probe.lua"), KEY],
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print("LUA EXIT %d" % r.returncode)
    print(r.stderr.rstrip())
    sys.exit(1)

print()
for argv in ([CHECK, "--mark", KEY], [CHECK, "--write-report"]):
    p = subprocess.run([sys.executable] + argv, capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=REPO)
    print(p.stdout.rstrip())
    if p.returncode != 0:
        print(p.stderr.rstrip())
    print()
