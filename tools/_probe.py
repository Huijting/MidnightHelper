"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Which addons changed since yesterday's sweep, and what version are they on now?

⚠️ NO CUT-OFF. On 18 aug a list truncated at 16 rows produced "nothing useful" and
HandyNotes_Midnight was row 17. Everything with a fresh file gets printed.
"""

import io
import os
import re
import time

ADDONS = r"E:\World of Warcraft\_retail_\Interface\AddOns"
VERSION = re.compile(r"^##\s*Version:\s*(.+)$", re.I | re.M)

# Yesterday's sweep ran at 22:34 on 18 Aug; anything newer than that is today's batch.
CUTOFF = time.mktime((2026, 8, 18, 23, 0, 0, 0, 0, -1))


def newest(path):
    best = 0
    for root, dirs, files in os.walk(path):
        dirs[:] = [d for d in dirs if d not in (".git", "__pycache__")]
        for f in files:
            try:
                m = os.path.getmtime(os.path.join(root, f))
            except OSError:
                continue
            if m > best:
                best = m
    return best


def toc_version(path, name):
    for cand in (name + ".toc", name + "_Mainline.toc", name + "-Mainline.toc"):
        p = os.path.join(path, cand)
        if os.path.exists(p):
            try:
                with io.open(p, "r", encoding="utf-8", errors="replace") as fh:
                    m = VERSION.search(fh.read())
                if m:
                    return m.group(1).strip()
            except OSError:
                pass
    return "?"


rows = []
for name in sorted(os.listdir(ADDONS)):
    p = os.path.join(ADDONS, name)
    if not os.path.isdir(p) or name.startswith("."):
        continue
    rows.append((newest(p), name, toc_version(p, name)))

rows.sort(reverse=True)
fresh = [r for r in rows if r[0] >= CUTOFF]

print("=" * 74)
print("Bijgewerkt sinds gisteravond 23:00  (%d van %d mappen)" % (len(fresh), len(rows)))
print("=" * 74)
print("%-34s %-18s %s" % ("addon", "versie", "nieuwste bestand"))
print("-" * 74)
for m, name, ver in fresh:
    print("%-34s %-18s %s" % (name[:34], ver[:18], time.strftime("%d-%m %H:%M", time.localtime(m))))

if not fresh:
    print("(geen)")
