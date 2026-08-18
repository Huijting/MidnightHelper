# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Morning routine: which addons were updated, and did the two claude.ai watchers
run? An addon's own folder date barely moves, so take the newest source file
inside it. Watch files are appended at the bottom, so print the tail.
"""
import io
import os
import sys
import time

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

ADDONS = r'E:\World of Warcraft\_retail_\Interface\AddOns'
DOCS = ADDONS + r'\MidnightHelper\docs'
NOW = time.time()
EXT = ('.lua', '.toc', '.xml')

print('nu: %s' % time.strftime('%Y-%m-%d %H:%M', time.localtime(NOW)))

rows = []
for name in os.listdir(ADDONS):
    d = os.path.join(ADDONS, name)
    if not os.path.isdir(d):
        continue
    newest = 0
    for root, dirs, files in os.walk(d):
        dirs[:] = [x for x in dirs if x != '.git']
        for f in files:
            if f.lower().endswith(EXT):
                try:
                    m = os.path.getmtime(os.path.join(root, f))
                except OSError:
                    continue
                if m > newest:
                    newest = m
    if newest:
        rows.append((newest, name))

rows.sort(reverse=True)

print('\n' + '=' * 66)
print('ADDONS — nieuwste bronbestand per map')
print('=' * 66)
for m, name in rows[:16]:
    age = (NOW - m) / 3600.0
    mark = '  <<< sinds gisteravond' if age < 14 else ''
    print('%-34s %s  %5.1f u%s' % (
        name[:34], time.strftime('%Y-%m-%d %H:%M', time.localtime(m)), age, mark))

for fn in ('PTR_12.1_WATCH.md', 'PTR_12.0.7_DATA.md'):
    p = os.path.join(DOCS, fn)
    print('\n' + '=' * 66)
    if not os.path.exists(p):
        print('%s — BESTAAT NIET' % fn)
        continue
    m = os.path.getmtime(p)
    print('%s — geschreven %s (%.1f uur geleden)'
          % (fn, time.strftime('%Y-%m-%d %H:%M', time.localtime(m)),
             (NOW - m) / 3600.0))
    print('=' * 66)
    t = io.open(p, encoding='utf-8', errors='replace', newline='').read()
    lines = t.rstrip('\n').split('\n')
    for l in lines[-8:]:
        print('  | ' + l[:120])
