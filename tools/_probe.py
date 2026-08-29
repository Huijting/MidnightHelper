#!/usr/bin/env python3
"""Settle the two-counts question: which enUS keys does the loader have that no file spells out?

lint_addon.py [5] reports ~3476 enUS keys where locale_probe --dump reports ~3501. The note in
NEXT_SESSION says "two numbers for the same thing, never looked into". Rather than guess which
one is wrong, list the difference and look at it: a key the loader knows but that appears
nowhere as a literal `KEY =` is built at runtime, and that is a real and interesting answer.
"""
import io
import os
import re
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOC = os.path.join(REPO, "Locales")
LUA = os.path.join(os.path.expanduser("~"), "AppData", "Local", "Programs", "Lua", "bin", "lua.exe")

p = subprocess.run([LUA, "tools/locale_probe.lua", "--dump"], cwd=REPO,
                   capture_output=True, text=True, encoding="utf-8", errors="replace")
if p.returncode != 0:
    raise SystemExit("dump failed:\n" + (p.stderr or ""))

loader = set()
for line in p.stdout.splitlines():
    parts = line.split("\t")
    if len(parts) == 3 and parts[0] == "enUS":
        loader.add(parts[1])
print("loader enUS keys: %d" % len(loader))

# Every key that any locale file spells out literally, in any context.
literal = set()
for fn in sorted(os.listdir(LOC)):
    if not fn.endswith(".lua"):
        continue
    text = io.open(os.path.join(LOC, fn), encoding="utf-8", errors="replace").read()
    for m in re.finditer(r'\[?"?([A-Z][A-Z0-9_]{2,})"?\]?\s*=\s*["\[]', text):
        literal.add(m.group(1))
print("keys written out literally somewhere in Locales/: %d" % len(literal))

only_loader = sorted(loader - literal)
print("\nIn the loader but never written literally: %d" % len(only_loader))
for k in only_loader[:60]:
    print("   " + k)

only_files = sorted(literal - loader)
print("\nWritten literally but NOT in the loader's enUS: %d" % len(only_files))
for k in only_files[:60]:
    print("   " + k)
