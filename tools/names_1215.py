"""Patch-day name check for 12.1.5: measures the new names in Blizzard data per client language,
on the newest 12.1.5 build wago knows, next to the PTR build 70077 the packs were built from.
Prints one row per (thing, language): PTR name | newest name | SAME/DIFF.

Run through the front door: job `run names_1215` (or `run names_1215 12.1.5.<build>` to force a build).
Baseline 12 Oct 2026 on 70077: every row localized in all 8 languages, 0 DIFF (wago had no live build yet).
Downloads and the output file go to the system temp folder (mh_names1215), not into the repo."""
import os, sys, csv, io, json, time, tempfile, urllib.request, urllib.parse
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass
SP = os.path.join(tempfile.gettempdir(), "mh_names1215")
OUT = os.path.join(SP, "n1215", "dl")
os.makedirs(OUT, exist_ok=True)
PTR = "12.1.5.70077"
LOCS = ["enUS", "deDE", "frFR", "esES", "esMX", "ptBR", "itIT", "ruRU"]

def get(url, dest, cache=True):
    if cache and os.path.exists(dest) and os.path.getsize(dest) > 0:
        return open(dest, "rb").read()
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=180) as r:
        data = r.read()
    open(dest, "wb").write(data)
    time.sleep(0.3)
    return data

# newest 12.1.5 build wago lists (any product), measured, not assumed
newest = None
try:
    data = json.loads(get("https://wago.tools/api/builds", os.path.join(OUT, "builds.json"), cache=False))
    seen = set()
    for product, blds in (data.items() if isinstance(data, dict) else []):
        for b in blds or []:
            v = b.get("version") if isinstance(b, dict) else None
            if v and v.startswith("12.1.5."):
                seen.add((int(v.rsplit(".", 1)[1]), v, product))
    if seen:
        top = sorted(seen)[-1]
        newest = top[1]
        print("builds: newest 12.1.5 = %s (%s); all 12.1.5 seen: %s" % (top[1], top[2], sorted(set(s[1] for s in seen))))
    else:
        print("builds: no 12.1.5 build in the list (control: %d products read)" % (len(data) if isinstance(data, dict) else -1))
except Exception as e:
    print("builds FAIL %s" % e)
if len(sys.argv) > 1:
    newest = sys.argv[1]
    print("builds: overridden by argument -> %s" % newest)
newest = newest or PTR

THINGS = [  # (label, table, id, name field)
    ("raid Kith'ix", "JournalInstance", "1324", "Name_lang"),
    ("boss Kith'ix", "JournalEncounter", "2896", "Name_lang"),
    ("ach Keystone Myth S2", "Achievement", "63690", "Title_lang"),
    ("ach aqir 63657", "Achievement", "63657", "Title_lang"),
    ("ach aqir 63658", "Achievement", "63658", "Title_lang"),
    ("ach aqir 63659", "Achievement", "63659", "Title_lang"),
    ("ach aqir 63680", "Achievement", "63680", "Title_lang"),
    ("POI Labyrinth 9035", "AreaPOI", "9035", "Name_lang"),
    ("faction Labyrinth 2836", "Faction", "2836", "Name_lang"),
    ("faction Aqir 2838", "Faction", "2838", "Name_lang"),
    ("POI Aqir ZA 8812", "AreaPOI", "8812", "Name_lang"),
    ("POI Aqir Eversong 8813", "AreaPOI", "8813", "Name_lang"),
    ("item Venomstone 280562", "ItemSparse", "280562", "Display_lang"),
]

def name(table, rid, field, build, loc):
    url = "https://wago.tools/db2/%s/csv?build=%s&locale=%s&filter%%5BID%%5D=%s" % (table, build, loc, rid)
    data = get(url, os.path.join(OUT, "%s_%s_%s_%s.csv" % (table, rid, build, loc)))
    rs = [r for r in csv.DictReader(io.StringIO(data.decode("utf-8-sig"))) if r.get("ID") == rid]
    return rs[0].get(field, "<no field %s>" % field) if rs else "<none>"

lines = ["PTR %s vs newest %s" % (PTR, newest)]
diffs = 0
for label, table, rid, field in THINGS:
    lines.append("== %s (%s %s)" % (label, table, rid))
    for loc in LOCS:
        try:
            a = name(table, rid, field, PTR, loc)
            b = a if newest == PTR else name(table, rid, field, newest, loc)
            flag = "SAME" if a == b else "DIFF"
            if flag == "DIFF":
                diffs += 1
            lines.append("  %s %s | PTR: %s | NEW: %s" % (flag, loc, a, b))
        except Exception as e:
            lines.append("  FAIL %s %s" % (loc, e))
lines.append("DIFF rows: %d" % diffs)
open(os.path.join(SP, "n1215", "out_%s.txt" % newest), "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("\n".join(lines))
