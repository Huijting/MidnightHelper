"""Waylaid Crates for WoW Forever -> Modules/ForeverCratesData.lua (read by Modules/ForeverCrates.lua).

Rob, 21 Nov 2026 (via sparring): "Waylaid crates zijn het ... wat zijn dat? En ik denk dat wij er ook iets mee moeten."
On the options (advice: middle): "Ja doe maar".

Sources, all GEMETEN by this script on every run (nothing typed over from a summary):
  - wago.tools DB2 (Forever build, tools/gamedata.py's cache): ItemSparse (names, required level, quality) and Item
    (class id, to tell a trade good from a quest item of the same name).
  - nether.wowhead.com/forever/tooltip/item/<id>: the crate's own "Fill the crate with any bundle from the following
    list" lines. That list is in the item's spell text, which the client shows in the same tooltip.
  - nether.wowhead.com/forever/tooltip/npc/<id>: the two trade representatives' spawn points.

Usage (front door): run forever_crates          numbers, writes nothing
                    run forever_crates --emit   write the data file
"""
import csv
import io
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402

OUT = os.path.join(ROOT, "Modules", "ForeverCratesData.lua")
TYPED = list(range(248682, 248700)) + list(range(248702, 248714))
SEALED = list(range(248765, 248780))
EMPTY = 248549
LABELS = {"A": 280179, "H": 280180}
REPS = {"A": 256390, "H": 256386}
BUNDLE = re.compile(r"^-\s*(\d+)\s+(.+?)\s*$")


def table(name):
    build = gd.latest_build("wowf")
    url = "https://wago.tools/db2/%s/csv?build=%s" % (name, build)
    data, _ = gd.fetch(url, os.path.join(gd.CACHE, "db2", build, "%s.enUS.csv" % name), None)
    return build, list(csv.DictReader(io.StringIO(data.decode("utf-8-sig", "replace"))))


def tip(kind, i):
    url = "https://nether.wowhead.com/forever/tooltip/%s/%d" % (kind, i)
    data, _ = gd.fetch(url, os.path.join(gd.CACHE, "tooltip", "forever", kind, "%d.enUS.json" % i), 3 * 86400,
                       soft404=True)
    if not data:
        return None
    try:
        return json.loads(data.decode("utf-8"))
    except ValueError:
        return None


def main():
    build, sparse = table("ItemSparse")
    _, items = table("Item")
    by_id = {int(r["ID"]): r for r in sparse}
    cls = {int(r["ID"]): int(r.get("ClassID") or -1) for r in items}
    by_name = {}
    for r in sparse:
        by_name.setdefault(r["Display_lang"], []).append(int(r["ID"]))
    print("build %s: ItemSparse %d rows, Item %d rows" % (build, len(sparse), len(items)))

    crates, problems = [], []
    for cid in TYPED:
        row = by_id.get(cid)
        j = tip("item", cid)
        if not row or not j:
            problems.append("crate %d: no DB2 row or no tooltip" % cid)
            continue
        lines = gd.strip_html(j.get("tooltip"))
        bundles = []
        for ln in lines:
            m = BUNDLE.match(ln.replace("&quot;", '"'))
            if not m:
                continue
            n, name = int(m.group(1)), m.group(2)
            ids = by_name.get(name, [])
            # A name can belong to several items (an old quest copy, a test item): prefer a trade good (class 7),
            # then the lowest id. Every choice among several is printed.
            good = [i for i in ids if cls.get(i) == 7] or ids
            if not good:
                problems.append("crate %d: '%s' has no item id" % (cid, name))
                continue
            pick = min(good)
            if len(ids) > 1:
                print("   note: '%s' = ids %s, took %d (class %s)" % (name, ids, pick, cls.get(pick)))
            bundles.append((n, pick, name))
        if not bundles:
            problems.append("crate %d: no bundle lines read" % cid)
        crates.append((cid, row["Display_lang"], int(row.get("RequiredLevel") or 0),
                       int(row.get("OverallQualityID") or -1), bundles))
    for c in crates:
        print("%d q%d L%d %s: %s" % (c[0], c[3], c[2], c[1], "; ".join("%d %s (%d)" % (n, nm, i) for n, i, nm in c[4])))

    sealed = []
    for sid in SEALED:
        row = by_id.get(sid)
        if row:
            sealed.append((sid, row["Display_lang"], int(row.get("OverallQualityID") or -1)))
            print("sealed %d q%s %s" % (sid, row.get("OverallQualityID"), row["Display_lang"]))
        else:
            problems.append("sealed %d: no DB2 row" % sid)
    for k, i in [("empty", EMPTY)] + sorted(LABELS.items()):
        row = by_id.get(i)
        print("%s %d: %s" % (k, i, row and row["Display_lang"]))

    reps = {}
    for side, npc in sorted(REPS.items()):
        j = tip("npc", npc)
        if not j:
            problems.append("npc %d: no tooltip" % npc)
            continue
        m = j.get("map") or {}
        pts = []
        for _f, p in (m.get("coords") or {}).items():
            pts += p
        sub = gd.strip_html(j.get("tooltip"))
        print("rep %s %d %s | %s | zone %s | spawns %s" % (side, npc, j.get("name"), " / ".join(sub[1:3]), m.get("zone"),
                                                            pts))
        reps[side] = (npc, j.get("name"), pts)

    # Positive control: the Apprentice Herbs crate must hold 10 Earthroot (2449), measured in its tooltip 21 Nov 2026.
    ctl = [c for c in crates if c[0] == 248682 and any(i == 2449 and n == 10 for n, i, _ in c[4])]
    print("control 248682 has 10 Earthroot (2449):", bool(ctl))
    for p in problems:
        print("PROBLEM: " + p)
    if not ctl:
        sys.exit("positive control failed; nothing written")
    if "--emit" in sys.argv:
        if problems:
            sys.exit("problems above; nothing written")
        out = ["local _, ns = ...", "",
               "-- GENERATED by tools/forever_crates.py --emit from wago DB2 (Forever %s: ItemSparse, Item) and" % build,
               "-- Wowhead Forever item tooltips (the crate's bundle list). Do not edit by hand.",
               "", "if not ns.IS_FOREVER then", "\treturn", "end", "",
               "-- [crate item id] = { level = required level, quality = item quality, b = { { count, item id }, ... } }",
               "ns.FOREVER_CRATES = {"]
        for cid, name, lvl, q, bundles in crates:
            out.append("\t[%d] = { level = %d, quality = %d, b = { %s } }, -- %s" % (
                cid, lvl, q, ", ".join("{ %d, %d }" % (n, i) for n, i, _ in bundles), name))
        out += ["}", "", "-- Filled and sealed crates: deliver these.",
                "ns.FOREVER_CRATES_SEALED = {"]
        for sid, name, q in sealed:
            out.append("\t[%d] = %d, -- %s (quality)" % (sid, q, name))
        out += ["}", ""]
        with io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(out))
        os.replace(OUT + ".tmp", OUT)
        print("wrote " + OUT)


if __name__ == "__main__":
    main()
