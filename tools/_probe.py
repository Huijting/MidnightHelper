#!/usr/bin/env python3
"""Did every profession get ranks, or only the ones Rob happened to visit?

⚠️ A rank of 0 everywhere looks exactly like a capture that did not work, so this reports
per profession whether ranks are PRESENT and whether any are NON-ZERO -- the positive control.
"""
import io
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

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
