"""Diff Holidays DB2 between live 12.1.5.70783 and PTR 12.1.7.70892 (gamedata cache only). Read-only."""
import csv
import io
import os
import sys
import datetime

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = os.path.join(os.environ.get("LOCALAPPDATA"), "MidnightHelper", "gamedata_cache", "db2")
LIVE, PTR = "12.1.5.70783", "12.1.7.70892"


def load(build, name):
    p = os.path.join(ROOT, build, name + ".enUS.csv")
    if not os.path.isfile(p):
        return None
    with io.open(p, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def dec(v):
    v = int(v)
    if v == 0:
        return None
    minute = v & 0x3F
    hour = (v >> 6) & 0x1F
    mday = ((v >> 14) & 0x3F) + 1
    month = ((v >> 20) & 0xF) + 1
    yr = (v >> 24) & 0x1F
    y = 2000 + yr if yr != 31 else 0
    return "%04d-%02d-%02d %02d:%02d" % (y, month, mday, hour, minute)


live = {r["ID"]: r for r in load(LIVE, "Holidays")}
ptr = {r["ID"]: r for r in load(PTR, "Holidays")}
names = {r["ID"]: r["Name_lang"] for r in (load(PTR, "HolidayNames") or [])}
descs = {r["ID"]: r["Description_lang"] for r in (load(PTR, "HolidayDescriptions") or [])}
print("live rows", len(live), "ptr rows", len(ptr))
for hid in sorted(set(live) | set(ptr), key=int):
    a, b = live.get(hid), ptr.get(hid)
    if a == b:
        continue
    r = b or a
    tag = "NEW-PTR" if a is None else ("GONE-PTR" if b is None else "CHANGED")
    nm = names.get(r["HolidayNameID"], "name%s" % r["HolidayNameID"])
    ds = descs.get(r["HolidayDescriptionID"], "").replace("\n", " ")[:90]
    print("%s hol=%s reg=%s name=%s desc=%s dur0=%s | %s" % (tag, hid, r["Region"], nm, r["HolidayDescriptionID"], r["Duration_0"], ds))
    for side, row in (("live", a), ("ptr ", b)):
        if not row:
            continue
        dates = [dec(row["Date_%d" % i]) for i in range(26)]
        dates = [d for d in dates if d]
        diffcols = [k for k in row if a and b and a.get(k) != b.get(k)]
        print("   %s dates=%s %s" % (side, ", ".join(dates), ("diffcols=" + ",".join(diffcols)) if diffcols and side == "ptr " else ""))
