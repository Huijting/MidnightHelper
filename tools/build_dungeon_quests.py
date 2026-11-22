"""build_dungeon_quests.py -- WoW Forever: the quests to pick up before each dungeon, from Zygor's local guides.

Rob, 21 Nov 2026 (via sparring, verbatim): "ik blijf bij Zygor, Polestar probeer ik later. maar kunnen wij er iets van
leren / verbeteren" -> "2 en 1, doe maar, daarna 3 en 4 :)". Point 2 = per dungeon "pick these quests up first", with
the quest giver, Show the way, and whether you already did it / have it in your log.

Sources (own, not Polestar = GPLv3, not FlowUp = all rights reserved):
  - Zygor Forever, Guides-Forever/Dungeons/ZygorDungeon{Alliance,Horde}CLASSIC.lua, the "Dungeon Guides\\Dungeon
    Quests\\..." guides: FACTS ONLY - quest id, NPC id, the |goto on the accept line, the order, and whether the step says
    "_Inside the ... Dungeon:_". No Zygor text (titles, names, tips) goes into MH (sparring 21 Nov: "neem alleen feiten
    mee ... geen Zygor-zinnen of -notities in MH's bestanden").
  - Spoken_Quests/Data/Compendium.lua (Rob, 16 Nov: Spoken counts as a source for givers and chains): `prev` (the quest
    before it) and the English quest title, used only as the fallback when the client has no title yet.
  - Wowhead Forever tooltips (tools/gamedata.py's fetch + cache): NPC names per language (Blizzard's names), and the
    English title of a quest Spoken does not have.
Zone names -> UiMap ids: wago UiMap, Forever build (ZONES below, GEMETEN with `run gamedata db2 UiMap`).

Output: Modules/ForeverDungeonQuestsData.lua (atomic write). Report on stdout: per dungeon how many quests, which zone
names had no map id, and quests without coordinates.

    run build_dungeon_quests            report only
    run build_dungeon_quests --write    report + write the Lua file
"""
import io
import os
import re
import sys

FOREVER = r"E:\World of Warcraft\_forever_\Interface\AddOns"
ZYG = os.path.join(FOREVER, "ZygorGuidesViewerForever", "Guides-Forever", "Dungeons")
SPOKEN = os.path.join(FOREVER, "Spoken_Quests", "Data", "Compendium.lua")
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, "Modules", "ForeverDungeonQuestsData.lua")

# Zygor guide title (after "Dungeon Quests\\") -> the key in ForeverDungeons.lua's DUNGEONS.
GUIDE_KEY = {
    "Ragefire Chasm Quests": "RFC",
    "Hall of Thanes Quests": "THANES",
    "Wailing Caverns Quests": "WC",
    "The Deadmines Quests": "DM",
    "Ruins of Lordaeron Quests": "LORDAERON",
    "Shadowfang Keep Quests": "SFK",
    "Blackfathom Deeps Quests": "BFD",
    "Excavation Site Quests": "EXCAVATION",
    "The Stockade Quests": "STOCKS",
    "Gnomeregan Quests": "GNOMER",
    "Razorfen Kraul Quests": "RFK",
    "City of Dalaran Quests": "DALARAN",
    "Scarlet Monastery Graveyard Quests": "SM_GY",
    "Scarlet Monastery Library Quests": "SM_LIB",
    "Scarlet Monastery Armory Quests": "SM_ARM",
    "Scarlet Monastery Cathedral Quests": "SM_CATH",
    "Razorfen Downs Quests": "RFD",
    "The Drowned City Quests": "DROWNED",
    "Uldaman Quests": "ULDA",
    "Krol'dok Stronghold": "KROLDOK",
    "Zul'Farrak Quests": "ZF",
    "Maraudon Quests": "MARA",
    "Temple of Atal'Hakkar Quests": "ST",
    "Blackrock Depths Quests": "BRD",
    "Dire Maul East Quests": "DM_E",
    "Dire Maul West Quests": "DM_W",
    "Dire Maul North Quests": "DM_N",
    "Lower Blackrock Spire Quests": "LBRS",
    "Upper Blackrock Spire Quests": "UBRS",
    "Scholomance Quests": "SCHOLO",
    "Stratholme - Live Side Quests": "STRAT_LIVE",
    "Stratholme - Undead Side Quests": "STRAT_UD",
}

# Zygor zone name -> UiMap id (wago UiMap, Forever). Filled from the report; a missing name prints below.
# GEMETEN 21 Nov 2026: `run gamedata db2 UiMap Name_lang=... --game forever`, build 1.60.1.71037, all Type 3 (zone).
ZONES = {
    "Durotar": 1411, "Mulgore": 1412, "The Barrens": 1413, "Alterac Mountains": 1416, "Badlands": 1418,
    "Blasted Lands": 1419, "Tirisfal Glades": 1420, "Silverpine Forest": 1421, "Western Plaguelands": 1422,
    "Eastern Plaguelands": 1423, "Hillsbrad Foothills": 1424, "The Hinterlands": 1425, "Dun Morogh": 1426,
    "Searing Gorge": 1427, "Burning Steppes": 1428, "Elwynn Forest": 1429, "Duskwood": 1431, "Loch Modan": 1432,
    "Redridge Mountains": 1433, "Stranglethorn Vale": 1434, "Swamp of Sorrows": 1435, "Westfall": 1436,
    "Wetlands": 1437, "Darkshore": 1439, "Ashenvale": 1440, "Thousand Needles": 1441, "Stonetalon Mountains": 1442,
    "Desolace": 1443, "Feralas": 1444, "Dustwallow Marsh": 1445, "Tanaris": 1446, "Azshara": 1447,
    "Un'Goro Crater": 1449, "Moonglade": 1450, "Winterspring": 1452, "Stormwind City": 1453, "Orgrimmar": 1454,
    "Ironforge": 1455, "Thunder Bluff": 1456, "Darnassus": 1457, "Undercity": 1458, "Riverglades": 2548,
}
# Zygor's own slips, corrected where the other sources agree: (side, guide key, the id Zygor writes) -> the real id.
# 22 Nov 2026 (the 5.8.0 Fable round, checked by the build chat): Zygor's Horde Scholomance guide accepts ##5803 at
# Apothecary Dithers. 5803 is the Alliance quest; the Horde's is 5804 (GEMETEN: Spoken races + prev 5802, and the
# Wowhead Forever tooltips: 5804 goes back to Dithers at the Bulwark, 5803 to Arbington at Chillwind Point).
QUEST_FIX = {("Horde", "SCHOLO", 5803): 5804}
# A |goto on an instance map (no UiMap of type zone): the quest is picked up inside.
INSTANCE_ZONES = {"Zul'Farrak"}

CLASSES = ("Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid")

RE_GUIDE = re.compile(r'^ZygorGuidesViewer:RegisterGuide\("Dungeon Guides\\\\Dungeon Quests\\\\([^"]+)"')
RE_ANY_GUIDE = re.compile(r'^ZygorGuidesViewer:RegisterGuide\(')
RE_TALK = re.compile(r"^\s*talk ([^#|]+)##(\d+)")
RE_ACCEPT = re.compile(r"^\s*'?\|?accept ([^#|]+)##(\d+)(.*)$")
RE_GOTO = re.compile(r"\|goto ([^|]+?)(?:/\d+)? (\d+(?:\.\d+)?),(\d+(?:\.\d+)?)")
RE_USE = re.compile(r"^\s*use ([^#|]+)##(\d+)")
RE_CLICK = re.compile(r"^\s*click ([^#|]+)##(\d*)")
RE_COLLECT = re.compile(r"^\s*collect (?:\d+ )?([^#|]+)##(\d+)")
RE_ONLY = re.compile(r"^\s*\|only if (.+)$")


def read(p):
    return io.open(p, encoding="utf-8", errors="replace").read()


def spoken_prev():
    out = {}
    for m in re.finditer(r"^\s*\[(\d+)\] = \{ \"((?:[^\"\\]|\\.)*)\"(.*)\},?\s*$", read(SPOKEN), re.M):
        q, rest = int(m.group(1)), m.group(3)
        pm = re.search(r"prev = (\d+)", rest)
        dm = re.search(r"dungeon = (\d+)", rest)
        out[q] = {"prev": int(pm.group(1)) if pm else None, "dungeon": int(dm.group(1)) if dm else None,
                  "title": m.group(2).replace('\\"', '"')}
    return out


sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gamedata  # noqa: E402  (fetch + cache of the Wowhead tooltips)
import json  # noqa: E402
import urllib.parse  # noqa: E402


def wh_name(kind, i, loc="enUS"):
    """Blizzard's name of an npc/quest from the Wowhead Forever tooltip, or None."""
    url = "https://nether.wowhead.com/forever/tooltip/%s/%d" % (kind, i)
    if loc != "enUS":
        url += "?" + urllib.parse.urlencode({"locale": loc})
    cpath = os.path.join(gamedata.CACHE, "tooltip", "forever", kind, "%d.%s.json" % (i, loc))
    data, _ = gamedata.fetch(url, cpath, 30 * 86400, soft404=True)
    if not data:
        return None
    try:
        j = json.loads(data.decode("utf-8"))
    except Exception:
        return None
    n = j and j.get("name")
    return n.strip() if isinstance(n, str) and n.strip() else None


def parse(path, side):
    guides = {}
    cur = None
    step = None
    for raw in read(path).splitlines():
        m = RE_GUIDE.match(raw)
        if m:
            cur = guides.setdefault(m.group(1), [])
            step = {"talk": None, "inside": False, "use": None, "click": None, "classes": None, "goto": None}
            continue
        if RE_ANY_GUIDE.match(raw):
            cur = None
            continue
        if cur is None:
            continue
        line = raw.strip()
        if line == "step":
            step = {"talk": None, "inside": False, "use": None, "click": None, "classes": None, "goto": None}
            continue
        if line.startswith("_Inside"):
            step["inside"] = True
        t = RE_TALK.match(line)
        if t:
            step["talk"] = (t.group(1).strip(), int(t.group(2)))
            g = RE_GOTO.search(line)
            if g:
                step["goto"] = g
            continue
        u = RE_USE.match(line)
        if u:
            step["use"] = (u.group(1).strip(), int(u.group(2)))
        c = RE_CLICK.match(line)
        if c:
            step["click"] = c.group(1).strip()
        o = RE_ONLY.match(line)
        if o:
            words = o.group(1).replace("NightElf", "").split()
            cls = [w for w in words if w in CLASSES]
            if cls and all(w in CLASSES or w in ("and", "or") for w in words):
                step["classes"] = cls
                for prior in step.get("accepts", []):  # Zygor puts "|only if" after the accept line
                    prior["classes"] = cls
        a = RE_ACCEPT.match(line)
        if a:
            name, q, rest = a.group(1).strip(), int(a.group(2)), a.group(3)
            g = RE_GOTO.search(rest) or step["goto"]
            e = {"q": q, "name": name, "side": side, "inside": step["inside"], "classes": step["classes"]}
            if g:
                e["zone"], e["x"], e["y"] = g.group(1).strip(), float(g.group(2)), float(g.group(3))
            if step["talk"]:
                e["npc"], e["npcId"] = step["talk"]
            elif step["use"]:
                e["item"], e["itemId"] = step["use"]
            elif step["click"]:
                e["object"] = step["click"]
            cur.append(e)
            step.setdefault("accepts", []).append(e)
            continue
        if "|goto" in line and step["goto"] is None:
            g = RE_GOTO.search(line)
            if g:
                step["goto"] = g
    return guides


NPC_LOCALES = ("deDE", "frFR", "esES", "ptBR", "ruRU")


def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def main():
    write = "--write" in sys.argv
    prev = spoken_prev()
    by_key = {}
    unknown_guides = []
    for side, fn in (("Alliance", "ZygorDungeonAllianceCLASSIC.lua"), ("Horde", "ZygorDungeonHordeCLASSIC.lua")):
        for title, entries in parse(os.path.join(ZYG, fn), side).items():
            key = GUIDE_KEY.get(title)
            if not key:
                unknown_guides.append(title)
                continue
            lst = by_key.setdefault(key, [])
            for e in entries:
                e["q"] = QUEST_FIX.get((side, key, e["q"]), e["q"])
                lst.append(e)

    missing_zones, no_coords, total = {}, [], 0
    title_src = {"spoken": 0, "wowhead": 0, "none": 0}
    npcs = set()
    lines = []
    for key in sorted(by_key):
        entries = by_key[key]
        # One row per quest id; a quest both sides take becomes side = nil.
        merged, order = {}, []
        for e in entries:
            if e["q"] in merged:
                m = merged[e["q"]]
                if m["side"] != e["side"]:
                    m["side"] = None
                continue
            merged[e["q"]] = dict(e)
            order.append(e["q"])
        lines.append("\t%s = {" % key)
        for q in order:
            e = merged[q]
            total += 1
            # The English title is only the fallback while the client has none: Spoken's, else Wowhead's (never Zygor's).
            title = prev.get(q, {}).get("title") or wh_name("quest", q)
            if title:
                title_src["spoken" if prev.get(q, {}).get("title") else "wowhead"] += 1
            else:
                title_src["none"] += 1
            parts = ["q = %d" % q] + (["en = %s" % lua_str(title)] if title else [])
            if e["side"]:
                parts.append('side = "%s"' % e["side"])
            if e.get("npcId"):
                parts.append("npc = %d" % e["npcId"])
                npcs.add(e["npcId"])
            elif e.get("itemId"):
                parts.append("item = %d" % e["itemId"])
            elif e.get("object"):
                parts.append("object = true")
            if e.get("zone") in INSTANCE_ZONES:
                e["inside"] = True
            elif e.get("zone"):
                m = ZONES.get(e["zone"])
                if m is None:
                    missing_zones[e["zone"]] = missing_zones.get(e["zone"], 0) + 1
                else:
                    parts.append("m = %d, x = %.2f, y = %.2f" % (m, e["x"], e["y"]))
            elif not e["inside"]:
                no_coords.append("%s %d" % (key, q))
            if e["inside"]:
                parts.append("inside = true")
            if e["classes"]:
                parts.append("classes = { %s }" % ", ".join('"%s"' % c.upper() for c in e["classes"]))
            p = prev.get(q, {}).get("prev")
            if p:
                parts.append("prev = %d" % p)
            lines.append("\t\t{ %s }," % ", ".join(parts))
        lines.append("\t},")
        print("%-11s %3d quests" % (key, len(order)))
    print("total %d quest rows over %d dungeons" % (total, len(by_key)))
    if unknown_guides:
        print("guides without a key:", unknown_guides)
    if missing_zones:
        print("zone names without a map id:")
        for z, n in sorted(missing_zones.items()):
            print("   %r: %d" % (z, n))
    if no_coords:
        print("outside the dungeon but no coordinates (%d):" % len(no_coords))
        for s in no_coords:
            print("   " + s)
    print("English fallback titles: %(spoken)d Spoken, %(wowhead)d Wowhead, %(none)d none" % title_src)
    # NPC names per client language: Blizzard's names from the Wowhead Forever tooltips (enUS always; another language
    # only where it differs). An npc Wowhead does not know gets no name: the row then shows the zone only.
    en = {i: wh_name("npc", i) for i in sorted(npcs)}
    print("NPC names enUS: %d of %d" % (sum(1 for v in en.values() if v), len(en)))
    nl = ["ns.FOREVER_DUNGEON_QUEST_NPCS = {"]
    for loc in ("enUS",) + NPC_LOCALES:
        names = en if loc == "enUS" else {i: wh_name("npc", i, loc) for i in sorted(npcs)}
        hits = [(i, n) for i, n in sorted(names.items()) if n and (loc == "enUS" or n != en.get(i))]
        print("NPC names %s: %d own" % (loc, len(hits)))
        nl.append("\t%s = {" % loc)
        for i, n in hits:
            nl.append("\t\t[%d] = %s," % (i, lua_str(n)))
        nl.append("\t},")
    nl.append("}")
    if write:
        if missing_zones:
            sys.exit("not written: fill ZONES first")
        head = io.open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "build_dungeon_quests_head.lua"),
                       encoding="utf-8").read()
        text = (head + "ns.FOREVER_DUNGEON_QUESTS = {\n" + "\n".join(lines) + "\n}\n\n" + "\n".join(nl) + "\n")
        io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n").write(text)
        os.replace(OUT + ".tmp", OUT)
        print("written:", OUT)


if __name__ == "__main__":
    main()
