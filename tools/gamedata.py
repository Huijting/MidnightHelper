"""gamedata.py -- fast game data for Midnight Helper research, without a browser.

Rob, 10 Nov 2026: "kunnen we niet iets bouwen ... om wowhead sneller te bekijken?" -> "Ja, bouw het".
A question about where a druid learns maces took a helper 70 steps and 7.5 minutes, mostly fighting Wowhead's 403s
in the browser window. Two sources answer plain Python in ~0.2 s (MEASURED 10 Nov 2026):

  1. wago.tools DB2 CSV -- Blizzard's own client tables, per build, for retail, PTR AND Forever.
  2. Wowhead's tooltip JSON (nether.wowhead.com) -- name, subtitle, zone and every spawn coordinate of an npc,
     and name/icon of a spell, item, quest or object. Works for /forever and /classic too.
  Still 403 for plain Python: the normal www.wowhead.com pages (e.g. an npc's "Teaches" tab) -> browser window.

ALWAYS call it through the front door (CLAUDE.md, "_probe.py krijgt GEEN argumenten meer"):
  write one line into <scratchpad>/probe_job.txt, then run  python ".../tools/_probe.py"  with no arguments.

Job lines:
  run gamedata builds                                   newest build per product (wow, wowt, wowf, ...)
  run gamedata db2 <Table> [filters] [options]          a DB2 table, filtered
      filters:  Col=val        exact (val may be a,b,c = any of them)
                Col~text       contains, case-insensitive
                Col!=val       not equal
      options:  --game retail|ptr|forever  (default retail)   --build 1.60.1.70862 (overrides --game)
                --locale deDE (names in that language)       --cols ID,Name_lang   --limit 50 (0 = all)
                --count (only the number of matching rows)    --header (only the column names)
  run gamedata npc|spell|item|quest|object <id> [<id> ...] [--game retail|forever|classic|ptr] [--locale deDE]

  examples:
    run gamedata db2 SpellName ID=198,199 --game forever
    run gamedata db2 SkillLine DisplayName_lang~Mace --game forever --cols ID,DisplayName_lang
    run gamedata npc 11865 11866 --game forever

Output rules for the reader: everything printed here is MEASURED in that source with that build -- say which one.
DB2 has structure and ids, not server-side facts (who a trainer teaches, prices, drop rates): those come from
Wowhead pages, guides or the client. A filter that prints 0 rows proves nothing until a filter you KNOW must hit
prints rows in the same run (CLAUDE.md, silence-is-not-absence).

Cache: %LOCALAPPDATA%\\MidnightHelper\\gamedata_cache (outside the repo and the WoW folder). DB2 per build is
fixed forever; tooltips are kept 3 days; the builds list 6 hours. Delete the folder to force a fresh download.
"""

import csv
import io
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/130.0 Safari/537.36")
CACHE = os.path.join(os.environ.get("LOCALAPPDATA") or os.path.expanduser("~"), "MidnightHelper", "gamedata_cache")
PRODUCT = {"retail": "wow", "live": "wow", "ptr": "wowt", "forever": "wowf"}
WH_ENV = {"retail": "", "live": "", "forever": "forever/", "classic": "classic/", "ptr": "ptr/"}
TOOLTIP_TYPES = ("npc", "spell", "item", "quest", "object")


def die(msg):
    print("gamedata: " + msg)
    sys.exit(2)


def write_atomic(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "wb") as f:
        f.write(data)
    os.replace(tmp, path)


def fetch(url, cache_path=None, max_age=None, soft404=False):
    """Bytes of url; cached at cache_path. max_age None = keep forever. soft404: a 404 returns (None, False)."""
    if cache_path and os.path.exists(cache_path):
        age = time.time() - os.path.getmtime(cache_path)
        if max_age is None or age < max_age:
            with open(cache_path, "rb") as f:
                return f.read(), True
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "*/*"})
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            data = r.read()
    except urllib.error.HTTPError as e:
        if soft404 and e.code == 404:
            return None, False
        die("could not read %s -- %s" % (url, e))
    except Exception as e:  # noqa: BLE001 -- report and stop, never guess
        die("could not read %s -- %s" % (url, e))
    if cache_path:
        write_atomic(cache_path, data)
    return data, False


def builds():
    data, _ = fetch("https://wago.tools/api/builds", os.path.join(CACHE, "builds.json"), 6 * 3600)
    try:
        return json.loads(data.decode("utf-8"))
    except Exception:
        die("wago.tools/api/builds did not return JSON")


def latest_build(product):
    rows = builds().get(product) or []
    if not rows:
        die("no build known for product '%s' (try: run gamedata builds)" % product)
    return rows[0].get("version")


def cmd_builds(_args):
    b = builds()
    print("newest build per product (wago.tools/api/builds):")
    for prod in sorted(b):
        rows = b[prod] or []
        if rows:
            print("  %-22s %-16s %s" % (prod, rows[0].get("version"), rows[0].get("created_at")))
    print("  games: retail=wow  ptr=wowt  forever=wowf")


def parse_opts(args, keys):
    opts, rest = {}, []
    i = 0
    while i < len(args):
        a = args[i]
        if a.startswith("--"):
            k = a[2:]
            if k in ("count", "header"):
                opts[k] = True
            elif k in keys:
                if i + 1 >= len(args):
                    die("--%s needs a value" % k)
                opts[k] = args[i + 1]
                i += 1
            else:
                die("unknown option --%s" % k)
        else:
            rest.append(a)
        i += 1
    return opts, rest


def parse_filter(s):
    m = re.match(r"^([A-Za-z0-9_\[\]]+)(!=|=|~)(.*)$", s)
    if not m:
        die("filter '%s' must look like Col=val, Col~text or Col!=val" % s)
    col, op, val = m.groups()
    return col, op, val


def match(row, col, op, val):
    v = row.get(col)
    if v is None:
        return False
    if op == "=":
        return v in val.split(",")
    if op == "!=":
        return v not in val.split(",")
    return val.lower() in v.lower()


def cmd_db2(args):
    opts, rest = parse_opts(args, ("game", "build", "locale", "cols", "limit"))
    if not rest:
        die("db2 needs a table name, e.g. run gamedata db2 SpellName ID=198 --game forever")
    table, filters = rest[0], [parse_filter(s) for s in rest[1:]]
    game = (opts.get("game") or "retail").lower()
    if game not in PRODUCT:
        die("--game must be retail, ptr or forever")
    build = opts.get("build") or latest_build(PRODUCT[game])
    locale = opts.get("locale") or "enUS"
    q = {"build": build}
    if locale != "enUS":
        q["locale"] = locale
    url = "https://wago.tools/db2/%s/csv?%s" % (urllib.parse.quote(table), urllib.parse.urlencode(q))
    cpath = os.path.join(CACHE, "db2", build, "%s.%s.csv" % (table, locale))
    data, cached = fetch(url, cpath, None)
    text = data.decode("utf-8-sig", "replace")
    if text.lstrip().startswith("<"):
        try:
            os.remove(cpath)
        except OSError:
            pass
        die("wago.tools gave a web page, not a table -- is '%s' a real DB2 name for build %s?" % (table, build))
    reader = csv.DictReader(io.StringIO(text))
    header = reader.fieldnames or []
    print("%s  build %s  locale %s  (%s)" % (table, build, locale, "cache" if cached else "downloaded"))
    if opts.get("header"):
        print("columns: " + ", ".join(header))
        return
    for col, _, _ in filters:
        if col not in header:
            die("column '%s' not in %s. Columns: %s" % (col, table, ", ".join(header)))
    cols = opts.get("cols")
    cols = [c for c in cols.split(",")] if cols else header
    for c in cols:
        if c not in header:
            die("--cols: '%s' not in %s. Columns: %s" % (c, table, ", ".join(header)))
    limit = int(opts.get("limit") or 50)
    total, shown = 0, 0
    out = csv.writer(sys.stdout, lineterminator="\n")
    if not opts.get("count"):
        out.writerow(cols)
    for row in reader:
        if all(match(row, c, op, v) for c, op, v in filters):
            total += 1
            if not opts.get("count") and (limit == 0 or shown < limit):
                out.writerow([row.get(c, "") for c in cols])
                shown += 1
    print("-- %d matching row(s)%s" % (total, "" if opts.get("count") or total <= shown else
                                        ", %d shown (--limit 0 for all)" % shown))


def strip_html(s):
    s = re.sub(r"</t[dr]>|<br\s*/?>", "\n", s or "")
    s = re.sub(r"<[^>]+>", "", s)
    lines = [ln.strip() for ln in s.replace("&nbsp;", " ").replace("&amp;", "&").split("\n")]
    return [ln for ln in lines if ln]


def cmd_tooltip(kind, args):
    opts, ids = parse_opts(args, ("game", "locale"))
    if not ids:
        die("%s needs at least one id" % kind)
    game = (opts.get("game") or "retail").lower()
    if game not in WH_ENV:
        die("--game must be retail, forever, classic or ptr")
    loc = opts.get("locale")
    for i in ids:
        if not i.isdigit():
            die("'%s' is not a number" % i)
        url = "https://nether.wowhead.com/%stooltip/%s/%s" % (WH_ENV[game], kind, i)
        if loc and loc != "enUS":
            url += "?" + urllib.parse.urlencode({"locale": loc})
        cpath = os.path.join(CACHE, "tooltip", game, kind, "%s.%s.json" % (i, loc or "enUS"))
        data, cached = fetch(url, cpath, 3 * 86400, soft404=True)
        if data is None:
            print("%s %s (%s): Wowhead knows nothing under this id (404)" % (kind, i, game))
            continue
        try:
            j = json.loads(data.decode("utf-8"))
        except Exception:
            print("%s %s (%s): no JSON back" % (kind, i, game))
            continue
        if not j or not j.get("name"):
            print("%s %s (%s): Wowhead knows nothing under this id" % (kind, i, game))
            continue
        lines = strip_html(j.get("tooltip"))
        extra = lines[1:] if lines and lines[0] == j["name"] else lines
        print("%s %s (%s%s): %s" % (kind, i, game, ", cache" if cached else "", j["name"]))
        if j.get("icon"):
            print("   icon: %s" % j["icon"])
        for ln in extra[:8]:
            print("   " + ln)
        m = j.get("map") or {}
        if m:
            coords = []
            for _floor, pts in (m.get("coords") or {}).items():
                coords += ["%s,%s" % (p[0], p[1]) for p in pts]
            print("   zone (wowhead/AreaTable id): %s   spawns: %d  %s" % (
                m.get("zone"), len(coords), "  ".join(coords[:12]) + ("  ..." if len(coords) > 12 else "")))
    print("source: nether.wowhead.com/%stooltip -- Wowhead's own data, %s" % (WH_ENV[game], time.strftime("%Y-%m-%d")))


def main(argv):
    if not argv or argv[0] in ("-h", "--help", "help"):
        print(__doc__)
        return
    cmd, rest = argv[0].lower(), argv[1:]
    if cmd == "builds":
        cmd_builds(rest)
    elif cmd == "db2":
        cmd_db2(rest)
    elif cmd in TOOLTIP_TYPES:
        cmd_tooltip(cmd, rest)
    else:
        die("unknown command '%s' (builds, db2, %s)" % (cmd, ", ".join(TOOLTIP_TYPES)))


if __name__ == "__main__":
    main(sys.argv[1:])
