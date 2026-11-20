"""Vendors who repair, for WoW Forever -> Modules/ForeverRepairData.lua (read by Modules/ForeverVendors.lua, Find ->
"Repair & sell").

Rob, 20 Nov 2026 (via sparring): "Hebben we al iets in onze helper staan waarbij ik aan kan klikken om zo snel mogelijk
naar iemand of iets te gaan waarbij ik mijn spullen kan repareren en zeker verkopen?" -> on the proposal: "ja doe maar".

Source (the coordinate rule: Rob measured > HandyNotes > Zygor > guide; HandyNotes_WoWForever has no vendors):
  Zygor Forever, on disk: ZygorGuidesViewerForever/Data-Forever/NPCData.lua, block ["Repair"] -- one line per NPC,
  `npcid=s<A|H|B>|m<uiMap>|x<x>|y<y>`; lines starting with -- (Zygor's own doubts, side s??) are left out.
  Names: Zygor's Localization-Forever/NPCs_enUS.lua (English; the game shows its own name once you met him, see
  ForeverVendors.lua). Every value GEMETEN in those files; that they are right in game is AFGELEID until visited --
  MH learns the real place and whether he repairs (CanMerchantRepair) at every vendor window.
Redridge Mountains (1433): Zygor's NPCData uses the old Classic map frame there (GEMETEN 18 Nov 2026 on the Lakeshire
flight master, 5.1 off; and 20 Nov on Innkeeper Brianna, 27.0 vs 21.8 in the Forever frame). x - 5.15 (AFGELEID from
those two points); y unchanged.

Usage (front door): run forever_repair            numbers, writes nothing
                    run forever_repair --emit     write the data file
"""
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
ZYG = r"E:\World of Warcraft\_forever_\Interface\AddOns\ZygorGuidesViewerForever"
NPCDATA = os.path.join(ZYG, "Data-Forever", "NPCData.lua")
NAMES = os.path.join(ZYG, "Localization-Forever", "NPCs_enUS.lua")
OUT = os.path.join(ROOT, "Modules", "ForeverRepairData.lua")
SHIFT = {1433: (-5.15, 0.0)}
SKIP_MAPS = {1459: "Alterac Valley (a battleground: no walking route there)"}
SIDE = {"A": "A", "H": "H", "B": "both"}
ROW = re.compile(r"^\s*(\d+)=s([AHB])\|m(\d+)\|x([\d.]+)\|y([\d.]+)")


def main():
    text = io.open(NPCDATA, encoding="utf-8", errors="replace").read()
    m = re.search(r'\["Repair"\]\s*=\s*\[\[(.*?)\]\]', text, re.S)
    if not m:
        sys.exit("no Repair block in " + NPCDATA)
    names = {}
    for line in io.open(NAMES, encoding="utf-8", errors="replace"):
        n = re.match(r'\s*\[(\d+)\]\s*=\s*"((?:\\.|[^"\\])*)"', line)
        if n:
            names[int(n.group(1))] = n.group(2).replace('\\"', '"')
    rows, skipped, shifted = [], 0, 0
    for line in m.group(1).split("\n"):
        if line.strip().startswith("--") or not line.strip():
            skipped += 1 if line.strip() else 0
            continue
        r = ROW.match(line)
        if not r:
            skipped += 1
            continue
        npc, side, mp, x, y = int(r.group(1)), r.group(2), int(r.group(3)), float(r.group(4)), float(r.group(5))
        if mp in SKIP_MAPS:
            skipped += 1
            continue
        # Only the old (Classic) NPCs sit in the old frame; Forever's own new NPCs (ids from 200000) are in the Forever
        # frame already (GEMETEN: 256730 Stondry Darkhammer was 5.2 off after the shift, right before it).
        if mp in SHIFT and npc < 200000:
            x, y = x + SHIFT[mp][0], y + SHIFT[mp][1]
            shifted += 1
        rows.append((npc, names.get(npc), SIDE[side], mp, round(x, 2), round(y, 2)))
    print("repair rows %d, skipped %d (commented or unreadable), Redridge shifted %d, without a name in Zygor %d" % (
        len(rows), skipped, shifted, sum(1 for r in rows if not r[1])))
    # Second source per row: the Wowhead Forever tooltip (name, subtitle, spawns), through tools/gamedata.py's cache.
    sys.path.insert(0, HERE)
    import gamedata as gd
    import json
    checked, agree, far, nowh, tags = [], 0, 0, 0, {}
    for npc, name, side, mp, x, y in rows:
        url = "https://nether.wowhead.com/forever/tooltip/npc/%d" % npc
        cpath = os.path.join(gd.CACHE, "tooltip", "forever", "npc", "%d.enUS.json" % npc)
        data, _ = gd.fetch(url, cpath, 3 * 86400, soft404=True)
        j = None
        if data:
            try:
                j = json.loads(data.decode("utf-8"))
            except ValueError:
                j = None
        if not j or not j.get("name"):
            nowh += 1
            checked.append((npc, name, side, mp, x, y, None, "no Wowhead"))
            continue
        lines = gd.strip_html(j.get("tooltip"))
        sub = lines[1] if len(lines) > 1 and lines[0] == j["name"] else None
        pts = []
        for _f, p in ((j.get("map") or {}).get("coords") or {}).items():
            pts += p
        d = min([((px - x) ** 2 + (py - y) ** 2) ** 0.5 for px, py in pts] or [99])
        if d <= 1.0:
            agree += 1
            note = "Wowhead agrees (%.1f)" % d
        else:
            far += 1
            note = "Wowhead nearest %.1f off" % d if pts else "Wowhead has no spawns"
        tags[sub] = tags.get(sub, 0) + 1
        checked.append((npc, name or j["name"], side, mp, x, y, sub, note))
    rows = checked
    print("Wowhead: agree within 1.0: %d, further off: %d, no Wowhead data: %d" % (agree, far, nowh))
    print("subtitles: %s" % sorted(tags.items(), key=lambda kv: -kv[1])[:15])
    # positive control: 54 Corina Steele (Goldshire armorer) must be there
    ctl = [r for r in rows if r[0] == 54]
    print("control 54:", ctl)
    if not ctl:
        sys.exit("positive control 54 missing; nothing written")
    if "--emit" in sys.argv:
        out = ["local _, ns = ...", "",
               "-- GENERATED by tools/forever_repair.py --emit from Zygor Forever NPCData.lua [\"Repair\"] + NPCs_enUS.lua.",
               "-- Do not edit by hand. %d vendors who repair. Redridge x shifted by -5.15 (old Classic frame)." % len(rows),
               "", "if not ns.IS_FOREVER then", "\treturn", "end", "", "ns.FOREVER_REPAIR_SPOTS = {"]
        def q(s):
            return ('"%s"' % s.replace('\\', '\\\\').replace('"', '\\"')) if s else "nil"
        for npc, name, side, mp, x, y, sub, note in rows:
            out.append('\t{ kind = "repair", npc = %d, name = %s, tag = %s, side = "%s", map = %d, x = %s, y = %s }, -- %s' % (
                npc, q(name), q(sub), side, mp, x, y, note))
        out += ["}", ""]
        with io.open(OUT + ".tmp", "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(out))
        os.replace(OUT + ".tmp", OUT)
        print("wrote " + OUT)


if __name__ == "__main__":
    main()
