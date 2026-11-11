# -*- coding: utf-8 -*-
"""WoW Forever: which items are an ingredient (reagent) for which profession -> Modules/ForeverReagentData.lua.

Rob, 11 Nov 2026 (via the sparring chat, "Ja, laat bouwen"; here "Ja, met probe-fix"): at a vendor he doubted whether
Stringy Wolf Meat was good for anything, and took Meaty Bat Wing for a Leatherworking item (it is Cooking). The
tooltip now says it: "MH: Used for Cooking (you have it)". His condition: "zonder dat we onze add-on onmenselijk groot
maken" -- so the data is one packed string of item:bits, a few KB.

Source: wago.tools DB2 for Forever (product wowf) through tools/gamedata.py, cached outside the repo.
  SkillLineAbility (recipe spell -> skill line)  +  SpellReagents (recipe spell -> reagent items)
  + ItemSparse (does the item exist in Forever)  +  SkillLine (the profession's name, per client language)

The rule, and why (measured on 1.60.1.70888, 11 Nov 2026; `--report` prints the numbers again):
  - Professions: the crafting ones plus Mining (smelting uses ore). Herbalism, Skinning and Fishing make nothing from
    reagents in Forever; whatever the table lists for them is printed by --report and left out.
  - A recipe counts when it and everything it uses or makes is a row in Forever's ItemSparse (leftovers of other game
    modes have no row there), and it is not a test/[DNT] spell.
  - Spell ids 400000-1199999 are left out unless --keep-mid: that range holds Season of Discovery / other-mode recipes
    (AFGELEID from the id ranges; --report prints a sample so a reader can check).
What DB2 does NOT know: at which skill you learn a recipe, and whether a trainer teaches it or it drops. So the line
says only WHICH profession, never a skill number.

Usage (front door):  run forever_reagents --report   numbers and samples, writes nothing
                     run forever_reagents --emit     write Modules/ForeverReagentData.lua
                     add --build <x> to pin another Forever build (default: the newest wago knows)
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

OUT = os.path.join(ROOT, "Modules", "ForeverReagentData.lua")
# bit order = this list; keys match ns.FOREVER_PROFS in ForeverTrainer.lua
PROFS = [("ALCHEMY", 171), ("BLACKSMITHING", 164), ("ENCHANTING", 333), ("ENGINEERING", 202),
         ("LEATHERWORKING", 165), ("TAILORING", 197), ("COOKING", 185), ("FIRSTAID", 129), ("MINING", 186)]
LEFT_OUT = {182: "Herbalism", 393: "Skinning", 356: "Fishing", 40: "Poisons (rogue class skill)"}
LOCALES = ("enUS", "deDE", "frFR", "esES", "esMX", "ptBR", "itIT", "ruRU")
# Positive controls (measured by the research helper, checked again by --report): these MUST come out like this.
CONTROLS = {2672: {"COOKING"},   # Stringy Wolf Meat
            12223: {"COOKING"},  # Meaty Bat Wing
            2589: None,          # Linen Cloth: at least Tailoring
            2770: {"MINING"}}    # Copper Ore: smelting


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


def build_data(build, keep_mid=False, report=False):
    lines = {l for _, l in PROFS} | set(LEFT_OUT)
    sla = [r for r in rows(build, "SkillLineAbility") if I(r["SkillLine"]) in lines]
    reag = defaultdict(list)
    for r in rows(build, "SpellReagents"):
        for k in range(8):
            it = I(r.get("Reagent_%d" % k))
            if it > 0:
                reag[I(r["SpellID"])].append(it)
    names = {I(r["ID"]): r["Name_lang"] for r in rows(build, "SpellName")}
    made = defaultdict(list)
    for r in rows(build, "SpellEffect"):
        if I(r["Effect"]) == 24 and I(r["SpellID"]) in reag:
            made[I(r["SpellID"])].append(I(r["EffectItemType"]))
    sparse = {I(r["ID"]): r for r in rows(build, "ItemSparse")}

    use = defaultdict(set)
    why = Counter()
    samples = defaultdict(list)
    left_out = Counter()
    acq = Counter()
    for r in sla:
        s, line = I(r["Spell"]), I(r["SkillLine"])
        if s not in reag:
            continue
        acq[(line, r.get("AcquireMethod"))] += 1
        key = None
        if line in LEFT_OUT:
            key = "gathering/other line %s" % LEFT_OUT[line]
        elif re.search(r"\(test\)|\[dnt\]|\btest\b", names.get(s, ""), re.I):
            key = "test spell"
        elif 400000 <= s < 1200000 and not keep_mid:
            key = "spell id 400000-1199999"
        elif not (all(i in sparse for i in reag[s]) and all(m in sparse for m in made.get(s, []))):
            key = "reagent or made item not in ItemSparse"
        if key:
            why[key] += 1
            if len(samples[key]) < 6:
                samples[key].append("%d %s" % (s, names.get(s, "?")))
            if line in LEFT_OUT:
                left_out[line] += 1
            continue
        why["kept"] += 1
        prof = [p for p, l in PROFS if l == line][0]
        for i in reag[s]:
            use[i].add(prof)

    if report:
        print("Forever build %s" % build)
        for k, n in why.most_common():
            print("  %-42s %5d recipes   e.g. %s" % (k, n, "; ".join(samples.get(k, [])[:4])))
        print("  AcquireMethod per line (recipes with reagents): %s" % dict(sorted(acq.items())))
        per = Counter(p for v in use.values() for p in v)
        print("  items: %d, used by 2+ professions: %d" % (len(use), sum(1 for v in use.values() if len(v) > 1)))
        print("  per profession: %s" % dict(per.most_common()))
        q = Counter(I(sparse[i]["OverallQualityID"]) for i in use if i in sparse)
        print("  by quality: %s (0 = grey)" % dict(sorted(q.items())))
    return use, sparse


def prof_names(build):
    out = {}
    want = {l: p for p, l in PROFS}
    for loc in LOCALES:
        out[loc] = {}
        for r in rows(build, "SkillLine", loc):
            if I(r["ID"]) in want:
                out[loc][want[I(r["ID"])]] = r["DisplayName_lang"]
    return out


def check_controls(use, sparse):
    bad = []
    for item, want in CONTROLS.items():
        got = use.get(item, set())
        nm = sparse.get(item, {}).get("Display_lang", "?")
        if want is None:
            ok = "TAILORING" in got
        else:
            ok = want <= got
        print("  control %d %s -> %s %s" % (item, nm, sorted(got), "OK" if ok else "FAIL"))
        if not ok:
            bad.append(item)
    return not bad


def emit(build, use, names):
    order = [p for p, _ in PROFS]
    pairs = ["%d:%d" % (i, sum(1 << order.index(p) for p in v)) for i, v in sorted(use.items())]
    chunks, cur = [], ""
    for p in pairs:
        if len(cur) + len(p) + 1 > 110:
            chunks.append(cur)
            cur = ""
        cur += p + ","
    chunks.append(cur)
    name_lines = []
    for loc in LOCALES:
        if loc == "enUS":
            continue
        en = names["enUS"]
        diff = {k: v for k, v in names[loc].items() if v and v != en.get(k)}
        body = ", ".join('%s = "%s"' % (k, diff[k].replace('"', '\\"')) for k in order if k in diff)
        name_lines.append("\t%s = { %s }," % (loc, body))
    out = [
        "local _, ns = ...",
        "",
        "-- GENERATED by tools/forever_reagents.py --emit from wago.tools DB2, Forever build %s. Do not edit by hand:" % build,
        "-- run it again for a new build. Which items are a reagent for which profession (SkillLineAbility + SpellReagents,",
        "-- only recipes whose items all exist in Forever's ItemSparse; the rule is in the generator's header).",
        "-- Read by Modules/ForeverReagentUse.lua. %d items." % len(use),
        "",
        "if not ns.IS_FOREVER then",
        "\treturn",
        "end",
        "",
        "ns.FOREVER_REAGENT_BUILD = \"%s\"" % build,
        "-- bit n (from 0) = this profession",
        "ns.FOREVER_REAGENT_ORDER = { %s }" % ", ".join('"%s"' % p for p in order),
        "-- the profession's name in that client, where it differs from English (SkillLine.DisplayName_lang, same build)",
        "ns.FOREVER_REAGENT_NAMES = {",
    ] + name_lines + [
        "}",
        "-- itemID:bits, comma separated",
        "ns.FOREVER_REAGENT_PACKED = [[",
    ] + chunks + ["]]", ""]
    text = "\n".join(out)
    tmp = OUT + ".tmp"
    with io.open(tmp, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    os.replace(tmp, OUT)
    print("wrote %s (%d items, %d bytes)" % (OUT, len(use), len(text.encode("utf-8"))))


def main():
    args = sys.argv[1:]
    if not args or "--help" in args:
        print(__doc__)
        return
    build = gd.latest_build("wowf")
    if "--build" in args:
        build = args[args.index("--build") + 1]
    use, sparse = build_data(build, keep_mid="--keep-mid" in args, report="--report" in args)
    ok = check_controls(use, sparse)
    if "--emit" in args:
        if not ok:
            gd.die("a positive control failed; nothing written")
        emit(build, use, prof_names(build))


if __name__ == "__main__":
    main()
