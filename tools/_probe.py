#!/usr/bin/env python3
"""Run the packs for a sample of retranslated keys, then re-run the drift report."""
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
KEYS = ["DELVE_TIP_SHADOW_ENCLAVE_BOSS", "DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE",
        "DELVE_TIP_TORMENTS_RISE_BOSS"]

r = subprocess.run([LUA, os.path.join(REPO, "tools", "locale_probe.lua")] + KEYS,
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print("LUA EXIT %d" % r.returncode)
    print(r.stderr.rstrip())
    sys.exit(1)

print()
p = subprocess.run([sys.executable, CHECK], capture_output=True, text=True,
                   encoding="utf-8", errors="replace", cwd=REPO)
print(p.stdout.rstrip())
