"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: swap the Season 2 primary/alternate crest ids. Measured 14 Aug — the
counts sit on 3442-3446, not on 3437-3441.

Every pair is named explicitly and the count is asserted, because "swap the two
numbers on each line" done by hand across five tiers is how one gets missed.
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

P = (r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper'
     r'\Modules\DawncrestData.lua')

# tier -> (was primary, was alternate) ; after the swap they trade places.
PAIRS = [
    ('adventurer', 3437, 3442),
    ('veteran', 3438, 3443),
    ('champion', 3439, 3444),
    ('hero', 3440, 3445),
    ('myth', 3441, 3446),
]

t = open(P, encoding='utf-8', newline='').read()
done = 0
for tier, old_primary, old_alt in PAIRS:
    pat_p = re.compile(r'(\bseason2CurrencyId = )%d\b' % old_primary)
    pat_a = re.compile(r'(\bseason2AlternateCurrencyIds = \{ )%d( \})' % old_alt)
    new, np = pat_p.subn(lambda m: m.group(1) + str(old_alt), t)
    if np != 1:
        print('%-11s primair %d: %d treffers — NIET aangepast' % (tier, old_primary, np))
        continue
    new2, na = pat_a.subn(lambda m: m.group(1) + str(old_primary) + m.group(2), new)
    if na != 1:
        print('%-11s alternate %d: %d treffers — NIET aangepast' % (tier, old_alt, na))
        continue
    t = new2
    done += 1
    print('%-11s %d <-> %d' % (tier, old_primary, old_alt))

print('%d van %d tiers omgedraaid' % (done, len(PAIRS)))
if done == len(PAIRS):
    io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
    os.replace(P + '.tmp', P)
    print('geschreven')
else:
    print('NIETS geschreven — alles of niets')
