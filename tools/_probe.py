#!/usr/bin/env python3
"""Read ns.db.tierScan and work out the Season 2 set name per class.

Runs after `/mh tierscan` + `/reload`. Three things, in this order, because the first two
decide whether the third means anything:

  1. Did the filter actually bite? Thirteen identical item counts means the journal ignored
     it and everything below is noise. Say that first and stop.
  2. Per class, which items sit in the five set slots.
  3. The phrase those five share -- that is the set name. Reported ONLY when it really is
     shared by several slots; a phrase appearing once is an item name, not a set.
"""
import io
import os
import re

SV = os.path.join("E:\\", "World of Warcraft", "_retail_", "WTF", "Account",
                  "JOEYWHATEVER", "SavedVariables", "MidnightHelper.lua")
text = io.open(SV, encoding="utf-8", errors="replace").read()


def block(name, src=None):
    s = src if src is not None else text
    m = re.search(r'\["%s"\]\s*=\s*\{' % re.escape(name), s)
    if not m:
        return None
    i = m.end() - 1
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "{":
            depth += 1
        elif s[j] == "}":
            depth -= 1
            if depth == 0:
                return s[i:j + 1]
    return None


scan = block("tierScan")
if scan is None:
    raise SystemExit("No tierScan in SavedVariables. Did /mh tierscan run, and was there a "
                     "/reload after it? Without the reload the table is still only in memory.")

print("tierScan: %d chars" % len(scan))
for f in ("instanceID", "encounterCount", "classCount", "build"):
    m = re.search(r'\["%s"\]\s*=\s*"?([^",\n]+)"?' % f, scan)
    print("   %-15s %s" % (f, m.group(1).strip() if m else "?"))

classes = block("classes", scan)
if classes is None:
    raise SystemExit("tierScan has no classes table")

TIER_SLOTS = ("Head", "Shoulder", "Chest", "Hands", "Legs")

rows = {}
for m in re.finditer(r'\["([A-Z]+)"\]\s*=\s*\{', classes):
    name = m.group(1)
    b = block(name, classes)
    if b is None:
        continue
    items = []
    for im in re.finditer(r'\{[^{}]*\["itemID"\][^{}]*\}', b):
        frag = im.group(0)

        def f(k):
            mm = re.search(r'\["%s"\]\s*=\s*"((?:[^"\\]|\\.)*)"' % k, frag)
            if mm:
                return mm.group(1)
            mm = re.search(r'\["%s"\]\s*=\s*(\d+)' % k, frag)
            return mm.group(1) if mm else ""

        items.append((f("slot"), f("armorType"), f("itemID"), f("name")))
    fa = re.search(r'\["filterAfterSet"\]\s*=\s*(\S+?),', b)
    rows[name] = (items, fa.group(1) if fa else "?")

print("\n--- did the filter bite? ---")
counts = {k: len(v[0]) for k, v in rows.items()}
for k in sorted(rows):
    print("   %-14s filterAfterSet=%-5s items=%d" % (k, rows[k][1], counts[k]))
if len(set(counts.values())) <= 1 and len(counts) > 1:
    raise SystemExit("\nAll classes returned the SAME item count. The journal ignored the "
                     "filter, so nothing below would mean anything. Stopping here rather "
                     "than reporting a set name we cannot support.")

print("\n--- set-slot items per class, and the phrase they share ---")
for k in sorted(rows):
    items = [r for r in rows[k][0] if r[0] in TIER_SLOTS]
    if not items:
        print("\n%s: nothing in the five set slots" % k)
        continue
    print("\n%s (%d in set slots):" % (k, len(items)))
    for slot, armor, iid, name in items:
        print("   %-9s %-8s %-7s %s" % (slot, armor, iid, name))
    counts2 = {}
    for _, _, _, name in items:
        w = name.split()
        for size in (2, 3, 4):
            for a in range(len(w) - size + 1):
                p = " ".join(w[a:a + size])
                counts2[p] = counts2.get(p, 0) + 1
    shared = [(p, c) for p, c in counts2.items() if c >= 3]
    shared.sort(key=lambda kv: (-kv[1], -len(kv[0])))
    if shared:
        print("   -> shared by %d pieces: %s" % (shared[0][1], shared[0][0]))
    else:
        print("   -> no phrase shared by 3+ pieces; these are probably not a set")
