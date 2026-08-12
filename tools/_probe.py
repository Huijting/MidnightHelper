"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: which AddOns were updated most recently, and their versions.
"""
import os
import re
import sys
import time

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns'


def toc_field(folder, field):
    for fn in os.listdir(folder):
        if not fn.lower().endswith('.toc'):
            continue
        try:
            t = open(os.path.join(folder, fn), encoding='utf-8', errors='replace').read()
        except OSError:
            continue
        m = re.search(r'^##\s*%s\s*:\s*(.+)$' % field, t, re.M | re.I)
        if m:
            return m.group(1).strip()
    return '?'


rows = []
for name in os.listdir(BASE):
    p = os.path.join(BASE, name)
    if not os.path.isdir(p):
        continue
    newest = 0
    for root, dirs, files in os.walk(p):
        dirs[:] = [d for d in dirs if d != '.git']
        for f in files:
            try:
                m = os.path.getmtime(os.path.join(root, f))
            except OSError:
                continue
            if m > newest:
                newest = m
    rows.append((newest, name, toc_field(p, 'Version'), toc_field(p, 'Interface')))

rows.sort(reverse=True)
now = time.time()
print('%-34s %-14s %-18s %s' % ('addon', 'version', 'interface', 'newest file'))
for newest, name, ver, iface in rows[:30]:
    age = (now - newest) / 3600.0
    print('%-34s %-14s %-18s %s  (%.1f h)' % (
        name[:34], ver[:14], iface[:18],
        time.strftime('%Y-%m-%d %H:%M', time.localtime(newest)), age))
