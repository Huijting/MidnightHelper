"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: four more SMC pins whose sentence repeats their own label.
Rob's Bank & Vault tooltip is the one that caught it — "de bank en Great Vault
locatie in Silvermoon City" under a button reading *Bank & Vault*, on the
Silvermoon page.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\UI.lua'

GENERIC = [
    'bank',            # label already says Bank & Vault; "in Silvermoon City" on the Silvermoon page
    'inn_cooking',     # label already says Inn & Cooking
    'timeways',        # label already says Timeways (Lindormi)
    'crafting_orders',  # label already says Crafting Orders (Mar'nah)
]

t = open(P, encoding='utf-8', newline='').read()
changed, missed = 0, []

for pid in GENERIC:
    pat = re.compile(
        r'(\{ id = "%s", label = "[^"]*", )description = "(?:[^"\\]|\\.)*", ' % re.escape(pid))
    new, n = pat.subn(lambda m: m.group(1), t)
    if n == 1:
        t, changed = new, changed + 1
    else:
        missed.append('%s (%d treffers)' % (pid, n))

if missed:
    print('NIET aangepast: ' + ', '.join(missed))
print('%d pins omgezet' % changed)

if changed:
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)

rest = re.findall(r'\{ id = "([a-z_]+)"[^}]*description = "', t)
print('nog met eigen tekst (%d): %s' % (len(rest), ', '.join(rest)))
