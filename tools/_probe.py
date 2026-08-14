"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: addons touched since this morning's batch, and whether the two watch
documents have a new entry today.
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
DOCS = os.path.join(BASE, 'MidnightHelper', 'docs')
CUTOFF = time.mktime((2026, 8, 14, 8, 0, 0, 0, 0, -1))


def toc_field(folder, field):
    try:
        names = os.listdir(folder)
    except OSError:
        return '?'
    for fn in names:
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
for name in sorted(os.listdir(BASE)):
    p = os.path.join(BASE, name)
    if not os.path.isdir(p) or name == 'MidnightHelper':
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
    if newest >= CUTOFF:
        rows.append((newest, name))

rows.sort(reverse=True)
print('ADDONS aangeraakt sinds vanochtend 08:00: %d' % len(rows))
for newest, name in rows:
    print('  %-34s %-16s %s' % (
        name[:34], toc_field(os.path.join(BASE, name), 'Version')[:16],
        time.strftime('%d %b %H:%M', time.localtime(newest))))
if not rows:
    print('  (geen)')

print()
for name in ('PTR_12.1_WATCH.md', 'PTR_12.0.7_DATA.md'):
    p = os.path.join(DOCS, name)
    if not os.path.exists(p):
        print('%s: bestaat niet' % name)
        continue
    mt = os.path.getmtime(p)
    text = open(p, encoding='utf-8', errors='replace').read()
    lines = text.splitlines()
    today = sum(1 for line in lines if '2026-08-14' in line)
    print('%-22s %d regels · geschreven %s · %d regel(s) met datum 14 aug' % (
        name, len(lines), time.strftime('%d %b %H:%M', time.localtime(mt)), today))
    for line in lines:
        if '2026-08-14' in line:
            print('   ' + line[:400])
