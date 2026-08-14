"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the other five languages. enUS and nlNL got the achievement names a
moment ago and the rest did not, which is exactly the half-done state this repo
keeps producing when a locale edit is written by hand.

Names stay English on purpose: the client shows achievement names in the
player's own language, so a translated guess would not match what they see, and
would not be searchable either.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

P = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales\Codex.lua'
W, R = '|cffffffff', '|r'

EDITS = [
    # Underbelly -> Soft Underbelly (62601)
    ('e la Underbelly ha un obiettivo tutto suo.',
     'e la Underbelly ha un obiettivo tutto suo, %sSoft Underbelly%s.' % (W, R)),
    ('Underbelly hat einen eigenen Erfolg.',
     'Underbelly hat einen eigenen Erfolg: %sSoft Underbelly%s.' % (W, R)),
    ("l'Underbelly a son propre haut fait.",
     "l'Underbelly a son propre haut fait, %sSoft Underbelly%s." % (W, R)),
    ('Underbelly tiene un logro propio.',
     'Underbelly tiene un logro propio: %sSoft Underbelly%s.' % (W, R)),
    ('Underbelly tem uma proeza própria.',
     'Underbelly tem uma proeza própria: %sSoft Underbelly%s.' % (W, R)),
    # third achievement -> Oppose the Foes (63601)
    ('un terzo obiettivo.', 'un terzo: %sOppose the Foes%s.' % (W, R)),
    ('einen dritten Erfolg.', 'einen dritten: %sOppose the Foes%s.' % (W, R)),
    ('un troisième haut fait.', 'un troisième : %sOppose the Foes%s.' % (W, R)),
    ('un tercer logro.', 'un tercero: %sOppose the Foes%s.' % (W, R)),
    ('uma terceira proeza.', 'uma terceira: %sOppose the Foes%s.' % (W, R)),
]

t = open(P, encoding='utf-8', newline='').read()
changed = 0
for old, new in EDITS:
    n = t.count(old)
    if n != 1:
        print('%-46s %d treffers — overgeslagen' % (old[:46], n))
        continue
    t = t.replace(old, new)
    changed += 1
    print('%-46s ok' % old[:46])

print('%d van %d' % (changed, len(EDITS)))
if changed == len(EDITS):
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('NIETS geschreven — alles of niets')
