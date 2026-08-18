# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Rob runs a third daily watcher on the API and wants to know whether it belongs
in the morning routine. Before judging that: is it actually running, where
does it write, and what does the tail say?
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

DOCS = (r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\docs')
NOW = time.time()

print('nu: %s\n' % time.strftime('%Y-%m-%d %H:%M', time.localtime(NOW)))

for fn in ('WATCHER_API_PROMPT.md', 'API_12_1_AUDIT.md',
           'PTR_12.1_WATCH.md', 'PTR_12.0.7_DATA.md'):
    p = os.path.join(DOCS, fn)
    if not os.path.exists(p):
        print('%-24s ONTBREEKT' % fn)
        continue
    m = os.path.getmtime(p)
    t = io.open(p, encoding='utf-8', errors='replace', newline='').read()
    lines = t.rstrip('\n').split('\n')
    age = (NOW - m) / 3600.0
    print('%-24s %s  %6.1f u  %5d regels%s' % (
        fn, time.strftime('%Y-%m-%d %H:%M', time.localtime(m)), age, len(lines),
        '  <<< vandaag' if age < 14 else ''))

print('\n' + '=' * 70)
print('API_12_1_AUDIT.md — laatste 30 regels')
print('=' * 70)
p = os.path.join(DOCS, 'API_12_1_AUDIT.md')
if os.path.exists(p):
    t = io.open(p, encoding='utf-8', errors='replace', newline='').read()
    for l in t.rstrip('\n').split('\n')[-30:]:
        print('  | ' + l[:130])

print('\n' + '=' * 70)
print('WATCHER_API_PROMPT.md — eerste 40 regels (wat de opdracht is)')
print('=' * 70)
p = os.path.join(DOCS, 'WATCHER_API_PROMPT.md')
if os.path.exists(p):
    t = io.open(p, encoding='utf-8', errors='replace', newline='').read()
    for l in t.rstrip('\n').split('\n')[:40]:
        print('  | ' + l[:130])
