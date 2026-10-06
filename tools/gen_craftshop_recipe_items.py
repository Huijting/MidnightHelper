"""Turn data/craftshop_recipe_items.tsv into Modules/CraftShopRecipeItems.lua (6 Oct 2026).
A recipe item (Pattern:/Recipe:/...) -> the recipe it teaches + its base profession, for the tooltip line
"which of your characters know this recipe" (Rob: the MyRecipeTracker idea, none of its code).
Run through the front door: probe_job.txt = `run gen_craftshop_recipe_items`, then plain `python tools/_probe.py`."""
import collections
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(REPO, "data", "craftshop_recipe_items.tsv")
OUT = os.path.join(REPO, "Modules", "CraftShopRecipeItems.lua")

# Midnight skill line -> base profession (research doc CRAFTSHOP_RECIPE_ITEMS_2026-10-06.md, wago SkillLine.ParentSkillLineID)
BASE = {2906: 171, 2907: 164, 2908: 185, 2909: 333, 2910: 202, 2911: 356, 2912: 182, 2913: 773, 2914: 755,
        2915: 165, 2916: 186, 2917: 393, 2918: 197}

rows = []
with open(SRC, encoding="utf-8") as f:
    header = f.readline().rstrip("\n").split("\t")
    for line in f:
        parts = line.rstrip("\n").split("\t")
        parts += [""] * (len(header) - len(parts))
        rows.append(dict(zip(header, parts)))

items, skipped = {}, collections.Counter()
for r in rows:
    if not (r["itemID"].isdigit() and r["recipeID"].isdigit() and r["skillLineID"].isdigit()):
        skipped[r["status"] or "?"] += 1
        continue
    base = BASE.get(int(r["skillLineID"]))
    if not base:
        skipped["no base " + r["skillLineID"]] += 1
        continue
    items[int(r["itemID"])] = (int(r["recipeID"]), base)

print("rows:", len(rows), "| items:", len(items), "| skipped:", dict(skipped))
per = collections.Counter(b for _, b in items.values())
print("per base profession:", dict(per))
for check in (256636, 275275, 256759, 278331):  # the research's Wowhead checks
    print("check", check, "->", items.get(check))

out = ["local _, ns = ...", "",
       "--[[",
       "\tRecipe item -> { recipe id, base profession }, for the recipe item tooltip \"which of your characters know this\".",
       "\tGENERATED from data/craftshop_recipe_items.tsv by tools/gen_craftshop_recipe_items.py (mh-research 6 Oct 2026: wago DB2",
       "\t12.1.0.69933, the item's learn effect -> a Midnight SkillLineAbility recipe). Do not edit by hand.",
       "\tKeyed by item id: the tooltip text is in the player's language and an item's name is not always its recipe's.",
       "]]", "", "ns.CRAFTSHOP_RECIPE_ITEM = {"]
for iid in sorted(items):
    rid, base = items[iid]
    out.append("\t[%d] = { %d, %d }," % (iid, rid, base))
out += ["}", ""]
text = "\n".join(out)
tmp = OUT + ".tmp"
with open(tmp, "w", encoding="utf-8", newline="\n") as f:
    f.write(text)
os.replace(tmp, OUT)
print("wrote", OUT, len(text), "bytes")
