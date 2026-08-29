# -*- coding: utf-8 -*-
"""What still needs translating, answered by the resolver rather than by counting.

Run:  python tools/translation_todo.py            (status per string)
      python tools/translation_todo.py --text     (also print the English source)
      python tools/translation_todo.py --since v3.3.0

⚠️ THIS TOOL LIED ONCE, AND THE FIX IS THE POINT. The first version asked "is this key
present in a language pack?" and called that translated. After the 22 aug batch landed it
reported all 56 strings as STALE while every one of them had just been translated -- the
keys were present before and after, so presence never answered the question. Rob spotted it
from the output; the tool would have kept saying it.

So it no longer decides anything itself. It runs tools/locale_probe.lua, which loads the
locale files in .toc order and asks ns:L what it actually returns per language -- the same
resolver the addon uses. CLAUDE.md's rule for exactly this: verify translations by RUNNING
them, not by counting them.

If no Lua interpreter is on PATH it says so and stops, rather than falling back to the
counting that was wrong in the first place.
"""
import argparse
import io
import os
import re
import shutil
import subprocess
import sys

# Force UTF-8 out, same as lint_addon.py and for the same reason: the Windows console
# is cp1252, and asking the caller for `python -X utf8 ...` changes the command string,
# which then matches no permission rule and prompts every single time.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACKS = ["deDE", "frFR", "esES", "ptBR", "itIT", "nlNL"]

# ---------------------------------------------------------------- settled, not missing
#
# ⚠️ THE SECOND WAY THIS TOOL MISLEADS, and it is the mirror of the first. The probe reports
# a verbatim English copy as untranslated, because from the resolver's side those are
# indistinguishable. On 23 Aug it reported "400 characters still to write" across 18 keys
# and every single one was already correct -- an hour spent re-deciding settled questions,
# and an invitation to "fix" strings that were right. A warning in the footer did not stop
# that; it has been there since the tool was written.
#
# So a key ruled deliberately-English is recorded HERE, with its reason, and reported as
# `settled` rather than TODO. The reason is the point: it makes the ruling auditable and
# re-openable instead of folklore. Wordless format strings are detected below rather than
# listed, because there is nothing to decide about them.
#
# langs=None means every pack. Add an entry only after checking the evidence, and write
# down what the evidence WAS.
SETTLED = {
    "PGUIDE_WAYPOINT_LABEL":         (None, "our own addon name"),
    "PROFGUIDE_BTN_WOWHEAD_PROF_FMT": (None, "brand name + placeholder"),
    "PROFHUB_GOAL_GOLD":             (("deDE",), "'Gold' is the German word; deDE.lua uses it 6x"),
    # nlNL keeps game terms English -- no Dutch client exists (CLAUDE.md, Localization).
    # Checked 23 Aug: the Dutch bodies around these do the same, e.g.
    # PROFGUIDE_SEC_SKINNING_BODY = "Leather gebruikt |cffffffffLeatherworking|r".
    "PROFGUIDE_SEC_ALCHEMY_TITLE":        (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_ENCHANTING_TITLE":     (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_HERBALISM_TITLE":      (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_LEATHERWORKING_TITLE": (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_SKINNING_TITLE":       (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_TAILORING_TITLE":      (("nlNL",), "profession name, English in nlNL"),
    "PROFGUIDE_SEC_COMBO_TE_TITLE":       (("nlNL",), "two profession names, English in nlNL"),
    "PROFGUIDE_SUB_PROFESSIONS":          (("nlNL",), "game term (the client's own tab)"),
    "PROFGUIDE_SUB_DAWNCREST":            (("nlNL",), "game term"),
    # "root" is taught as vocabulary by PROFACAD_CH_TREES_BODY ("het vakje in het midden
    # (de root)") and used by ADVISE_NEXT_FMT and ADVISE_DONE. Translating it here alone
    # would break the word the chapter just explained.
    "PROFACAD_ADVISE_GOAL_LINE_FMT": (("nlNL",), "'root' is deliberate nlNL vocabulary"),
    "PROFGUIDE_BTN_OPEN_BROWSER":    (("nlNL",), "'Open in browser' is identical in Dutch"),
    "PROFHUB_GOAL_ALLROUND":         (("nlNL",), "'Allround' is a Dutch word"),
    "VALEERA_LEVEL":                 (("nlNL",), "game term; Dutch players say 'level'"),
}


def is_wordless(s):
    """True when the string is only placeholders, markup and punctuation.

    "%s x%d" and "%s (%d/%d)." carry nothing to translate, so a pack that copies them
    verbatim is finished, not behind.
    """
    t = re.sub(r"%%|%\d*\.?\d*[sdfx]", " ", s)
    t = re.sub(r"\|c[fF][fF][0-9a-fA-F]{6}|\|[rn]", " ", t)
    return not re.search(r"[A-Za-z]{2}", t)

ap = argparse.ArgumentParser()
ap.add_argument("--since", default="v3.3.0",
                help="report strings enUS gained since this tag (the default question)")
ap.add_argument("--prefix",
                help="instead: report every key starting with these comma-separated "
                     "prefixes, however old. Use this to finish an AREA rather than a "
                     "release, e.g. --prefix PROFACAD_,PROFGUIDE_,PROFHUB_,PROFNEXT_,PGUIDE_")
ap.add_argument("--text", action="store_true")
args = ap.parse_args()

# ---------------------------------------------------------------- pending keys
#
# 🔴 THE KEY LIST USED TO COME FROM ONE FILE, AND THAT WAS THE SECOND TIME THIS TOOL LIED.
#
# It read Locales/enUS.lua and matched `^\t KEY = "..."`. Everything else was invisible:
# eleven merge files (DelveTips, DelveStories, Codex, RitualTips, RaidTips, MythicPlus,
# StartHere, DungeonGuide, SettingsPage, DungeonTips, OmniumFolio, ConsumablesNotes) define
# enUS strings too, and any key indented differently fell out as well. Measured 26 aug:
# 901 enUS keys were out of scope, so `--prefix DELVE_STORY` answered "no strings found"
# while there were 48 of them -- including the 48 delve stories that exist in enUS and nlNL
# only. Two counts for the same number came from the same blind spot: lint_addon.py [5] saw
# 3421 keys where the loader saw 3446.
#
# The header above already says this tool must ask the resolver rather than count. The
# resolution half did; the SCOPE half still counted, in a file. So both halves ask now.
#
# ⚠️ Deliberately not a fourth parser. CLAUDE.md records three static parsers that each gave
# a confidently wrong answer here, and locale_probe.lua contradicted every one of them and
# was right every time. Same --dump the drift checker uses.
def _english_from_loader():
    """{key: english text} exactly as the client would load it, merge files included."""
    exe = shutil.which("lua") or shutil.which("lua5.1") or shutil.which("lua54")
    if not exe:
        raise SystemExit(
            "No Lua interpreter on PATH, so the loader cannot be asked for the key list.\n"
            "Deliberately NOT falling back to reading enUS.lua: that is the blind spot\n"
            "this replaced, and a confident wrong scope is worse than no answer.")
    p = subprocess.run([exe, "tools/locale_probe.lua", "--dump"], cwd=REPO,
                       capture_output=True, text=True, encoding="utf-8", errors="replace")
    if p.returncode != 0:
        raise SystemExit("locale_probe.lua --dump failed:\n" + (p.stderr or ""))
    out = {}
    for line in p.stdout.splitlines():
        parts = line.split("\t")
        if len(parts) != 3:
            continue
        code, key, val = parts
        if code != "enUS":
            continue
        out[key] = val.replace("\\t", "\t").replace("\\n", "\n").replace("\\\\", "\\")
    if not out:
        raise SystemExit("The dump contained no enUS at all. That is a broken instrument, "
                         "not an empty answer.")
    return out


strings = _english_from_loader()

if args.prefix:
    # ⚠️ Finishing an AREA, not a release. The --since question only ever sees strings
    # added after a tag, which is exactly why 46 professions strings sat untranslated
    # after the 22 Aug batch reported itself complete: they were older than v3.3.0 and
    # so were never in scope. Asking by prefix has no such blind spot.
    pres = tuple(p.strip() for p in args.prefix.split(",") if p.strip())
    pending = sorted(k for k in strings if k.startswith(pres))
    scope = "matching " + ", ".join(pres)
else:
    # ⚠️ EVERY locale file, not just enUS.lua -- a string added to Codex.lua or DelveTips.lua
    # is exactly as untranslated as one added to the main pack, and the old single-file diff
    # could never see it. The leading-tab requirement is gone for the same reason.
    diff = subprocess.run(
        ["git", "-C", REPO, "diff", args.since + "..HEAD", "--", "Locales"],
        capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
    added = []
    for line in diff.splitlines():
        if line.startswith("+++"):
            continue
        m = re.match(r'\+\s*\[?"?([A-Z][A-Z0-9_]+)"?\]?\s*=\s*"', line)
        if m:
            added.append(m.group(1))
    # A key only counts if the loader actually has it in enUS: a diff hunk can name a key
    # that was later renamed or removed, and reporting that as work to do is noise.
    pending = [k for k in dict.fromkeys(added) if k in strings]
    scope = "changed since " + args.since

# CHANGELOG_* stays English on purpose (CLAUDE.md), so it is not work.
pending = [k for k in pending if not k.startswith("CHANGELOG_")]


# ---------------------------------------------------------------- deliberately English
# 🔴 A KEY THAT IS ENGLISH ON PURPOSE IS NOT DEBT, and a list that says it is gets ignored.
# Locales/KeepEnglish.lua records both halves: keys Blizzard owns in every language
# (achievement titles), and keys settled per language (crest ranks are English in nlNL
# because there is no Dutch client). Without this the tool reported the three Dawn
# achievements as TODO in all six packs on the very day they were deliberately reverted.
def _keep_english():
    """(global set, {lang: set}) straight out of the Lua table."""
    path = os.path.join(REPO, "Locales", "KeepEnglish.lua")
    glob, per = set(), {}
    if not os.path.isfile(path):
        return glob, per
    cur = None
    for line in io.open(path, encoding="utf-8", errors="replace"):
        s = line.strip()
        if s.startswith("--"):
            continue
        if re.match(r'ns\.KEEP_ENGLISH\s*=', s):
            cur = "__global__"
            continue
        if re.match(r'ns\.KEEP_ENGLISH_FOR\s*=', s):
            cur = None
            continue
        m = re.match(r'([a-z]{2}[A-Z]{2})\s*=\s*\{', s)
        if m:
            cur = m.group(1)
            continue
        m = re.match(r'([A-Z][A-Z0-9_]+)\s*=\s*"', s)
        if m and cur:
            if cur == "__global__":
                glob.add(m.group(1))
            else:
                per.setdefault(cur, set()).add(m.group(1))
    return glob, per


KEEP_GLOBAL, KEEP_PER_LANG = _keep_english()
pending = [k for k in pending if k not in KEEP_GLOBAL]
if not pending:
    raise SystemExit("No strings " + scope + ".")

# ---------------------------------------------------------------- ask the resolver
lua = shutil.which("lua") or shutil.which("lua5.1") or shutil.which("lua54")
if not lua:
    raise SystemExit(
        "No Lua interpreter on PATH, so the resolver cannot be asked.\n"
        "Install Lua, or run: lua tools/locale_probe.lua <KEY> ...\n"
        "Deliberately NOT falling back to checking whether keys exist -- that is the\n"
        "measurement that was wrong before, and a wrong answer is worse than none.")

probe = subprocess.run([lua, "tools/locale_probe.lua"] + pending,
                       cwd=REPO, capture_output=True, text=True,
                       encoding="utf-8", errors="replace").stdout

# locale_probe prints "== KEY" then one indented line per language.
status = {}
cur = None
for line in probe.splitlines():
    m = re.match(r'^==\s+([A-Z][A-Z0-9_]+)', line)
    if m:
        cur = m.group(1)
        status[cur] = {}
        continue
    m = re.match(r'^\s+(\w{4})\s\s+(\S.*?)\s\s+', line)
    if m and cur:
        status[cur][m.group(1)] = m.group(2).strip()

# ---------------------------------------------------------------- report
todo_chars = 0
done_all = 0
settled_notes = []
print("Strings {}: {}\n".format(scope, len(pending)))
for key in pending:
    per = status.get(key, {})
    missing = [c for c in PACKS if per.get(c, "?") != "OK"]
    # A language where this key is settled as English is not behind; drop it silently
    # rather than let it read as work that will never be done.
    missing = [c for c in missing if key not in KEEP_PER_LANG.get(c, ())]
    body = strings.get(key, "")

    # Drop the languages where English is the settled answer, so they never read as debt.
    if missing:
        if is_wordless(body):
            settled_notes.append((key, "nothing to translate"))
            missing = []
        elif key in SETTLED:
            langs, why = SETTLED[key]
            kept = [c for c in missing if langs is not None and c not in langs]
            if len(kept) < len(missing):
                settled_notes.append((key, why))
            missing = kept

    if missing:
        todo_chars += len(body) * len(missing)
        mark = "TODO in " + ",".join(missing)
    else:
        done_all += 1
        mark = "settled" if key in dict(settled_notes) else "done"
    print("{:<40} {:>6} chars   {}".format(key, len(body), mark))
    if args.text and missing:
        print("    EN: " + body[:4000] + ("..." if len(body) > 4000 else ""))
        print()

print("\n{} of {} strings are done in all six packs.".format(done_all, len(pending)))
print("characters still to write, across all languages: {:,}".format(todo_chars))

if settled_notes:
    print("\nEnglish on purpose ({} keys) -- reasons, so the ruling can be re-opened:".format(
        len(settled_notes)))
    for key, why in settled_notes:
        print("  {:<38} {}".format(key, why))
    print("  Disagree with one? Edit SETTLED at the top of this file, don't just translate it:")
    print("  the reason is what stops the question being re-decided every release.")

print("""
⚠️ Anything still listed as TODO is a string the resolver returns English for AND that is
not recorded as deliberately-English above. Read it before treating it as work: a verbatim
English copy and a missing translation look identical from the resolver's side.

RULES (CLAUDE.md, Localization):
  - Keep %s / %d / %% and every |cff...|r pair around the SAME words. Keep \\n as \\n.
  - Meaning first, the in-game label after it -- never a label with no meaning.
  - ⚠️ Names: the test is not "is it a proper noun" but "does Blizzard leave it in
    English". Zone names ARE localised (Coiled Isle is Die Gewundene Insel in German), and
    so are the six profession stats and the Patron tab. Currency names like Corrosive Coin
    are not. Look the term up per language; the client decides, Wowhead is a candidate.
  - nlNL keeps game terms English because there is no Dutch client -- same rule, not an
    exception.
  - de/fr/es/pt/it go in Locales/Translations2026.lua (fill-only, never overwrites).
""")
