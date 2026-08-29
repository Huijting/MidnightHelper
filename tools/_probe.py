#!/usr/bin/env python3
"""Ask the loader what the crest ranks resolve to per language, after the nlNL change.

Counting lines is not verification here; locale_probe.lua loads Locales/ in .toc order once
per language and prints what ns:L actually returns.
"""
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROBE = os.path.join(REPO, "tools", "locale_probe.lua")
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")

keys = ["DAWNCREST_TIER_ADVENTURER", "DAWNCREST_TIER_VETERAN",
        "DAWNCREST_TIER_CHAMPION", "DAWNCREST_TIER_HERO", "DAWNCREST_TIER_MYTH"]
r = subprocess.run([LUA, PROBE] + keys, capture_output=True, text=True,
                   encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print("--- stderr ---")
    print(r.stderr.rstrip())
