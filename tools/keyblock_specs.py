"""Standard key block per spec for the website: runs tools/keyblock_specs.lua with lua.

Front door only: probe_job.txt = `run keyblock_specs`. Writes data/keyblock_specs.json.
"""
import os
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LUA = shutil.which("lua") or shutil.which("lua5.1") or os.path.join(
    os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")

if not os.path.isfile(LUA) and not shutil.which(LUA):
    sys.exit("no lua interpreter found (looked for lua, lua5.1 and %s)" % LUA)

res = subprocess.run([LUA, os.path.join(ROOT, "tools", "keyblock_specs.lua"), ROOT.replace("\\", "/")])
sys.exit(res.returncode)
