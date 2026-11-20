# -*- coding: utf-8 -*-
"""Skill-up data for WoW Forever -> Modules/ForeverSkillupData.lua, read by Modules/ForeverSkillup.lua.

Rob, 20 Nov 2026 (idea 6, via sparring, option MIDDEL): "Ja, begin daar dan mee. Het geld kunnen we inderdaad later
bekijken." Per recipe: the profession, where it turns yellow and grey, what it makes and what it uses; per recipe item
(Plans:, Pattern:, Recipe: ...) the recipe it teaches. No prices.

Source: wago.tools DB2 (product wowf) through tools/gamedata.py, cached outside the repo. GEMETEN 20 Nov 2026 on
1.60.1.70959 (mh-research + here):
  SkillLineAbility: Spell, SkillLine (the profession), TrivialSkillLineRankLow = yellow, TrivialSkillLineRankHigh = grey.
    There is NO green column; green = floor((yellow + grey) / 2) is AFGELEID (community, the same in four addons).
    MinSkillLineRank is NOT the skill you learn it at (2665 Coarse Sharpening Stone: Min 75, grey 55), so it is not used.
  SpellReagents: SpellID, Reagent_0..7, ReagentCount_0..7.
  SpellEffect: Effect 24 = create item, EffectItemType, EffectBasePointsF = how many.
  ItemXItemEffect + ItemEffect (TriggerType 6) = which recipe a recipe item teaches (2881 Plans: Runed Copper
  Breastplate -> 2667).
Same recipe filter as tools/forever_reagents.py (no test spells, no spell ids 400000-1199999, every reagent and made
item in ItemSparse), plus yellow > 0 and grey >= yellow.

Usage (front door):  run forever_skillup --report    numbers + controls, writes nothing
                     run forever_skillup --emit      write the data file
                     add --build <x> to pin another build
"""
import io
import os
import re
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402
import forever_reagents as fr  # noqa: E402

OUT = os.path.join(ROOT, "Modules", "ForeverSkillupData.lua")
# Same order as ns.REAGENT_ORDER (Modules/ForeverReagentData.lua), so the profession names there can be reused.
PROFS = [("ALCHEMY", 171), ("BLACKSMITHING", 164), ("ENCHANTING", 333), ("ENGINEERING", 202),
         ("LEATHERWORKING", 165), ("TAILORING", 197), ("COOKING", 185), ("FIRSTAID", 129), ("MINING", 186)]
# Positive controls (GEMETEN 20 Nov 2026): Rough Sharpening Stone, and a plan item.
CONTROL_SPELL = {2660: ("BLACKSMITHING", 15, 55, 2862, {2835: 1})}
CONTROL_ITEM = {2881: 2667}
I = fr.I


def build(b, report):
    line_idx = {l: i + 1 for i, (_, l) in enumerate(PROFS)}
    sparse = {I(r["ID"]): r for r in fr.rows(b, "ItemSparse")}
    names = {I(r["ID"]): r["Name_lang"] for r in fr.rows(b, "SpellName")}
    reag = {}
    for r in fr.rows(b, "SpellReagents"):
        lst = []
        for k in range(8):
            it, n = I(r.get("Reagent_%d" % k)), I(r.get("ReagentCount_%d" % k))
            if it > 0:
                lst.append((it, max(1, n)))
        if lst:
            reag[I(r["SpellID"])] = lst
    made = {}
    for r in fr.rows(b, "SpellEffect"):
        if I(r["Effect"]) == 24 and I(r["SpellID"]) in reag and I(r["EffectItemType"]) > 0:
            try:
                n = int(float(r.get("EffectBasePointsF") or 1))
            except ValueError:
                n = 1
            made.setdefault(I(r["SpellID"]), (I(r["EffectItemType"]), max(1, n)))
    rec, why, samples = {}, Counter(), {}
    for r in fr.rows(b, "SkillLineAbility"):
        s, line = I(r["Spell"]), I(r["SkillLine"])
        if line not in line_idx or s not in reag or s in rec:
            continue
        y, g = I(r.get("TrivialSkillLineRankLow")), I(r.get("TrivialSkillLineRankHigh"))
        key = None
        if re.search(r"\(test\)|\[dnt\]|\btest\b", names.get(s, ""), re.I):
            key = "test spell"
        elif 400000 <= s < 1200000:
            key = "spell id 400000-1199999"
        elif not all(i in sparse for i, _ in reag[s]) or (s in made and made[s][0] not in sparse):
            key = "reagent or made item not in ItemSparse"
        elif y <= 0 or g < y:
            key = "no yellow/grey value"
        if key:
            why[key] += 1
            samples.setdefault(key, "%d %s" % (s, names.get(s, "?")))
            continue
        why["kept"] += 1
        rec[s] = (line_idx[line], y, g, made.get(s), reag[s])
    effect_spell = {I(r["ID"]): I(r["SpellID"]) for r in fr.rows(b, "ItemEffect") if I(r.get("TriggerType")) == 6}
    teach = {}
    for r in fr.rows(b, "ItemXItemEffect"):
        it, sp = I(r["ItemID"]), effect_spell.get(I(r["ItemEffectID"]))
        if sp in rec and it in sparse:
            teach[it] = sp
    if report:
        for k, n in why.most_common():
            print("  %-42s %5d   e.g. %s" % (k, n, samples.get(k, "")))
        print("  recipe items that teach a kept recipe: %d" % len(teach))
        print("  per profession: %s" % dict(Counter(PROFS[v[0] - 1][0] for v in rec.values()).most_common()))
    return rec, teach


def controls(rec, teach):
    ok = True
    for s, (prof, y, g, prod, rg) in CONTROL_SPELL.items():
        got = rec.get(s)
        good = bool(got) and PROFS[got[0] - 1][0] == prof and got[1] == y and got[2] == g and got[3] \
            and got[3][0] == prod and dict(got[4]) == rg
        ok = ok and good
        print("  control spell %d -> %s %s" % (s, got, "OK" if good else "FAIL"))
    for it, s in CONTROL_ITEM.items():
        good = teach.get(it) == s
        ok = ok and good
        print("  control item %d -> %s %s" % (it, teach.get(it), "OK" if good else "FAIL"))
    return ok


def chunks(parts, width=110):
    out, cur = [], ""
    for p in parts:
        if len(cur) + len(p) + 1 > width:
            out.append(cur)
            cur = ""
        cur += p + ","
    out.append(cur)
    return out


def emit(b, rec, teach):
    parts = []
    for s in sorted(rec):
        p, y, g, prod, rg = rec[s]
        mk = "0" if not prod else ("%d" % prod[0] if prod[1] == 1 else "%d*%d" % prod)
        parts.append("%d:%d:%d:%d:%s:%s" % (s, p, y, g, mk, "/".join(
            ("%d" % i if n == 1 else "%d*%d" % (i, n)) for i, n in rg)))
    items = ["%d:%d" % (i, teach[i]) for i in sorted(teach)]
    text = "\n".join([
        "local _, ns = ...",
        "",
        "-- GENERATED by tools/forever_skillup.py --emit from wago.tools DB2, Forever build %s. Do not edit by hand:" % b,
        "-- run it again for a new build (the rule is in the generator's header). Read by Modules/ForeverSkillup.lua.",
        "-- %d recipes, %d recipe items." % (len(rec), len(items)),
        "",
        "if not ns.IS_FOREVER then",
        "\treturn",
        "end",
        "",
        "ns.SKILLUP_BUILD = \"%s\"" % b,
        "-- profession number = position in ns.REAGENT_ORDER (Modules/ForeverReagentData.lua), from 1",
        "-- spell:prof:yellow:grey:made[*n]:reagent[*n]/reagent[*n]...  (made 0 = makes no item, e.g. an enchant)",
        "ns.SKILLUP_PACKED = [[",
    ] + chunks(parts) + [
        "]]",
        "-- recipe item:spell it teaches",
        "ns.SKILLUP_ITEMS = [[",
    ] + chunks(items) + ["]]", ""])
    tmp = OUT + ".tmp"
    with io.open(tmp, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    os.replace(tmp, OUT)
    print("wrote %s (%d recipes, %d recipe items, %d bytes)" % (OUT, len(rec), len(items), len(text.encode("utf-8"))))


def main():
    args = sys.argv[1:]
    if not args or "--help" in args:
        print(__doc__)
        return
    b = args[args.index("--build") + 1] if "--build" in args else gd.latest_build("wowf")
    print("forever build %s" % b)
    rec, teach = build(b, True)
    ok = controls(rec, teach)
    if "--emit" in args:
        if not ok:
            gd.die("a positive control failed; nothing written")
        emit(b, rec, teach)


if __name__ == "__main__":
    main()
