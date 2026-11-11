# -*- coding: utf-8 -*-
"""Which items are an ingredient (reagent) for which profession -> Modules/ForeverReagentData.lua and
Modules/MidnightReagentData.lua, read by Modules/ReagentUse.lua ("MH: Used for Cooking (you have it)" in the tooltip).

Rob, 11 Nov 2026 (via the sparring chat, "Ja, laat bouwen"; here "Ja, met probe-fix"): at a vendor he doubted whether
Stringy Wolf Meat was good for anything, and took Meaty Bat Wing for a Leatherworking item (it is Cooking). His
condition: "zonder dat we onze add-on onmenselijk groot maken" -- so the data is one packed string of item:bits.
The same evening, after it worked in Forever: "Kunnen we dit ook in de midnight versie bouwen?" -> measured -> "Ja,
bouw het".

Source: wago.tools DB2 through tools/gamedata.py, cached outside the repo.

FOREVER (product wowf). Rule, measured on 1.60.1.70888 (`--report` prints the numbers again):
  SkillLineAbility.SkillLine (recipe -> profession) + SpellReagents (recipe -> reagents) + ItemSparse (item exists).
  - Professions: the crafting ones plus Mining (smelting uses ore). Herbalism, Skinning and Fishing only list housing
    things; Poisons is a rogue class skill: all left out.
  - A recipe counts when it and everything it uses or makes is a row in Forever's ItemSparse, and it is no test spell.
  - Spell ids 400000-1199999 are left out (Season of Discovery / other modes; AFGELEID from the id ranges).

MIDNIGHT (product wow). Rule, measured on 12.1.5.70783:
  - Recipes: SkillLineAbility rows whose SkillupSkillLineID is a "Midnight <profession>" child line (SkillLine
    ParentSkillLineID = the profession). The SkillLine column holds the parent and has NO Midnight rows (measured: 0).
  - Reagents: SpellReagents (plain reagents) PLUS the quality reagents: ModifiedCraftingSpellSlot -> slot ->
    MCRSlotXMCRCategory -> category -> CraftingReagentQuality.ItemID. Without the second path most ores, herbs and cloth
    would be missing (744 of 915 recipes use slots). Optional slots (embellishments, Sparks, finishing) count too.
  - Only Midnight recipes, not every expansion: what a Midnight player picks up today, and it keeps the file small.

What DB2 does NOT know: at which skill you learn a recipe, or whether a trainer teaches it. So no skill number.

Usage (front door):  run forever_reagents --report [--midnight]   numbers and samples, writes nothing
                     run forever_reagents --emit [--midnight]     write the data file
                     add --build <x> to pin another build (default: the newest wago knows)
"""
import csv
import io
import os
import re
import sys
import urllib.parse
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402

GAMES = {
    "forever": {
        "product": "wowf", "out": os.path.join(ROOT, "Modules", "ForeverReagentData.lua"), "guard": "not ns.IS_FOREVER",
        # key, skill line (what GetProfessionInfo returns). Bit order = this list.
        "profs": [("ALCHEMY", 171), ("BLACKSMITHING", 164), ("ENCHANTING", 333), ("ENGINEERING", 202),
                  ("LEATHERWORKING", 165), ("TAILORING", 197), ("COOKING", 185), ("FIRSTAID", 129), ("MINING", 186)],
        "locales": ("enUS", "deDE", "frFR", "esES", "esMX", "ptBR", "itIT", "ruRU"),
        "controls": {2672: {"COOKING"}, 12223: {"COOKING"}, 2589: {"TAILORING"}, 2770: {"MINING"}},
        "control_names": {2672: "Stringy Wolf Meat", 12223: "Meaty Bat Wing", 2589: "Linen Cloth", 2770: "Copper Ore"},
    },
    "midnight": {
        "product": "wow", "out": os.path.join(ROOT, "Modules", "MidnightReagentData.lua"), "guard": "ns.IS_FOREVER",
        "profs": [("ALCHEMY", 171), ("BLACKSMITHING", 164), ("ENCHANTING", 333), ("ENGINEERING", 202),
                  ("LEATHERWORKING", 165), ("TAILORING", 197), ("COOKING", 185), ("INSCRIPTION", 773),
                  ("JEWELCRAFTING", 755)],
        "locales": ("enUS", "deDE", "frFR", "esES", "esMX", "ptBR", "itIT", "ruRU"),
        # Measured 11 Nov 2026 in the first Midnight run; a control proves the quality-reagent path too.
        "controls": {242639: {"COOKING"}, 238383: {"ALCHEMY", "COOKING", "ENCHANTING"}},
        "control_names": {242639: "Practically Pork", 238383: "Eversong Trout"},
    },
}
FOREVER_LEFT_OUT = {182: "Herbalism", 393: "Skinning", 356: "Fishing", 40: "Poisons (rogue class skill)"}


def rows(build, table, locale="enUS"):
    q = {"build": build}
    if locale != "enUS":
        q["locale"] = locale
    data, _ = gd.fetch("https://wago.tools/db2/%s/csv?%s" % (table, urllib.parse.urlencode(q)),
                       os.path.join(gd.CACHE, "db2", build, "%s.%s.csv" % (table, locale)), None)
    text = data.decode("utf-8-sig", "replace")
    if text.lstrip().startswith("<"):
        gd.die("wago.tools gave a web page for %s %s" % (table, build))
    return list(csv.DictReader(io.StringIO(text)))


def I(v):
    try:
        return int(v)
    except (TypeError, ValueError):
        return 0


def spell_reagents(build):
    reag = defaultdict(list)
    for r in rows(build, "SpellReagents"):
        for k in range(8):
            it = I(r.get("Reagent_%d" % k))
            if it > 0:
                reag[I(r["SpellID"])].append(it)
    return reag


def build_forever(build, g, report):
    line_key = {l: p for p, l in g["profs"]}
    sla = [r for r in rows(build, "SkillLineAbility") if I(r["SkillLine"]) in line_key or I(r["SkillLine"]) in FOREVER_LEFT_OUT]
    reag = spell_reagents(build)
    names = {I(r["ID"]): r["Name_lang"] for r in rows(build, "SpellName")}
    made = defaultdict(list)
    for r in rows(build, "SpellEffect"):
        if I(r["Effect"]) == 24 and I(r["SpellID"]) in reag:
            made[I(r["SpellID"])].append(I(r["EffectItemType"]))
    sparse = {I(r["ID"]): r for r in rows(build, "ItemSparse")}
    use, why, samples = defaultdict(set), Counter(), defaultdict(list)
    for r in sla:
        s, line = I(r["Spell"]), I(r["SkillLine"])
        if s not in reag:
            continue
        key = None
        if line in FOREVER_LEFT_OUT:
            key = "left-out line %s" % FOREVER_LEFT_OUT[line]
        elif re.search(r"\(test\)|\[dnt\]|\btest\b", names.get(s, ""), re.I):
            key = "test spell"
        elif 400000 <= s < 1200000:
            key = "spell id 400000-1199999"
        elif not (all(i in sparse for i in reag[s]) and all(m in sparse for m in made.get(s, []))):
            key = "reagent or made item not in ItemSparse"
        if key:
            why[key] += 1
            if len(samples[key]) < 4:
                samples[key].append("%d %s" % (s, names.get(s, "?")))
            continue
        why["kept"] += 1
        for i in reag[s]:
            use[i].add(line_key[line])
    if report:
        for k, n in why.most_common():
            print("  %-42s %5d recipes   e.g. %s" % (k, n, "; ".join(samples.get(k, []))))
    return use


def build_midnight(build, g, report):
    parent_key = {l: p for p, l in g["profs"]}
    child = {}
    for r in rows(build, "SkillLine"):
        if I(r.get("ParentSkillLineID")) in parent_key and "Midnight" in r["DisplayName_lang"]:
            child[I(r["ID"])] = parent_key[I(r["ParentSkillLineID"])]
    spell_prof = {}
    for r in rows(build, "SkillLineAbility"):
        if I(r["SkillupSkillLineID"]) in child:
            spell_prof[I(r["Spell"])] = child[I(r["SkillupSkillLineID"])]
    reag = spell_reagents(build)
    slot_cats = defaultdict(list)
    for r in rows(build, "MCRSlotXMCRCategory"):
        slot_cats[I(r["ModifiedCraftingReagentSlotID"])].append(I(r["ModifiedCraftingCategoryID"]))
    cat_items = defaultdict(list)
    for r in rows(build, "CraftingReagentQuality"):
        if I(r["ItemID"]) > 0:
            cat_items[I(r["ModifiedCraftingCategoryID"])].append(I(r["ItemID"]))
    spell_slots = defaultdict(list)
    for r in rows(build, "ModifiedCraftingSpellSlot"):
        spell_slots[I(r["SpellID"])].append(I(r["ModifiedCraftingReagentSlotID"]))
    use = defaultdict(set)
    plain, quality = set(), set()
    for s, prof in spell_prof.items():
        for i in reag.get(s, []):
            use[i].add(prof)
            plain.add(i)
        for sl in spell_slots.get(s, []):
            for c in slot_cats.get(sl, []):
                for i in cat_items.get(c, []):
                    use[i].add(prof)
                    quality.add(i)
    if report:
        print("  Midnight child lines: %s" % sorted(child.items()))
        print("  recipes: %d; plain reagent items %d, quality/slot items %d" % (len(spell_prof), len(plain), len(quality)))
    return use


def prof_names(build, g):
    out = {}
    want = {l: p for p, l in g["profs"]}
    for loc in g["locales"]:
        out[loc] = {}
        for r in rows(build, "SkillLine", loc):
            if I(r["ID"]) in want:
                out[loc][want[I(r["ID"])]] = r["DisplayName_lang"]
    return out


def check_controls(use, g):
    ok = True
    for item, want in g["controls"].items():
        got = use.get(item, set())
        good = want <= got
        ok = ok and good
        print("  control %d %s -> %s %s" % (item, g["control_names"][item], sorted(got), "OK" if good else "FAIL"))
    return ok


def emit(game, build, use, names, g):
    order = [p for p, _ in g["profs"]]
    pairs = ["%d:%d" % (i, sum(1 << order.index(p) for p in v)) for i, v in sorted(use.items())]
    chunks, cur = [], ""
    for p in pairs:
        if len(cur) + len(p) + 1 > 110:
            chunks.append(cur)
            cur = ""
        cur += p + ","
    chunks.append(cur)
    name_lines = []
    for loc in g["locales"]:
        body = ", ".join('%s = "%s"' % (k, names[loc][k].replace('"', '\\"')) for k in order if names[loc].get(k))
        name_lines.append("\t%s = { %s }," % (loc, body))
    text = "\n".join([
        "local _, ns = ...",
        "",
        "-- GENERATED by tools/forever_reagents.py --emit%s from wago.tools DB2, %s build %s. Do not edit by hand:"
        % (" --midnight" if game == "midnight" else "", game.capitalize(), build),
        "-- run it again for a new build (the rule is in the generator's header). Read by Modules/ReagentUse.lua.",
        "-- %d items." % len(use),
        "",
        "if %s then" % g["guard"],
        "\treturn",
        "end",
        "",
        "ns.REAGENT_BUILD = \"%s\"" % build,
        "-- bit n (from 0) = this profession; the number is the skill line GetProfessionInfo returns for it",
        "ns.REAGENT_ORDER = { %s }" % ", ".join('"%s"' % p for p in order),
        "ns.REAGENT_LINES = { %s }" % ", ".join("%s = %d" % (p, l) for p, l in g["profs"]),
        "-- the profession's name in each client language (SkillLine.DisplayName_lang, same build)",
        "ns.REAGENT_NAMES = {",
    ] + name_lines + [
        "}",
        "-- itemID:bits, comma separated",
        "ns.REAGENT_PACKED = [[",
    ] + chunks + ["]]", ""])
    tmp = g["out"] + ".tmp"
    with io.open(tmp, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    os.replace(tmp, g["out"])
    print("wrote %s (%d items, %d bytes)" % (g["out"], len(use), len(text.encode("utf-8"))))


def main():
    args = sys.argv[1:]
    if not args or "--help" in args:
        print(__doc__)
        return
    game = "midnight" if "--midnight" in args else "forever"
    g = GAMES[game]
    build = args[args.index("--build") + 1] if "--build" in args else gd.latest_build(g["product"])
    print("%s build %s" % (game, build))
    use = (build_midnight if game == "midnight" else build_forever)(build, g, "--report" in args)
    per = Counter(p for v in use.values() for p in v)
    print("  items: %d, used by 2+ professions: %d; per profession %s" % (
        len(use), sum(1 for v in use.values() if len(v) > 1), dict(per.most_common())))
    ok = check_controls(use, g)
    if "--emit" in args:
        if not ok:
            gd.die("a positive control failed; nothing written")
        emit(game, build, use, prof_names(build, g), g)


if __name__ == "__main__":
    main()
