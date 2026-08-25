# -*- coding: utf-8 -*-
"""Gatenlijst: welke story-varianten heeft de client ons gegeven, en welke
daarvan kent onze eigen tabel?

Links: ns.db.delveCoach.storyDaily uit SavedVariables (wat de client zei).
Rechts: storyKeys in Modules/DelveBossShowcase.lua (wat wij hardcoded weten).
"""
import io
import re
import sys

SV = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
      r"\SavedVariables\MidnightHelper.lua")
SRC = (r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
       r"\Modules\DelveBossShowcase.lua")

sys.stdout.reconfigure(encoding="utf-8")


def block(lines, key):
    start = next((i for i, l in enumerate(lines) if key in l), None)
    if start is None:
        return None
    depth, end = 0, start
    for i in range(start, len(lines)):
        depth += lines[i].count("{") - lines[i].count("}")
        if depth == 0 and i > start:
            end = i
            break
    return lines[start:end + 1]


with io.open(SV, "r", encoding="utf-8", errors="replace") as fh:
    sv = fh.read().split("\n")

rows = block(sv, '["storyDaily"]')
if rows is None:
    print("storyDaily bestaat niet -- niets opgevangen.")
    raise SystemExit(0)

seen, cur = {}, None
for line in rows[1:]:
    m = re.match(r'\["([a-z0-9_]+)"\] = \{', line.strip())
    if m:
        cur = m.group(1)
        seen[cur] = {}
        continue
    if cur:
        m = re.search(r'\["(day|text)"\] = "(.*?)"', line)
        if m:
            seen[cur][m.group(1)] = m.group(2)

# Kleurcodes eruit -- 12.x gebruikt |cnNAAM: en niet |cffRRGGBB.
def clean(s):
    s = re.sub(r"\|cn[A-Z][A-Z0-9_]*:", "", s)
    s = re.sub(r"\|c%x{8}", "", s)
    return s.replace("|r", "").strip()


with io.open(SRC, "r", encoding="utf-8", errors="replace") as fh:
    src = fh.read()

# storyKeys per delve-sleutel uit de showcase-tabel.
#
# ⚠️ Eerder met een regex op "^\t\},$" gedaan; die gaf grudge_pit nul varianten
# terwijl het er drie heeft. Accolades tellen doet het wel, net als bij de
# SavedVariables. Een gatenlijst die zelf gaten verzint is erger dan geen lijst.
srclines = src.split("\n")
tstart = next(i for i, l in enumerate(srclines)
              if "ns.DELVE_BOSS_SHOWCASE = {" in l)
known, depth, cur, buf = {}, 0, None, []
for line in srclines[tstart + 1:]:
    m = re.match(r"^\t([a-z0-9_]+) = \{\s*$", line)
    if m and depth == 0:
        cur, buf, depth = m.group(1), [], 1
        continue
    if cur is None:
        if line.startswith("}"):
            break
        continue
    depth += line.count("{") - line.count("}")
    if depth <= 0:
        names = []
        for km in re.finditer(r"storyKeys = \{(.*?)\}", "\n".join(buf), re.S):
            names += re.findall(r'"(.*?)"', km.group(1))
        known[cur] = names
        cur, depth = None, 0
        continue
    buf.append(line)

days = sorted({v.get("day", "?") for v in seen.values()})
print("opgevangen varianten: %d   (datums: %s)" % (len(seen), ", ".join(days)))
print("")

hit, miss = [], []
for dkey in sorted(seen):
    text = clean(seen[dkey].get("text", ""))
    day = seen[dkey].get("day", "?")
    ours = known.get(dkey, [])
    # Exact dezelfde regel als StoryMatches in DelveBossShowcase.lua: gelijk, of
    # deelstring in beide richtingen zodra de sleutel 10+ tekens heeft. Een eigen,
    # strengere regel hier verzint gaten die het spel niet heeft.
    story = text.lower()
    match = None
    for k in ours:
        needle = k.lower()
        if story == needle:
            match = k
            break
        if len(needle) >= 10 and (needle in story or story in needle):
            match = k
            break
    (hit if match else miss).append((dkey, text, day, len(ours), match))

print("--- KENNEN WE (%d) ---" % len(hit))
for dkey, text, day, n, via in hit:
    note = "" if via.lower() == text.lower() else "   (matcht op deelstring: \"%s\")" % via
    print("  %-22s %-32s %s%s" % (dkey, text, day, note))

print("")
print("--- KENNEN WE NIET (%d) ---" % len(miss))
for dkey, text, day, n, _ in miss:
    tag = "wij hebben 0 varianten voor deze delve" if n == 0 else "wij hebben er %d, deze niet" % n
    print("  %-22s %-32s %s   (%s)" % (dkey, text, day, tag))

print("")
print("--- wat onze tabel kent (%d varianten) ---" % sum(len(v) for v in known.values()))
for dkey in sorted(k for k in known if known[k]):
    print("  %-22s %s" % (dkey, " | ".join(known[dkey])))
nokeys = sorted(k for k in known if not known[k])
print("")
print("delves in de tabel zonder enige variant: %d" % len(nokeys))
print("  %s" % ", ".join(nokeys))
