# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: which addons were updated recently, and what version do they claim?

Rob's standing request after an update round. The point is not the list but the
diff-able facts: an addon that just gained 12.1 data is where new ids show up
first, and a .toc Interface bump tells us who has already been rebuilt for the
current client.
"""
import io
import os
import re
import sys
import time

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

ROOT = r'E:\World of Warcraft\_retail_\Interface\AddOns'
NOW = time.time()
DAYS = 4

rows = []
for name in sorted(os.listdir(ROOT)):
    d = os.path.join(ROOT, name)
    if not os.path.isdir(d) or name.startswith('!') and False:
        continue
    newest, count = 0, 0
    for base, _dirs, files in os.walk(d):
        for f in files:
            try:
                m = os.path.getmtime(os.path.join(base, f))
            except OSError:
                continue
            count += 1
            if m > newest:
                newest = m
    if not newest:
        continue
    age = (NOW - newest) / 86400.0
    if age > DAYS:
        continue

    ver = iface = None
    for toc in os.listdir(d):
        if toc.lower().endswith('.toc'):
            try:
                t = io.open(os.path.join(d, toc), encoding='utf-8',
                            errors='replace').read()
            except OSError:
                continue
            mv = re.search(r'^##\s*Version:\s*(.+)$', t, re.M)
            mi = re.search(r'^##\s*Interface:\s*(.+)$', t, re.M)
            ver = mv.group(1).strip() if mv else ver
            iface = mi.group(1).strip() if mi else iface
            break
    rows.append((newest, name, ver, iface, count))

rows.sort(reverse=True)
print('addons met een bestand jonger dan %d dagen: %d' % (DAYS, len(rows)))
print()
print('%-16s %-34s %-14s %s' % ('gewijzigd', 'addon', 'versie', 'Interface'))
print('-' * 86)
for newest, name, ver, iface, count in rows:
    print('%-16s %-34s %-14s %s' % (
        time.strftime('%d-%m %H:%M', time.localtime(newest)),
        name[:34], (ver or '-')[:14], iface or '-'))
