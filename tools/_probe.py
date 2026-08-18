# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Which player-facing commands are the ONLY door to their feature?

A command that duplicates a button is a shortcut. A command that is the only
way in is a hidden feature -- proposal item 3.4's shape (AccessibleAlerts:
well designed, unfindable). Tell them apart by asking whether the handler is
called anywhere other than the slash router in Core.lua.
"""
import glob
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

MH = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
CORE = os.path.join(MH, 'Core.lua')

core = io.open(CORE, encoding='utf-8', errors='replace').read()

# Every player-facing command from the list, and the ns.* it calls in Core.
listed = []
src = io.open(os.path.join(MH, 'Modules', 'CommandList.lua'),
              encoding='utf-8', errors='replace').read()
for m in re.finditer(r'cmd = "/mh\s*([^"]*)"', src):
    c = m.group(1).strip()
    if c:
        listed.append(c.split()[0])

# For each command, find the ns.<Fn> mentioned in its Core.lua branch.
handlers = {}
for cmd in listed:
    pat = re.compile(r'msg == "%s"(.{0,400}?)\n\s*return\n' % re.escape(cmd), re.S)
    m = pat.search(core)
    if not m:
        pat = re.compile(r'msg:match\("\^%s(.{0,400}?)\n\s*return\n'
                         % re.escape(cmd), re.S)
        m = pat.search(core)
    if m:
        fns = re.findall(r'ns\.([A-Z][A-Za-z0-9_]*)', m.group(1))
        if fns:
            handlers[cmd] = sorted(set(fns))

# Where else is each handler called from? Any file other than Core.lua counts
# as a second door -- a button, a tab, a panel.
others = {}
paths = sorted(glob.glob(os.path.join(MH, 'Modules', '*.lua')))
paths.append(os.path.join(MH, 'UI.lua'))
blob = {}
for p in paths:
    if os.path.exists(p):
        blob[os.path.basename(p)] = io.open(p, encoding='utf-8',
                                            errors='replace').read()

print('%-14s %-30s %s' % ('commando', 'handler', 'ook aangeroepen vanuit'))
print('-' * 78)
only_door = []
for cmd in listed:
    fns = handlers.get(cmd)
    if not fns:
        continue
    callers = set()
    for fn in fns:
        needle = 'ns.' + fn
        for name, text in blob.items():
            # A definition is not a call.
            body = text.replace('function ' + needle, '')
            if needle in body:
                callers.add(name)
    label = ', '.join(sorted(callers)[:2]) if callers else 'NERGENS — alleen /mh'
    if not callers:
        only_door.append(cmd)
    print('%-14s %-30s %s' % ('/mh ' + cmd, fns[0][:30], label))

print('\n' + '=' * 60)
print('ALLEEN VIA HET COMMANDO BEREIKBAAR — %d' % len(only_door))
print('=' * 60)
for c in only_door:
    print('  /mh %s' % c)
