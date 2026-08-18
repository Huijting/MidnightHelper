# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

The API watcher's "what MH uses" list was written by hand in July and copied
forward since. Measure it instead: which C_* namespaces does the addon
actually call, and how often? A watcher matching against a stale list will
quietly stop flagging the modules that matter.
"""
import io
import os
import re
import sys
from collections import Counter

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

MH = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'

ns_counts = Counter()
ns_files = {}
for root, dirs, files in os.walk(MH):
    dirs[:] = [d for d in dirs if d not in ('.git', 'docs', 'tools', 'dist')]
    for f in files:
        if not f.endswith('.lua'):
            continue
        p = os.path.join(root, f)
        text = io.open(p, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'\b(C_[A-Za-z]+)\.', text):
            ns_counts[m.group(1)] += 1
            ns_files.setdefault(m.group(1), set()).add(f)

print('C_* namespaces die Midnight Helper aanroept')
print('=' * 66)
print('%-28s %6s  %s' % ('namespace', 'calls', 'bestanden'))
print('-' * 66)
for name, n in ns_counts.most_common():
    print('%-28s %6d  %d' % (name, n, len(ns_files[name])))

print('\n%d namespaces in totaal' % len(ns_counts))

# The global (non-C_) API surface that a secure-action addon can lose.
print('\n' + '=' * 66)
print('Globale API die een secure-action addon kan verliezen')
print('=' * 66)
GLOBALS = ['CreateFrame', 'RegisterStateDriver', 'SecureActionButtonTemplate',
           'InCombatLockdown', 'GetAchievementCriteriaInfo', 'GetInstanceInfo',
           'UnitAura', 'issecretvalue', 'GetSpellInfo', 'UnitOnTaxi',
           'SetOverrideBinding', 'C_Timer']
for g in GLOBALS:
    hits = 0
    for root, dirs, files in os.walk(MH):
        dirs[:] = [d for d in dirs if d not in ('.git', 'docs', 'tools', 'dist')]
        for f in files:
            if f.endswith('.lua'):
                text = io.open(os.path.join(root, f), encoding='utf-8',
                               errors='replace').read()
                hits += len(re.findall(r'\b%s\b' % re.escape(g), text))
    print('%-34s %d' % (g, hits))
