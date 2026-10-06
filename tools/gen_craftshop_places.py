"""Turn data/craftshop_recipe_places.tsv into Modules/CraftShopPlaces.lua (6 Oct 2026, Rob: build the 39 places).
Two vendors for one recipe: the profession vendor next to the trainer wins over Lyrendal (Rob followed the advice).
Run through the front door: probe_job.txt = `run gen_craftshop_places`, then plain `python tools/_probe.py`."""
import collections
import os

REPO = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper"
SRC = os.path.join(REPO, "data", "craftshop_recipe_places.tsv")
OUT = os.path.join(REPO, "Modules", "CraftShopPlaces.lua")

rows = []
with open(SRC, encoding="utf-8") as f:
    header = f.readline().rstrip("\n").split("\t")
    for line in f:
        parts = line.rstrip("\n").split("\t")
        parts += [""] * (len(header) - len(parts))
        rows.append(dict(zip(header, parts)))

kinds = collections.Counter(r["sourceType"] for r in rows)
print("rows:", len(rows))
print("sourceTypes:", dict(kinds))

with_place = [r for r in rows if r["mapID"].strip().isdigit()]
print("rows with a place:", len(with_place))

by_recipe = collections.defaultdict(list)
for r in with_place:
    by_recipe[int(r["recipeID"])].append(r)

def clean(name):
    # "Magisters' Terrace (ingang) - Drop: ..." -> "Magisters' Terrace"; "Jennara Sunglow (254051), ..." -> "Jennara Sunglow"
    return name.split(" (")[0].strip()

KIND = {"vendor": "vendor", "quest": "quest", "dungeon-baas": "dungeon", "raid-baas": "raid",
        "trainer (Jennara Sunglow)": "trainer"}

places, place_index, recipes = [], {}, {}
two = 0
for rid in sorted(by_recipe):
    cands = by_recipe[rid]
    if len(cands) > 1:
        two += 1
        others = [c for c in cands if c["place name"] != "Lyrendal"]
        if others:
            cands = others
    c = cands[0]
    key = (clean(c["place name"]), c["mapID"], c["x"], c["y"])
    if key not in place_index:
        place_index[key] = len(places) + 1
        places.append(c)
    recipes[rid] = place_index[key]

print("recipes with a place:", len(recipes), "| with two candidates:", two)
print("unique places used:", len(places))
for i, p in enumerate(places, 1):
    print("  %2d %-28s %-10s %s %s/%s %s" % (i, p["place name"], p["sourceType"], p["mapID"], p["x"], p["y"], p["status"]))

def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'

out = []
out.append("local _, ns = ...")
out.append("")
out.append("--[[")
out.append("\tWhere you get a Midnight recipe: recipe id -> place, for \"Show the way\" in the craft shopping list.")
out.append("\tGENERATED from data/craftshop_recipe_places.tsv (mh-research 6 Oct 2026: wago DB2 12.1.0.69933 SourceInfo, the")
out.append("\ttable behind C_TradeSkillUI.GetRecipeSourceText; vendor places from CollectableSourceVendorSparse, entrances from")
out.append("\tAreaPOI; 7 places from Zygor/Wowhead). Do not edit by hand: change the TSV and regenerate.")
out.append("\tchecked = true: Blizzard's own data (GEMETEN-DB2). false: Zygor/Wowhead only (KANDIDAAT), not yet walked in game.")
out.append("\tTwo vendors for one recipe: the profession vendor next to the trainer wins over Lyrendal (Rob, 6 Oct 2026).")
out.append("\tKeyed by recipe id, never by the NPC name in the text: that text is in the player's own language.")
out.append("]]")
out.append("")
out.append("ns.CRAFTSHOP_PLACES = {")
for i, p in enumerate(places, 1):
    checked = "true" if p["status"].startswith("GEMETEN") else "false"
    out.append("\t[%d] = { name = %s, kind = %s, map = %s, x = %s, y = %s, checked = %s }," % (
        i, lua_str(clean(p["place name"])), lua_str(KIND[p["sourceType"]]), p["mapID"], p["x"], p["y"], checked))
out.append("}")
out.append("")
out.append("ns.CRAFTSHOP_RECIPE_PLACE = {")
for rid in sorted(recipes):
    out.append("\t[%d] = %d," % (rid, recipes[rid]))
out.append("}")
out.append("")
text = "\n".join(out)

tmp = OUT + ".tmp"
with open(tmp, "w", encoding="utf-8", newline="\n") as f:
    f.write(text)
os.replace(tmp, OUT)
print("wrote", OUT, len(text), "bytes")
