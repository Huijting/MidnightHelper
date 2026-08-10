"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: what does centring do to the bars, for a few real spec sizes?
"""
import math

# bar width -> how many keys a spec uses, from the measurements
CASES = [
    ('balk 1 nummers',    6, [5, 4, 3]),
    ('balk 2 letters',    9, [8, 7, 6]),
    ('balk 3 shift-num',  7, [7, 5, 4, 1]),
    ('balk 4 shift-let',  8, [8, 5, 3, 1]),
    ('balk 5 F-rij',      6, [4, 3, 1]),
    ('balk 6 ctrl',       6, [6, 3, 1]),
]

for name, width, uses in CASES:
    print('%-18s breedte %d' % (name, width))
    for used in uses:
        offset = math.floor((width - used) / 2) if width > used else 0
        cells = ['.'] * width
        for i in range(used):
            if offset + i < width:
                cells[offset + i] = '#'
        left = offset
        right = width - used - offset
        print('   %2d in gebruik   [%s]   links leeg %d, rechts leeg %d'
              % (used, ' '.join(cells), left, max(right, 0)))
    print()
