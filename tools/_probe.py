#!/usr/bin/env python3
"""Positive control: does check [15] now guard the split ADVENTURER name, and leave the hint alone?

Two things to prove, not one:
  1. Translating the NAME in nlNL must fire.
  2. The Dutch "(groen)" hint must NOT fire -- it is supposed to follow the language, and the
     whole reason for splitting was that guarding it was wrong.

Restores atomically in a finally block; this is Rob's live folder.
"""
import io
import os
import re
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGET = os.path.join(REPO, "Locales", "nlNL.lua")
LINT = os.path.join(REPO, "tools", "lint_addon.py")

original = io.open(TARGET, encoding="utf-8").read()


def lint_15():
    r = subprocess.run(["python", LINT], capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=REPO)
    for line in (r.stdout or "").splitlines():
        if line.strip().startswith("[15]") or "DAWNCREST" in line:
            print("   " + line.strip())
    return r.stdout or ""


print("BEFORE (expect 0):")
lint_15()

try:
    broken = original.replace('DAWNCREST_TIER_ADVENTURER = "Adventurer"',
                              'DAWNCREST_TIER_ADVENTURER = "Avonturier"', 1)
    if broken == original:
        raise SystemExit("could not find the split name line; nothing changed")
    io.open(TARGET + ".tmp", "w", encoding="utf-8", newline="").write(broken)
    os.replace(TARGET + ".tmp", TARGET)
    print("\n1) NAME translated (expect 1, naming ADVENTURER):")
    out = lint_15()
    name_fires = "translated anyway: 1" in out
finally:
    io.open(TARGET + ".tmp", "w", encoding="utf-8", newline="").write(original)
    os.replace(TARGET + ".tmp", TARGET)

print("\n2) HINT is Dutch, as designed (expect 0 — it must NOT be guarded):")
out2 = lint_15()
hint_quiet = "translated anyway: 0" in out2

print("\nVERDICT:")
print("   name guarded : " + ("yes" if name_fires else "NO — check is decorative"))
print("   hint free    : " + ("yes" if hint_quiet else "NO — it is being guarded wrongly"))
print("   file restored: %s" % (io.open(TARGET, encoding="utf-8").read() == original))
