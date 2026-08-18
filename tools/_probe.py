"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

How much of the "missing translation" gap is deliberate? CLAUDE.md: CHANGELOG_*
keys stay English on purpose, so the in-game what's-new popup is one language.
The i18n audit counts them as gaps anyway, which flatters the problem.
"""

import io
import os
import re
from collections import defaultdict

LOC = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales"

KEY = re.compile(r'^\s*(?:\[\s*")?([A-Z][A-Z0-9_]+)"?\]?\s*=\s*"')
FILL = re.compile(r'fill\(\s*"(\w+)"\s*,')
MERGE = re.compile(r'merge\(\s*ns\._mhLocales(?:\s+and\s+ns\._mhLocales)?\.(\w+)\s*,')
FILE_RE = re.compile(r"^(deDE|frFR|esES|ptBR|itIT|nlNL)\.lua$")

data = defaultdict(set)
for fn in sorted(os.listdir(LOC)):
    if not fn.endswith(".lua"):
        continue
    m = FILE_RE.match(fn)
    ctx = m.group(1) if m else ("enUS" if fn == "enUS.lua" else None)
    with io.open(os.path.join(LOC, fn), "r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            f = FILL.search(line)
            if f:
                ctx = f.group(1)
            g = MERGE.search(line)
            if g:
                ctx = g.group(1)
            if "ns._mhLocales.enUS = {" in line:
                ctx = "enUS"
            if not ctx:
                continue
            k = KEY.match(line)
            if k:
                data[ctx].add(k.group(1))

en = data["enUS"]

# Keys that are English ON PURPOSE.
#   CHANGELOG_*  -- the in-game what's-new popup, English since 2.4.0 (CLAUDE.md)
#   LANG_LABEL_* -- language names in their own language, identical in every pack
BY_DESIGN = [k for k in en if k.startswith("CHANGELOG_") or k.startswith("LANG_LABEL_")]

print("=" * 72)
print("Hoeveel van het 'gat' is opzet?")
print("=" * 72)
print("enUS totaal                       : %d" % len(en))
print("waarvan bewust Engels             : %d  (CHANGELOG_* + LANG_LABEL_*)" % len(BY_DESIGN))
print("dus echt te vertalen              : %d" % (len(en) - len(BY_DESIGN)))
print()
print("%-6s %8s %8s %8s %9s" % ("pack", "heeft", "gat(ruw)", "gat(echt)", "echt %"))
print("-" * 72)
real_en = set(en) - set(BY_DESIGN)
for loc in ("deDE", "frFR", "esES", "ptBR", "itIT", "nlNL"):
    have = data[loc]
    raw_gap = len(en - have)
    real_gap = len(real_en - have)
    pct = 100.0 * (len(real_en) - real_gap) / max(1, len(real_en))
    print("%-6s %8d %8d %8d %8.1f%%" % (loc, len(have), raw_gap, real_gap, pct))
