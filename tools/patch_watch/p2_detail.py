"""p2_detail.py -- speur-opdracht 2, details on top of p2_gd_diff.py. Read-only; writes p2_out/detail.txt."""
import csv
import io
import json
import os
import sys
import time

TOOLS = r"E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\tools"
sys.path.insert(0, TOOLS)
import gamedata as gd  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "p2_out")
csv.field_size_limit(10 ** 8)
LIVE, PTR = "12.1.5.70783", "12.1.7.70892"
W = io.open(os.path.join(OUT, "detail.txt") + ".tmp", "w", encoding="utf-8", newline="\n")


def p(s=""):
    W.write(s + "\n")


def load(table, build):
    url = "https://wago.tools/db2/%s/csv?build=%s" % (table, build)
    cpath = os.path.join(gd.CACHE, "db2", build, "%s.enUS.csv" % table)
    data, _ = gd.fetch(url, cpath, None)
    rd = csv.DictReader(io.StringIO(data.decode("utf-8-sig", "replace")))
    return {r["ID"]: r for r in rd}


def dec(v):
    v = int(v)
    if v == 0:
        return "-"
    mi = v & 0x3F
    hr = (v >> 6) & 0x1F
    wd = (v >> 11) & 0x7
    dy = ((v >> 14) & 0x3F) + 1
    mo = ((v >> 20) & 0xF) + 1
    yr = ((v >> 24) & 0x1F) + 2000
    return "%04d-%02d-%02d %02d:%02d%s" % (yr, mo, dy, hr, mi, "" if wd == 7 else " wd%d" % wd)


# ---------------- Holidays
HL, HP = load("Holidays", LIVE), load("Holidays", PTR)
HN = load("HolidayNames", PTR)
HD = load("HolidayDescriptions", PTR)
p("== HOLIDAYS (decoded packed dates; Duration in hours)")
ids = sorted(set(HL) | set(HP), key=int)
for i in ids:
    a, b = HL.get(i), HP.get(i)
    if a and b and a == b:
        continue
    r = b or a
    nm = HN.get(r["HolidayNameID"], {}).get("Name_lang", "") if r["HolidayNameID"] != "0" else ""
    desc = HD.get(r["HolidayDescriptionID"], {}).get("Description_lang", "")[:90] if r["HolidayDescriptionID"] != "0" else ""
    state = "ADDED" if not a else ("REMOVED" if not b else "CHANGED")
    p("\n%s holiday %s  name#%s '%s'  desc '%s'  region %s->%s  flags %s->%s  filter %s" % (
        state, i, r["HolidayNameID"], nm, desc, a and a["Region"], b and b["Region"], a and a["Flags"],
        b and b["Flags"], r["CalendarFilterType"]))
    for nmx, row in (("live", a), ("ptr ", b)):
        if not row:
            continue
        durs = [row["Duration_%d" % k] for k in range(10) if row["Duration_%d" % k] != "0"]
        dates = [dec(row["Date_%d" % k]) for k in range(26) if row["Date_%d" % k] != "0"]
        p("   %s dur %s  dates %s" % (nmx, ",".join(durs), " | ".join(dates)))
# also every holiday whose dates touch Nov 2026 - Feb 2027 on PTR
p("\n== PTR holidays with a date between 2026-11-15 and 2027-03-01")
lo, hi = "2026-11-15", "2027-03-01"
for i in sorted(HP, key=int):
    r = HP[i]
    ds = [dec(r["Date_%d" % k]) for k in range(26) if r["Date_%d" % k] != "0"]
    hit = [d for d in ds if lo <= d[:10] < hi]
    if hit:
        nm = HN.get(r["HolidayNameID"], {}).get("Name_lang", "") if r["HolidayNameID"] != "0" else ""
        p("  %s '%s' region %s dur %s: %s%s" % (i, nm, r["Region"], r["Duration_0"], " | ".join(hit),
                                             "  (same in live)" if HL.get(i) == r else "  (CHANGED vs live)"))

# ---------------- achievements owning changed criteria trees / criteria
AP = load("Achievement", PTR)
CTP = load("CriteriaTree", PTR)
CTL = load("CriteriaTree", LIVE)
root_to_ach = {}
for k, r in AP.items():
    root_to_ach.setdefault(r["Criteria_tree"], []).append(k)


def owner(node):
    seen = 0
    n = node
    while n in CTP and CTP[n]["Parent"] != "0" and seen < 50:
        n = CTP[n]["Parent"]
        seen += 1
    return n, root_to_ach.get(n, [])


p("\n== CHANGED criteria-tree nodes -> owning achievement (PTR)")
for node in ("823", "824", "825", "826", "902", "903", "904", "905", "136325", "142573", "143006", "143007", "143008",
             "144189", "224832", "224833", "234279", "234285", "234287", "234289", "234291"):
    root, achs = owner(node)
    p("  node %s (%s | Amount %s->%s | Op %s->%s) root %s -> %s" % (
        node, CTP[node]["Description_lang"][:60], CTL[node]["Amount"], CTP[node]["Amount"], CTL[node]["Operator"],
        CTP[node]["Operator"], root, "; ".join("%s %s" % (x, AP[x]["Title_lang"]) for x in achs) or "(no achievement)"))
p("\n  full subtree of root of 224832 (live vs ptr):")
r224, _ = owner("224832")
for k in sorted(CTP, key=int):
    if CTP[k]["Parent"] == r224 or k == r224:
        p("   ptr  %s" % " | ".join(CTP[k][c] for c in ("ID", "Description_lang", "Parent", "Amount", "Operator", "CriteriaID", "Flags")))
        if k in CTL:
            p("   live %s" % " | ".join(CTL[k][c] for c in ("ID", "Description_lang", "Parent", "Amount", "Operator", "CriteriaID", "Flags")))
KP = load("Criteria", PTR)
by_crit = {}
for k, r in CTP.items():
    by_crit.setdefault(r["CriteriaID"], []).append(k)
p("\n== criteria with a new modifier tree -> achievement")
for c in ("4256", "6935", "18531"):
    for node in by_crit.get(c, []):
        root, achs = owner(node)
        p("  criteria %s (type %s asset %s) node %s root %s -> %s" % (c, KP[c]["Type"], KP[c]["Asset"], node, root,
          "; ".join("%s %s" % (x, AP[x]["Title_lang"]) for x in achs) or "(none)"))
MT = load("ModifierTree", PTR)
p("  ModifierTree 403949: %s" % (" | ".join("%s=%s" % kv for kv in MT.get("403949", {}).items())))
for k, r in MT.items():
    if r.get("Parent") == "403949":
        p("    child %s" % " | ".join("%s=%s" % kv for kv in r.items()))

# ---------------- Difficulty
DF = load("Difficulty", PTR)
DL = load("Difficulty", LIVE)
p("\n== Difficulty rows 230-245 (ptr; * = not in live)")
for k in sorted(DF, key=int):
    if 230 <= int(k) <= 245:
        p("  %s%s %s | instType %s | maxPlayers %s" % (k, "" if k in DL else "*", DF[k].get("Name_lang"),
                                                      DF[k].get("InstanceType"), DF[k].get("MaxPlayers")))

# ---------------- QuestLine 6307 / 6385
QL = load("QuestLine", PTR)
QX = load("QuestLineXQuest", PTR)
for ql in ("6307", "6385", "6210", "6212", "6220", "6222"):
    p("\n== QuestLine %s '%s' flags %s" % (ql, QL.get(ql, {}).get("Name_lang"), QL.get(ql, {}).get("Flags")))
    rows = sorted([r for r in QX.values() if r["QuestLineID"] == ql], key=lambda r: int(r["OrderIndex"]))
    p("   quests in order: %s" % ", ".join("%s(%s)" % (r["QuestID"], r["OrderIndex"]) for r in rows))

# ---------------- Wowhead PTR quest names for the new quests
QVL, QVP = load("QuestV2", LIVE), load("QuestV2", PTR)
new_q = sorted([k for k in QVP if k not in QVL], key=int)
p("\n== NEW QuestV2 ids on PTR (%d) with Wowhead PTR tooltip name" % len(new_q))
for q in new_q:
    url = "https://nether.wowhead.com/ptr/tooltip/quest/%s" % q
    cpath = os.path.join(gd.CACHE, "tooltip", "ptr", "quest", "%s.enUS.json" % q)
    cached = os.path.exists(cpath)
    try:
        data, _ = gd.fetch(url, cpath, 3 * 86400, soft404=True)
    except SystemExit:
        p("  %s: fetch failed" % q)
        continue
    if not cached:
        time.sleep(0.15)
    if data is None:
        p("  %s: 404" % q)
        continue
    try:
        j = json.loads(data.decode("utf-8"))
    except Exception:
        p("  %s: no json" % q)
        continue
    lines = gd.strip_html(j.get("tooltip"))
    p("  %s: %s || %s" % (q, j.get("name"), " / ".join(lines[1:4])[:220]))

W.close()
os.replace(os.path.join(OUT, "detail.txt") + ".tmp", os.path.join(OUT, "detail.txt"))
print("done: %s" % os.path.join(OUT, "detail.txt"))
