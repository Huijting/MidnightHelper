# -*- coding: utf-8 -*-
"""Check every {SPELL:id} in our raid tips against DBM's own boss mods.

WHY DBM IS THE YARDSTICK. Rob, 3 Sep 2026: "ik vind dat dbm best betrouwbaar is voor
onze info, daar zit een groot en fanatiek team achter die dit soort dingen echt
uitzoekt". That is the right call and it is not merely a vote of confidence: DBM's ids
are exercised in real pulls by people who get told immediately when a warning fires on
the wrong thing. Ours came from datamining, in at least one case before the boss
existed.

WHAT SET THIS OFF. Rob ran a Coiled Isle encounter and could not make sense of our
advice. Ula'tek measured by hand that morning: of our four spell ids, one matched a DBM
warning, two pointed at the wrong aspect of a mechanic, and one appeared nowhere in any
installed addon. Our own tip text even ended with "She never appeared on the PTR, so
expect surprises" -- honest, but printed AFTER four lines that read as fact.

HOW IT DECIDES. For every id we print, it asks a single question: does any DBM mod
mention this number at all? That is deliberately generous. DBM only creates warnings
for what it wants to warn about, so "DBM does not mention it" is a strong flag rather
than proof of error -- and the report says so rather than pretending otherwise.

🔴 POSITIVE CONTROL, BUILT IN. The run fails loudly if it cannot find DBM's own ids in
DBM's own files. An audit whose scanner silently matched nothing would report every id
as unknown and look like a catastrophe; this refuses to print in that state.
"""
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADDONS = os.path.dirname(ROOT)

# Our tips live in enUS-shaped tables; one file holds the raid text.
TIPS = os.path.join(ROOT, "Locales", "RaidTips.lua")

SPELL_RE = re.compile(r"\{SPELL:(\d+)\}")
KEY_RE = re.compile(r"^\s*(RAID_BOSS_[A-Z0-9_]+)\s*=")
# DBM ids are plain numbers in Lua source. Six digits or more keeps out timers,
# priorities and the small option numbers that would otherwise match everything.
NUM_RE = re.compile(r"\b(\d{6,})\b")


def dbm_sources():
    """Every DBM mod folder that ships boss files."""
    out = []
    for name in sorted(os.listdir(ADDONS)):
        if not name.startswith("DBM-"):
            continue
        p = os.path.join(ADDONS, name)
        if os.path.isdir(p):
            out.append((name, p))
    return out


# 🔴 "IT IS IN THE FILE" IS NOT THE SAME AS "DBM WARNS ON IT", and the difference is
# the whole point. Measured by hand on Ula'tek, 3 Sep 2026: of our four ids, 1286860
# drives a real warning and a 20.5s timer, 1292403 appears ONLY inside an
# AddAuraSoundOption (it is the DoT of a different cast), and 1287265 appears ONLY in a
# "--TODO" comment naming a spell DBM ended up implementing under another id. A checker
# that answers "is this number present" marks all three green and reassures you about
# two lines that made no sense in a real pull.
# 🔴 THIS CLASSIFIER WAS WRONG TWICE, IN OPPOSITE DIRECTIONS, BEFORE IT WAS CHECKED.
#
#   v1 accepted any `mod:Something(id` as a warning. `mod:AddAuraSoundOption(1292403,…)`
#      matched, so the DoT of a different cast came back "warned" — under a line of ours
#      telling people to DODGE it. Too generous.
#   v2 required the id to be the FIRST argument of a hand-listed set of constructors.
#      Both assumptions are false: DBM writes `NewCDCountTimer(20.5, 1284483, …)` with a
#      duration first, and its constructor names are far more varied than any list I
#      guessed (NewCountAnnounce is not New+Announce). Too strict — it reported 24 WEAK
#      of which at least three were provably real warnings.
#
# 📌 So classify by LINE, not by argument position or a name list. A DBM mod that acts
# on a spell says `mod:New…` on the line that carries the id; a mod that merely knows
# the number says AddAuraSoundOption or RegisterAltSpellName, or mentions it in a
# comment. That needs no list of constructor names and no view on where the id sits.
#
# ⚠️ Verified by hand against three ids on 3 Sep 2026 (1305959, 1284483, 1284590) —
# the two that v2 got wrong and one it got right. Do not "simplify" this back.
WARN_LINE = "mod:new"
KNOWS_ONLY = ("addaurasoundoption", "registeraltspellname", "addbooloption",
              "adddropdownoption", "addseticonoption", "addinfoframeoption")


def _strip_comments(text):
    """Drop -- line comments so a TODO cannot count as an implementation."""
    out = []
    for line in text.split("\n"):
        i = line.find("--")
        out.append(line if i < 0 else line[:i])
    return "\n".join(out)


def scan_dbm():
    """id -> { 'strong': set(files), 'weak': set(files) }.

    strong = the id is an argument to a DBM warning/timer constructor, i.e. DBM
             actually acts on it.
    weak   = the number occurs somewhere else: a comment, an aura-sound option, a
             sound-file mapping. Present, but nobody is being warned.
    """
    where = {}
    files = 0
    for addon, path in dbm_sources():
        for dirpath, _dirs, names in os.walk(path):
            for n in names:
                if not n.endswith(".lua"):
                    continue
                fp = os.path.join(dirpath, n)
                try:
                    text = io.open(fp, encoding="utf-8", errors="replace").read()
                except OSError:
                    continue
                files += 1
                label = "%s/%s" % (addon, os.path.splitext(n)[0])
                for raw in text.split("\n"):
                    line = _strip_comments(raw)
                    if not line.strip():
                        continue  # a comment-only line teaches us nothing
                    low = line.lower()
                    acts = (WARN_LINE in low)
                    knows = any(k in low for k in KNOWS_ONLY)
                    for m in NUM_RE.finditer(line):
                        i = m.group(1)
                        rec = where.setdefault(i, {"strong": set(), "weak": set()})
                        if acts and not knows:
                            rec["strong"].add(label)
                        else:
                            rec["weak"].add(label)
    return where, files


def our_tips():
    """key -> [ids] for the FIRST (enUS) block only; later blocks are translations."""
    text = io.open(TIPS, encoding="utf-8", errors="replace").read()
    found = {}
    order = []
    for line in text.split("\n"):
        km = KEY_RE.match(line)
        if not km:
            continue
        key = km.group(1)
        if key in found:
            continue  # translations repeat the same keys; keep the first
        ids = SPELL_RE.findall(line)
        found[key] = ids
        order.append(key)
    return order, found


def main():
    if not os.path.exists(TIPS):
        sys.exit("no %s" % TIPS)
    where, files = scan_dbm()

    print("=" * 70)
    print("Raid tips vs DBM")
    print("=" * 70)
    print("scanned %d DBM lua files in %d addon folder(s)"
          % (files, len(dbm_sources())))

    # 🔴 Positive control. These are ids read straight out of DBM's Ula'tek mod on
    # 3 Sep 2026. If the scanner cannot find them in DBM's own files, it is broken and
    # every "not in DBM" below would be a lie.
    # Two of these were misclassified by an earlier version of the scanner and are kept
    # here on purpose: 1305959 sits in NewCDCountTimer with the duration first, 1284483
    # likewise. A classifier that cannot see those is the classifier we already shipped
    # once and had to throw away.
    control = {"1300530": "Spectral Coils", "1301510": "Circling Prey",
               "1302982": "Virulent Spit", "1305959": "Venomous Surge",
               "1284483": "Blighted Blood"}
    missing_control = [i for i in control
                       if i not in where or not where[i]["strong"]]
    if missing_control:
        sys.exit("POSITIVE CONTROL FAILED: DBM's own ids %s not found. "
                 "The scanner is broken; no conclusion below would be trustworthy."
                 % ", ".join(missing_control))
    print("positive control ok: %s all found in DBM"
          % ", ".join("%s (%s)" % (i, n) for i, n in sorted(control.items())))
    print()

    order, tips = our_tips()
    total_ids = 0
    n_absent = 0
    n_weak = 0
    flagged = []

    for key in order:
        ids = tips.get(key) or []
        if not ids:
            continue
        rows = []
        bad = 0
        for i in ids:
            rec = where.get(i)
            if not rec:
                rows.append((i, "ABSENT", "in no DBM mod at all"))
                n_absent += 1
                bad += 1
            elif rec["strong"]:
                shown = sorted(rec["strong"])
                extra = "" if len(shown) <= 2 else "  (+%d)" % (len(shown) - 2)
                rows.append((i, "warned", ", ".join(shown[:2]) + extra))
            else:
                shown = sorted(rec["weak"])
                rows.append((i, "WEAK", "only mentioned, never warned on — "
                             + ", ".join(shown[:2])))
                n_weak += 1
                bad += 1
        total_ids += len(ids)
        mark = "  " if bad == 0 else "🔴"
        print("%s %-34s %d id(s), %d questionable" % (mark, key, len(ids), bad))
        for i, kind, note in rows:
            print("       %-9s %-7s %s" % (i, kind, note))
        if bad:
            flagged.append((key, bad))
        print()

    print("=" * 70)
    print("%d spell ids across %d tip lines" % (total_ids, len([k for k in order if tips.get(k)])))
    print("   %d ABSENT  — the number appears in no DBM mod at all" % n_absent)
    print("   %d WEAK    — present, but only in a comment or a sound option;" % n_weak)
    print("               DBM never warns on it, so it is probably not the cast")
    print("               a player is reacting to.")
    if flagged:
        print("tip lines carrying at least one of those: %d" % len(flagged))
        for k, n in flagged:
            print("   %-34s %d" % (k, n))
    print("=" * 70)
    print("⚠️  Neither verdict is proof. DBM only warns on what it chooses to warn on,")
    print("    and a WEAK hit can still be a real spell. What they DO prove is that the")
    print("    id was never checked against the mod of the team that fights this boss")
    print("    every week. Read the mod before rewriting the line.")


def classify():
    """(rows, where) for reuse by the linter.

    rows: [ (key, id, 'warned'|'WEAK'|'ABSENT') ] in file order.
    ⚠️ Kept separate from main() so lint_addon can import this module without printing
    a 200-line report inside its own output. _probe runs tools with run_name="__main__",
    so the guard below still lets `python tools/_probe.py run raid_tip_audit` work.
    """
    where, _files = scan_dbm()
    order, tips = our_tips()
    rows = []
    for key in order:
        for i in (tips.get(key) or []):
            rec = where.get(i)
            if not rec:
                rows.append((key, i, "ABSENT"))
            elif rec["strong"]:
                rows.append((key, i, "warned"))
            else:
                rows.append((key, i, "WEAK"))
    return rows, where


if __name__ == "__main__":
    main()
