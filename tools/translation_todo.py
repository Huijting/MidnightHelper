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

ap = argparse.ArgumentParser()
ap.add_argument("--since", default="v3.3.0")
ap.add_argument("--text", action="store_true")
args = ap.parse_args()

# ---------------------------------------------------------------- pending keys
diff = subprocess.run(
    ["git", "-C", REPO, "diff", args.since + "..HEAD", "--", "Locales/enUS.lua"],
    capture_output=True, text=True, encoding="utf-8", errors="replace").stdout

added = []
for line in diff.splitlines():
    m = re.match(r'\+\t([A-Z][A-Z0-9_]+)\s*=', line)
    if m and not line.startswith("+++"):
        added.append(m.group(1))

# CHANGELOG_* stays English on purpose (CLAUDE.md), so it is not work.
pending = [k for k in dict.fromkeys(added) if not k.startswith("CHANGELOG_")]
if not pending:
    raise SystemExit("Nothing changed in enUS since " + args.since + ".")

en = io.open(os.path.join(REPO, "Locales/enUS.lua"), encoding="utf-8").read()
strings = dict(re.findall(r'^\t([A-Z][A-Z0-9_]+)\s*=\s*"((?:[^"\\]|\\.)*)"', en, re.M))

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
print("Changed in enUS since {}: {} strings\n".format(args.since, len(pending)))
for key in pending:
    per = status.get(key, {})
    missing = [c for c in PACKS if per.get(c, "?") != "OK"]
    body = strings.get(key, "")
    if missing:
        todo_chars += len(body) * len(missing)
        mark = "TODO in " + ",".join(missing)
    else:
        done_all += 1
        mark = "done"
    print("{:<40} {:>6} chars   {}".format(key, len(body), mark))
    if args.text and missing:
        print("    EN: " + body[:4000] + ("..." if len(body) > 4000 else ""))
        print()

print("\n{} of {} strings are done in all six packs.".format(done_all, len(pending)))
print("characters still to write, across all languages: {:,}".format(todo_chars))
print("""
⚠️ A "TODO in nlNL" on a bare format string or a proper name is usually correct as it
stands -- locale_probe reports a verbatim English copy as untranslated, and sometimes the
copy IS the translation. Read the two before treating them as work.

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
