#!/usr/bin/env python3
"""Rename "trees started" -- Rob read it as "trees I opened"; it means "points in".

GetSpecSummary lists a tree only when its root activeRank is > 1, and the comment beside
that test says why: rank 1 is unlocked but untouched. The addon was right and the word was
wrong. Rob had unlocked all four Enchanting trees, saw three listed, and reasonably asked
whether the panel could refresh without a reload. An accurate line that makes someone doubt
working code has still failed.

Anchored on the KEY plus a regex for the phrase, not on the whole string: the French line
carries a no-break space before its colon, and my first attempt guessed five of the seven
wordings wrong.
"""
import io
import os
import re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOC = os.path.join(REPO, "Locales")
KEY = "PROFACAD_SPEC_LINE_FMT"

JOBS = {
    "deDE": ("deDE.lua", r"begonnene Bäume(?=: %s)", "Bäume mit Punkten darin"),
    "itIT": ("itIT.lua", r"alberi iniziati(?=: %s)", "alberi con punti dentro"),
    "frFR": ("frFR.lua", r"arbres commencés(?=\s*: %s)", "arbres avec des points dedans"),
    "esES": ("esES.lua", r"árboles iniciados(?=: %s)", "árboles con puntos dentro"),
    "ptBR": ("ptBR.lua", r"árvores iniciadas(?=: %s)", "árvores com pontos dentro"),
    "nlNL": ("nlNL.lua", r"gestarte trees(?=: %s)", "trees met punten erin"),
}

for code, (fn, pat, new) in JOBS.items():
    path = os.path.join(LOC, fn)
    text = io.open(path, encoding="utf-8", newline="").read()
    m = re.search(r'^[ \t]*' + KEY + r'[ \t]*=[ \t]*"(.*)",?[ \t]*$', text, re.M)
    if not m:
        print("%s  key not found -- skipped" % code)
        continue
    line, hits = m.group(1), re.findall(pat, m.group(1))
    if len(hits) != 1:
        print("%s  phrase: %d matches in the line -- skipped" % (code, len(hits)))
        continue
    fixed = re.sub(pat, new, line, count=1)
    text = text[:m.start(1)] + fixed + text[m.end(1):]
    with io.open(path + ".tmp", "w", encoding="utf-8", newline="") as fh:
        fh.write(text)
    os.replace(path + ".tmp", path)
    print("%s  ok -> %s" % (code, fixed))
