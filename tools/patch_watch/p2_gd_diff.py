"""p2_gd_diff.py -- speur-opdracht 2 (12.1.7 speldata): live vs PTR DB2-diff via tools/gamedata.py.
Read-only. Writes its reports to <scratchpad>/p2_out/. Uses gamedata's fetch + cache (same cache paths)."""
import csv
import io
import os
import re
import sys
import time

TOOLS = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\tools"
sys.path.insert(0, TOOLS)
import gamedata as gd  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "p2_out")
os.makedirs(OUT, exist_ok=True)
csv.field_size_limit(10 ** 8)

LOG = []


def log(s):
    LOG.append(s)
    print(s)


def load(table, build, keep=None):
    """dict id -> tuple, header list. keep = column subset (ID always first). None if table missing."""
    url = "https://wago.tools/db2/%s/csv?build=%s" % (table, build)
    cpath = os.path.join(gd.CACHE, "db2", build, "%s.enUS.csv" % table)
    try:
        data, cached = gd.fetch(url, cpath, None)
    except SystemExit:
        log("  !! %s %s: download failed" % (table, build))
        return None, None
    text = data.decode("utf-8-sig", "replace")
    if text.lstrip().startswith("<"):
        try:
            os.remove(cpath)
        except OSError:
            pass
        log("  !! %s %s: web page instead of table (not in this build?)" % (table, build))
        return None, None
    rd = csv.reader(io.StringIO(text))
    header = next(rd)
    idx = list(range(len(header)))
    if keep:
        idx = [header.index(c) for c in keep if c in header]
    hdr = [header[i] for i in idx]
    rows = {}
    dup = 0
    idcol = header.index("ID") if "ID" in header else 0
    for r in rd:
        if not r:
            continue
        k = r[idcol]
        if k in rows:
            dup += 1
        rows[k] = tuple(r[i] if i < len(r) else "" for i in idx)
    if dup:
        log("  note %s %s: %d duplicate ids (last one kept)" % (table, build, dup))
    return rows, hdr


def diff(table, live_b, ptr_b, keep=None, show_changed=True):
    t0 = time.time()
    L, hl = load(table, live_b, keep)
    P, hp = load(table, ptr_b, keep)
    path = os.path.join(OUT, "%s.txt" % table)
    if L is None or P is None:
        log("%-34s skipped (live %s, ptr %s)" % (table, "ok" if L is not None else "MISSING",
                                                 "ok" if P is not None else "MISSING"))
        return L, hl, P, hp
    added = [k for k in P if k not in L]
    removed = [k for k in L if k not in P]
    common_cols = [c for c in hp if c in hl]
    ci_l = [hl.index(c) for c in common_cols]
    ci_p = [hp.index(c) for c in common_cols]
    changed = []
    for k in P:
        if k in L:
            a, b = L[k], P[k]
            dd = [(common_cols[j], a[ci_l[j]], b[ci_p[j]]) for j in range(len(common_cols))
                  if a[ci_l[j]] != b[ci_p[j]]]
            if dd:
                changed.append((k, dd))
    with io.open(path + ".tmp", "w", encoding="utf-8", newline="\n") as f:
        f.write("%s  live %s (%d rows)  ptr %s (%d rows)\n" % (table, live_b, len(L), ptr_b, len(P)))
        f.write("columns live: %s\n" % ", ".join(hl))
        if hl != hp:
            f.write("columns ptr : %s\n" % ", ".join(hp))
            f.write("COLUMNS DIFFER: only live %s | only ptr %s\n" % (
                [c for c in hl if c not in hp], [c for c in hp if c not in hl]))
        f.write("added %d  removed %d  changed %d\n\n" % (len(added), len(removed), len(changed)))
        f.write("== ADDED (ptr row)\n")
        for k in sorted(added, key=lambda x: int(x) if x.lstrip("-").isdigit() else 0):
            f.write("+ " + " | ".join(P[k]) + "\n")
        f.write("\n== REMOVED (live row)\n")
        for k in sorted(removed, key=lambda x: int(x) if x.lstrip("-").isdigit() else 0):
            f.write("- " + " | ".join(L[k]) + "\n")
        if show_changed:
            f.write("\n== CHANGED (col: live -> ptr)\n")
            for k, dd in sorted(changed, key=lambda x: int(x[0]) if x[0].lstrip("-").isdigit() else 0):
                f.write("~ %s: %s\n" % (k, " ; ".join("%s: %r -> %r" % d for d in dd)))
    os.replace(path + ".tmp", path)
    log("%-34s live %7d  ptr %7d  +%-6d -%-6d ~%-6d (%.1fs)" % (table, len(L), len(P), len(added), len(removed),
                                                              len(changed), time.time() - t0))
    return L, hl, P, hp


def main():
    b = gd.builds()
    log("builds (wago.tools/api/builds, read %s):" % time.strftime("%Y-%m-%d %H:%M"))
    for prod in ("wow", "wowt", "wowxptr", "wow_beta", "wowf"):
        rows = b.get(prod) or []
        for r in rows[:3]:
            log("  %-10s %-16s %s" % (prod, r.get("version"), r.get("created_at")))
    live_b = gd.latest_build("wow")
    ptr_b = gd.latest_build("wowt")
    log("LIVE = %s   PTR = %s\n" % (live_b, ptr_b))

    plain = ["Achievement", "CriteriaTree", "Criteria", "QuestV2", "CurrencyTypes", "Item", "Holidays",
             "HolidayNames", "HolidayDescriptions", "MythicPlusSeason", "MythicPlusSeasonRewardLevels",
             "MythicPlusSeasonTrackedAffix", "MythicPlusSeasonTrackedMap", "ChallengeModeItemBonusOverride",
             "MapChallengeMode", "GroupFinderActivity", "GroupFinderActivityGrp", "GroupFinderCategory", "UiMap",
             "AreaTable", "Mount", "MountXDisplay", "JournalInstance", "JournalEncounter", "QuestLine",
             "QuestLineXQuest", "Map", "LFGDungeons", "Achievement_Category", "CurrencyContainer",
             "AreaPOI", "SpellName", "ModifierTree"]
    res = {}
    for t in plain:
        res[t] = diff(t, live_b, ptr_b)
    res["ItemSparse"] = diff("ItemSparse", live_b, ptr_b,
                             keep=["ID", "Display_lang", "Description_lang", "ItemLevel", "ExpansionID",
                                   "OverallQualityID", "RequiredLevel", "Bonding", "LimitCategory"])

    # ---- MH ids (SelftestData.lua, R + B parts = retail side)
    st = io.open(r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Modules\SelftestData.lua",
                 encoding="utf-8").read()
    cats = {}
    for m in re.finditer(r'(\w+)\s*=\s*\{\s*R\s*=\s*"([^"]*)"\s*,\s*F\s*=\s*"([^"]*)"\s*,\s*B\s*=\s*"([^"]*)"', st):
        ids = [x for x in (m.group(2) + "," + m.group(4)).split(",") if x]
        cats[m.group(1)] = ids
    tab = {"spell": ("SpellName", 1), "achievement": ("Achievement", None), "quest": ("QuestV2", None),
           "item": ("Item", None), "map": ("UiMap", None)}
    with io.open(os.path.join(OUT, "mh_ids.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("MH ids from Modules/SelftestData.lua (R+B, retail side) vs live %s / ptr %s\n" % (live_b, ptr_b))
        for cat, ids in cats.items():
            f.write("\n== %s: %d ids\n" % (cat, len(ids)))
            if cat not in tab:
                f.write("  (no retail table checked)\n")
                continue
            t = tab[cat][0]
            L, hl, P, hp = res[t]
            if L is None or P is None:
                f.write("  table %s missing\n" % t)
                continue
            inL = sum(1 for i in ids if i in L)
            inP = sum(1 for i in ids if i in P)
            f.write("  present live %d / ptr %d  (table %s)\n" % (inL, inP, t))
            for i in ids:
                if i in L and i not in P:
                    f.write("  GONE on PTR: %s  live row: %s\n" % (i, " | ".join(L[i])[:300]))
                elif i not in L and i in P:
                    f.write("  ONLY on PTR: %s  ptr row: %s\n" % (i, " | ".join(P[i])[:300]))
                elif i not in L and i not in P:
                    f.write("  in NEITHER: %s\n" % i)
                elif L[i] != P[i]:
                    cc = [c for c in hp if c in hl]
                    dd = ["%s: %r -> %r" % (c, L[i][hl.index(c)], P[i][hp.index(c)]) for c in cc
                          if L[i][hl.index(c)] != P[i][hp.index(c)]]
                    f.write("  CHANGED %s: %s\n" % (i, " ; ".join(dd)))

        # achievement criteria subtrees
        AL, ahl, AP, ahp = res["Achievement"]
        CL, chl, CP, chp = res["CriteriaTree"]
        KL, khl, KP, khp = res["Criteria"]
        if AL and CL and CP:
            def kids(C, hdr):
                pi = hdr.index("Parent")
                out = {}
                for k, r in C.items():
                    out.setdefault(r[pi], []).append(k)
                return out
            kl, kp = kids(CL, chl), kids(CP, chp)

            def sub(C, kd, root):
                seen, st2 = [], [root]
                while st2:
                    n = st2.pop()
                    if n in seen or n not in C:
                        continue
                    seen.append(n)
                    st2 += kd.get(n, [])
                return seen
            ctcol = ahl.index("Criteria_tree")
            f.write("\n== criteria subtree check for MH achievements\n")
            for i in cats.get("achievement", []):
                ra = AL.get(i) or AP.get(i)
                if not ra:
                    continue
                root = ra[ctcol]
                rootp = AP[i][ahp.index("Criteria_tree")] if i in AP else None
                sl = sub(CL, kl, root)
                sp = sub(CP, kp, rootp or root)
                diffs = []
                if rootp and rootp != root:
                    diffs.append("root %s -> %s" % (root, rootp))
                for n in set(sl) | set(sp):
                    if n in sl and n not in sp:
                        diffs.append("node %s gone" % n)
                    elif n in sp and n not in sl:
                        diffs.append("node %s new: %s" % (n, " | ".join(CP[n])))
                    elif CL[n] != CP[n]:
                        diffs.append("node %s: %s -> %s" % (n, " | ".join(CL[n]), " | ".join(CP[n])))
                    cid = (CP.get(n) or CL.get(n))[chp.index("CriteriaID")]
                    if KL is not None and KP is not None and cid != "0":
                        if (KL.get(cid) or ()) != (KP.get(cid) or ()):
                            diffs.append("criteria %s: %s -> %s" % (cid, " | ".join(KL.get(cid, ("-",))),
                                                                   " | ".join(KP.get(cid, ("-",)))))
                f.write("  %s (tree %s, %d/%d nodes): %s\n" % (i, root, len(sl), len(sp),
                                                              "unchanged" if not diffs else "; ".join(diffs)))
            # full dump of 64207's tree on both
            for i in ("64207", "61463"):
                for nm, A, ah, C, ch, kd in (("live", AL, ahl, CL, chl, kl), ("ptr", AP, ahp, CP, chp, kp)):
                    if i not in A:
                        f.write("\n%s %s: achievement not in table\n" % (nm, i))
                        continue
                    root = A[i][ah.index("Criteria_tree")]
                    f.write("\n%s %s tree %s:\n  cols %s\n" % (nm, i, root, ", ".join(ch)))
                    for n in sub(C, kd, root):
                        f.write("  %s\n" % " | ".join(C[n]))
    io.open(os.path.join(OUT, "summary.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(LOG) + "\n")
    print("done; reports in %s" % OUT)


main()
