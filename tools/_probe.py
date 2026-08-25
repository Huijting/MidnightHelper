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
i = next(k for k, l in enumerate(lines) if l.strip() == '["name"] = "The Venomous Abyss",')
start = i - 1
while not lines[start].strip().endswith("{"):
    start -= 1
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
    tier = [it for it in items
            if it.get("slot") in TIER_SLOTS and not it.get("armorType")]
    print("-- %d. %s  (%d items, %d zonder armorType op een tier-slot)"
          % (no, nm, len(items), len(tier)))
    for it in tier:
        print("     %-34s %-9s filter=%s  id=%s"
              % (it.get("name", "?")[:34], it.get("slot"),
                 it.get("filterType", "-"), it.get("itemID")))
        tokens.append((no, nm, it))
    print("")

print("=== samenvatting ===")
print("kandidaat-tokens: %d" % len(tokens))
slots = {}
for no, nm, it in tokens:
    slots.setdefault(it.get("slot"), []).append("%d. %s" % (no, nm))
for slot in ("Head", "Shoulder", "Chest", "Hands", "Legs"):
    who = slots.get(slot)
    print("  %-9s %s" % (slot, ", ".join(who) if who else "GEEN"))
