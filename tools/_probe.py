"""Scratch probe -- fixed path so the allowlist keeps matching (see CLAUDE.md).

Rob thinks he just updated Zygor. Its guide data is dated 18 Aug 23:36, which is
last night's batch, but something in the folder is newer. Which files, exactly?
Naming them is the difference between "Zygor changed" and "a cache file changed".
"""

import os
import time

ZYG = r"E:\World of Warcraft\_retail_\Interface\AddOns\ZygorGuidesViewer"
CUTOFF = time.mktime((2026, 8, 18, 23, 40, 0, 0, 0, -1))

rows = []
for root, dirs, files in os.walk(ZYG):
    dirs[:] = [d for d in dirs if d != ".git"]
    for f in files:
        p = os.path.join(root, f)
        try:
            m = os.path.getmtime(p)
        except OSError:
            continue
        if m >= CUTOFF:
            rows.append((m, os.path.relpath(p, ZYG), os.path.getsize(p)))

rows.sort(reverse=True)
print("=" * 74)
print("ZygorGuidesViewer: bestanden nieuwer dan 18 aug 23:40  (%d)" % len(rows))
print("=" * 74)
for m, rel, size in rows[:40]:
    print("%s  %9d  %s" % (time.strftime("%d-%m %H:%M", time.localtime(m)), size, rel))
if not rows:
    print("(geen)")
