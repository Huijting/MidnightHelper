#!/usr/bin/env python3
"""Positive control for lint check [15]: break one value, confirm it fires, put it back.

A check that reports zero proves nothing until something is supposed to make it non-zero.
Today alone that mistake appeared twice -- ReadItemSetLine was declared blind on a control
that was not one, and the first bonus parser matched a prefix that is absent when the bonus
is earned.

⚠️ This edits a file in Rob's LIVE AddOns folder, so the restore is in a finally block and
the write is atomic. If this script is interrupted the worst case is the original text back
on disk, never a truncated locale.
"""
import io
import os
import subprocess

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGET = os.path.join(REPO, "Locales", "nlNL.lua")
LINT = os.path.join(REPO, "tools", "lint_addon.py")

GOOD = 'DAWNCREST_ACH_HERO = "Hero of the Dawn"'
BAD = 'DAWNCREST_ACH_HERO = "Held van de Dageraad"'

original = io.open(TARGET, encoding="utf-8").read()
if GOOD not in original:
    raise SystemExit("Expected line not found; refusing to edit blind.")


def run_lint():
    r = subprocess.run(["python", LINT], capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=REPO)
    for line in (r.stdout or "").splitlines():
        if line.strip().startswith("[15]") or "DAWNCREST_ACH_HERO" in line:
            print("   " + line.strip())
    return r.stdout or ""


print("BEFORE (should be 0):")
run_lint()

try:
    broken = original.replace(GOOD, BAD, 1)
    io.open(TARGET + ".tmp", "w", encoding="utf-8", newline="").write(broken)
    os.replace(TARGET + ".tmp", TARGET)
    print("\nWITH ONE DELIBERATELY TRANSLATED (should be 1 and name the key):")
    out = run_lint()
    fired = "[15] Keys that must stay English, translated anyway: 1" in out
finally:
    io.open(TARGET + ".tmp", "w", encoding="utf-8", newline="").write(original)
    os.replace(TARGET + ".tmp", TARGET)

print("\nAFTER RESTORE (should be 0 again):")
run_lint()

print("\nVERDICT: " + ("check [15] works" if fired else
                       "check [15] did NOT fire -- it is decorative, fix it"))
print("file restored byte-for-byte: %s"
      % (io.open(TARGET, encoding="utf-8").read() == original))
