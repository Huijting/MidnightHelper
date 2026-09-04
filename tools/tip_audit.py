# -*- coding: utf-8 -*-
"""Check every {SPELL:id} in our tips against DBM's own boss mods.

🔴 READ THE COVERAGE TABLE BEFORE READING THE FINDINGS. DBM is only a yardstick where DBM
has done the work. MEASURED 3 Sep 2026: DBM-Raids-Midnight 17/17 boss files carry
warnings and DBM-Party-Midnight 31/36 -- those are real checks. DBM-Delves-Midnight is
4/30: Antenorian, Hydrangea and Gladius Slaurna are stubs holding SetEncounterID and
nothing else, one still carrying "--mod:SetCreatureID(0)--TODO".

So an ABSENT verdict on a delve id means DBM HAS NO OPINION, not that we are wrong. The
first widened run reported 40 of 44 delve ids absent, which reads as a catastrophe and is
an artefact of somebody else's TODO list. It was caught by opening one mod by hand.


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

# 📌 WIDENED 3 Sep 2026 FROM RAIDS TO EVERY TIP FILE WE SHIP, at Rob's request the same
# afternoon the raid pass finished: "kunnen we de dungeons en Delves ook met DBM data
# checken en dicht timmeren?" Yes -- and the counts say why it mattered. The raid file
# carried 105 spell ids; DungeonTips carries several times that, and nothing had ever
# held any of them against DBM either.
#
# ⚠️ Ritual tips are included even though DBM has no ritual mods. That is deliberate: the
# report then says out loud that those ids have no yardstick, instead of leaving a whole
# content type silently unchecked, which is how the raid problem survived for months.
TIP_FILES = [
    ("raids", os.path.join(ROOT, "Locales", "RaidTips.lua")),
    ("dungeons", os.path.join(ROOT, "Locales", "DungeonTips.lua")),
    ("delves", os.path.join(ROOT, "Locales", "DelveTips.lua")),
    ("rituals", os.path.join(ROOT, "Locales", "RitualTips.lua")),
]

SPELL_RE = re.compile(r"\{SPELL:(\d+)\}")

# 🔴 DELVES USE NAMES, NOT NUMBERS, AND THE FIRST RUN OF THIS TOOL SILENTLY SKIPPED THEM.
# DelveTips.lua writes {SPELL:@shadow_bolt}; the numeric pattern above matched none of its
# 154 placeholders, so the report showed no "delves" row at all -- an entire content type
# missing, looking exactly like a content type with nothing wrong. That is the mistake
# this repo has been burned by repeatedly, committed by the very tool built to catch it.
# It was caught only because the widened run printed no delve line and the counts had said
# there were 154 placeholders to find.
#
# The tokens resolve through Modules/DelveSpellIds.lua, so they are checkable after all.
NAMED_RE = re.compile(r"\{SPELL:@([a-z0-9_]+)\}")
TOKEN_MAP_FILE = os.path.join(ROOT, "Modules", "DelveSpellIds.lua")
TOKEN_RE = re.compile(r"^\s*([a-z0-9_]+)\s*=\s*(\d+)\s*,")


def token_map():
    """token -> spell id, from the addon's own table."""
    out = {}
    if not os.path.exists(TOKEN_MAP_FILE):
        return out
    for line in io.open(TOKEN_MAP_FILE, encoding="utf-8", errors="replace"):
        m = TOKEN_RE.match(line)
        if m:
            out[m.group(1)] = m.group(2)
    return out
KEY_RE = re.compile(r"^\s*((?:RAID_BOSS|DGN_TIP|DELVE_TIP|RITUAL_TIP)_[A-Z0-9_]+)\s*=")
# DBM ids are plain numbers in Lua source. Six digits or more keeps out timers,
# priorities and the small option numbers that would otherwise match everything.
NUM_RE = re.compile(r"\b(\d{6,})\b")


#: 🔴 The positive control, shared by both entry points.
#
# Ids read straight out of DBM's Ula'tek mod on 3 Sep 2026. If the scanner cannot find
# these in DBM's own files it is broken, or DBM is not installed, and every "not in DBM"
# verdict would be a lie.
#
# Two of them were misclassified by an earlier version of the scanner and are kept on
# purpose: 1305959 sits in NewCDCountTimer with the duration first, 1284483 likewise. A
# classifier that cannot see those is the classifier we already shipped once and threw
# away.
#
# ⚠️ This lived inside main() until 4 Sep 2026, which meant `classify()` -- the function
# the linter imports -- never ran it. See the note on classify().
CONTROL_IDS = {
    "1300530": "Spectral Coils",
    "1301510": "Circling Prey",
    "1302982": "Virulent Spit",
    "1305959": "Venomous Surge",
    "1284483": "Blighted Blood",
}


def assert_dbm_present(where, files):
    """Raise unless DBM is installed and readable.

    The caller decides what to do about it. The linter turns this into "NOT CHECKED",
    which is the honest answer on a CI runner that has no addon folder beside the repo --
    and a great deal better than 378 invented findings.
    """
    if not files:
        raise RuntimeError(
            "no DBM boss files found (%d addon folder(s) scanned). This check compares "
            "our spell ids against DBM's own mods, so without DBM it can measure "
            "nothing -- it must not report every id as ABSENT."
            % len(dbm_sources()))
    missing = [i for i in CONTROL_IDS
               if i not in where or not where[i]["strong"]]
    if missing:
        raise RuntimeError(
            "positive control failed: DBM's own ids %s were not found. The scanner is "
            "broken or DBM is incomplete; no verdict would be trustworthy."
            % ", ".join(sorted(missing)))


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

# 🔴 A FOURTH VERDICT, 3 Sep 2026, AND THE CLASSIFIER WAS WRONG A THIRD TIME.
# All 13 remaining WEAK dungeon ids turned out to be CORRECT. Every one of them sits in
# AddAuraSoundOption(id, true, id, ..., "<cue>", n) -- enabled by default, with a named
# voice cue. In 12.x a private aura is unreadable, so this is not DBM declining to warn:
# it is the ONLY way DBM *can* warn, and "only mentioned, never warned on" said the
# opposite of the truth about them.
#
# The real discriminator is inside the call, not the call itself. Argument 1 is the aura,
# argument 3 is the CAST it belongs to:
#     AddAuraSoundOption(1246753, true, 1246753, 1, 2, "watchfeet", 8)  -- Lightsap
#     AddAuraSoundOption(1292403, true, 1292188, 1, 3, "dotyou",   19)  -- Caustic Wave Dot
# The first is the thing itself. The second is the DoT OF ANOTHER CAST -- Ula'tek's
# 1292403, the id that started this whole audit, which our text told players to "dodge"
# while DBM's cue says "dotyou". So: parent == id is the ability; parent != id means we
# are quoting a side effect and naming it as the cast. That is the trap, and it is
# machine-checkable, where "is it in AddAuraSoundOption" never was.
#
# ⚠️ WHAT THIS STILL CANNOT DO. It cannot tell whether OUR VERB matches DBM's cue --
# "cone" against "watchfeet" stays a human read. The report prints the cue precisely so
# that read is possible; it is not a check. (It caught Kystia's tank line that way:
# our sentence says "aim the cone", which is the cast 1253811, not the ground 1253813.)
# ⚠️ DO NOT try to reach the cue with one regex and an optional trailing group. Two
# attempts failed the same way: a greedy filler consumes the arguments up to the quote,
# the OPTIONAL cue group then matches empty, the overall match SUCCEEDS, and nothing
# backtracks. The tool printed 'DBM cue "no cue"' for ids that have one -- inviting the
# reader to conclude DBM said nothing. Grab the argument list and split it instead;
# there are no nested parens or commas inside these calls.
AURA_CALL_RE = re.compile(r"AddAuraSoundOption\(([^)]*)\)")
CUE_RE = re.compile(r'^"([a-z]+)"$')


def parse_aura(line):
    """(aura_id, parent_id, cue, enabled) for one AddAuraSoundOption call, or None."""
    m = AURA_CALL_RE.search(line)
    if not m:
        return None
    args = [a.strip() for a in m.group(1).split(",")]
    if len(args) < 3 or not args[0].isdigit():
        return None
    parent = args[2]
    # 🔴 A NEGATIVE PARENT IS A JOURNAL SECTION, NOT ANOTHER CAST. DBM writes
    #     AddAuraSoundOption(1301118, true, -36292, 1, 1, "targetyou", 2, 0)--Grasping Fangs
    # where -36292 is an encounter-journal section id it borrows for the option's name.
    # The first parser required digits, gave up, and the id fell through to WEAK -- which
    # is how lint [19] flagged a brand-new Ula'tek healer line as unbacked on 3 Sep. It is
    # not a side effect of a different spell, so it must not read as AURA-OF either:
    # negative parent counts as SELF. The trap this distinction exists for needs a real
    # spell id on the other side of it.
    if not (parent.isdigit() or (parent.startswith("-") and parent[1:].isdigit())):
        return None
    is_self = (parent == args[0]) or parent.startswith("-")
    cue = ""
    for a in args[3:]:
        cm = CUE_RE.match(a)
        if cm:
            cue = cm.group(1)
            break
    return args[0], parent, cue, args[1] == "true", is_self
# DBM alerts through these too. EnableAlertOptions(1230304, 610, "targetchange", ...) is
# a real text warning with a cue; it just has no timeline timer, which is why the mod
# says so in a comment right above it.
ACTS_TOO = ("enablealertoptions", "addcustomalertsoundoption")


def _aura_self(rec):
    """(label, (parent, cue, enabled, is_self)) where DBM's aura IS the ability itself."""
    for lab, v in sorted((rec.get("aura") or {}).items()):
        if v[2] and v[3]:
            return lab, v
    return None


def _aura_other(rec):
    """(label, (parent, cue, enabled, is_self)) where the aura belongs to another cast."""
    for lab, v in sorted((rec.get("aura") or {}).items()):
        if v[2] and not v[3]:
            return lab, v
    return None


def _strip_comments(text):
    """Drop -- line comments so a TODO cannot count as an implementation."""
    out = []
    for line in text.split("\n"):
        i = line.find("--")
        out.append(line if i < 0 else line[:i])
    return "\n".join(out)


def scan_extra_sources():
    """id -> set of non-DBM addons that also know it.

    🔴 ROB, 3 Sep: "er zijn toch ook sites en addons op cf voor alles". Right, and it
    landed exactly where the audit was weakest. MythicDungeonTools ships per-dungeon
    spell tables for Midnight and is installed here, which makes it a SECOND local
    yardstick for dungeons -- and it immediately vindicated three ids this tool had
    called ABSENT (1296219, 1251813, 1214352).
    ⚠️ Local and machine-readable is the requirement, not authority in the abstract. A
    website cannot be checked by a linter every run, and the guides this project already
    burned itself on were confidently wrong. An addon on disk can be parsed and re-parsed.
    """
    out = {}
    for name in ("MythicDungeonTools", "GTFO", "BossHelper", "JustAC"):
        root = os.path.join(ADDONS, name)
        if not os.path.isdir(root):
            continue
        for dirpath, _d, names in os.walk(root):
            for n in names:
                if not n.endswith(".lua"):
                    continue
                try:
                    text = io.open(os.path.join(dirpath, n), encoding="utf-8",
                                   errors="replace").read()
                except OSError:
                    continue
                for m in NUM_RE.finditer(text):
                    out.setdefault(m.group(1), set()).add(name)
    return out


def scan_dbm():
    """id -> { 'strong': set(files), 'weak': set(files), 'noted': set(files) }.

    🔴 'noted' EXISTS BECAUSE STRIPPING COMMENTS WAS RIGHT TWICE AND WRONG ONCE. Comments
    had to be ignored so a "--TODO" mention could not pass as an implementation. But DBM
    also uses comments to record a DECISION about a real spell, and those reads as ABSENT:
      Ravi.lua      "--https://.../spell=1296219/fetid-roar isn't in journal but has
                     encounter event" and a commented warning marked "Possibly not needed"
      Vordaza.lua   "1251813 has a private aura but it doesn't need an alert"
      Zaen.lua      "1214352 ... ENCOUNTER_WARNING intercept is used instead"
    All three are real spells DBM deliberately does not warn on, and all three are in
    MythicDungeonTools too. Calling them ABSENT told Rob to go fix three correct lines.

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
                        # Comment-only: DBM knows the number and wrote down why it does
                        # not act on it. That is a decision, not silence.
                        for m in NUM_RE.finditer(raw):
                            rec = where.setdefault(m.group(1), {
                                "strong": set(), "weak": set(), "noted": set(),
                                "aura": {}})
                            rec.setdefault("aura", {})
                            rec["noted"].add(label)
                        continue
                    low = line.lower()
                    acts = (WARN_LINE in low) or any(k in low for k in ACTS_TOO)
                    knows = any(k in low for k in KNOWS_ONLY)
                    am = parse_aura(line)
                    if am:
                        aura_id, parent, cue, enabled, is_self = am
                        rec = where.setdefault(aura_id, {
                            "strong": set(), "weak": set(), "noted": set(),
                            "aura": {}})
                        rec.setdefault("aura", {})[label] = (
                            parent, cue, enabled, is_self)
                    for m in NUM_RE.finditer(line):
                        i = m.group(1)
                        rec = where.setdefault(i, {
                            "strong": set(), "weak": set(), "noted": set(),
                            "aura": {}})
                        rec.setdefault("aura", {})
                        if acts and not knows:
                            rec["strong"].add(label)
                        else:
                            rec["weak"].add(label)
                    # A trailing comment on a code line can also carry a decision.
                    tail = raw[len(line):] if raw.startswith(line) else ""
                    for m in NUM_RE.finditer(tail):
                        rec = where.setdefault(m.group(1), {
                            "strong": set(), "weak": set(), "noted": set(),
                            "aura": {}})
                        rec.setdefault("aura", {})
                        rec["noted"].add(label)
    return where, files


def our_tips():
    """key -> [ids] for the FIRST (enUS) block only; later blocks are translations.

    Returns (order, found, origin) where origin maps key -> which content type it came
    from, so the report can say "dungeons" rather than making the reader infer it.
    """
    found, order, origin = {}, [], {}
    tokens = token_map()
    unresolved = []
    for label, path in TIP_FILES:
        if not os.path.exists(path):
            continue
        text = io.open(path, encoding="utf-8", errors="replace").read()
        for line in text.split("\n"):
            km = KEY_RE.match(line)
            if not km:
                continue
            key = km.group(1)
            if key in found:
                continue  # translations repeat the same keys; keep the first
            ids = list(SPELL_RE.findall(line))
            for tok in NAMED_RE.findall(line):
                if tok in tokens:
                    ids.append(tokens[tok])
                else:
                    # A token with no entry cannot render at all. Louder than an id DBM
                    # does not know: this one shows the player nothing.
                    unresolved.append((key, tok))
            if not ids and not unresolved:
                continue
            if not ids:
                continue
            found[key] = ids
            origin[key] = label
            order.append(key)
    return order, found, origin, unresolved


def main():
    # 🔴 This tool has NO options, so it must say so instead of accepting them.
    # On 3 Sep 2026 it was run as `--write-baseline`, printed a full clean report, and
    # wrote nothing -- the flag was invented on the spot and silently swallowed. The
    # report looked exactly like success. Same shape as the false CLAUDE.md line: an
    # instruction that is wrong is worse than one that is missing, because it stops you
    # looking. tip_baseline.json is maintained BY HAND from lint check [19]'s output.
    if len(sys.argv) > 1:
        sys.exit("tip_audit takes no arguments (got %s). It only prints the report;\n"
                 "tools/tip_baseline.json is edited by hand from lint check [19]."
                 % " ".join(sys.argv[1:]))

    missing_files = [p for _l, p in TIP_FILES if not os.path.exists(p)]
    if missing_files:
        sys.exit("missing tip file(s): %s" % ", ".join(missing_files))
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
    control = dict(CONTROL_IDS)
    missing_control = [i for i in control
                       if i not in where or not where[i]["strong"]]
    if missing_control:
        sys.exit("POSITIVE CONTROL FAILED: DBM's own ids %s not found. "
                 "The scanner is broken; no conclusion below would be trustworthy."
                 % ", ".join(missing_control))
    print("positive control ok: %s all found in DBM"
          % ", ".join("%s (%s)" % (i, n) for i, n in sorted(control.items())))

    # 🔴 THIRD POSITIVE CONTROL — for the aura parser, because its whole value is the cue.
    # A verdict that prints 'cue "no cue"' for an id that has one is worse than no verdict:
    # it invites the reader to conclude DBM said nothing. The first regex did exactly that
    # for 1300685 by swallowing the quoted cue as a positional argument.
    # These two are the pair the AURA-OF distinction rests on:
    #   1246753 Lightsap       parent == self, cue watchfeet  -> the ability itself
    #   1292403 Caustic Wave   parent 1292188, cue dotyou     -> the aura of ANOTHER cast
    #   1301118 Grasping Fangs parent -36292, cue targetyou -> a JOURNAL SECTION parent,
    #           which must still count as self; getting this wrong flagged a new and
    #           correctly-sourced Ula'tek healer line as unbacked.
    aura_control = {"1246753": ("1246753", "watchfeet"),
                    "1292403": ("1292188", "dotyou"),
                    "1301118": ("-36292", "targetyou")}
    for i, (want_parent, want_cue) in sorted(aura_control.items()):
        got = (where.get(i) or {}).get("aura") or {}
        hit = [v for v in got.values() if v[0] == want_parent and v[1] == want_cue]
        if not hit:
            sys.exit("AURA CONTROL FAILED: %s should parse as parent=%s cue=%s, got %r.\n"
                     "The aura parser is broken; every cue printed below is unreliable."
                     % (i, want_parent, want_cue, sorted(got.values())))
    print("aura control ok: 1246753 = watchfeet (self), 1292403 = dotyou (aura of 1292188)")

    # 🔴 SECOND POSITIVE CONTROL, ADDED THE MOMENT THE DELVE NUMBERS LOOKED TOO BAD.
    # The first widened run reported 40 of 44 delve ids ABSENT, which reads as "our delve
    # tips are almost entirely wrong". Reading one mod by hand said otherwise:
    # DBM-Delves-Midnight/Encounters/Antenorian.lua is a STUB -- SetEncounterID and
    # RegisterCombat and nothing else, with "--mod:SetCreatureID(0)--TODO" still in it.
    # Hydrangea and Gladius Slaurna are the same. Spiritflayer Jin'Ma has four warnings,
    # the Nemesis mods have thirteen, so the coverage is partial rather than missing.
    #
    # ⚠️ So for a stubbed encounter ABSENT means "DBM HAS NO OPINION", not "we are wrong",
    # and reporting it as a finding would have manufactured a crisis out of DBM's own TODO
    # list. This prints the coverage so nobody reads the delve column the way I nearly did.
    print()
    print("DBM coverage (files with at least one warning / total boss files):")
    for addon, path in dbm_sources():
        if not any(k in addon for k in ("Delves", "Party-Midnight", "Raids-Midnight", "Lairs")):
            continue
        withw = total = 0
        for dirpath, _d, names in os.walk(path):
            for n in names:
                if not n.endswith(".lua") or n.startswith("localization"):
                    continue
                total += 1
                try:
                    t = io.open(os.path.join(dirpath, n), encoding="utf-8",
                                errors="replace").read()
                except OSError:
                    continue
                if "mod:New" in _strip_comments(t):
                    withw += 1
        if total:
            flag = "  <-- mostly stubs" if withw * 2 < total else ""
            print("   %-28s %3d / %3d%s" % (addon, withw, total, flag))
    print()

    extra = scan_extra_sources()
    print("second sources on disk: %d ids known to MythicDungeonTools / GTFO / others"
          % len(extra))
    print()
    order, tips, origin, unresolved = our_tips()
    if unresolved:
        print("🔴 %d {SPELL:@token} placeholder(s) with no entry in DelveSpellIds.lua —"
              % len(unresolved))
        print("   these render as nothing at all, which is worse than a wrong id:")
        for key, tok in unresolved[:20]:
            print("    HARD  %-34s @%s" % (key, tok))
        print()
    total_ids = 0
    n_absent = 0
    n_weak = 0
    n_aura = 0
    n_auraof = 0
    flagged = []
    per_type = {}

    for key in order:
        ids = tips.get(key) or []
        if not ids:
            continue
        rows = []
        bad = 0
        for i in ids:
            rec = where.get(i)
            others = extra.get(i)
            if not rec and others:
                # Not in DBM at all, but another installed addon carries it. Weaker than
                # a DBM warning and much stronger than nothing.
                rows.append((i, "2nd-src", "not in DBM, but known to " + ", ".join(sorted(others))))
            elif rec and not rec["strong"] and not rec["weak"] and rec["noted"]:
                rows.append((i, "noted", "DBM names it in a comment and chose not to warn — "
                             + ", ".join(sorted(rec["noted"])[:2])))
            elif not rec:
                rows.append((i, "ABSENT", "in no DBM mod at all"))
                n_absent += 1
                bad += 1
            elif rec["strong"]:
                shown = sorted(rec["strong"])
                more = "" if len(shown) <= 2 else "  (+%d)" % (len(shown) - 2)
                rows.append((i, "warned", ", ".join(shown[:2]) + more))
            elif _aura_self(rec):
                lab, (_p, cue, _on, _s) = _aura_self(rec)
                rows.append((i, "aura", "private aura, DBM cue \"%s\" — %s"
                             % (cue or "no cue", lab)))
                n_aura += 1
            elif _aura_other(rec):
                lab, (parent, cue, _on, _s) = _aura_other(rec)
                rows.append((i, "AURA-OF", "side effect of cast %s, DBM cue \"%s\" — %s"
                             % (parent, cue or "no cue", lab)))
                n_auraof += 1
                bad += 1
            else:
                shown = sorted(rec["weak"])
                rows.append((i, "WEAK", "only mentioned, never warned on — "
                             + ", ".join(shown[:2])))
                n_weak += 1
                bad += 1
        total_ids += len(ids)
        per_type.setdefault(origin.get(key, "?"), [0, 0, 0])
        per_type[origin.get(key, "?")][0] += len(ids)
        per_type[origin.get(key, "?")][1] += bad
        if bad:
            per_type[origin.get(key, "?")][2] += 1
        # ⚠️ ONLY THE FLAGGED LINES GET PRINTED. Widening this from one file to four took
        # the tip count past a hundred; a full listing scrolls the findings off the top,
        # and a report nobody reads to the end is a report that hides things.
        if bad:
            flagged.append((key, bad))
            print("🔴 %-34s %-9s %d id(s), %d questionable"
                  % (key, origin.get(key, "?"), len(ids), bad))
            for i, kind, note in rows:
                if kind == "warned":
                    continue
                print("       %-9s %-7s %s" % (i, kind, note))
            print()

    print("=" * 70)
    for label, _p in TIP_FILES:
        if label in per_type:
            ids_n, bad_n, lines_n = per_type[label]
            print("%-10s %4d ids · %3d questionable · %2d line(s) affected"
                  % (label, ids_n, bad_n, lines_n))
    print("-" * 70)
    print("%d spell ids across %d tip lines" % (total_ids, len([k for k in order if tips.get(k)])))
    print("   %d ABSENT   — the number appears in no DBM mod at all" % n_absent)
    print("   %d AURA-OF  — DBM has this id, but as the aura of a DIFFERENT cast." % n_auraof)
    print("               If our sentence names it as the thing to react to, it")
    print("               names the side effect and not the cast.")
    print("   %d WEAK     — present, but only in a comment or an option with no cue." % n_weak)
    print("   %d aura     — NOT a finding: a private aura DBM warns on by voice cue," % n_aura)
    print("               which in 12.x is the only warning it can give. Printed with")
    print("               its cue so the cue can be read against our verb.")
    if flagged:
        print("tip lines carrying at least one finding: %d" % len(flagged))
        for k, n in flagged:
            print("   %-34s %d" % (k, n))
    print("=" * 70)
    print("⚠️  No verdict here is proof. DBM only warns on what it chooses to warn on,")
    print("    and the tool cannot tell whether OUR VERB matches DBM's cue — \"aim the")
    print("    cone\" against \"watchfeet\" is a human read. That read is the point of")
    print("    printing the cue. Read the mod before rewriting the line.")


def classify():
    """(rows, where) for reuse by the linter.

    rows: [ (key, id, 'warned'|'WEAK'|'ABSENT') ] in file order.
    ⚠️ Kept separate from main() so lint_addon can import this module without printing
    a 200-line report inside its own output. _probe runs tools with run_name="__main__",
    so the guard below still lets `python tools/_probe.py run raid_tip_audit` work.

    🔴 RAISES WHEN DBM IS NOT THERE, instead of reporting every id as ABSENT.
    Measured 4 Sep 2026: the GitHub runner checks out the repo alone, so there are no
    sibling addon folders and no DBM. `main()` has run a positive control since day one
    and would have caught it — but `classify()`, which is what the linter imports, walked
    straight past it. The build then failed every push with "378 HARD, newly written",
    naming ids nobody had touched, and mailed Rob about it all day.

    That is this repo's own rule about an empty search proving nothing, breaking the
    thing built to enforce it. A tool with a positive control that only one of its two
    entry points runs does not have a positive control.
    """
    where, _files = scan_dbm()
    assert_dbm_present(where, _files)
    extra = scan_extra_sources()
    order, tips, _origin, _unresolved = our_tips()
    rows = []
    for key in order:
        for i in (tips.get(key) or []):
            rec = where.get(i)
            # Same three-way widening as the report: an id another installed addon knows,
            # or one DBM documents a decision about, is not a finding.
            if (not rec and extra.get(i)) or (
                    rec and not rec["strong"] and not rec["weak"] and rec["noted"]):
                rows.append((key, i, "warned"))
                continue
            if not rec:
                rows.append((key, i, "ABSENT"))
            elif rec["strong"]:
                rows.append((key, i, "warned"))
            elif _aura_self(rec):
                # DBM's only possible warning for a private aura. Not a finding.
                rows.append((key, i, "warned"))
            elif _aura_other(rec):
                rows.append((key, i, "AURA-OF"))
            else:
                rows.append((key, i, "WEAK"))
    return rows, where


if __name__ == "__main__":
    main()
