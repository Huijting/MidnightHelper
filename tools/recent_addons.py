#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""recent_addons.py -- which installed addons changed most recently.

WHY
    Rob updates his addons from the CurseForge app and then asks what is new. The answer is a
    file-modification question, which is exactly the kind of thing that used to be done with a
    PowerShell one-liner and cost him a permission prompt every time. It lives here instead.

USAGE
    python "<repo>/tools/_probe.py" run recent_addons [days]

    days -- how far back to list (default 3).

⚠️ A folder's newest file is NOT proof the addon was re-downloaded: saved settings, caches and
   our own edits touch files too. It says "something in here changed", no more. MidnightHelper is
   flagged for that reason -- we edit it constantly.
"""

import os
import sys
import time

# .../AddOns/MidnightHelper/tools/recent_addons.py -> three levels up is the AddOns folder.
# ⚠️ Getting this wrong is silent: with one dirname too few it happily lists MidnightHelper's own
# subfolders as if they were addons, which is exactly what it did on its first run.
ADDONS = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
assert os.path.isdir(os.path.join(ADDONS, "MidnightHelper")), (
    "ADDONS does not look like the AddOns folder: %s" % ADDONS
)

# Folders whose changes say nothing about an update having been downloaded.
OURS = {"MidnightHelper"}

# Files that change on their own and would otherwise make every addon look freshly updated.
NOISE_EXT = {".bak", ".tmp", ".log"}


def newest_in(path):
    """Return (mtime, relative filename) of the most recently modified file in a folder."""
    best = (0.0, None)
    for root, dirs, files in os.walk(path):
        # Skip version-control and cache dirs; they churn for reasons of their own.
        dirs[:] = [d for d in dirs if d not in (".git", "__pycache__", ".github")]
        for f in files:
            if os.path.splitext(f)[1].lower() in NOISE_EXT:
                continue
            full = os.path.join(root, f)
            try:
                m = os.path.getmtime(full)
            except OSError:
                continue
            if m > best[0]:
                best = (m, os.path.relpath(full, path))
    return best


def toc_version(path):
    """Read '## Version:' from any .toc in the folder, so an update shows what it became."""
    try:
        names = sorted(n for n in os.listdir(path) if n.lower().endswith(".toc"))
    except OSError:
        return ""
    for n in names:
        try:
            with open(os.path.join(path, n), "r", encoding="utf-8", errors="replace") as fh:
                for line in fh:
                    low = line.lower()
                    if low.startswith("## version"):
                        return line.split(":", 1)[-1].strip()[:24]
            # a .toc without a Version line is normal; try the next one
        except OSError:
            continue
    return ""


def main():
    days = 3
    if len(sys.argv) > 1:
        try:
            days = float(sys.argv[1])
        except ValueError:
            sys.exit("usage: recent_addons [days]")
    cutoff = time.time() - days * 86400

    rows = []
    for name in sorted(os.listdir(ADDONS)):
        folder = os.path.join(ADDONS, name)
        if not os.path.isdir(folder):
            continue
        m, which = newest_in(folder)
        if m >= cutoff:
            rows.append((m, name, which, toc_version(folder)))

    rows.sort(reverse=True)
    print("Addon folders touched in the last %g day(s) -- %d of %d"
          % (days, len(rows), len(os.listdir(ADDONS))))
    print("%-34s %-16s %-12s %s" % ("addon", "when", "version", "newest file"))
    print("-" * 100)
    for m, name, which, ver in rows:
        tag = " (ours)" if name in OURS else ""
        print("%-34s %-16s %-12s %s"
              % (name + tag, time.strftime("%d %b %H:%M", time.localtime(m)), ver or "-", which))
    if not rows:
        print("(nothing -- measured, not assumed)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
