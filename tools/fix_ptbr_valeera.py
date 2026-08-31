#!/usr/bin/env python3
"""Rename Valeera to Valira inside ptBR scope only.

Usage:  python tools/fix_ptbr_valeera.py [--write]

MEASURED 31 Aug 2026 from Blizzard's own DB2 at wago.tools, build 12.1.0.69497, table
`Creature`: filtering Name_lang=Valeera in enUS returns 14 rows; the SAME filter in ptBR
returns zero, and those 14 ids read "Valira Sanguinar" in ptBR (id 248750 checked on its own).
🔴 The enUS query is the positive control -- without it, an empty ptBR result would equally
mean the filter was broken, which is the mistake this repo has made three times.

So ptBR players see Valira. Our pack said Valeera in most places and Valira in the hand-written
Venomfall block; the hand-written one was right.

⚠️ SCOPE, and both halves matter:
  - Only ptBR. Whether esES, itIT, deDE or frFR localise her name is NOT MEASURED. Do not
    assume this generalises -- one language localising a name says nothing about another, which
    is the same trap as the crest names Carola could not recognise.
  - Not CHANGELOG_* keys. "Valeera" there is a release CODENAME we chose, not the NPC, and
    renaming it would rewrite our own history.
"""
import io
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "Locales")
WRITE = "--write" in sys.argv
# A whole file is ptBR when it is locale-gated to ptBR; otherwise only fill/merge blocks are.
BLOCK = re.compile(r'(?:fill\(\s*"ptBR"\s*,\s*\{)|(?:merge\(ns\._mhLocales and ns\._mhLocales\.ptBR\s*,\s*\{)')


def spans(text, whole):
    """Yield (start, end) regions that are ptBR."""
    if whole:
        yield (0, len(text))
        return
    for m in BLOCK.finditer(text):
        depth, j, ins = 1, m.end(), False
        while j < len(text) and depth:
            c = text[j]
            if ins:
                if c == "\\":
                    j += 2
                    continue
                if c == '"':
                    ins = False
            elif c == '"':
                ins = True
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            j += 1
        yield (m.end(), j)


total, skipped = 0, 0
for name in sorted(os.listdir(ROOT)):
    if not name.endswith(".lua"):
        continue
    p = os.path.join(ROOT, name)
    text = io.open(p, encoding="utf-8", errors="replace").read()
    if "Valeera" not in text:
        continue
    whole = name == "ptBR.lua"
    if not whole and not BLOCK.search(text):
        continue

    out, last, hits, skips = [], 0, 0, 0
    for a, b in spans(text, whole):
        out.append(text[last:a])
        chunk = text[a:b]
        # Walk line by line so a CHANGELOG_ key can be spared individually.
        lines = chunk.split("\n")
        for i, line in enumerate(lines):
            if "Valeera" not in line:
                continue
            if re.search(r'\bCHANGELOG_[A-Z0-9_]*\s*=', line):
                skips += line.count("Valeera")
                continue
            hits += line.count("Valeera")
            lines[i] = line.replace("Valeera", "Valira")
        out.append("\n".join(lines))
        last = b
    out.append(text[last:])
    if hits or skips:
        print("%-26s %d renamed, %d left as a changelog codename" % (name, hits, skips))
    total += hits
    skipped += skips
    if WRITE and hits:
        io.open(p + ".tmp", "w", encoding="utf-8", newline="").write("".join(out))
        os.replace(p + ".tmp", p)

print("\n%d occurrences in ptBR scope, %d deliberately untouched" % (total, skipped))
print("⚠️  es/it/de/fr NOT measured -- their client name for her is still unknown.")
if not WRITE:
    print("\nDry run. Re-run with --write to apply.")
