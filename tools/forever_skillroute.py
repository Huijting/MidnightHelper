# -*- coding: utf-8 -*-
"""The whole route 1-300 per crafting profession for WoW Forever -> Modules/ForeverSkillRouteData.lua.

Rob, 27 Nov 2026, via Sparring 27-11, verbatim: "zoek al de 4 opties goed uit en begin met 2". Option 2 = a complete
route 1-300 per profession, with a shopping list for the whole route, and where you go to the trainer (75/150/225).
Money is not part of it (Sparring: "zonder geld nu prima").

FIRST PLAN, measured and dropped the same day: take the order from Zygor's Forever profession guides. GEMETEN
27 Nov 2026: Forever's DB2 grey value equals what the Forever client itself reports (Rob's ns.db.skillupProbe, 3 of
3), and Zygor's routes ask for crafts that are already grey in Forever on 40+ steps (they read like Classic values).
So the ORDER is worked out here (ours(), below) from Blizzard's measured colours (tools/forever_skillup.py) and the
learn skill in Modules/ForeverRecipeSourceData.lua. Zygor's guides (ZygorGuidesViewerForever, Guides-Forever/
Professions/ZygorProfessions{Horde,Alliance}CLASSIC.lua; Rob 22 Nov 2026: ids, places and order may be taken over,
never texts, notes or code) only give the SET of recipes to prefer: their material choices. parse() reads them
(|learn Name##id, "_<Create N Name>_" turned into our spell id, never guessed) and --report prints where they and
Forever's data disagree.

The route's rule, per skill: a recipe still orange or yellow beats a green one; then trainer recipes (and the ones you
start with) before sold, dropped or quest recipes; then Zygor's; then the surest. A step ends at the recipe's green
point, where a better recipe becomes learnable, or at 50 / 125 / 200 (train the next rank). How many crafts, what you
know and what you have are worked out in the client (Modules/ForeverSkillup.lua, RouteText).

Usage (front door):  run forever_skillroute --report    Zygor vs Forever + our route per profession, writes nothing
                     run forever_skillroute --report --steps   the same with every step
                     run forever_skillroute --emit      write the data file (only when both controls pass)
"""
import io
import os
import re
import sys
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402
import forever_reagents as fr  # noqa: E402
import forever_skillup as fs  # noqa: E402

OUT = os.path.join(ROOT, "Modules", "ForeverSkillRouteData.lua")
ZYGOR = os.path.join("E:\\", "World of Warcraft", "_forever_", "Interface", "AddOns", "ZygorGuidesViewerForever",
                     "Guides-Forever", "Professions")
FILES = {"H": "ZygorProfessionsHordeCLASSIC.lua", "A": "ZygorProfessionsAllianceCLASSIC.lua"}
# Guide name in Zygor -> our profession key (ns.REAGENT_ORDER). Gathering guides and Mining are not crafting routes.
GUIDES = OrderedDict([("Alchemy", "ALCHEMY"), ("Blacksmithing", "BLACKSMITHING"), ("Enchanting", "ENCHANTING"),
                      ("Engineering", "ENGINEERING"), ("Leatherworking", "LEATHERWORKING"), ("Tailoring", "TAILORING"),
                      ("Cooking", "COOKING"), ("First Aid", "FIRSTAID")])
# Positive controls, read by hand in the Horde file on 27 Nov 2026: Blacksmithing starts with Rough Sharpening Stone
# (2660) up to 30, then learns Rough Grinding Stone (3320); Journeyman (150) waits for level 10.
CONTROL = ("H", "BLACKSMITHING", [("m", 2660, 30), ("l", 3320), ("m", 3320, 65)], ("r", 150, 10))

RE_GUIDE = re.compile(r'RegisterGuide\("Profession Guides\\\\([^\\"]+)\\\\([^"]+)"')
RE_SKILLMAX = re.compile(r"\|skillmax ([^,|]+),(\d+)")
RE_DING = re.compile(r"\|ding (\d+)")
RE_LEARN = re.compile(r"\|learn [^|#]*##(\d+)")
RE_CREATE = re.compile(r"^_<Create (?:(\d+) )?(.+?)>_\s*$")
RE_SKILL = re.compile(r"\|skill ([^,|]+),(\d+)")


def guides(path):
    """{guide title: [lines]} for the "(1-300)" guides in one Zygor file."""
    out, cur = {}, None
    with io.open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            m = RE_GUIDE.search(line)
            if m:
                cur = None
                if m.group(2) == "%s (1-300)" % m.group(1):
                    cur = m.group(1)
                    out[cur] = []
                continue
            if cur:
                out[cur].append(line.rstrip("\r\n"))
    return out


def norm(s):
    return re.sub(r"\s+", " ", s.strip().lower())


def candidates(name):
    n = norm(name)
    c = [n]
    if n.endswith("es"):
        c.append(n[:-2])
    if n.endswith("s"):
        c.append(n[:-1])
    c.append(re.sub(r"^(\w+?)s of ", r"\1 of ", n))  # "Filets of Redgill" -> "Filet of Redgill"
    return c


def name_maps(b, rec):
    spell_names = {fr.I(r["ID"]): r["Name_lang"] for r in fr.rows(b, "SpellName")}
    item_names = {fr.I(r["ID"]): r.get("Display_lang") or "" for r in fr.rows(b, "ItemSparse")}
    per = {}
    for s, (p, y, g, prod, rg) in rec.items():
        key = fs.PROFS[p - 1][0]
        m = per.setdefault(key, {})
        for n in (spell_names.get(s), item_names.get(prod[0]) if prod else None):
            if n:
                # Several ranks/recipes with one name: keep the lowest yellow (the one a route meets first).
                old = m.get(norm(n))
                if old is None or rec[old][1] > y:
                    m[norm(n)] = s
    # 27 Nov 2026 (GEMETEN 1.60.1.71139): the healing potions (2330, 2337, 3447 ...) are in SkillLineAbility but have NO
    # SpellReagents row, so our recipe data leaves them out. They are the spine of Zygor's Alchemy route, so the step
    # stays: matched on the spell name of any recipe of that profession's skill line; the client says it does not know
    # the ingredients. Recipes with data win.
    line_key = {line: key for key, line in fs.PROFS}
    extra = {}
    for r in fr.rows(b, "SkillLineAbility"):
        key = line_key.get(fr.I(r["SkillLine"]))
        s = fr.I(r["Spell"])
        n = spell_names.get(s)
        if key and n and not (400000 <= s < 1200000):
            extra.setdefault(key, {}).setdefault(norm(n), s)
    for key, m in extra.items():
        for n, s in m.items():
            per.setdefault(key, {}).setdefault(n, s)
    return per


def parse(lines, key, names, report_bad):
    start = 0
    for i, l in enumerate(lines):
        if l.strip() == 'label "Begin_Profession_Leveling"':
            start = i
            break
    steps, ding = [], 0
    block = []
    # 27 Nov 2026 (GEMETEN): Forever renamed some recipes (7418 "Enchant Bracer - Minor Health" is "... - Inferior
    # Stamina" in Forever's SpellName), while Zygor keeps the old name in "Train <name> |learn <name>##<id>". Within one
    # guide that name and id belong together, so a make name may match the id of such a learn line too.
    learned = {}
    for l in lines:
        for m in re.finditer(r"\|learn ([^|#]+?)##(\d+)", l):
            learned.setdefault(norm(m.group(1)), int(m.group(2)))

    def flush(bl):
        nonlocal ding
        create, skill = None, None
        for l in bl:
            t = l.strip()
            m = RE_DING.search(t)
            if m:
                ding = int(m.group(1))
            m = RE_SKILLMAX.search(t)
            if m:
                steps.append(("r", int(m.group(2)), ding))
                ding = 0
            m = RE_LEARN.search(t)
            if m:
                steps.append(("l", int(m.group(1))))
            m = RE_CREATE.match(t)
            if m and create is None:
                create = (int(m.group(1)) if m.group(1) else 0, m.group(2))
            m = RE_SKILL.search(t)
            if m and "|skillmax" not in t:
                skill = int(m.group(2))
        if create:
            n, name = create
            first = re.split(r"\s+or\s+", name)[0]
            spell = None
            for c in candidates(first):
                spell = names.get(key, {}).get(c) or learned.get(c)
                if spell:
                    break
            if not spell:
                # A hole, kept as a hole: the route says "MH has no recipe for this part", never another recipe.
                report_bad.append("%s: %r (up to %s)" % (key, name, skill))
                if skill:
                    steps.append(("g", skill))
                return
            steps.append(("m", spell, skill or 0, n))

    for l in lines[start:]:
        if l.strip() == "step":
            flush(block)
            block = []
        else:
            block.append(l)
    flush(block)
    # A make step without "up to skill" that repeats the step before it ("_<Create Heavy Grinding Stones>_" after
    # "_<Create 30 Heavy Grinding Stones>_") adds nothing; drop it.
    out = []
    for s in steps:
        if s[0] == "m" and s[2] == 0 and out and out[-1][0] == "m" and out[-1][1] == s[1]:
            continue
        out.append(s)
    return out


def build(b):
    rec, _ = fs.build(b, False)
    names = name_maps(b, rec)
    routes, bad = {}, []
    for side, fn in FILES.items():
        g = guides(os.path.join(ZYGOR, fn))
        for title, key in GUIDES.items():
            if title not in g:
                bad.append("%s: guide %r not found" % (side, title))
                continue
            routes.setdefault(side, OrderedDict())[key] = parse(g[title], key, names, bad)
    return rec, routes, bad


# ---------------------------------------------------------------------------------------------------------------------
# 27 Nov 2026: OUR route. GEMETEN that day: Forever's DB2 grey value equals what the Forever client itself reports
# (C_TradeSkillUI maxTrivialLevel in Rob's SavedVariables, ns.db.skillupProbe: 2881 Light Leather 40/40, 3816 Cured Light
# Hide 70/70, 1229432 Camp Tent 20/20), while Zygor's route asks for crafts that our data calls grey on 40+ steps
# (2665 Coarse Sharpening Stone from 65 to 75; grey 55 in Forever). So the ORDER is worked out here from the measured
# values, and Zygor only says which recipes to prefer (its material choices).
# ---------------------------------------------------------------------------------------------------------------------
SRC_FILE = os.path.join(ROOT, "Modules", "ForeverRecipeSourceData.lua")
RE_SRC = re.compile(r'^\s*\[(\d+)\] = \{ k = "(\w)"[^\n]*?\bat = (\d+)')
RANK_AT = {75: 50, 150: 125, 225: 200}  # cap -> skill at which the next rank can be trained (ForeverProfGuide.lua)
TOP = 300


def sources():
    out = {}
    with io.open(SRC_FILE, encoding="utf-8") as f:
        for line in f:
            m = RE_SRC.match(line)
            if m:
                out[int(m.group(1))] = (m.group(2), int(m.group(3)))
    return out


def chance(r, s):
    y, g = r[1], r[2]
    if s < y:
        return 1.0
    if s >= g:
        return 0.0
    return (g - s) / float(g - y)


def tier(r, s):
    if s < r[1]:
        return 0  # orange
    return 1 if s < (r[1] + r[2]) // 2 else 2  # yellow, green


def simulate(key, rec, src, prefer):
    """[("r", cap) | ("l", spell) | ("m", spell, to) | ("g", to)] from skill 1 to 300."""
    pidx = [i + 1 for i, (k, _) in enumerate(fs.PROFS) if k == key][0]
    mine = {s: r for s, r in rec.items() if r[0] == pidx and s in src}

    def at(sp):
        # K = comes with the profession: you know it from skill 1 (its "at" is its yellow value, not a learn skill).
        return 1 if src[sp][0] == "K" else src[sp][1]

    def rank(c, s):
        # A recipe that is still orange or yellow beats a green one (green = many crafts per point). Within that:
        # trainer recipes (and the ones you start with) first, then Zygor's, then the surest.
        return (tier(c[1], s) == 2, src[c[0]][0] not in ("K", "T"), c[0] not in prefer, tier(c[1], s),
                -chance(c[1], s), c[1][2], c[0])

    s, cap, steps, learned = 1, 75, [], set()
    while s < TOP:
        if cap < TOP and s >= RANK_AT[cap]:
            cap += 75
            steps.append(("r", cap))
            continue
        cands = [(sp, r) for sp, r in mine.items() if at(sp) <= s and chance(r, s) > 0]
        if not cands:
            nxt = min([at(sp) for sp, r in mine.items() if at(sp) > s and r[2] > at(sp)] or [TOP])
            nxt = min(nxt, cap)
            if nxt <= s:
                break
            steps.append(("g", nxt))
            s = nxt
            continue
        sp, r = min(cands, key=lambda c: rank(c, s))
        green = (r[1] + r[2]) // 2
        to = green if green > s else min(r[2], s + 10)
        # Stop where a better recipe becomes learnable (higher in the same order), so the route can switch to it.
        for sp2, r2 in mine.items():
            a = at(sp2)
            if sp2 != sp and s < a < to and chance(r2, a) > 0 and rank((sp2, r2), a) < rank((sp, r), a):
                to = a
        to = min(to, cap, TOP)
        if cap < TOP:
            to = min(to, max(s + 1, RANK_AT[cap]))
        if src[sp][0] != "K" and sp not in learned:
            steps.append(("l", sp))
            learned.add(sp)
        if steps and steps[-1][0] == "m" and steps[-1][1] == sp:
            steps[-1] = ("m", sp, to)
        else:
            steps.append(("m", sp, to))
        s = to
    return steps


def pack_ours(steps):
    parts = []
    for st in steps:
        if st[0] == "r":
            parts.append("r%d" % st[1])
        elif st[0] == "l":
            parts.append("l%d" % st[1])
        elif st[0] == "g":
            parts.append("g%d" % st[1])
        else:
            parts.append("m%d>%d" % (st[1], st[2]))
    return ",".join(parts)


def ours(rec, routes):
    src = sources()
    out = OrderedDict()
    for key in GUIDES.values():
        prefer = set()
        for side in routes:
            for st in routes[side].get(key, []):
                if st[0] in ("l", "m"):
                    prefer.add(st[1])
        out[key] = simulate(key, rec, src, prefer)
    return out, src


def control(routes):
    side, key, first3, rank = CONTROL
    got = routes.get(side, {}).get(key, [])
    head = [s[:3] if s[0] == "m" else s for s in got[:3]]
    ok = head == first3 and rank in [s for s in got if s[0] == "r"]
    print("  control %s %s first steps %s, rank %s -> %s" % (side, key, head, rank, "OK" if ok else "FAIL"))
    return ok


def pack(steps):
    parts = []
    for s in steps:
        if s[0] == "r":
            parts.append("r%d" % s[1] + ("L%d" % s[2] if s[2] else ""))
        elif s[0] == "l":
            parts.append("l%d" % s[1])
        elif s[0] == "g":
            parts.append("g%d" % s[1])
        else:
            parts.append("m%d" % s[1] + (">%d" % s[2] if s[2] else "") + ("x%d" % s[3] if s[3] else ""))
    return ",".join(parts)


def emit(b, mine):
    out = [
        "local _, ns = ...",
        "",
        "-- GENERATED by tools/forever_skillroute.py --emit. Do not edit by hand; the rule is in the generator's header.",
        "-- The route is worked out from Blizzard's DB2 (yellow/grey, build %s, the same data as" % b,
        "-- Modules/ForeverSkillupData.lua) and the learn skill in Modules/ForeverRecipeSourceData.lua. Zygor's Forever",
        "-- profession guides only say which recipes to prefer (ids; Rob 22 Nov 2026). Read by Modules/ForeverSkillRoute.lua.",
        "--   rN    train the next rank, up to N (possible from skill 50 / 125 / 200)",
        "--   lS    learn recipe S at a trainer",
        "--   mS>X  make recipe S up to skill X",
        "--   gX    up to skill X MH has no trainer recipe that still gives points",
        "",
        "if not ns.IS_FOREVER then",
        "\treturn",
        "end",
        "",
        "ns.SKILLROUTE_BUILD = \"%s\"" % b,
        "ns.SKILLROUTE_PACKED = {",
    ]
    for key, steps in mine.items():
        out.append('\t%s = "%s",' % (key, pack_ours(steps)))
    out += ["}", ""]
    text = "\n".join(out)
    tmp = OUT + ".tmp"
    with io.open(tmp, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    os.replace(tmp, OUT)
    print("wrote %s (%d bytes)" % (OUT, len(text.encode("utf-8"))))


def main():
    args = sys.argv[1:]
    if not args or "--help" in args:
        print(__doc__)
        return
    b = args[args.index("--build") + 1] if "--build" in args else gd.latest_build("wowf")
    print("forever build %s" % b)
    rec, routes, bad = build(b)
    for side in ("A", "H"):
        for key, steps in routes.get(side, {}).items():
            n = {k: sum(1 for s in steps if s[0] == k) for k in "rlm"}
            unknown = [s[1] for s in steps if s[0] in "lm" and s[1] not in rec]
            print("  %s %-15s ranks %d, learn %d, make %d, last skill %s, not in recipe data: %s" % (
                side, key, n["r"], n["l"], n["m"], max([s[2] for s in steps if s[0] == "m"] or [0]), unknown))
            # Check against OUR data (DB2): a make step must still give points where it starts, and not be grey before
            # the skill it is meant to reach.
            p = 1
            for s in steps:
                if s[0] == "g":
                    print("     HOLE up to %d (from %d)" % (s[1], p))
                    p = max(p, s[1])
                elif s[0] == "m":
                    r = rec.get(s[1])
                    if r and r[2] <= p:
                        print("     grey already: %d (grey %d) at %d" % (s[1], r[2], p))
                    elif r and s[2] and r[2] < s[2]:
                        print("     grey before the goal: %d (grey %d) goal %d" % (s[1], r[2], s[2]))
                    p = max(p, s[2])
            if "--steps" in args:
                print("     " + pack(steps))
    print("  unmatched make names (left out): %d" % len(bad))
    for x in bad:
        print("     " + x)
    ok = control(routes)
    mine, src = ours(rec, routes)
    print("OUR route (DB2 colours, Zygor recipes preferred):")
    for key, steps in mine.items():
        holes = [st for st in steps if st[0] == "g"]
        makes = [st for st in steps if st[0] == "m"]
        reach = max([st[1] if st[0] == "g" else st[2] for st in steps if st[0] in "gm"] or [0])
        print("  %-15s steps %d, make %d, holes %s, reaches %d" % (key, len(steps), len(makes), holes, reach))
        if "--steps" in args:
            print("     " + pack_ours(steps))
    # Control on our own route: Blacksmithing starts with Rough Sharpening Stone (DB2 15/55, comes with the profession).
    bs = mine.get("BLACKSMITHING", [])
    ok2 = bool(bs) and bs[0][:2] == ("m", 2660) and any(st == ("r", 150) for st in bs) and \
        max(st[2] for st in bs if st[0] == "m") == TOP
    print("  control BLACKSMITHING starts with 2660, has rank 150, reaches 300 -> %s" % ("OK" if ok2 else "FAIL"))
    if "--emit" in args:
        if not (ok and ok2):
            gd.die("a positive control failed; nothing written")
        emit(b, mine)


if __name__ == "__main__":
    main()
