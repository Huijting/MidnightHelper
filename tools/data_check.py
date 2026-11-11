# -*- coding: utf-8 -*-
"""C2 + C4: game data in MH against Blizzard's own tables (plan deel 2; Rob 10 Nov 2026: "Ja, stap 4").

C2  every spell / achievement / quest / item / map NUMBER in a recognised form must exist as a row in that game's DB2.
C4  every enUS Locales value that IS a game name (exactly the English name of an area, map, achievement or spell) must,
    in de/fr/es/pt/it/ru, be the name THAT client shows for the same row (CLAUDE.md, the 20 Oct 2026 rule).

Source: wago.tools DB2 CSVs per build, through tools/gamedata.py (cached in %LOCALAPPDATA%\\MidnightHelper\\gamedata_cache;
first run downloads ~40 tables, later runs are offline). Needs the network once per build, so this runs locally and in
the nightly watcher, NOT in the GitHub lint.

What it claims, and what it does not:
  ✅ "this number is no row in that table" — exact. Reported as "nakijken": a removed spell, a typo, or a number from a
     table this check does not know (a creature id written as `spell = …`).
  ⚠️ A number that EXISTS is not proven RIGHT (the same lesson as the 3 Nov "Skip": existence is not meaning).
  ⚠️ Numbers that come from a variable, a computed key or a form not listed in PATTERNS are not seen: the count of
     lines with an id-looking assignment that no pattern read is printed as the blind spot.
  ⚠️ DB2 holds structure and ids, not server facts (who sells what, drop rates).
  ⚠️ C4 only sees single-line Locales values and the FIRST value a pack sets for a key; a later fill() overriding it is
     not followed. Mismatches are "nakijken", never errors.
Positive controls run in the same run: known ids must be found, an impossible id must not, and the scanner must read
at least one number of each kind.

Usage (front door):  run data_check            -> C2 and C4
                     run data_check --c2       -> numbers only
                     run data_check --c4       -> names only
"""
import csv
import glob
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import gamedata as gd  # noqa: E402

GAMES = ("live", "ptr", "forever")
KINDS = {
    # kind: (table, patterns). Patterns read ONE number; keep them narrow — a wrong form floods the report.
    "spell": ("SpellName", [r"\{SPELL:(\d+)\}", r"\bspell(?:ID|Id)?\s*=\s*(\d+)", r"GetSpellName\(\s*(\d+)",
                            r"IsPlayerSpell\(\s*(\d+)", r"IsSpellKnown\(\s*(\d+)"]),
    "achievement": ("Achievement", [r"\b(?:achievementID|achID|achievementId|achievement|achiev|ach)\s*=\s*(\d+)",
                                    r"GetAchievementInfo\(\s*(\d+)"]),
    "quest": ("QuestV2", [r"\bquest(?:ID|Id)?\s*=\s*(\d+)", r"IsQuestFlaggedCompleted\(\s*(\d+)"]),
    "item": ("Item", [r"\bitem(?:ID|Id)?\s*=\s*(\d+)", r"GetItemCount\(\s*(\d+)"]),
    "map": ("UiMap", [r"\b(?:uiMapID|uiMapId|mapID|map)\s*=\s*(\d+)"]),
}
# The blind spot: id-looking assignments that no pattern above reads.
LOOSE = re.compile(r"\b(?:spell|ach|quest|item|map|npc)\w*\s*=\s*\d{3,}", re.I)
# Positive control: Auto Attack and Azeroth exist in all three games. (Not 1415: that is Eastern Kingdoms in Forever
# only; retail has no row 1415 — measured 10 Nov 2026, the first run failed on exactly that.)
KNOWN = {"spell": 6603, "map": 947}
# Numbers that are wrong on purpose, with the reason. Counted and printed, never silently dropped.
IGNORE = {
    999001: "DispelTest.lua: fake aura for /mh dispeltest", 999002: "DispelTest.lua: fake aura",
    999003: "DispelTest.lua: fake aura", 999004: "DispelTest.lua: fake aura",
}


def strip_block_comments(src):
    """Blank out --[[ … ]] blocks but keep the line count, so line numbers stay right."""
    return re.sub(r"--\[(=*)\[.*?\]\1\]", lambda m: "\n" * m.group(0).count("\n"), src, flags=re.S)
FOREVER_ONLY = re.compile(r"^if not ns\.IS_FOREVER then\s*(?:return|\r?\n\s*return)", re.M)
RETAIL_ONLY = re.compile(r"^if ns\.IS_FOREVER then\s*(?:return|\r?\n\s*return)", re.M)


def table_rows(game, table, locale="enUS", build=None):
    """{id: row-dict} for one DB2 table, or None when wago cannot give it (reported, never guessed)."""
    try:
        build = build or gd.latest_build(gd.PRODUCT[game])
        q = "build=%s" % build + ("" if locale == "enUS" else "&locale=" + locale)
        data, _ = gd.fetch("https://wago.tools/db2/%s/csv?%s" % (table, q),
                           os.path.join(gd.CACHE, "db2", build, "%s.%s.csv" % (table, locale)), None)
    except SystemExit:
        return None, build
    text = data.decode("utf-8-sig", "replace")
    if text.lstrip().startswith("<"):
        return None, build
    return {int(r["ID"]): r for r in csv.DictReader(io.StringIO(text)) if r.get("ID", "").isdigit()}, build


def lua_files():
    out = [os.path.join(ROOT, "Core.lua"), os.path.join(ROOT, "UI.lua")]
    for d in ("Modules", "Locales"):
        for dp, _, fs in os.walk(os.path.join(ROOT, d)):
            out += [os.path.join(dp, f) for f in fs if f.endswith(".lua")]
    return [p for p in out if os.path.isfile(p)]


def games_for(src):
    head = "\n".join(src.splitlines()[:60])
    if FOREVER_ONLY.search(head):
        return ("forever",)
    if RETAIL_ONLY.search(head):
        return ("live", "ptr")
    return GAMES  # shared: a number is fine when ANY of the games has it


def c2():
    found = {k: {} for k in KINDS}  # kind -> id -> [(rel, line, games)]
    loose = 0
    for p in lua_files():
        rel = os.path.relpath(p, ROOT).replace("\\", "/")
        with open(p, encoding="utf-8", errors="replace") as fh:
            src = fh.read()
        games = games_for(src)
        for n, line in enumerate(strip_block_comments(src).splitlines(), 1):
            if line.lstrip().startswith("--"):
                continue
            line = line.split("--", 1)[0] if "--" in line and '"' not in line else line
            read_here = 0
            for kind, (_, pats) in KINDS.items():
                for pat in pats:
                    for m in re.finditer(pat, line):
                        found[kind].setdefault(int(m.group(1)), []).append((rel, n, games))
                        read_here += 1
            if not read_here and LOOSE.search(line):
                loose += 1
                if "--loose" in sys.argv and loose <= 40:
                    print("     loose  %s:%d  %s" % (rel, n, line.strip()[:110]))
    print("C2 — numbers against Blizzard's tables")
    total = 0
    ok_all = True
    for kind, (table, _) in KINDS.items():
        ids = found[kind]
        if not ids:
            print("  %-11s scanner read 0 numbers — this kind proves nothing this run" % kind)
            ok_all = False
            continue
        rows, builds, missing_tables = {}, [], []
        for g in GAMES:
            r, b = table_rows(g, table)
            if r is None:
                missing_tables.append("%s %s" % (g, b))
                continue
            rows[g] = set(r)
            builds.append("%s %s" % (g, b))
        if not rows:
            print("  %-11s NOT CHECKED — wago gave no %s for %s" % (kind, table, ", ".join(missing_tables)))
            ok_all = False
            continue
        ctrl = KNOWN.get(kind)
        if ctrl and not all(ctrl in s for s in rows.values()):
            print("  %-11s positive control FAILED: %d missing from %s" % (kind, ctrl, table))
            ok_all = False
        if any(99999999 in s for s in rows.values()):
            print("  %-11s positive control FAILED: 99999999 found in %s" % (kind, table))
            ok_all = False
        bad = []
        for i, sites in sorted(ids.items()):
            if i in IGNORE:
                print("     on purpose %-7d %s" % (i, IGNORE[i]))
                continue
            games = set(g for _, _, gs in sites for g in gs)
            if not any(i in rows[g] for g in games if g in rows):
                bad.append((i, sites))
        total += len(bad)
        print("  %-11s %5d distinct numbers, %d nakijken  (%s%s)" % (
            kind, len(ids), len(bad), table + ": " + ", ".join(builds),
            ("; NOT in this run: " + ", ".join(missing_tables)) if missing_tables else ""))
        for i, sites in bad[:25]:
            print("     nakijken  %-9d %s" % (i, ", ".join("%s:%d" % (r, n) for r, n, _ in sites[:3])))
        if len(bad) > 25:
            print("     ... and %d more" % (len(bad) - 25))
    print("  blind spot: %d lines with an id-looking assignment that no pattern reads (not checked)" % loose)
    return total, ok_all


C4_TABLES = (("AreaTable", "AreaName_lang"), ("Map", "MapName_lang"), ("Achievement", "Title_lang"),
             ("SpellName", "Name_lang"))
C4_LOCALES = {"deDE": ("live", "forever"), "frFR": ("live", "forever"), "esES": ("live", "forever"),
              "ptBR": ("live", "forever"), "itIT": ("live",), "ruRU": ("live", "forever")}
# Keys whose English text only happens to equal a game name: the pack is right to translate the plain word.
# Rob chose these on 11 Nov 2026 ("Ja, alle drie"). Counted and printed, never silently dropped.
C4_IGNORE = {
    "CRAFTSHOP_MAKING": "status word 'Crafting' (being made), not the Crafting achievement/area",
    "LAYOUT_CARD_BUILDER": "resource-builder spell role, not the 'Builder' NPC/achievement",
    "SETTINGS_SECTION_GENERAL": "settings section 'General', not the NPC rank General",
    "SET_BTN_TEST": "button 'Test', not the Test area",
    "TOUR_CODEX_NAV": "opens MH's own Codex tab, not the spell 'Open Codex'",
    "DAWNCREST_TIER_CHAMPION": "crest track word; deDE client says 'Morgenlichtwappen des Champions' (CurrencyTypes "
                               "3343, measured 11 Nov 2026), the 'Feldherr' match is another row",
    "SMC_SEARCH_PORTALS": "search words; since 11 Nov 2026 they CONTAIN the client name, which an exact match cannot see",
    "GUIDE_CONS_TYPE_HEALING": "category label for Midnight's potions (ItemSparse 241304 etc., measured 11 Nov 2026: "
                               "Heiltrank / soins / sanación / Vida / лечебное); the exact 'Health Potion' row is "
                               "another, older thing",
}
# Still flagged on purpose (11 Nov 2026): deDE DELVE_NAME_LABYRINTH / DELVE_NAME_RING_OF_GLORY and esES
# DELVE_NAME_RING_OF_GLORY. The client name has an article ("Das Labyrinth", "Der Ring"), but the same key goes into
# a sentence (DELVE_SHARE_CONFIRM_FMT via ns:GetDelveChatDisplayName), where "für Das Labyrinth" is wrong German.
# Fixing it needs a separate label key; until then these three stay visible here.


def _same(a):
    """Compare names without typography noise: ’ vs ', no-break spaces, – vs -, case. Measured 10 Nov 2026: French
    "Zul’Aman : les plus hautes cimes" was flagged against itself because of a no-break space before the colon."""
    a = a.replace("’", "'").replace(" ", " ").replace(" ", " ").replace("–", "-")
    return " ".join(a.split()).lower()


def c4():
    import lint_addon as la
    values = la.collect_locale_values(ROOT)
    en = values.get("enUS", {})
    # What the game shows is NOT the first value: fill() in the fill files replaces a pack value that is still the
    # English copy (CLAUDE.md, Localization). Measured 10 Nov 2026: reading only the first value flagged
    # "Restored Coffer Key" in de/fr/es/pt/it although Translations2026.lua sets the client name. Mirror the runtime.
    real_files = la.locale_files
    la.locale_files = lambda root: [p for p in real_files(root)
                                    if os.path.basename(p) in {os.path.basename(f) for f in la.FILL_FILES}]
    try:
        fills = la.collect_locale_values(ROOT)
    finally:
        la.locale_files = real_files
    for loc, fv in fills.items():
        if loc == "enUS":
            continue
        lv = values.setdefault(loc, {})
        for k, v in fv.items():
            if k not in lv or (k in en and lv[k][0] == en[k][0]):
                lv[k] = v
    print("C4 — game names per language (the name THAT client shows)")
    # enUS name -> [(game, table, col, ids)]
    names = {}
    for g in ("live", "forever"):
        for table, col in C4_TABLES:
            rows, b = table_rows(g, table)
            if rows is None:
                print("  NOT CHECKED: %s %s (%s)" % (g, table, b))
                continue
            for i, r in rows.items():
                v = (r.get(col) or "").strip()
                # A one-word spell name ("Hide", "Shift", "Left") is an ordinary button word far more often than a
                # game name: measured 10 Nov 2026, the first run gave 361 hits, mostly those. Spells need 2+ words.
                if len(v) >= 4 and (table != "SpellName" or " " in v):
                    names.setdefault(v, []).append((g, table, col, i))
    keys = {k: v[0] for k, v in en.items() if v[0].strip() in names}
    print("  enUS values that are exactly a game name: %d" % len(keys))
    if not keys:
        print("  positive control FAILED: no Locales value matched any name — the parse is wrong")
        return 0, False
    cache = {}

    def loc_name(g, table, col, loc, i):
        k = (g, table, loc)
        if k not in cache:
            rows, _ = table_rows(g, table, loc)
            cache[k] = rows or {}
        r = cache[k].get(i)
        return (r.get(col) or "").strip() if r else None

    total, shown = 0, 0
    for k in sorted(C4_IGNORE):
        print("     on purpose %-34s %s%s" % (k, C4_IGNORE[k], "" if k in keys else "  [no longer matched]"))
    for loc, games in C4_LOCALES.items():
        lv = values.get(loc, {})
        miss = []
        checked = 0
        for k, enval in sorted(keys.items()):
            if k not in lv or k in C4_IGNORE:
                continue  # not translated: the English fallback is a different finding (parity), not this one
            mine = lv[k][0].strip()
            want = set()
            for g, table, col, i in names[enval.strip()]:
                if g in games:
                    n = loc_name(g, table, col, loc, i)
                    if n:
                        want.add(n)
            if not want:
                continue
            checked += 1
            if _same(mine) not in {_same(w) for w in want}:
                miss.append((k, mine, sorted(want)[:2], lv[k][1], lv[k][2]))
        total += len(miss)
        print("  %s: %d checked, %d nakijken" % (loc, checked, len(miss)))
        lim = 200 if "--all" in sys.argv else 12
        for k, mine, want, rel, n in miss[:lim]:
            print("     nakijken  %-34s pack %r  client %s  (%s:%d)" % (k, mine, " / ".join(want), rel, n))
        if len(miss) > lim:
            print("     ... and %d more (--all shows them)" % (len(miss) - lim))
        shown += checked
    ok = shown > 0
    if not ok:
        print("  positive control FAILED: nothing could be compared")
    return total, ok


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    args = sys.argv[1:]
    do2 = "--c4" not in args
    do4 = "--c2" not in args
    ok = True
    n2 = n4 = 0
    if do2:
        n2, o = c2()
        ok &= o
    if do4:
        n4, o = c4()
        ok &= o
    print("RESULT: %d numbers and %d names to look at; positive controls %s" % (n2, n4, "OK" if ok else "FAILED"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
