"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Report-only. The repair already ran; this answers the question the crashed run
could not print: are there backslash runs in these packs that are neither a lone
escape nor something already handled? Anything unexpected gets named rather than
touched -- assuming what was there is exactly what broke the first attempt.

No emoji in the output: the Windows console is cp1252 and the previous run died on
one, which swallowed the very report it existed to produce.
"""

import io
import os
import re

LOC = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"

ENTRY = re.compile(r'^\s*(?:\[\s*")?([A-Z][A-Z0-9_]+)"?\]?\s*=\s*"((?:[^"\\]|\\.)*)"')
RUNS = re.compile(r"(\\+)(.)")

print("=" * 70)
print("Backslash-runs per pack (aantal x volgend teken)")
print("=" * 70)

for fn in sorted(os.listdir(LOC)):
    if not fn.endswith(".lua"):
        continue
    tally = {}
    with io.open(os.path.join(LOC, fn), "r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            m = ENTRY.match(line)
            if not m:
                continue
            for run, nxt in RUNS.findall(m.group(2)):
                tally[(len(run), nxt)] = tally.get((len(run), nxt), 0) + 1
    if not tally:
        continue
    odd = {k: v for k, v in tally.items() if k[0] != 1}
    line = "  ".join("%dx%r:%d" % (n, c, v) for (n, c), v in sorted(tally.items()))
    print("%-22s %s" % (fn, line))
    if odd:
        print("%-22s LET OP: %s" % ("", odd))
