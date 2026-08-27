# -*- coding: utf-8 -*-
"""Addon-ronde: wat is er sinds de vorige ronde bijgewerkt, en welke versie draait er?

CLAUDE.md: bestandsdatums en versies uit .toc's gaan hier doorheen, nooit via een
PowerShell-one-liner — die verandert elke keer van vorm en levert dus altijd een prompt.
"""
import io
import os
import re
import sys
import time

ADDONS = r"E:\World of Warcraft\_retail_\Interface\AddOns"
sys.stdout.reconfigure(encoding="utf-8")

DAYS = 10
now = time.time()
cut = now - DAYS * 86400


def toc_version(folder):
    """## Version uit de .toc die bij de map hoort."""
    for name in (folder + ".toc", folder + "_Mainline.toc", folder + "-Mainline.toc"):
        p = os.path.join(ADDONS, folder, name)
        if not os.path.exists(p):
            continue
        try:
            with io.open(p, encoding="utf-8", errors="replace") as fh:
                for line in fh:
                    m = re.match(r"^##\s*Version:\s*(.+?)\s*$", line)
                    if m:
                        return m.group(1)
        except OSError:
            pass
    return "?"


def newest(folder):
    """Jongste bestandsdatum in de map — pakketten raken niet elk bestand aan."""
    best = 0
    for root, _dirs, files in os.walk(os.path.join(ADDONS, folder)):
        for f in files:
            try:
                t = os.path.getmtime(os.path.join(root, f))
            except OSError:
                continue
            if t > best:
                best = t
    return best


rows = []
for folder in sorted(os.listdir(ADDONS)):
    p = os.path.join(ADDONS, folder)
    if not os.path.isdir(p) or folder.startswith("."):
        continue
    t = newest(folder)
    if t >= cut:
        rows.append((t, folder, toc_version(folder)))

rows.sort(reverse=True)
print("Addons met bestanden nieuwer dan %d dagen (%d van %d mappen)\n"
      % (DAYS, len(rows), len(os.listdir(ADDONS))))
print("%-19s %-34s %s" % ("jongste bestand", "addon", "versie"))
for t, folder, ver in rows:
    print("%-19s %-34s %s" % (time.strftime("%Y-%m-%d %H:%M", time.localtime(t)), folder, ver))
