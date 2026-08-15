"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: add CODEX_CAT_COILEDISLE next to every CODEX_CAT_WORLD.

"Coiled Isle" is a zone name Blizzard owns, so it stays English in all seven
packs — same rule as Corrosive Coin. One string, seven insertions.
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
ANCHOR = '\tCODEX_CAT_WORLD = "Void & Rituals",'
NEW = '\tCODEX_CAT_COILEDISLE = "Coiled Isle",'

t = io.open(P, encoding='utf-8', newline='').read()

if 'CODEX_CAT_COILEDISLE' in t:
    print('staat er al — niets gedaan')
    sys.exit(0)

# CRLF: the anchor line ends with \r\n, and appending after \n would put the new
# line before the \r. Split on the line ending that is actually there.
eol = '\r\n' if '\r\n' in t else '\n'
count = t.count(ANCHOR)
print('anker gevonden: %d keer (verwacht 7)' % count)

if count != 7:
    print('NIETS geschreven — alles of niets')
    sys.exit(1)

t = t.replace(ANCHOR, ANCHOR + eol + NEW)

io.open(P + '.tmp', 'w', encoding='utf-8', newline='').write(t)
os.replace(P + '.tmp', P)
print('geschreven: %d regels toegevoegd' % count)
