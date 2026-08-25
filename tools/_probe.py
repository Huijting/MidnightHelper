# -*- coding: utf-8 -*-
"""Welke Abyss-drops dragen een set-regel in hun tooltip? Dat is de tier-test.

setLine kan drie dingen zijn en die mogen NIET op een hoop:
  een tekst   -> het spel zegt zelf dat dit een setstuk is
  false       -> tooltip gelezen, geen setregel  (echt geen tier)
  een reden   -> tooltip niet leesbaar           (weten we niets)
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

i = next(k for k, l in enumerate(lines)
         if l.strip() == '["name"] = "The Venomous Abyss",')
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

boss_no, items, bosses, cur = None, [], [], {}
for line in lines[start:end + 1]:
    s = line.strip()
    m = re.match(r'\["index"\] = (\d+),$', s)
    if m:
        if boss_no is not None:
            bosses.append((boss_no, items))
        boss_no, items = int(m.group(1)), []
        continue
    m = re.match(r'\["(itemID|slot|armorType|name|setLine)"\] = (.*),$', s)
    if m:
        v = m.group(2).strip()
        cur[m.group(1)] = (v == "true") if v in ("true", "false") else v.strip('"')
        if v == "false":
            cur[m.group(1)] = False
        continue
    if s == "}," and "itemID" in cur:
        items.append(cur)
        cur = {}
        continue
    if s.endswith("{"):
        cur = {}
if boss_no is not None:
    bosses.append((boss_no, items))

NAMES = ["Nek'zali the Soulcoiler", "Entombed Sentinels", "The Lost Explorers",
         "Vashnik the Malignant", "Sszorak", "The Twin Fangs",
         "The Coiled Altar", "Ula'tek"]

setpieces, plain, unread = [], [], []
for no, its in bosses:
    for it in its:
        if it.get("slot") not in TIER_SLOTS:
            continue
        sl = it.get("setLine")
        row = (no, NAMES[no - 1] if no <= len(NAMES) else str(no),
               it.get("name", "?"), it.get("armorType") or "-", sl)
        if sl is False:
            plain.append(row)
        elif isinstance(sl, str) and sl in ("tooltip unreadable",
                                            "no C_TooltipInfo.GetItemByID"):
            unread.append(row)
        elif isinstance(sl, str):
            setpieces.append(row)
        else:
            unread.append(row)

print("tier-slot drops in The Venomous Abyss: %d"
      % (len(setpieces) + len(plain) + len(unread)))
print("  met setregel        : %d" % len(setpieces))
print("  gelezen, geen set   : %d" % len(plain))
print("  tooltip onleesbaar  : %d   <- hierover weten we NIETS" % len(unread))
print("")

if setpieces:
    print("=== SETSTUKKEN (het spel zegt het zelf) ===")
    for no, boss, nm, armor, sl in setpieces:
        print("  boss %d  %-34s %-8s  %s" % (no, nm[:34], armor, sl))
    print("")

if unread:
    print("=== onleesbaar ===")
    for no, boss, nm, armor, sl in unread[:12]:
        print("  boss %d  %-34s %-8s  %s" % (no, nm[:34], armor, sl))
    print("")

print("=== gelezen, GEEN setregel ===")
for no, boss, nm, armor, sl in plain:
    print("  boss %d  %-34s %s" % (no, nm[:34], armor))

# ---------------------------------------------------------------------------
# POSITIEVE CONTROLE. Nul setregels kan twee dingen betekenen: deze raid heeft
# geen tier, OF de test werkt niet. Season 1 HAD tier-sets, dus als The Voidspire
# er ook nul geeft, is mijn test kapot en zegt de uitkomst hierboven niets.
# ---------------------------------------------------------------------------
print("")
print("=== POSITIEVE CONTROLE: setregels in de HELE vangst ===")
whole = "\n".join(lines)
tot = len(re.findall(r'\["setLine"\] = ', whole))
false_n = len(re.findall(r'\["setLine"\] = false,', whole))
unread_n = len(re.findall(r'\["setLine"\] = "tooltip unreadable"', whole))
noapi_n = len(re.findall(r'\["setLine"\] = "no C_TooltipInfo', whole))
real = tot - false_n - unread_n - noapi_n
print("  setLine-velden totaal : %d" % tot)
print("  false (geen set)      : %d" % false_n)
print("  onleesbaar            : %d" % unread_n)
print("  API ontbrak           : %d" % noapi_n)
print("  ECHTE setregels       : %d" % real)
if real:
    print("")
    print("  voorbeelden:")
    seen = set()
    for m in re.finditer(r'\["setLine"\] = "(.*?)",', whole):
        t = m.group(1)
        if t.startswith("tooltip") or t.startswith("no C_Tooltip") or t in seen:
            continue
        seen.add(t)
        print("     %s" % t)
        if len(seen) >= 8:
            break
else:
    print("")
    print("  ⚠️ NUL in de hele vangst, ook in Season 1-raids die wel tier hadden.")
    print("     Dan bewijst de uitslag hierboven NIETS over de Abyss -- dan is de")
    print("     test zelf stuk (waarschijnlijk geeft GetItemByID geen setregel voor")
    print("     een item dat je niet bezit).")
