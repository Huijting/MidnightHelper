"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: pull the two new /mh atal blocks (map links, area POIs) and any
unknownDelves out of the SavedVariables, so Rob does not have to paste a wall
of chat.

Brace-matched extraction, not a regex over the whole file: the SV is one deeply
nested Lua table and a regex would stop at the first '}' it met.
"""
import io
import os
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

SV = r'E:\World of Warcraft\_retail_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua'


def block(text, key, start=0):
    """Return the {...} that follows ["key"] = , brace-matched."""
    needle = '["%s"]' % key
    i = text.find(needle, start)
    if i == -1:
        return None, -1
    j = text.find('{', i)
    if j == -1:
        return None, -1
    depth, k = 0, j
    while k < len(text):
        c = text[k]
        if c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
            if depth == 0:
                return text[j:k + 1], k
        k += 1
    return None, -1


t = io.open(SV, encoding='utf-8', errors='replace').read()
print('SV: %d KB' % (len(t) // 1024))

probe, _ = block(t, 'atalProbe')
if probe is None:
    print('GEEN atalProbe in de SV — is /mh atal wel gedraaid vóór de reload?')
else:
    print('atalProbe gevonden (%d tekens)' % len(probe))
    for key in ('links', 'pois'):
        b, _ = block(probe, key)
        if b is None:
            print('\n=== %s: ONTBREEKT (oude code geladen?) ===' % key)
        else:
            lines = [ln.rstrip() for ln in b.splitlines()]
            print('\n=== %s — %d regels ===' % (key, len(lines)))
            for ln in lines:
                print(ln)

unk, _ = block(t, 'unknownDelves')
print('\n=== unknownDelves ===')
print(unk if unk is not None else '(niet aanwezig — nog geen onbekende delve gedraaid)')
