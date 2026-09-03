# -*- coding: utf-8 -*-
"""Our raid boss advice, side by side with Zygor's — a SECOND source for the half DBM cannot judge.

Rob, 3 Sep 2026: "ja doe zygor als tweede bron voor raid tips."

WHY THIS IS A DIFFERENT TOOL AND NOT A NEW SOURCE IN tip_audit.
🔴 MEASURED FIRST, and the measurement changed the design: `grep` for four of our raid spell ids
(1300530, 1284483, 1301510, 1292188) across ZygorDungeonCommonMID.lua returns **zero**, while the
same file holds **619** `|grouprole` tips. Positive control passed, so the zero is real: Zygor
carries no spell ids at all. It cannot confirm or deny a single number, which is the entire job
tip_audit does. Adding it there would have produced a source that agrees with nothing.

What it has instead is the thing DBM does NOT have. DBM gives ids and an alert type -- watchfeet,
justrun, breaklos -- which tells you what KIND of thing an ability is. Zygor gives sentences written
for a player: "Split into two groups for phase 2 to soak Spectral Coils." That is the layer this
addon exists for, and we had never read it.

WHAT THIS TOOL CLAIMS, AND WHAT IT DOES NOT.
✅ EXACT: whether Zygor writes advice for a ROLE where we ship none. That is a structural comparison
   -- our TIPS table against Zygor's `_TANK_`/`_HEALER_`/`_DAMAGE_` sections -- and it needs no
   reading of text at all. It is the one finding here that cannot be argued with.
⚠️ NOT A VERDICT: the side-by-side text. Deliberately no automatic "we are missing X". Our tips
   write abilities as `{SPELL:id}` and Zygor writes them as names, so a phrase absent from our raw
   source may be present on the player's screen. A checker that cannot see that would report almost
   every ability as missing and be wrong nearly every time. The reading is left to a human, which is
   how the Caustic Waves finding was made by hand this afternoon.

📌 Names are the join, and they are exact: `RaidCoachData.lua` spells the bosses the way the client
does ("Nek'zali the Soulcoiler"), verified against Rob's own `/mh ej save`, and Zygor writes the same
strings in `kill <Name>##<npcID>`. No fuzzy matching.

⚠️ Zygor re-parses on every run. It updates often -- twice in the three days before this was written
-- so nothing is snapshotted; a stale copy is exactly the failure this project keeps paying for.
"""
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADDONS = os.path.dirname(ROOT)
ZYGOR = os.path.join(ADDONS, "ZygorGuidesViewer", "Guides-Retail", "Dungeons",
                     "ZygorDungeonCommonMID.lua")
COACH = os.path.join(ROOT, "Modules", "RaidCoachData.lua")
RAIDTIPS = os.path.join(ROOT, "Locales", "RaidTips.lua")

GUIDE_RE = re.compile(r'RegisterGuide\("Dungeon Guides\\\\([^\\"]+)\\\\([^"]+)"')
KILL_RE = re.compile(r"^kill\s+(.+?)##(\d+)")
TIP_RE = re.compile(r"^\|tip\s+(.*?)\s*\|grouprole\s+(\w+)\s*$")
ROLE_HEAD_RE = re.compile(r"^_([A-Z]+)_\s*\|grouprole")

# ⚠️ TWO BUGS LIVED HERE IN FIVE MINUTES, and the second was caused by fixing the first.
# v1 had `\s*` throughout, and `\s` spans newlines, so it also matched the RAID entries --
# `{ key = "raid_venomousabyss",` and `name = "The Venomous Abyss",` are on separate lines
# -- putting five instances in the "bosses Zygor has no step for" list.
# v2 required `encounterID` immediately after the name, which dropped every Season 1 boss:
# theirs carry `seedCreatureId` in between. Tightening a pattern is not free.
# v3 allows other fields but forbids a newline, so it stays inside one table entry.
BOSS_RE = re.compile(
    r'\{\s*key\s*=\s*"(\w+)"\s*,\s*name\s*=\s*"([^"]+)"[^\n}]*encounterID')
# 📌 A SECOND, HARDER JOIN THAN THE NAME. Zygor writes `kill <Name>##<npcID>` and our Season 1
# bosses carry `seedCreatureId`. Measured: Imperator Averzian is 240435 in both files. Where
# both numbers exist they are compared, so a boss Blizzard renames cannot silently stop
# matching -- the id keeps the join and the mismatch gets reported instead of vanishing.
SEED_RE = re.compile(r'key\s*=\s*"(\w+)"[^\n}]*seedCreatureId\s*=\s*(\d+)')
TIPS_RE = re.compile(r"^\s*(\w+)\s*=\s*\{(.+)\},\s*$")
TIPKEY_RE = re.compile(r'(\w+)\s*=\s*"([A-Z0-9_]+)"')
LOCALE_RE = re.compile(r'^\s*([A-Z][A-Z0-9_]+)\s*=\s*"(.*)",\s*$')

# Zygor's section markers -> the role name our TIPS table uses.
ROLE_MAP = {"EVERYONE": "steps", "TANK": "tank", "HEALER": "healer", "DPS": "dps"}


def parse_zygor():
    """instance -> [ {bosses: [names], tips: {ROLE: [str]}} ], in guide order."""
    if not os.path.exists(ZYGOR):
        sys.exit("Zygor guide not found: %s\nIs ZygorGuidesViewer installed?" % ZYGOR)
    text = io.open(ZYGOR, encoding="utf-8", errors="replace").read()
    out, instance, step = {}, None, None
    for raw in text.split("\n"):
        line = raw.strip()
        gm = GUIDE_RE.search(line)
        if gm:
            instance = (gm.group(1), gm.group(2))  # (category, instance)
            out.setdefault(instance, [])
            step = None
            continue
        if instance is None:
            continue
        if line == "step":
            step = None
            continue
        km = KILL_RE.match(line)
        if km:
            if step is None:
                step = {"bosses": [], "tips": {}}
                out[instance].append(step)
            step["bosses"].append((km.group(1).strip(), km.group(2)))
            continue
        if step is None:
            continue
        if ROLE_HEAD_RE.match(line):
            continue
        tm = TIP_RE.match(line)
        if tm:
            step["tips"].setdefault(tm.group(2), []).append(tm.group(1).strip())
    return out


def parse_our_bosses():
    """[(key, name)] in file order, plus key -> {role: localeKey}."""
    text = io.open(COACH, encoding="utf-8", errors="replace").read()
    seeds = dict(SEED_RE.findall(text))
    bosses = [(m.group(1), m.group(2), seeds.get(m.group(1)))
              for m in BOSS_RE.finditer(text)]
    tips = {}
    for line in text.split("\n"):
        m = TIPS_RE.match(line)
        if not m:
            continue
        body = dict(TIPKEY_RE.findall(m.group(2)))
        if body:
            tips[m.group(1)] = body
    return bosses, tips


def parse_locale():
    """enUS only: the first block wins, later blocks are translations."""
    out = {}
    text = io.open(RAIDTIPS, encoding="utf-8", errors="replace").read()
    for line in text.split("\n"):
        m = LOCALE_RE.match(line)
        if m and m.group(1) not in out:
            out[m.group(1)] = m.group(2)
    return out


def norm(s):
    return re.sub(r"[^a-z0-9]", "", (s or "").lower())


def main():
    if len(sys.argv) > 1:
        sys.exit("zygor_tips takes no arguments (got %s)." % " ".join(sys.argv[1:]))

    guides = parse_zygor()
    bosses, our_tips = parse_our_bosses()
    locale = parse_locale()

    # Index every Zygor boss step by normalised name.
    by_name = {}
    for (cat, inst), steps in guides.items():
        for st in steps:
            for name, npc in st["bosses"]:
                by_name[norm(name)] = (cat, inst, npc, st)

    raids = sorted(k for k in guides if k[0].lower().find("raid") >= 0)
    print("=" * 78)
    print("Our raid advice vs Zygor's")
    print("=" * 78)
    print("Zygor guides parsed: %d (%d of them raids), %d boss steps, %d tips"
          % (len(guides), len(raids),
             sum(len(v) for v in guides.values()),
             sum(len(t) for v in guides.values() for s in v for t in s["tips"].values())))

    # 🔴 POSITIVE CONTROL. Measured by hand on 3 Sep: Zygor's Ula'tek step carries an
    # EVERYONE tip naming Spectral Coils. If the parser cannot find that, every "Zygor
    # says nothing here" below is a lie about a file that does say something.
    ctl = by_name.get(norm("Ula'tek"))
    ok = ctl and any("spectral coils" in t.lower() for t in ctl[3]["tips"].get("EVERYONE", []))
    if not ok:
        sys.exit("POSITIVE CONTROL FAILED: Zygor's Ula'tek step should carry an EVERYONE tip\n"
                 "naming Spectral Coils. The parser is broken; nothing below is trustworthy.")
    print("positive control ok: Ula'tek -> EVERYONE tip naming Spectral Coils")
    print()

    missing_role, no_match, id_ok, id_bad = [], [], 0, []
    for key, name, seed in bosses:
        hit = by_name.get(norm(name))
        if not hit:
            no_match.append(name)
            continue
        cat, inst, npc, st = hit
        if seed:
            if seed == npc:
                id_ok += 1
            else:
                id_bad.append((name, seed, npc))
        ours = our_tips.get(key) or {}
        print("-" * 78)
        print("%s   (%s / %s, npc %s)" % (name, cat, inst, npc))
        print("-" * 78)
        for role in ("steps", "tank", "healer", "dps"):
            lk = ours.get(role)
            if lk:
                body = locale.get(lk, "(no enUS text)")
                print("  OURS  [%s]" % role)
                for part in body.split("|n"):
                    print("        %s" % part.strip())
        for zrole in ("EVERYONE", "TANK", "HEALER", "DPS"):
            tips = st["tips"].get(zrole) or []
            if not tips:
                continue
            ourrole = ROLE_MAP.get(zrole)
            gap = "" if ours.get(ourrole) else "   <-- WE SHIP NOTHING FOR THIS ROLE"
            print("  ZYGOR [%s]%s" % (zrole, gap))
            for t in tips:
                print("        - %s" % t)
            if not ours.get(ourrole):
                missing_role.append((name, zrole))
        print()

    print("=" * 78)
    if id_ok or id_bad:
        print("npc-id cross-check (our seedCreatureId vs Zygor's kill##id): %d agree, %d differ"
              % (id_ok, len(id_bad)))
        for name, seed, npc in id_bad:
            print("   🔴 %-32s ours %s, Zygor %s — one of us has the wrong NPC"
                  % (name, seed, npc))
    if no_match:
        # ⚠️ " | ", not ", ": two of our bosses have a comma in the name ("Belo'ren, Child
        # of Al'ar", "Chimaerus, the Undreamt God") and a comma-joined list splits them into
        # four bosses that do not exist.
        print("Bosses of ours Zygor has no step for (%d): %s"
              % (len(no_match), " | ".join(no_match)))
    print("✅ EXACT FINDING — roles where Zygor writes advice and we ship none: %d"
          % len(missing_role))
    for name, zrole in missing_role:
        print("   %-32s %s" % (name, zrole))
    print()
    print("⚠️  The text above is for READING, not a verdict. Our tips write abilities as")
    print("    {SPELL:id} and Zygor writes names, so a phrase missing from our source may")
    print("    still be on the player's screen. Only the role list above is machine-checked.")
    print("📌  Zygor also covers 9 Midnight dungeons and Sporefall (Rotmire); this report")
    print("    shows raids only. The parser already holds the rest.")


if __name__ == "__main__":
    main()
