"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: which currency ids the Currencies page hard-codes, per language.
"""
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'

for fn in sorted(os.listdir(BASE)):
    if not fn.endswith('.lua'):
        continue
    t = open(os.path.join(BASE, fn), encoding='utf-8', errors='replace').read()
    for m in re.finditer(r'CURRENCY_GUIDE_BODY\s*=\s*"((?:[^"\\]|\\.)*)"', t):
        body = m.group(1)
        ids = re.findall(r'\{CURRENCY:(\d+)\}', body)
        print('%-24s %d ids: %s   {CRESTS}: %s' % (
            fn, len(ids), ', '.join(ids) or '-', 'yes' if '{CRESTS}' in body else 'NO'))
