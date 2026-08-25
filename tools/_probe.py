# -*- coding: utf-8 -*-
"""Tier-tokens in The Venomous Abyss, uit ns.db.ejCapture.

Een class-token herken je NIET aan zijn naam (die verzin ik dan) maar aan de vorm:
het bezet een tier-slot (head/shoulder/chest/hands/legs) en heeft GEEN armorType,
want het is nog geen wapenrusting. We tonen alle vijf de slots zodat de conclusie
te controleren is in plaats van te geloven.
"""
import io
import re
import sys

SV = (r"E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER"
      r"\SavedVariables\MidnightHelper.lua")
TIER_SLOTS = {"Head", "Shoulder", "Chest", "Hands", "Legs"}

sys.stdout.reconfigure(encoding="utf-8")

with io.open(SV, "r", encoding="utf-8", errors="replace") as fh:
    lines = fh.read().split("\n")

# Het instance-blok begint bij de naamregel; loop terug naar de openende accolade.
# ⚠️ NIET "de eerste regel die op { eindigt": sinds de vangst een lootFilters-blok
# vóór de naam schrijft, is dat de accolade van dát blok en leest de probe vijf regels
# in plaats van achthonderd. Tel accolades, dan maakt de volgorde niet uit.
i = next(k for k, l in enumerate(lines) if l.strip() == '["name"] = "The Venomous Abyss",')
bal, start = 0, i
while start > 0:
    start -= 1
    bal += lines[start].count("}") - lines[start].count("{")
    if bal < 0:
        break
depth, end = 0, start
for k in range(start, len(lines)):
    depth += lines[k].count("{") - lines[k].count("}")
    if depth == 0 and k > start:
        end = k
        break

block = lines[start:end + 1]
print("The Venomous Abyss: regel %d-%d" % (start + 1, end + 1))

# Bosses liggen op een vaste diepte; we volgen ["index"] als bossgrens en
# verzamelen de items ertussen.
boss_no, boss_items, bosses = None, [], []
cur = {}
for line in block:
    s = line.strip()
    m = re.match(r'\["index"\] = (\d+),$', s)
    if m:
        if boss_no is not None:
            bosses.append((boss_no, boss_items))
        boss_no, boss_items = int(m.group(1)), []
        continue
    m = re.match(r'\["(itemID|slot|armorType|filterType|name)"\] = (.*),$', s)
    if m:
        cur[m.group(1)] = m.group(2).strip('"')
        continue
    if s == "}," and "itemID" in cur:
        boss_items.append(cur)
        cur = {}
        continue
    if s.endswith("{"):
        cur = {}
if boss_no is not None:
    bosses.append((boss_no, boss_items))

# Bossnamen uit onze eigen tabel, in volgorde.
NAMES = ["Nek'zali the Soulcoiler", "Entombed Sentinels", "The Lost Explorers",
         "Vashnik the Malignant", "Sszorak", "The Twin Fangs",
         "The Coiled Altar", "Ula'tek"]

print("bosses met loot: %d" % len(bosses))
print("")
tokens = []
for no, items in bosses:
    nm = NAMES[no - 1] if no <= len(NAMES) else ("boss %d" % no)
    print("-- %d. %s  (%d items)" % (no, nm, len(items)))
    for it in items:
        mark = ""
        if it.get("slot") in TIER_SLOTS and not it.get("armorType"):
            mark = "  <== tier-slot zonder armorType"
            tokens.append((no, nm, it))
        print("     %-36s slot=%-10s armor=%-9s filter=%-3s id=%s%s"
              % (it.get("name", "?")[:36], it.get("slot", "") or "-",
                 it.get("armorType", "") or "-", it.get("filterType", "-"),
                 it.get("itemID"), mark))
    print("")

print("=== samenvatting ===")
print("items zonder armorType op een tier-slot: %d" % len(tokens))
for no, nm, it in tokens:
    print("   %s  (boss %d, %s)" % (it.get("name"), no, nm))

print("")
print("=== per pantsertype: welke boss geeft welk tier-slot? ===")
grid = {}
for no, items in bosses:
    for it in items:
        a, s = it.get("armorType"), it.get("slot")
        if a in ("Cloth", "Leather", "Mail", "Plate") and s in TIER_SLOTS:
            grid.setdefault(a, {}).setdefault(s, []).append((no, it.get("name")))

order = ["Head", "Shoulder", "Chest", "Hands", "Legs"]
print("%-9s %s" % ("", "  ".join("%-9s" % s for s in order)))
for a in ("Cloth", "Leather", "Mail", "Plate"):
    row = []
    for s in order:
        hits = grid.get(a, {}).get(s, [])
        row.append("%-9s" % (",".join(str(h[0]) for h in hits) or "-"))
    print("%-9s %s" % (a, "  ".join(row)))
print("")
print("(cijfers = bossnummer. Een compleet stel op alle vijf de slots betekent dat")
print(" tier hier als GEWONE uitrusting valt en niet als class-token.)")
