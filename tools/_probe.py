#!/usr/bin/env python3
"""Run the packs for the new advice key: does every language resolve it?"""
import os
import subprocess
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")
r = subprocess.run([LUA, os.path.join(REPO, "tools", "locale_probe.lua"),
                    "PROFACAD_ADVISE_PICK_ONE_FMT"],
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print("EXIT %d" % r.returncode)
    print(r.stderr.rstrip())
