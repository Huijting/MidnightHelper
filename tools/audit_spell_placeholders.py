#!/usr/bin/env python3
"""Repair misspelled {SPELL:@...} placeholders, and check EVERY one against the table.

The Portuguese block spells `{SPELL:@linding_burst}` (the leading b is gone) and
`{SPELL:@coalescing_maldiction}` twice. DelveTipMarkup falls through to a plain gsub on
unknown tokens, so a Brazilian player reads the grey words "linding burst" where everyone
else gets a spell link. Same class as the French devoring_nova found yesterday.

⚠️ A targeted fix would leave the next one to be found by accident, so this validates every
placeholder in the file against DelveSpellIds.lua rather than only the two that were reported.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
TIPS = os.path.join(REPO, "Locales", "DelveTips.lua")
IDS = os.path.join(REPO, "Modules", "DelveSpellIds.lua")

known = set(re.findall(r'^\s*([a-z0-9_]+)\s*=\s*\d+',
                       io.open(IDS, encoding="utf-8", errors="replace").read(), re.M))
print("known spell aliases: %d" % len(known))

text = io.open(TIPS, encoding="utf-8", newline="").read()
used = {}
for m in re.finditer(r'\{SPELL:@([a-z0-9_]+)\}', text):
    used[m.group(1)] = used.get(m.group(1), 0) + 1

bad = {k: v for k, v in used.items() if k not in known}
print("placeholders used: %d distinct, %d unknown\n" % (len(used), len(bad)))
for k, v in sorted(bad.items()):
    print("   UNKNOWN  %-32s %dx" % (k, v))

FIX = {"linding_burst": "blinding_burst", "coalescing_maldiction": "coalescing_malediction"}
for wrong, right in FIX.items():
    if right not in known:
        print("\nABORT: %r is not in DelveSpellIds either." % right)
        sys.exit(1)

n = 0
for wrong, right in FIX.items():
    c = text.count("{SPELL:@%s}" % wrong)
    if c:
        text = text.replace("{SPELL:@%s}" % wrong, "{SPELL:@%s}" % right)
        n += c
        print("\nfixed %s -> %s  (%dx)" % (wrong, right, c))

still = {k: v for k, v in bad.items() if k not in FIX}
if still:
    print("\n⚠️ STILL UNKNOWN after the fix, needs a human:")
    for k, v in sorted(still.items()):
        print("   %-32s %dx" % (k, v))

if n:
    io.open(TIPS + ".tmp", "w", encoding="utf-8", newline="").write(text)
    os.replace(TIPS + ".tmp", TIPS)
    print("\nwritten: %d replacements" % n)
else:
    print("\nnothing to fix")
