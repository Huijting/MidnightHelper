"""Decode Holidays DB2 (PTR 12.1.7.70892) packed dates; list every occurrence Nov 2026 - Mar 2027.
Read-only: uses the gamedata cache only."""
import csv
import io
import os
import sys
import datetime

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

BUILD = "12.1.7.70892"
if len(sys.argv) > 1:
    BUILD = sys.argv[1]
BASE = os.path.join(os.environ.get("LOCALAPPDATA"), "MidnightHelper", "gamedata_cache", "db2", BUILD)


def load(name):
    p = os.path.join(BASE, name + ".enUS.csv")
    with io.open(p, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def dec(v):
    v = int(v)
    if v == 0:
        return None
    minute = v & 0x3F
    hour = (v >> 6) & 0x1F
    wday = (v >> 11) & 0x7
    mday = ((v >> 14) & 0x3F) + 1
    month = ((v >> 20) & 0xF) + 1
    yr = (v >> 24) & 0x1F
    return (2000 + yr if yr != 31 else None, month, mday, hour, minute, wday)


names = {r["ID"]: r["Name_lang"] for r in load("HolidayNames")}
descs = {r["ID"]: r["Description_lang"] for r in load("HolidayDescriptions")}
rows = load("Holidays")
print("build", BUILD, "holidays rows", len(rows))
# positive control: count of rows with any decodable 2026 date
lo = datetime.datetime(2026, 11, 1)
hi = datetime.datetime(2027, 3, 1)
out = []
for r in rows:
    region = r["Region"]
    durs = [int(r["Duration_%d" % i]) for i in range(10)]
    for i in range(26):
        d = dec(r["Date_%d" % i])
        if not d:
            continue
        y, mo, md, h, mi, wd = d
        if y is None:
            # any-year date: report if month Nov-Feb
            if mo in (11, 12, 1, 2):
                out.append(("anyyear-%02d-%02d %02d:%02d" % (mo, md, h, mi), r, durs, i))
            continue
        try:
            t = datetime.datetime(y, mo, md, h, mi)
        except ValueError:
            continue
        if lo <= t < hi:
            out.append((t.strftime("%Y-%m-%d %a %H:%M"), r, durs, i))
out.sort(key=lambda x: x[0])
print("=== looping rows / Winter / Anniversary / Hallow / Pilgrim names (any date) ===")
for r in rows:
    nm = names.get(r["HolidayNameID"], "?name%s" % r["HolidayNameID"])
    if r["Looping"] != "0" or any(k in nm for k in ("Winter", "Anniversary", "Pilgrim", "Love", "Lunar", "Darkmoon")):
        ds = [dec(r["Date_%d" % i]) for i in range(26)]
        ds = [d for d in ds if d]
        print("hol=%-5s reg=%-5s loop=%s dur0=%s %s first=%s last=%s n=%d" % (
            r["ID"], r["Region"], r["Looping"], r["Duration_0"], nm, ds[0] if ds else None,
            ds[-1] if ds else None, len(ds)))
print("=== dated occurrences Nov 2026 - Feb 2027, all regions ===")
for when, r, durs, i in out:
    nm = names.get(r["HolidayNameID"], "?name%s" % r["HolidayNameID"])
    ds = descs.get(r["HolidayDescriptionID"], "").replace("\n", " ")
    dur = durs[0]
    print("%-22s reg=%-4s hol=%-5s loop=%s dur0=%sh  %s | %s" % (
        when, r["Region"], r["ID"], r["Looping"], dur, nm, ds[:150]))
