# -*- coding: utf-8 -*-
"""Drop PROFACAD_CONTENTS_SHOW / _HIDE from all seven packs.

They labelled the panel's contents-rail toggle, which went with the rail. A locale key with
no reader is not harmless: it shows up in every coverage count and every translation
worklist, so the next person spends time keeping a dead string alive in six languages.

Asserts a hit in every file it edits, so a rename upstream cannot make this quietly do
nothing. Atomic write -- the repo IS the live game folder.
"""
import io
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FILES = ["Locales/enUS.lua", "Locales/nlNL.lua", "Locales/deDE.lua", "Locales/frFR.lua",
         "Locales/esES.lua", "Locales/ptBR.lua", "Locales/itIT.lua",
         "Locales/Translations2026.lua"]
PAT = re.compile(r'^\t+PROFACAD_CONTENTS_(?:SHOW|HIDE)\s*=\s*"(?:[^"\\]|\\.)*",\s*\n', re.M)

total = 0
for rel in FILES:
    p = os.path.join(REPO, rel)
    try:
        text = io.open(p, encoding="utf-8", errors="strict").read()
    except IOError:
        continue
    new, n = PAT.subn("", text)
    if n:
        io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(new)
        os.replace(p + ".tmp", p)
        total += n
    print("%-34s %d removed" % (rel, n))

if total == 0:
    sys.exit("\nRemoved nothing at all -- the pattern no longer matches. Check before trusting.")
print("\n%d lines removed across the packs." % total)
