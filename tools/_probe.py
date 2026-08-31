#!/usr/bin/env python3
"""The scratch probe -- AND the front door for every other tool in this folder.

    python ".../tools/_probe.py"                     runs the scratch probe below
    python ".../tools/_probe.py" run <tool> [args]   runs tools/<tool>.py with those args

🔴 The second form exists because of a cost Rob pays and I do not. The allowlist covers exactly
five script paths; every NEW script is a new command string, so it prompts him, every single
run. On 31 Aug 2026 I added four tools in one day and cost him about ten prompts before he
asked why they kept coming. CLAUDE.md has said for weeks that the variable part belongs INSIDE
the script rather than in the command line -- this is that rule applied to the tools folder
itself, instead of only to one-off probes.

⚠️ So: a permanent tool still gets its own well-named file. It just gets INVOKED through here,
because `_probe.py *` is already allowlisted and therefore never prompts. Adding a new
permission rule cannot fix this, since settings.json is only read at startup.
"""
import io
import os
import re
import runpy
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

if len(sys.argv) > 2 and sys.argv[1] == "run":
    name = sys.argv[2]
    if not name.endswith(".py"):
        name += ".py"
    target = os.path.join(os.path.dirname(os.path.abspath(__file__)), name)
    if not os.path.isfile(target):
        sys.exit("no such tool: %s" % target)
    # argv[0] becomes the tool's own path, so scripts that resolve paths from __file__
    # or read sys.argv keep working exactly as they do when run directly.
    sys.argv = [target] + sys.argv[3:]
    runpy.run_path(target, run_name="__main__")
    raise SystemExit(0)

SV = r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua"
PROF = {164: "Blacksmithing", 165: "Leatherworking", 171: "Alchemy", 182: "Herbalism",
        186: "Mining", 197: "Tailoring", 202: "Engineering", 333: "Enchanting",
        393: "Skinning", 755: "Jewelcrafting", 773: "Inscription"}

text = io.open(SV, encoding="utf-8", errors="replace").read()


def block(s, at):
    start = s.find("{", at)
    depth, j, ins = 0, start, False
    while j < len(s):
        c = s[j]
        if ins:
            if c == "\\":
                j += 2
                continue
            if c == '"':
                ins = False
        elif c == '"':
            ins = True
        elif c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return s[start:j + 1]
        j += 1
    return ""


dump = block(text, text.find('["profIdDump"]'))
print("%-16s %-8s %-8s %-6s %s" % ("profession", "entries", "ranks", "top", "captured on"))
print("-" * 66)
missing = []
for sid in sorted(PROF):
    m = re.search(r'\["%d"\]\s*=\s*\{' % sid, dump)
    if not m:
        missing.append(PROF[sid])
        continue
    b = block(dump, m.end() - 1)
    ids = len(re.findall(r'\["id"\]\s*=\s*\d+', b))
    ranks = [int(x) for x in re.findall(r'\["rank"\]\s*=\s*(\d+)', b)]
    top = max(ranks) if ranks else None
    who = re.search(r'\["char"\]\s*=\s*"([^"]*)"', b)
    # ⚠️ No owner means the row predates the fix, NOT that it came from nobody.
    owner = who.group(1) if who else "|before the fix|"
    print("%-16s %-8d %-8s %-6s %s" % (PROF[sid], ids, len(ranks) or "-",
                                       top if top is not None else "-", owner))
print("\nnot captured at all: %s" % (", ".join(missing) or "none"))
