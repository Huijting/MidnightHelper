#!/usr/bin/env python3
"""Regenerate docs/TRANSLATION_DRIFT.md so the report stops repeating the dead rule."""
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
r = subprocess.run([sys.executable, os.path.join(REPO, "tools", "check_drift.py"),
                    "--write-report"],
                   capture_output=True, text=True, encoding="utf-8", errors="replace", cwd=REPO)
print(r.stdout.rstrip())
if r.returncode != 0:
    print(r.stderr.rstrip())
