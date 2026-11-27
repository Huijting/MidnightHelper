# -*- coding: utf-8 -*-
"""Class reagents and ammunition for WoW Forever -> Modules/ForeverClassVendorData.lua (read by ForeverClassVendors.lua
and ForeverVendors.lua: Find -> "Class reagents" / "Arrows" / "Bullets").

Rob, 27 Nov 2026, via Sparring 27-11, verbatim: "nr 4 ja" (idea 4: where you buy class reagents and ammo, the nearest
vendor with the arrow; Pathfinder Forever and MMOBoom are NOT sources).

What comes from where:
  Which reagent a spell uses, and from which level: Blizzard's DB2 (wago.tools, product wowf, tools/gamedata.py):
    SpellReagents.Reagent_0 and SpellLevels.BaseLevel, per spell id listed in SPELLS below. The spell ids are the
    candidates; the reagent each one MUST use is checked here (a mismatch stops --emit). GEMETEN at generation.
  Ammo items and their level: ItemSparse.RequiredLevel + Display_lang, same build.
  Vendors: Zygor Forever, on disk, ZygorGuidesViewerForever/Data-Forever/NPCData.lua, the ready lists ["Reagents"],
    ["VendorReagent"], ["Arrows"], ["VendorArrows"], ["Bullets"], ["VendorBullets"] (Rob 22 Nov 2026: ids, places and
    order from Zygor may be taken over; no texts or code). Names: Localization-Forever/NPCs_enUS.lua (the game shows
    its own name; ForeverVendors.lua). One place per npc: the first list that has it.
  The ammo tier per vendor: the condition Zygor puts on ["Arrows"]/["Bullets"]: clevel<10 = 1 (Rough/Light),
  clevel<25 = 2 (Sharp/Heavy), clevel<40 = 3 (Razor/Solid), none = 4 (Jagged/Accurate). That those mean "this vendor's
  best ammo" is AFGELEID from QuestieDB's vendor lists (mh-research 27 Nov 2026: 15/16, 28/28, 9/9, 22/22).
  A vendor only in a Vendor* list has no tier (shown only when you need the lowest ammo).
Left out: Alterac Valley (a battleground), lines Zygor itself commented out, the Redridge old-frame shift as in
tools/forever_repair.py.

Usage (front door): run forever_classvendors           numbers + controls, writes nothing
                    run forever_classvendors --emit    write the data file
"""
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402
import forever_reagents as fr  # noqa: E402

ZYG = r"E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever"
NPCDATA = os.path.join(ZYG, "Data-Forever", "NPCData.lua")
NAMES = os.path.join(ZYG, "Localization-Forever", "NPCs_enUS.lua")
OUT = os.path.join(ROOT, "Modules", "ForeverClassVendorData.lua")
SHIFT = {1433: (-5.15, 0.0)}
SKIP_MAPS = {1459}
SIDE = {"A": "A", "H": "H", "B": "both"}
ROW = re.compile(r"^\s*(\d+)=s([AHB])\|m(\d+)\|x([\d.]+)\|y([\d.]+)(?:\|([^-\s]*))?")

# Per class: (mode, reagent item that every spell must use, [spell ids]). mode "any" = any known spell needs that item;
# "rank" = the spells are ranks, each with its own reagent (the item here is None; DB2 decides), the highest known counts.
SPELLS = {
    "MAGE": [("any", 17031, [3561, 3562, 3563, 3565, 3566, 3567, 1297659]),  # Teleport: ... -> Rune of Teleportation
             ("any", 17032, [10059, 11416, 11417, 11418, 11419, 11420]),  # Portal: ... -> Rune of Portals
             ("any", 17020, [23028])],  # Arcane Brilliance -> Arcane Powder
    "PRIEST": [("any", 17028, [21562]),  # Prayer of Fortitude 1 -> Holy Candle
               ("any", 17029, [21564, 27683, 27681])],  # -> Sacred Candle
    "PALADIN": [("any", 17033, [19752]),  # Divine Intervention -> Symbol of Divinity
                ("any", 21177, [25782, 25916, 25894, 25918, 25898])],  # Greater Blessings -> Symbol of Kings
    "SHAMAN": [("any", 17030, [20608])],  # Reincarnation -> Ankh
    "DRUID": [("rank", None, [20484, 20739, 20742, 20747, 20748]),  # Rebirth ranks -> the seeds
              ("rank", None, [21849, 21850])],  # Gift of the Wild -> Wild Berries / Wild Thornroot
    "WARLOCK": [("any", 5565, [1122]),  # Inferno -> Infernal Stone
                ("any", 16583, [18540])],  # Ritual of Doom -> Demonic Figurine
    "ROGUE": [("any", 5140, [1856, 1857])],  # Vanish -> Flash Powder (sold where Thieves' Tools are: vendor "thief")
}
AMMO = {"arrows": [2512, 2515, 3030, 11285], "bullets": [2516, 2519, 3033, 11284]}
LISTS = [("Reagents", "reagent"), ("VendorReagent", "reagent"), ("Arrows", "arrows"), ("VendorArrows", "arrows"),
         ("Bullets", "bullets"), ("VendorBullets", "bullets")]
I = fr.I


def tier_of(cond):
    if not cond:
        return 4
    m = re.match(r"clevel<(\d+)", cond)
    return {10: 1, 25: 2, 40: 3}.get(int(m.group(1))) if m else None


def vendors():
    text = io.open(NPCDATA, encoding="utf-8", errors="replace").read()
    names = {}
    for line in io.open(NAMES, encoding="utf-8", errors="replace"):
        n = re.match(r'\s*\[(\d+)\]\s*=\s*"((?:\\.|[^"\\])*)"', line)
        if n:
            names[int(n.group(1))] = n.group(2).replace('\\"', '"')
    rows, counts = {}, {}
    for block, kind in LISTS:
        m = re.search(r'\["%s"\]\s*=\s*\[\[(.*?)\]\]' % block, text, re.S)
        if not m:
            gd.die("no %s block in %s" % (block, NPCDATA))
        n = 0
        tiered = block in ("Arrows", "Bullets")
        for line in m.group(1).split("\n"):
            if line.strip().startswith("--") or not line.strip():
                continue
            r = ROW.match(line)
            if not r:
                continue
            npc, side, mp, x, y = int(r.group(1)), r.group(2), int(r.group(3)), float(r.group(4)), float(r.group(5))
            if mp in SKIP_MAPS:
                continue
            if mp in SHIFT and npc < 200000:
                x, y = x + SHIFT[mp][0], y + SHIFT[mp][1]
            key = (kind, npc)
            if key not in rows:
                rows[key] = {"kind": kind, "npc": npc, "name": names.get(npc), "side": SIDE[side], "map": mp,
                             "x": round(x, 2), "y": round(y, 2), "tier": None}
                n += 1
            if tiered:
                t = tier_of(r.group(6))
                if t and (rows[key]["tier"] is None or t > rows[key]["tier"]):
                    rows[key]["tier"] = t
        counts[block] = n
    # A name Zygor's name list lacks: the Wowhead Forever tooltip (cached 3 days by tools/gamedata.py), as
    # tools/forever_repair.py does. Still none = the row keeps no name (the window then says the category).
    import json
    for v in rows.values():
        if v["name"]:
            continue
        url = "https://nether.wowhead.com/forever/tooltip/npc/%d" % v["npc"]
        cpath = os.path.join(gd.CACHE, "tooltip", "forever", "npc", "%d.enUS.json" % v["npc"])
        data, _ = gd.fetch(url, cpath, 3 * 86400, soft404=True)
        try:
            j = json.loads(data.decode("utf-8")) if data else None
        except ValueError:
            j = None
        if j and j.get("name"):
            v["name"] = j["name"]
    return rows, counts


def reagents(b):
    sr = {}
    for r in fr.rows(b, "SpellReagents"):
        sr[I(r["SpellID"])] = (I(r.get("Reagent_0")), I(r.get("ReagentCount_0")))
    lv = {I(r["SpellID"]): I(r.get("BaseLevel")) for r in fr.rows(b, "SpellLevels")}
    names = {I(r["ID"]): r["Name_lang"] for r in fr.rows(b, "SpellName")}
    out, bad = {}, []
    for cls, groups in SPELLS.items():
        for mode, item, spells in groups:
            g = {"mode": mode, "rows": []}
            for s in spells:
                got = sr.get(s, (0, 0))[0]
                if not got or (item and got != item):
                    bad.append("%s %d %s: reagent %s, expected %s" % (cls, s, names.get(s), got, item))
                    continue
                g["rows"].append((s, got, lv.get(s, 0), names.get(s)))
            if g["rows"]:
                out.setdefault(cls, []).append(g)
    return out, bad


def ammo(b):
    sparse = {I(r["ID"]): r for r in fr.rows(b, "ItemSparse")}
    out = {}
    for kind, ids in AMMO.items():
        out[kind] = [(i, I(sparse[i].get("RequiredLevel")), sparse[i].get("Display_lang")) for i in ids if i in sparse]
    return out


def main():
    args = sys.argv[1:]
    b = args[args.index("--build") + 1] if "--build" in args else gd.latest_build("wowf")
    print("forever build %s" % b)
    rows, counts = vendors()
    print("Zygor lists (rows new to MH's list): %s" % counts)
    by = {}
    for (kind, _), v in rows.items():
        by.setdefault(kind, []).append(v)
    for kind, lst in sorted(by.items()):
        tiers = {}
        for v in lst:
            tiers[v["tier"]] = tiers.get(v["tier"], 0) + 1
        print("  %-8s %3d vendors (A %d, H %d, both %d), tiers %s, without a name %d" % (
            kind, len(lst), sum(v["side"] == "A" for v in lst), sum(v["side"] == "H" for v in lst),
            sum(v["side"] == "both" for v in lst), tiers, sum(1 for v in lst if not v["name"])))
    rg, bad = reagents(b)
    for cls, groups in rg.items():
        for g in groups:
            print("  %-8s %-4s %s" % (cls, g["mode"], ", ".join("%d %s -> %d (L%d)" % (s, n, it, l) for s, it, l, n in g["rows"])))
    print("  spells whose reagent did not match: %d" % len(bad))
    for x in bad:
        print("     " + x)
    am = ammo(b)
    for kind, lst in am.items():
        print("  %-8s %s" % (kind, ", ".join("%d %s (L%d)" % (i, n, l) for i, l, n in lst)))
    # Positive controls: Kyra Boucher (Stormwind reagents), a top-tier arrow vendor, Teleport: Orgrimmar -> Rune of
    # Teleportation at level 20, Rough Arrow at level 1.
    ok = ("reagent", 1275) in rows and any(v["kind"] == "arrows" and v["tier"] == 4 for v in rows.values())
    ok = ok and any(s == 3567 and it == 17031 and l == 20 for g in rg.get("MAGE", []) for s, it, l, _ in g["rows"])
    ok = ok and am["arrows"] and am["arrows"][0][:2] == (2512, 1)
    print("controls (1275 reagent vendor, a tier-4 arrow vendor, 3567 -> 17031 L20, Rough Arrow L1): %s" % (
        "OK" if ok else "FAIL"))
    if "--emit" not in args:
        return
    if not ok or bad:
        gd.die("a control failed or a reagent did not match; nothing written")

    def q(s):
        return ('"%s"' % s.replace('\\', '\\\\').replace('"', '\\"')) if s else "nil"
    out = ["local _, ns = ...", "",
           "-- GENERATED by tools/forever_classvendors.py --emit (rule and sources in its header). Do not edit by hand.",
           "-- DB2 build %s (reagents per spell, levels, ammo); vendors from Zygor Forever NPCData.lua." % b,
           "", "if not ns.IS_FOREVER then", "\treturn", "end", "",
           "-- [class] = { { mode = any|rank, { spell, item, level } ... } }: any = any known spell needs the item;",
           "-- rank = ranks of one spell, the highest you know decides the item.",
           "ns.FOREVER_CLASS_REAGENTS = {"]
    for cls in sorted(rg):
        out.append("\t%s = {" % cls)
        for g in rg[cls]:
            out.append('\t\t{ mode = "%s", %s },' % (g["mode"], ", ".join(
                "{ %d, %d, %d }" % (s, it, l) for s, it, l, _ in g["rows"])))
        out.append("\t},")
    out += ["}", "", "-- ammo item per tier: { item, required level }", "ns.FOREVER_AMMO = {"]
    for kind in ("arrows", "bullets"):
        out.append("\t%s = { %s }," % (kind, ", ".join("{ %d, %d }" % (i, l) for i, l, _ in am[kind])))
    out += ["}", "", "ns.FOREVER_CLASS_VENDORS = {"]
    for key in sorted(rows, key=lambda k: (k[0], k[1])):
        v = rows[key]
        out.append('\t{ kind = "%s", npc = %d, name = %s, side = "%s", map = %d, x = %s, y = %s%s },' % (
            v["kind"], v["npc"], q(v["name"]), v["side"], v["map"], v["x"], v["y"],
            (", tier = %d" % v["tier"]) if v["tier"] else ""))
    out += ["}", ""]
    with io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out))
    os.replace(OUT + ".tmp", OUT)
    print("wrote %s (%d vendors)" % (OUT, len(rows)))


if __name__ == "__main__":
    main()
