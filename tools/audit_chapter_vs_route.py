#!/usr/bin/env python3
"""Does a profession's chapter text contradict its own advisor route?

Born on 30 Aug 2026, from the third fault of that day. `advisorRoutes[333]` said
Disenchanting Delegate first and Spellbound Shatterer last; PROFACAD_CH_ENCHANTING_BODY
said the exact reverse, and had said it for months. The routes were all rewritten on
20 Aug (Spec 28) and the chapter texts were not touched, so every profession is a
candidate for the same drift.

⚠️ CANDIDATES, NOT VERDICTS. Prose mentions a tree for reasons other than build order --
naming the four trees before recommending one, or a flavour line ("Majestic Lures
(Talented Tracker) summon a zone beast"). Three of the six it flagged on its first run
were exactly that. It prints the surrounding sentences so a human decides; if it ever
starts deciding for you, it has become the very thing it was written to catch.

Reads enUS only. A contradiction in English is a contradiction in all seven, because the
other packs are translations of it.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(REPO, "Modules", "ProfessionAcademyData.lua")
ENUS = os.path.join(REPO, "Locales", "enUS.lua")

data = io.open(DATA, encoding="utf-8", errors="replace").read()
enus = io.open(ENUS, encoding="utf-8", errors="replace").read()


def locale(key):
    m = re.search(r'^[ \t]*' + key + r'[ \t]*=[ \t]*"(.*)",?[ \t]*$', enus, re.M)
    return m.group(1) if m else None


chapters = {}
for block in re.finditer(r'\{\s*\n\s*key\s*=\s*"([a-z_]+)",(.*?)\n\t\t\},', data, re.S):
    name, body = block.group(1), block.group(2)
    sk = re.search(r'skillLineID\s*=\s*(\d+)', body)
    if not sk:
        continue
    keys = [m.group(1) for m in
            re.finditer(r'(?:bodyKey|advancedKey|familiesKey)\s*=\s*"([A-Z0-9_]+)"', body)]
    chapters[int(sk.group(1))] = (name, keys)

# Only top-level `tree =` steps. Goal branches are deliberately NOT flattened in: a route
# that splits by goal legitimately reads out of order in prose, and folding them in is
# what produced the Tailoring and Leatherworking false positives.
routes = {}
body = data[data.index("advisorRoutes = {"):]
for m in re.finditer(r'\n\t\t\[(\d+)\]\s*=\s*\{(.*?)\n\t\t\},', body, re.S):
    sid, steps = int(m.group(1)), m.group(2)
    steps = re.sub(r'goals\s*=\s*\{.*', '', steps, flags=re.S)
    names = [st.group(1) for st in re.finditer(r'\{\s*tree\s*=\s*"([^"]+)"', steps)]
    if names:
        routes[sid] = names

print("=" * 74)
print("Chapter text vs advisor route -- order disagreements")
print("=" * 74)
flagged = 0
for sid in sorted(routes):
    if sid not in chapters:
        continue
    name, keys = chapters[sid]
    text = " ".join(filter(None, (locale(k) for k in keys)))
    if not text:
        continue
    hits = []
    for tree in routes[sid]:
        pos = text.find(tree)
        if pos >= 0:
            hits.append((pos, tree))
    if len(hits) < 2:
        continue
    text_order = [t for _, t in sorted(hits)]
    route_order = [t for t in routes[sid] if t in text_order]
    if text_order == route_order:
        print("  OK   %-16s %s" % (name, " -> ".join(route_order)))
        continue
    flagged += 1
    print()
    print("  !!   %-16s (skillLine %d)" % (name, sid))
    print("       route says: %s" % " -> ".join(route_order))
    print("       text  says: %s" % " -> ".join(text_order))
    for pos, tree in sorted(hits):
        s = max(0, pos - 90)
        print("         ...%s..." % text[s:pos + len(tree) + 90].replace("\\n", " "))
print()
print("%d profession(s) where the chapter names the trees in a different order." % flagged)
print("Candidates, not verdicts -- read the sentences above before changing anything.")
