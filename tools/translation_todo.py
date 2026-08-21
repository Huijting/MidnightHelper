# -*- coding: utf-8 -*-
"""What still needs translating, with the English source, straight from the repo.

Run:  python tools/translation_todo.py            (summary + key list)
      python tools/translation_todo.py --text     (also print the English text)
      python tools/translation_todo.py --since v3.3.0

WHY A TOOL AND NOT A LIST. A pasted list of keys is wrong the moment anyone edits a
string. This reads enUS.lua and the five packs as they are right now, so it cannot
disagree with the addon.

⚠️ A key MISSING from a pack falls back to English and is fine. A key PRESENT in a pack
is what that pack shows, so a string we rewrote keeps its old wording there until it is
retranslated -- those are marked STALE and matter more than the missing ones.
"""
import argparse
import io
import os
import re
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACKS = ["deDE", "frFR", "esES", "ptBR", "itIT"]

ap = argparse.ArgumentParser()
ap.add_argument("--since", default="v3.3.0")
ap.add_argument("--text", action="store_true")
args = ap.parse_args()

diff = subprocess.run(
    ["git", "-C", REPO, "diff", args.since + "..HEAD", "--", "Locales/enUS.lua"],
    capture_output=True, text=True, encoding="utf-8", errors="replace").stdout

added, removed = [], set()
for line in diff.splitlines():
    m = re.match(r'([+-])\t([A-Z][A-Z0-9_]+)\s*=', line)
    if m and not line.startswith("+++") and not line.startswith("---"):
        (added.append(m.group(2)) if m.group(1) == "+" else removed.add(m.group(2)))

pending = list(dict.fromkeys(added))
en = io.open(os.path.join(REPO, "Locales/enUS.lua"), encoding="utf-8").read()
strings = dict(re.findall(r'^\t([A-Z][A-Z0-9_]+)\s*=\s*"((?:[^"\\]|\\.)*)"', en, re.M))

# CHANGELOG_* stays English on purpose (CLAUDE.md), so it is not work.
pending = [k for k in pending if not k.startswith("CHANGELOG_")]

fill = io.open(os.path.join(REPO, "Locales/Translations2026.lua"), encoding="utf-8").read()
packtext = {c: io.open(os.path.join(REPO, "Locales/" + c + ".lua"), encoding="utf-8").read()
            for c in PACKS}

total = 0
print("Pending since {}: {} strings\n".format(args.since, len(pending)))
for key in pending:
    body = strings.get(key, "")
    total += len(body)
    where = [c for c in PACKS
             if re.search(r"\b" + key + r"\b", packtext[c]) or re.search(r"\b" + key + r"\b", fill)]
    mark = "STALE in " + ",".join(where) if where else "missing (falls back)"
    print("{:<40} {:>6} chars   {}".format(key, len(body), mark))
    if args.text:
        print("    EN: " + body[:4000] + ("..." if len(body) > 4000 else ""))
        print()

print("\ncharacters, one language: {:,}".format(total))
print("characters, five languages: {:,}".format(total * 5))
print("""
RULES (CLAUDE.md, Localization):
  - Blizzard proper nouns stay English: zone, NPC, rare, mount, item and CURRENCY names,
    quest titles, achievement names.
  - Game terms stay English: Mythic+, Renown, Knowledge Points, Delves, Vault, Bountiful,
    Tier, ilvl, Keys, Shards -- and the six profession stats (Multicraft, Resourcefulness,
    Ingenuity, Finesse, Perception, Deftness), plus Concentration.
  - Keep %s / %d / %% and every |cff...|r pair around the SAME words. Keep \\n as \\n.
  - Meaning first, the in-game label after it -- never a label with no meaning.
  - The article around an English name follows the language: "der Coiled Isle", not
    "der The Coiled Isle".
  - New translations for de/fr/es/pt/it go in Locales/Translations2026.lua (fill-only,
    never overwrites). nlNL and enUS are already complete.
  - VERIFY BY RUNNING IT: lua5.1 tools/locale_probe.lua KEY [KEY ...]
""")
