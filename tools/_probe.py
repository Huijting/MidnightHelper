#!/usr/bin/env python3
"""Ask the loader what the Collegiate overview resolves to, per language."""
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")
r = subprocess.run([LUA, os.path.join(REPO, "tools", "locale_probe.lua"),
                    "DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW"],
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print(r.stderr.rstrip())
