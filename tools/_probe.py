# -*- coding: utf-8 -*-
"""Beroepen per character + hoe vers de momentopname is.

Zonder de datum is "geen beroepen" niet te onderscheiden van "nooit vastgelegd",
en dat verschil bepaalt of een advies ergens op slaat.
"""
import datetime
import io
import re
import sys

SV = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
      r"\SavedVariables\MidnightHelper.lua")

sys.stdout.reconfigure(encoding="utf-8")

with io.open(SV, "r", encoding="utf-8", errors="replace") as fh:
    lines = fh.read().split("\n")

start = next(i for i, l in enumerate(lines) if '["charCurrencies"]' in l)
depth, end = 0, start
for i in range(start, len(lines)):
    depth += lines[i].count("{") - lines[i].count("}")
    if depth == 0 and i > start:
        end = i
        break

chars, cur, d = [], None, 0
for line in lines[start + 1:end]:
    if d == 0 and re.match(r'^\["[^"]+"\] = \{', line):
        cur = {}
        chars.append(cur)
        d = 1
        continue
    if cur is None:
        continue
    d += line.count("{") - line.count("}")
    m = re.match(r'^\["([A-Za-z]+)"\] = (.*),$', line.strip())
    if m:
        v = m.group(2).strip()
        if v.startswith('"'):
            v = v[1:-1]
        cur.setdefault(m.group(1), v)
    if d <= 0:
        cur, d = None, 0

now = datetime.datetime.now()


def stamp(c):
    for key in ("at", "ts"):
        v = c.get(key)
        if v and v.isdigit() and int(v) > 1000000000:
            when = datetime.datetime.fromtimestamp(int(v))
            return when, (now - when).days
    return None, None


rows = []
for c in chars:
    if not c.get("name"):
        continue
    when, age = stamp(c)
    rows.append({
        "name": c["name"],
        "realm": c.get("realm", "?"),
        "level": int(c["level"]) if c.get("level", "").isdigit() else None,
        "profs": c.get("professionsFull") or c.get("professions") or "",
        "when": when, "age": age,
    })

rows.sort(key=lambda r: (-(r["level"] or 0), r["name"]))

print("%-16s %-13s %5s  %-8s  %s" % ("CHARACTER", "REALM", "LVL", "OUD", "BEROEPEN"))
print("-" * 96)
for r in rows:
    age = ("%d d" % r["age"]) if r["age"] is not None else "?"
    lvl = str(r["level"]) if r["level"] else "?"
    print("%-16s %-13s %5s  %-8s  %s" % (r["name"], r["realm"], lvl, age, r["profs"] or "(niets vastgelegd)"))

CRAFT = ["Alchemy", "Blacksmithing", "Enchanting", "Engineering",
         "Inscription", "Jewelcrafting", "Leatherworking", "Tailoring"]
GATHER = ["Herbalism", "Mining", "Skinning"]

print("")
print("=== dekking op level 90 ===")
maxrows = [r for r in rows if r["level"] == 90]
print("characters op 90: %d" % len(maxrows))
print("")
for group, title in ((CRAFT, "crafting"), (GATHER, "gathering")):
    print("-- %s --" % title)
    for p in group:
        who = [r["name"] for r in maxrows if p in r["profs"]]
        mark = "OK  " if len(who) == 1 else ("MIST" if not who else "DUB ")
        print("  %-4s %-16s %s" % (mark, p, ", ".join(who) if who else "niemand op 90"))
    print("")

print("=== waar staat het wel, maar niet op 90? ===")
for p in CRAFT + GATHER:
    at90 = any(p in r["profs"] for r in maxrows)
    low = [("%s (%s)" % (r["name"], r["level"] or "?")) for r in rows
           if p in r["profs"] and r["level"] != 90]
    if not at90 and low:
        print("  %-16s alleen op: %s" % (p, ", ".join(low)))
