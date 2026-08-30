#!/usr/bin/env python3
"""Mark the two chapter keys that were edited again after their last mark.

Both were rewritten in all seven languages in the same pass, so they are in step; the drift
is only that the stored hash predates the last edit.
"""
import os
import subprocess
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHECK = os.path.join(REPO, "tools", "check_drift.py")
KEYS = ["PROFACAD_CH_ENCHANTING_BODY", "PROFACAD_CH_ENCHANTING_FAMILIES"]

for argv in ([CHECK, "--mark"] + KEYS, [CHECK, "--write-report"]):
    p = subprocess.run([sys.executable] + argv, capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=REPO)
    print(p.stdout.rstrip())
    if p.returncode != 0:
        print(p.stderr.rstrip())
    print()
