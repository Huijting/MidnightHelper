#!/usr/bin/env python3
"""Rename a proper noun inside ONE language's scope, and nowhere else.

    python "<repo>/tools/_probe.py" run rename_in_locale --lang ptBR --from Valeera --to Valira
    ... add --write to apply.

WHY IT EXISTS. On 31 Aug 2026 we found the delve companion is called **Valira Sanguinar** in
ptBR, not Valeera. Measured in DB2 `Creature` at wago.tools, build 12.1.0.69497: filtering
Name_lang=Valeera returns 14 rows in enUS and ZERO in ptBR, and those same 14 ids read Valira
there (id 248750 checked on its own).

🔴 The enUS query is the positive control, and it is the whole reason the answer is trustworthy.
Without it, "zero rows in ptBR" would equally mean a broken filter or an empty table -- this
repo has three recorded cases of reading an empty result as proof of absence and being wrong.

⚠️ AND THE SCOPE IS THE POINT. One language localising a name says NOTHING about another. The
first version of this script hardcoded ptBR and Valeera; it was generalised the same day, when
Rob asked to settle the other four, precisely so nobody reaches for a ptBR-shaped tool and
quietly applies a ptBR answer to German. Pass the language you actually measured.

What it will not touch:
  - anything outside the named language's blocks;
  - CHANGELOG_* keys, where "Valeera" is a release CODENAME we chose rather than the NPC.
    ⚠️ If your rename has no such carve-out, check whether the word means something else
    somewhere in the pack before running with --write.
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


def arg(name, default=None):
    if name in sys.argv:
        i = sys.argv.index(name)
        if i + 1 < len(sys.argv):
            return sys.argv[i + 1]
    return default


LANG = arg("--lang")
OLD = arg("--from")
NEW = arg("--to")
WRITE = "--write" in sys.argv
if not (LANG and OLD and NEW):
    sys.exit(__doc__)

BLOCK = re.compile(
    r'(?:fill\(\s*"%s"\s*,\s*\{)|(?:merge\(ns\._mhLocales and ns\._mhLocales\.%s\s*,\s*\{)'
    % (re.escape(LANG), re.escape(LANG)))


def spans(text, whole):
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


total, skipped, files = 0, 0, 0
for name in sorted(os.listdir(ROOT)):
    if not name.endswith(".lua"):
        continue
    p = os.path.join(ROOT, name)
    text = io.open(p, encoding="utf-8", errors="replace").read()
    if OLD not in text:
        continue
    whole = name == "%s.lua" % LANG
    if not whole and not BLOCK.search(text):
        continue

    out, last, hits, skips = [], 0, 0, 0
    for a, b in spans(text, whole):
        out.append(text[last:a])
        lines = text[a:b].split("\n")
        for i, line in enumerate(lines):
            if OLD not in line:
                continue
            if re.search(r'\bCHANGELOG_[A-Z0-9_]*\s*=', line):
                skips += line.count(OLD)
                continue
            hits += line.count(OLD)
            lines[i] = line.replace(OLD, NEW)
        out.append("\n".join(lines))
        last = b
    out.append(text[last:])
    if hits or skips:
        print("%-26s %d renamed, %d left as a changelog codename" % (name, hits, skips))
        files += 1
    total += hits
    skipped += skips
    if WRITE and hits:
        io.open(p + ".tmp", "w", encoding="utf-8", newline="").write("".join(out))
        os.replace(p + ".tmp", p)

print("\n%s: %d occurrences in %d file(s), %d deliberately untouched"
      % (LANG, total, files, skipped))
if total == 0:
    print("⚠️  Nothing matched. That may be correct -- or the block pattern may not fit this\n"
          "    file's shape. Check one occurrence by hand before concluding it is absent.")
if not WRITE:
    print("\nDry run. Add --write to apply.")
