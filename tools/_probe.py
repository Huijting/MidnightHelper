# -*- coding: utf-8 -*-
"""Copy RELEASE_NOTES.md to the per-version archive, byte for byte, and prove it."""
import hashlib
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(REPO, "RELEASE_NOTES.md")
DST = os.path.join(REPO, "docs", "CURSEFORGE_3.5.0.md")

data = io.open(SRC, "rb").read()
io.open(DST + ".tmp", "wb").write(data)
os.replace(DST + ".tmp", DST)
back = io.open(DST, "rb").read()
print("identical:", data == back, "|", len(data), "bytes",
      hashlib.sha256(data).hexdigest()[:16])

text = data.decode("utf-8")
lines = text.splitlines()
print("lines: {}   chars: {}   bullets: {}   first: {}".format(
    len(lines), len(text), sum(1 for l in lines if l.startswith("- ")), lines[0]))
