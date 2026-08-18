"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Fix the doubled backslash in four locale packs: `\\n` where `\n` belongs. Lua reads
the first as a literal backslash plus the letter n, so players of those four
languages read "\n\n" as text where a paragraph break should be. enUS, nlNL and
itIT are already correct, which is what makes this a slip from one generation run
rather than a convention.

⚠️ Only touches the VALUE of a single-line locale entry. A blanket search-and-
replace over the file could hit a backslash that belongs somewhere else, and these
files are the live addon -- see the atomic-write note in CLAUDE.md, which exists
because Rob once logged in halfway through a rewrite of enUS.lua.
"""

import io
import os
import re

LOC = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"
FILES = ["deDE.lua", "esES.lua", "frFR.lua", "ptBR.lua"]

ENTRY = re.compile(r'^(\s*(?:\[\s*")?[A-Z][A-Z0-9_]+"?\]?\s*=\s*")((?:[^"\\]|\\.)*)(".*)$')

total = 0
for fn in FILES:
    path = os.path.join(LOC, fn)
    with io.open(path, "r", encoding="utf-8", newline="") as fh:
        lines = fh.readlines()

    changed = 0
    out = []
    for line in lines:
        m = ENTRY.match(line.rstrip("\r\n"))
        if not m:
            out.append(line)
            continue
        head, val, tail = m.group(1), m.group(2), m.group(3)
        fixed = val.replace("\\\\n", "\\n")
        if fixed != val:
            changed += val.count("\\\\n")
            ending = line[len(line.rstrip("\r\n")):]
            out.append(head + fixed + tail + ending)
        else:
            out.append(line)

    if changed:
        tmp = path + ".tmp"
        with io.open(tmp, "w", encoding="utf-8", newline="") as fh:
            fh.writelines(out)
        os.replace(tmp, path)   # atomic: the game sees old or new, never half
    print("%-12s %3d hersteld" % (fn, changed))
    total += changed

print("-" * 30)
print("totaal      %3d" % total)
